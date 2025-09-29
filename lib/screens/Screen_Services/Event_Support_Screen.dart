import 'package:flutter/material.dart';

import '../../widget/Network_image.dart';

class EventSupportScreen extends StatelessWidget {
  const EventSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 🔹 Banner Section
            Image.network(
              NetworkImages.banner,
              fit: BoxFit.cover,
              height: 220,
              width: double.infinity,
            ),

            // 🔹 Content Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Service Tag
                  Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade100,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        "SERVICE",
                        style: TextStyle(
                          color: Colors.deepOrange,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Title
                  Center(
                    child: const Text.rich(
                      TextSpan(
                        text: "More about ",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                        children: [
                          TextSpan(
                            text: "Event Support",
                            style: TextStyle(
                              color: Colors.deepOrange,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Center(
                    child: Image.asset(
                      "assets/services/17318401883464rent.jpg", //  car image
                      height: 150,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Description
                  const Text(
                    "It is a long established fact that a reader will be distracted "
                        "by the readable content of a page when looking at its layout. "
                        "The point of using Lorem Ipsum is that it has a more-or-less "
                        "normal distribution of letters.",
                    textAlign: TextAlign.justify,
                    style: TextStyle(fontSize: 14, height: 1.4),
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
