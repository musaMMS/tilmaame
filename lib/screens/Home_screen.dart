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
      "text":
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Duis ac eros vel magna tempor gravida."
    },
    {
      "name": "Sarah Miller",
      "role": "Business Partner",
      "img": "assets/owner/istockphoto-1438133166-612x612.jpg",
      "text":
      "Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae."
    },
    {
      "name": "Michael Lee",
      "role": "Car Owner",
      "img": "assets/owner/istockphoto-1499761455-612x612.jpg",
      "text":
      "Praesent posuere sem nec urna fermentum, sit amet facilisis odio tincidunt."
    },
  ];

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    setState(() {
      isLoggedIn = token != null && token.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isMobile = screenWidth < 600;
    final bool isTablet = screenWidth >= 600 && screenWidth < 1024;

    return WillPopScope(
      onWillPop: () async {
        bool exit = await showExitDialog(context);
        return exit;
      },
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
        body: CustomScrollView(
          slivers: [
            // Banner Carousel
            SliverToBoxAdapter(
              child: FutureBuilder<List<MyCar>>(
                future: MyCarApiService.fetchCars(), // API call returning List<Car>
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return SizedBox(
                      height: isMobile ? 180 : isTablet ? 260 : 350,
                      child: Center(child: CircularProgressIndicator()),
                    );
                  } else if (snapshot.hasError) {
                    return SizedBox(
                      height: isMobile ? 180 : isTablet ? 260 : 350,
                      child: Center(child: Text("Failed to load images")),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return SizedBox(
                      height: isMobile ? 180 : isTablet ? 260 : 350,
                      child: Center(child: Text("No images available")),
                    );
                  }

                  final bannerImages = snapshot.data!;

                  String fullImageUrl(String relativePath) {
                    return "https://apps.piit.us/new/tilmaame/$relativePath";
                  }

                  return CarouselSlider(
                    options: CarouselOptions(
                      height: isMobile ? 180 : isTablet ? 260 : 350,
                      autoPlay: true,
                      viewportFraction: 1,
                      enlargeCenterPage: false,
                    ),
                    items: bannerImages.map((car) => ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        fullImageUrl(car.image), // relative path → full URL
                        fit: BoxFit.cover,
                        width: double.infinity,
                        errorBuilder: (context, error, stackTrace) =>
                            Center(child: Icon(Icons.broken_image, size: 50)),
                      ),
                    )).toList(),
                  );
                },
              ),
            ),


            // Available Cars Section
            SliverToBoxAdapter(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final screenWidth = constraints.maxWidth;

                  // Responsive padding
                  double horizontalPadding =
                  screenWidth < 600 ? 12 : screenWidth < 1024 ? 20 : 40;
                  double verticalPadding = screenWidth < 600 ? 8 : 12;
                  return Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: horizontalPadding, vertical: verticalPadding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _sectionTitle("Available ", "Cars"),
                        SizedBox(height: screenWidth < 600 ? 8 : 12),
                        // Wrap CategoryScreen with ConstrainedBox
                        ConstrainedBox(
                          constraints: BoxConstraints(
                              maxHeight: 400), // adjust max height as needed
                          child: CategoryScreen(),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

// About Us Section
//             SliverToBoxAdapter(
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
//                 child: isMobile
//                     ? Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Center(
//                       child: Container(
//                         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
//                         decoration: BoxDecoration(
//                           color: Colors.orange.withOpacity(0.2),
//                           borderRadius: BorderRadius.circular(30),
//                         ),
//                         child: const Text(
//                           "ABOUT",
//                           style: TextStyle(
//                             color: Colors.orange,
//                             fontWeight: FontWeight.bold,
//                             letterSpacing: 1,
//                           ),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 5),
//                     // RichText(
//                     //   text: const TextSpan(
//                     //     text: "Find Out More ",
//                     //     style: TextStyle(
//                     //       fontSize: 22,
//                     //       color: AppColors.textDark,
//                     //       fontWeight: FontWeight.bold,
//                     //     ),
//                     //     children: [
//                     //       TextSpan(
//                     //         text: "About Us",
//                     //         style: TextStyle(
//                     //           color: AppColors.primary,
//                     //           fontWeight: FontWeight.bold,
//                     //         ),
//                     //       ),
//                     //     ],
//                     //   ),
//                     // ),
//                 //     const SizedBox(height: 15),
//                 //     Image.asset(
//                 //       "assets/owner/istockphoto-2152381827-612x612.jpg",
//                 //       fit: BoxFit.cover,
//                 //       height: 160,
//                 //       width: double.infinity,
//                 //     ),
//                 //     const SizedBox(height: 12),
//                 //     const Text(
//                 //       "We realize your vehicle needs",
//                 //       style: TextStyle(
//                 //           fontSize: 18,
//                 //           fontWeight: FontWeight.bold,
//                 //           color: AppColors.textDark),
//                 //     ),
//                 //     const SizedBox(height: 6),
//                 //     Text(
//                 //       "Lorem ipsum dolor sit amet, consectetur adipiscing elit...",
//                 //       style: TextStyle(
//                 //           fontSize: 14, color: AppColors.textLight),
//                 //     ),
//                 //     const SizedBox(height: 10),
//                 //     ElevatedButton(
//                 //       onPressed: () {
//                 //         Navigator.push(
//                 //           context,
//                 //           MaterialPageRoute(builder: (_) => AboutScreen()),
//                 //         );
//                 //       },
//                 //       style: ElevatedButton.styleFrom(
//                 //         backgroundColor: AppColors.primary,
//                 //         minimumSize: const Size(100, 35),
//                 //       ),
//                 //       child: const Text("Read More"),
//                 //     ),
//                 //   ],
//                 // )
//                 //      Row(
//                 //   children: [
//                 //     Expanded(
//                 //       flex: 1,
//                 //       child: Image.asset(
//                 //         "assets/owner/istockphoto-2152381827-612x612.jpg",
//                 //         fit: BoxFit.cover,
//                 //         height: 200,
//                 //       ),
//                 //     ),
//                 //     const SizedBox(width: 12),
//                 //     Expanded(
//                 //       flex: 2,
//                 //       child: Column(
//                 //         crossAxisAlignment: CrossAxisAlignment.start,
//                 //         children: const [
//                 //           Text(
//                 //             "We realize your vehicle needs",
//                 //             style: TextStyle(
//                 //                 fontSize: 18,
//                 //                 fontWeight: FontWeight.bold,
//                 //                 color: AppColors.textDark),
//                 //           ),
//                 //           SizedBox(height: 6),
//                 //           Text(
//                 //             "Lorem ipsum dolor sit amet, consectetur adipiscing elit...",
//                 //             style: TextStyle(
//                 //                 fontSize: 14,
//                 //                 color: AppColors.textLight),
//                 //           ),
//                 //         ],
//                 //       ),
//                 //     ),
//                 //   ],
//                 // ),
//               // ),
//             ),


            // Featured Cars Section
            // Featured Cars Section
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.orange.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: const Text(
                          "Cars",
                          style: TextStyle(
                            color: Colors.orange,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12), // gap adjust
                    // _sectionTitle("Featured", "Cars"),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 400, // GridView এর height fix
                      child: CarListScreen(categoryId: 0),
                    ),
                  ],
                ),
              ),
            ),



            // Why Choose Us
            // SliverToBoxAdapter(child: _buildWhyChooseUs(isMobile)),

            // Partners
            SliverToBoxAdapter(child: _buildPartners(isMobile, isTablet)),

            // Testimonials
            SliverToBoxAdapter(child: _buildTestimonials(isMobile)),

            // Extra bottom spacing
            const SliverToBoxAdapter(child: SizedBox(height: 40)),
          ],
        ),
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

  // Widget _buildWhyChooseUs(bool isMobile) {
  //   return Padding(
  //     padding: const EdgeInsets.all(16.0),
  //     child: isMobile
  //         ? Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Image.asset(
  //           "assets/owner/istockphoto-2152381827-612x612.jpg",
  //           height: 200,
  //           fit: BoxFit.cover,
  //           width: double.infinity,
  //         ),
  //         const SizedBox(height: 16),
  //         const Text(
  //           "Why Choose Us",
  //           style: TextStyle(
  //               color: AppColors.primary,
  //               fontWeight: FontWeight.bold,
  //               fontSize: 16),
  //         ),
  //         const SizedBox(height: 6),
  //         const Text(
  //           "Why Customer Love Us",
  //           style: TextStyle(
  //               fontSize: 22,
  //               fontWeight: FontWeight.bold,
  //               color: AppColors.textDark),
  //         ),
  //         const SizedBox(height: 10),
  //         const Text(
  //           "✔  Best affordable pricing\n"
  //               "✔  Exceptional value & transparent\n"
  //               "✔  Reliable customer support\n"
  //               "✔  Wide range of vehicles\n"
  //               "✔  Easy booking options",
  //           style: TextStyle(fontSize: 14, color: AppColors.textLight),
  //         ),
  //         const SizedBox(height: 12),
  //         ElevatedButton(
  //           onPressed: () async {
  //             if (isLoggedIn) {
  //               Navigator.push(
  //                 context,
  //                 MaterialPageRoute(builder: (_) => BookNowDialog()),
  //               );
  //             } else {
  //               Navigator.push(
  //                 context,
  //                 MaterialPageRoute(
  //                   builder: (context) => LogInScreen(
  //                       onLoginSuc: (userId, token) async {
  //                         final prefs = await SharedPreferences.getInstance();
  //                         await prefs.setString('auth_token', token);   // ✅ Token save
  //                         await prefs.setString('user_id', userId as String);     // ✅ User ID save
  //
  //                         setState(() {
  //                           isLoggedIn = true;
  //                         });
  //                       }
  //                   ),
  //                 ),
  //               );
  //             }
  //           },
  //           style:
  //           ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
  //           child: const Text("Book Now!"),
  //         )
  //       ],
  //     )
  //         : Row(
  //       children: [
  //         Expanded(
  //           flex: 1,
  //           child: Image.asset(
  //             "assets/owner/istockphoto-2152381827-612x612.jpg",
  //             height: 280,
  //             fit: BoxFit.cover,
  //           ),
  //         ),
  //         const SizedBox(width: 16),
  //         Expanded(
  //           flex: 1,
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               const Text(
  //                 "Why Choose Us",
  //                 style: TextStyle(
  //                     color: AppColors.primary,
  //                     fontWeight: FontWeight.bold,
  //                     fontSize: 16),
  //               ),
  //               const SizedBox(height: 6),
  //               const Text(
  //                 "Why Customer Love Us",
  //                 style: TextStyle(
  //                     fontSize: 22,
  //                     fontWeight: FontWeight.bold,
  //                     color: AppColors.textDark),
  //               ),
  //               const SizedBox(height: 10),
  //               const Text(
  //                 "✔  Best affordable pricing\n"
  //                     "✔  Exceptional value & transparent\n"
  //                     "✔  Reliable customer support\n"
  //                     "✔  Wide range of vehicles\n"
  //                     "✔  Easy booking options",
  //                 style:
  //                 TextStyle(fontSize: 14, color: AppColors.textLight),
  //               ),
  //               const SizedBox(height: 12),
  //               ElevatedButton(
  //                 onPressed: () async {
  //                   if (isLoggedIn) {
  //                     Navigator.push(
  //                       context,
  //                       MaterialPageRoute(builder: (_) => BookNowDialog()),
  //                     );
  //                   } else {
  //                     Navigator.push(
  //                       context,
  //                       MaterialPageRoute(
  //                         builder: (context) => LogInScreen(
  //                             onLoginSuc: (userId, token) async {
  //                               final prefs = await SharedPreferences.getInstance();
  //                               await prefs.setString('auth_token', token);   // ✅ Token save
  //                               await prefs.setString('user_id', userId as String);     // ✅ User ID save
  //
  //                               setState(() {
  //                                 isLoggedIn = true;
  //                               });
  //                             }
  //                         ),
  //                       ),
  //                     );
  //                   }
  //                 },
  //                 style: ElevatedButton.styleFrom(
  //                     backgroundColor: AppColors.primary),
  //                 child: const Text("Book Now!"),
  //               ),
  //             ],
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildPartners(bool isMobile, bool isTablet) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          Chip(
            backgroundColor: AppColors.primary.withOpacity(0.1),
            label: const Text(
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
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(
                    partners[index],
                    fit: BoxFit.contain,
                  ),
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
      child: Column(
        children: [
          const SizedBox(height: 20),
          _sectionTitle("Business ", " Partner"),
          const SizedBox(height: 16),
          CarouselSlider(
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
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircleAvatar(
                        backgroundImage: AssetImage(item["img"]!),
                        radius: 28,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        item["name"]!,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.textDark),
                      ),
                      Text(
                        item["role"]!,
                        style: const TextStyle(
                            color: AppColors.textLight, fontSize: 12),
                      ),
                      const SizedBox(height: 8),
                      Flexible(
                        child: Text(
                          item["text"]!,
                          textAlign: TextAlign.center,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: 14, color: AppColors.textDark),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
