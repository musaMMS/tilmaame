import 'package:flutter/material.dart';
import '../widget/Network_image.dart';
import '../widget/color.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text("About Us"),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 🔹 Top Banner Image only
            Image.network(
              NetworkImages.banner,
              fit: BoxFit.cover,
              height: 220,
              width: double.infinity,
            ),

            const SizedBox(height: 20),

            /// 🔹 Title + Subtitle (under banner)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Column(
                      children: [
                        // 🔹 Normal Text
                        Center(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.orange.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: const Text(
                              "ABOUT",
                              style: TextStyle(
                                color: Colors.orange,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        // 🔹 RichText
                        RichText(
                          text: const TextSpan(
                            text: "Find Out More ",
                            style: TextStyle(
                              fontSize: 22,
                              color: AppColors.textDark,
                              fontWeight: FontWeight.bold,
                            ),
                            children: [
                              TextSpan(
                                text: "About Us",
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// 🔹 About Section Content
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    "assets/owner/istockphoto-2152381827-612x612.jpg",
                    fit: BoxFit.cover,
                    height: 180,
                    width: double.infinity,
                  ),
                  const SizedBox(height: 16),

                  const Text(
                    "We realize your vehicle needs",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 10),

                  const Text(
                    "Lorem ipsum dolor sit amet, consectetur adipiscing elit. "
                        "Nullam dictum leo quis lacus tempor, a aliquet erat fringilla. "
                        "Proin non consequat lorem. Cras interdum fermentum posuere.",
                    style: TextStyle(
                      fontSize: 15,
                      height: 1.5,
                      color: AppColors.textLight,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
