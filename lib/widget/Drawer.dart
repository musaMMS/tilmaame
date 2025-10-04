import 'package:flutter/material.dart';
import '../Screens/Car_details_screen.dart';
import '../Services/On_Bodaring_screen/On_Bodaring_Model.dart';
import '../Services/On_Bodaring_screen/car_category_model.dart';
import '../Services/On_Bodaring_screen/on_Bodaring_api.dart';
import '../screens/About_screen.dart';
import '../screens/Contact_us.dart';
import '../screens/Home_screen.dart';
import '../screens/LogIn_screen.dart';
import '../screens/Screen_Services/CorporateTransportPage.dart';
import '../screens/Screen_Services/Dash_Board_Screen.dart';
import '../screens/Screen_Services/Event_Support_Screen.dart';
import '../screens/Screen_Services/Profile_screen.dart';
import '../screens/Screen_Services/Rent_Cars_Screen.dart';
import '../screens/Screen_Services/Rental_Screen.dart';
import '../screens/Screen_Services/Tour_Travels_screen.dart';
import '../widget/color.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DrawerScreen extends StatefulWidget {
  const DrawerScreen({super.key});

  @override
  State<DrawerScreen> createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  Future<Map<String, dynamic>> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    final userId = prefs.getString('user_id');
    return {
      "isLoggedIn": token != null && token.isNotEmpty,
      "userId": userId,
    };
  }

  Future<void> logoutUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    setState(() {});
    Get.offAll(() => LogInScreen(
      onLoginSuc: (String userId, String token) async {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', token);
        await prefs.setString('user_id', userId);
        setState(() {});
      },
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: FutureBuilder<Map<String, dynamic>>(
        future: _checkLoginStatus(),
        builder: (context, snapshot) {
          final isLoggedIn = snapshot.data?["isLoggedIn"] ?? false;
          final loggedInUserId = snapshot.data?["userId"] ?? "";

          return ListView(
            padding: EdgeInsets.zero,
            children: [
              // Header
              DrawerHeader(
                decoration: BoxDecoration(color: AppColors.primary),
                child: Center(
                  child: DefaultTextStyle(
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    child: AnimatedTextKit(
                      animatedTexts: [
                        TyperAnimatedText(
                          'Tilmaame',
                          textStyle: const TextStyle(fontFamily: "Merienda"),
                          speed: const Duration(milliseconds: 150),
                        ),
                      ],
                      repeatForever: true,
                    ),
                  ),
                ),
              ),

              // Home & About
              ListTile(
                leading: const Icon(Icons.home),
                title: const Text("Home"),
                onTap: () => Get.to(() => const HomePage()),
              ),
              ListTile(
                leading: const Icon(Icons.info),
                title: const Text("About"),
                onTap: () => Get.to(() => const AboutScreen()),
              ),

              // Car List (unchanged, same as your code)
              ExpansionTile(
                leading: const Icon(Icons.directions_car),
                title: const Text("Car List"),
                children: [
                  FutureBuilder<List<MyCarCategory>>(
                    future: MyCarApiService.fetchCategories(),
                    builder: (context, catSnapshot) {
                      if (catSnapshot.connectionState == ConnectionState.waiting) {
                        return const Padding(
                          padding: EdgeInsets.all(12),
                          child: CircularProgressIndicator(),
                        );
                      } else if (catSnapshot.hasError) {
                        return Padding(
                          padding: const EdgeInsets.all(12),
                          child: Text("Error: ${catSnapshot.error}"),
                        );
                      } else if (!catSnapshot.hasData || catSnapshot.data!.isEmpty) {
                        return const Padding(
                          padding: EdgeInsets.all(12),
                          child: Text("No categories found"),
                        );
                      }

                      final categories = catSnapshot.data!;
                      return Column(
                        children: categories.map((MyCarCategory category) {
                          return ExpansionTile(
                            title: Text(category.name),
                            children: [
                              FutureBuilder<List<MyCar>>(
                                future: MyCarApiService.fetchCars(
                                  categoryId: category.id,
                                ),
                                builder: (context, carSnapshot) {
                                  if (carSnapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Padding(
                                      padding: EdgeInsets.all(12),
                                      child: CircularProgressIndicator(),
                                    );
                                  } else if (carSnapshot.hasError) {
                                    return Padding(
                                      padding: const EdgeInsets.all(12),
                                      child: Text("Error: ${carSnapshot.error}"),
                                    );
                                  } else if (!carSnapshot.hasData ||
                                      carSnapshot.data!.isEmpty) {
                                    return const Padding(
                                      padding: EdgeInsets.all(12),
                                      child: Text("No cars in this category"),
                                    );
                                  }

                                  final cars = carSnapshot.data!;
                                  return Column(
                                    children: cars.map((MyCar car) {
                                      return ListTile(
                                        title: Text(car.title),
                                        subtitle: Text("৳${car.price}"),
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) => CarDetailsScreen(
                                                carId: car.id.toString(),
                                                title: car.title,
                                                image: car.image,
                                                price: car.price,
                                                features: car.features,
                                                description: car.description,
                                                userId: loggedInUserId ?? '',
                                                carType: category.name,
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    }).toList(),
                                  );
                                },
                              ),
                            ],
                          );
                        }).toList(),
                      );
                    },
                  ),
                ],
              ),

              // Services
              ExpansionTile(
                leading: const Icon(Icons.miscellaneous_services),
                title: const Text("Services"),
                children: [
                  ListTile(
                    title: const Text("Corporate Transport"),
                    onTap: () => Get.to(() => const CorporateTransportPage()),
                  ),
                  ListTile(
                    title: const Text("Event Support"),
                    onTap: () => Get.to(() => const EventSupportScreen()),
                  ),
                  ListTile(
                    title: const Text("Rent Cars"),
                    onTap: () => Get.to(() => const RentCarScreen()),
                  ),
                  ListTile(
                    title: const Text("Rental"),
                    onTap: () => Get.to(() => const RantalScreen()),
                  ),
                  ListTile(
                    title: const Text("Tour and Travels"),
                    onTap: () => Get.to(() => const TourAndTravelScreen()),
                  ),
                ],
              ),

              ListTile(
                leading: const Icon(Icons.contact_page),
                title: const Text("Contact"),
                onTap: () => Get.to(() => const ContactUsScreen()),
              ),

              const Divider(),

              //  Conditional Part
              if (isLoggedIn) ...[
                ListTile(
                  leading: const Icon(Icons.person_rounded),
                  title: const Text("Profile"),
                  onTap: () => Get.to(() => const ProfileUpdatePage()),
                ),
                // Drawer
                ListTile(
                  leading: const Icon(Icons.dashboard),
                  title: const Text("Dashboard"),
                  onTap: () {
                    Get.to(() => DashboardScreen(isFromDrawer: true));
                  },
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.red),
                  title: const Text("Logout", style: TextStyle(color: Colors.red)),
                  onTap: logoutUser,
                ),
              ] else ...[
                ListTile(
                  leading: const Icon(Icons.login),
                  title: const Text("Login"),
                  onTap: () => Get.to(() => LogInScreen(
                    onLoginSuc: (String userId, String token) async {
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.setString('auth_token', token);
                      await prefs.setString('user_id', userId);
                      setState(() {});
                    },
                  )),
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}
