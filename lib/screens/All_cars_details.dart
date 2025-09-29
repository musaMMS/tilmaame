import 'package:flutter/material.dart';

class AllCarsScreen extends StatelessWidget {
  const AllCarsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> carImages = [
      "assets/1731757597529Toyota-RAV4-Hybrid-036.jpg",
      "assets/17318358878817toyo.jpg",
      "assets/17318359586668f57029ca4b2e9959e5ebb42b57ae5b0a.jpg",
      "assets/17317577143472001.jpgg",
      "assets/173183584765652022_Hyundai_Creta_1.6_Plus_(Chile)_front_view.jpg",
      "assets/car-man-drive-watch.jpg",
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("All Cars"),
        backgroundColor: Colors.orange,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),

            /// Section Title
            const Text(
              "🚘 All Cars",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),

            const SizedBox(height: 20),

            /// Responsive Grid
            LayoutBuilder(
              builder: (context, constraints) {
                int crossAxisCount = 2; // Default for mobile
                if (constraints.maxWidth > 1200) {
                  crossAxisCount = 4; // Desktop large
                } else if (constraints.maxWidth > 800) {
                  crossAxisCount = 3; // Tablet
                }

                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(12),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1,
                  ),
                  itemCount: carImages.length,
                  itemBuilder: (context, index) {
                    return Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(12)),
                              child: Image.asset(
                                carImages[index],
                                fit: BoxFit.cover,
                                width: double.infinity,
                              ),
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(8),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: () {
                                // Navigate to Car Details Screen
                              },
                              child: const Text("Details"),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
