import 'package:flutter/material.dart';
import '../Services/car/Car_Model.dart';
import '../Services/car/Cars_Api_Services.dart';
import '../Services/car/SafeNetwork.dart';
import 'Car_details_screen.dart';
import '../widget/color.dart';

class CarListScreen extends StatefulWidget {
  final int? categoryId;

  const CarListScreen({super.key, this.categoryId});

  @override
  State<CarListScreen> createState() => _CarListScreenState();
}

class _CarListScreenState extends State<CarListScreen> {
  late Future<List<Car>> carsFuture;

  @override
  void initState() {
    super.initState();
    carsFuture = ApiService.fetchCars(); // fetch all cars
  }

  int getCrossAxisCount(double width) {
    if (width < 600) return 2; // Mobile
    if (width < 900) return 3; // Small tablet
    if (width < 1200) return 4; // Large tablet
    return 5; // Desktop
  }

  double getChildAspectRatio(double width) {
    if (width < 600) return 0.65; // Mobile
    if (width < 900) return 0.7; // Small Tablet
    if (width < 1200) return 0.75; // Large Tablet
    return 0.8; // Desktop
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Cars"),
        backgroundColor: AppColors.primary,
      ),
      body: FutureBuilder<List<Car>>(
        future: carsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("❌ Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No cars found"));
          }

          // Filter cars based on categoryId
          final filteredCars = (widget.categoryId == null || widget.categoryId == 0)
              ? snapshot.data!
              : snapshot.data!
              .where((car) => car.category.id == widget.categoryId)
              .toList();

          if (filteredCars.isEmpty) {
            return const Center(child: Text("No cars for this category"));
          }

          return GridView.builder(
            padding: const EdgeInsets.all(12),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: getCrossAxisCount(width),
              childAspectRatio: getChildAspectRatio(width),
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
            ),
            itemCount: filteredCars.length,
            itemBuilder: (context, index) {
              final car = filteredCars[index];

              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
// Image
                    Flexible(
                      flex: 7,
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(12),
                        ),
                        child: SafeNetworkImage(url: car.image),
                      ),
                    ),

// Text + Button
                    Flexible(
                      flex: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              car.title,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: AppColors.textDark,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              "৳${car.price}",
                              style: const TextStyle(
                                color: AppColors.primary,
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                              ),
                            ),

                            /// 👉 Spacer ensures button always stays at bottom
                            const Spacer(),
                            SizedBox(
                              width: double.infinity,
                              height: 25,
                              child: ElevatedButton(
                                onPressed: () {
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
                                        carType: car.carType,
                                        userId: '',
                                      ),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  padding: EdgeInsets.zero,
                                ),
                                child: const Text(
                                  "Details",
                                  style: TextStyle(fontSize: 11),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );


            },
          );
        },
      ),
    );
  }
}
