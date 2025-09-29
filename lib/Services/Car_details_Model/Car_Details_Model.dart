class CarDetails {
  final int id;
  final String title;
  final String slug;
  final int categoryId;
  final String? brand;
  final String image;
  final String price;
  final String? number;
  final String description;
  final String features;
  final int status;
  final String? carType; // add this if API provides

  CarDetails({
    required this.id,
    required this.title,
    required this.slug,
    required this.categoryId,
    this.brand,
    required this.image,
    required this.price,
    this.number,
    required this.description,
    required this.features,
    required this.status,
    this.carType, // nullable
  });

  factory CarDetails.fromJson(Map<String, dynamic> json) {
    return CarDetails(
      id: json['id'] ?? 0,
      title: json['title'] ?? "",
      slug: json['slug'] ?? "",
      categoryId: json['category_id'] ?? 0,
      brand: json['brand'],
      image: json['image'] != null
          ? "https://apps.piit.us/new/tilmaame/${json['image']}"
          : "https://apps.piit.us/new/tilmaame/uploads/no-image.png",
      price: json['price']?.toString() ?? "0",
      number: json['number'],
      description: json['description'] ?? "",
      features: json['features'] ?? "",
      status: json['status'] ?? 0,
      carType: json['car_type'], // key name from API, nullable
    );
  }
}
