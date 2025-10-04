import 'dart:io';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Services/On_Bodaring_screen/On_Bodaring_Model.dart';
import '../Services/On_Bodaring_screen/on_Bodaring_api.dart';
import '../widget/Drawer.dart';
import '../widget/Exit_app_reuseable.dart' show showExitDialog;
import '../widget/color.dart';
import 'Catagory_screen.dart';
import 'car_list_screen.dart';

class HomePage extends StatefulWidget {
  final List<Widget>? drawerItems;
  const HomePage({super.key, this.drawerItems});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoggedIn = false;
  bool hasInternet = true; // 🔹 Internet check state

  final List<String> partners = [
    "assets/cars/acura-logo.png",
    "assets/cars/bmw-logo.png",
    "assets/cars/tesla-logo.png",
    "assets/cars/mazda-logo.png",
    "assets/cars/mercedes-benz-logo.png",
    "assets/cars/suzuki-logo.png",
  ];

  final List<Map<String, String>> testimonials = [
    {
      "name": "John Carter",
      "role": "Customer",
      "img": "assets/owner/istockphoto-1438133166-612x612.jpg",
      "text": "Lorem ipsum dolor sit amet, consectetur adipiscing elit."
    },
    {
      "name": "Sarah Miller",
      "role": "Business Partner",
      "img": "assets/owner/istockphoto-1438133166-612x612.jpg",
      "text": "Vestibulum ante ipsum primis in faucibus orci luctus."
    },
    {
      "name": "Michael Lee",
      "role": "Car Owner",
      "img": "assets/owner/istockphoto-1499761455-612x612.jpg",
      "text": "Praesent posuere sem nec urna fermentum tincidunt."
    },
  ];

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
    _checkInternet(); // 🔹 Start by checking internet
  }

  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    setState(() {
      isLoggedIn = token != null && token.isNotEmpty;
    });
  }

  /// 🔹 Internet check
  Future<void> _checkInternet() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() => hasInternet = true);
      }
    } on SocketException catch (_) {
      setState(() => hasInternet = false);
    }
  }

  /// 🔹 Pull-to-refresh
  Future<void> _onRefresh() async {
    await _checkInternet();
    await Future.delayed(const Duration(seconds: 1));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => await showExitDialog(context),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          title: Image.network(
            'https://apps.piit.us/new/tilmaame/uploads/logo/17517819134399.jpg',
            height: 40,
            fit: BoxFit.contain,
          ),
          centerTitle: false,
          actions: [
            Builder(
              builder: (context) => IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () {
                  Scaffold.of(context).openEndDrawer();
                },
              ),
            ),
          ],
        ),
        endDrawer: DrawerScreen(),

        // 🔹 Offline Mode UI check
        body: hasInternet
            ? RefreshIndicator(
          onRefresh: _onRefresh,
          child: _buildMainContent(context),
        )
            : _buildOfflineUI(),
      ),
    );
  }

  /// 🔹 Main UI content (when internet available)
  Widget _buildMainContent(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isMobile = screenWidth < 600;
    final bool isTablet = screenWidth >= 600 && screenWidth < 1024;

    return CustomScrollView(
      slivers: [
        // Banner Carousel
        SliverToBoxAdapter(
          child: FutureBuilder<List<MyCar>>(
            future: MyCarApiService.fetchCars(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return SizedBox(
                  height: isMobile ? 180 : isTablet ? 260 : 350,
                  child: const Center(child: CircularProgressIndicator()),
                );
              } else if (snapshot.hasError || !snapshot.hasData) {
                return SizedBox(
                  height: isMobile ? 180 : isTablet ? 260 : 350,
                  child: const Center(child: Text("Failed to load images")),
                );
              }

              final bannerImages = snapshot.data!;
              String fullImageUrl(String path) =>
                  "https://apps.piit.us/new/tilmaame/$path";

              return CarouselSlider(
                options: CarouselOptions(
                  height: isMobile ? 180 : isTablet ? 260 : 350,
                  autoPlay: true,
                  viewportFraction: 1,
                ),
                items: bannerImages
                    .map((car) => ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    fullImageUrl(car.image),
                    fit: BoxFit.cover,
                    width: double.infinity,
                    errorBuilder: (_, __, ___) => const Icon(
                      Icons.broken_image,
                      size: 50,
                    ),
                  ),
                ))
                    .toList(),
              );
            },
          ),
        ),

        // Cars + Categories
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _sectionTitle("Available ", "Cars"),
                const SizedBox(height: 12),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 400),
                  child: CategoryScreen(),
                ),
              ],
            ),
          ),
        ),

        // Cars List
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              height: 400,
              child: CarListScreen(categoryId: 0),
            ),
          ),
        ),

        // Partners + Testimonials
        SliverToBoxAdapter(child: _buildPartners(isMobile, isTablet)),
        SliverToBoxAdapter(child: _buildTestimonials(isMobile)),
        const SliverToBoxAdapter(child: SizedBox(height: 40)),
      ],
    );
  }

  /// 🔹 Offline Mode UI
  Widget _buildOfflineUI() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.wifi_off, size: 80, color: Colors.redAccent),
          const SizedBox(height: 16),
          const Text(
            "No Internet Connection",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          ElevatedButton.icon(
            onPressed: _checkInternet,
            icon: const Icon(Icons.refresh),
            label: const Text("Tap to Retry"),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String first, String highlight) {
    return RichText(
      text: TextSpan(
        text: first,
        style: const TextStyle(
            fontSize: 22, color: AppColors.textDark, fontWeight: FontWeight.bold),
        children: [
          TextSpan(
            text: highlight,
            style: const TextStyle(color: AppColors.primary),
          ),
        ],
      ),
    );
  }

  Widget _buildPartners(bool isMobile, bool isTablet) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          const Chip(
            backgroundColor: Color(0xFFE3F2FD),
            label: Text(
              "VALUABLE PARTNERS",
              style: TextStyle(
                  color: AppColors.primary, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: partners.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: isMobile ? 3 : isTablet ? 5 : 7,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 2,
            ),
            itemBuilder: (context, index) {
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(partners[index], fit: BoxFit.contain),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTestimonials(bool isMobile) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: CarouselSlider(
        options: CarouselOptions(
          height: isMobile ? 220 : 280,
          autoPlay: true,
          enlargeCenterPage: true,
          viewportFraction: 0.9,
        ),
        items: testimonials.map((item) {
          return Card(
            elevation: 4,
            margin: const EdgeInsets.symmetric(horizontal: 8),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  CircleAvatar(
                    backgroundImage: AssetImage(item["img"]!),
                    radius: 28,
                  ),
                  const SizedBox(height: 8),
                  Text(item["name"]!,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark)),
                  Text(item["role"]!,
                      style: const TextStyle(
                          color: AppColors.textLight, fontSize: 12)),
                  const SizedBox(height: 8),
                  Flexible(
                    child: Text(
                      item["text"]!,
                      textAlign: TextAlign.center,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
