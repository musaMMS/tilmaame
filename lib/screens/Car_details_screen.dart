import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:tilmaame/screens/Home_screen.dart';
import '../../Services/car/SafeNetwork.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

import 'LogIn_screen.dart';
import 'Screen_Services/Booking_screwen.dart';
class CarDetailsScreen extends StatefulWidget {

  final String carId;
  final String title;
  final String image;
  final String price;
  final String features;
  final String description;
  final String? carType;
  final String userId;

  const CarDetailsScreen({
    super.key,
    required this.carId,
    required this.title,
    required this.image,
    required this.price,
    required this.features,
    required this.description,
    required this.carType,
    required this.userId,
  });

  @override
  State<CarDetailsScreen> createState() => _CarDetailsScreenState();
}

class _CarDetailsScreenState extends State<CarDetailsScreen> {
  String? loggedInUserId;

  @override
  void initState() {
    super.initState();
    _loadUserId();
  }

  Future<void> _loadUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getString('user_id');
    setState(() {
      loggedInUserId = id ?? '';
    });
  }

  void _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
    try {
      if (!await launchUrl(launchUri)) throw 'Could not launch $phoneNumber';
    } catch (e) {
      debugPrint('Error launching phone call: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final featureList = widget.features.split(",");

    return WillPopScope(
      onWillPop: ()async{
        Get.offAll(()=>HomePage());
        return false;
      },
      child: Scaffold(
        appBar: AppBar(title: Text(widget.title), backgroundColor: Colors.orange),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: SafeNetworkImage(
                  url: widget.image,
                  height: 200,
                  width: double.infinity,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                widget.title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
              ),
              if (widget.carType != null) ...[
                const SizedBox(height: 6),
                Text(
                  "Car Type: ${widget.carType}",
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
              const SizedBox(height: 10),
              const Text(
                "Car Features",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 6),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: featureList
                    .map(
                      (f) => Row(
                    children: [
                      const Icon(Icons.circle, size: 8, color: Colors.orange),
                      const SizedBox(width: 6),
                      Expanded(child: Text(f.trim())),
                    ],
                  ),
                )
                    .toList(),
              ),
              const SizedBox(height: 12),
              Text(
                "Rent Price: ৳${widget.price}",
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.red,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (loggedInUserId == null || loggedInUserId!.isEmpty) {
                          // Not logged in → go to login
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => LogInScreen(
                                onLoginSuc: (userId, token) async {
                                  final prefs =
                                  await SharedPreferences.getInstance();
                                  await prefs.setString('user_id', userId.toString());
                                  await prefs.setString('auth_token', token);

                                  setState(() {
                                    loggedInUserId = userId.toString();
                                  });

                                  // After login → open booking
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => BookingFormPage(
                                        carId: widget.carId,
                                        carName: widget.title,
                                        amount: int.tryParse(widget.price) ?? 0,
                                        userId: userId.toString(),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          );
                        } else {
                          // Already logged in → go to booking
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => BookingFormPage(
                                carId: widget.carId,
                                carName: widget.title,
                                amount: int.tryParse(widget.price) ?? 0,
                                userId: loggedInUserId!,
                              ),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text("Book Now"),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _makePhoneCall('+252634197012'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text("Call Now"),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                "Details",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              HtmlWidget(widget.description),
            ],
          ),
        ),
      ),
    );
  }
}
