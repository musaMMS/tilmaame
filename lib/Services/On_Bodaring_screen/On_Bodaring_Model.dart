import 'car_category_model.dart';

class MyCar {
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
  final MyCarCategory category;

  MyCar({
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
    required this.category,
  });

  factory MyCar.fromJson(Map<String, dynamic> json) {
    return MyCar(
      id: json['id'],
      title: json['title'],
      slug: json['slug'],
      categoryId: json['category_id'],
      brand: json['brand'],
      image: json['image'],
      price: json['price'],
      number: json['number'],
      description: json['description'],
      features: json['features'],
      status: json['status'],
      category: MyCarCategory.fromJson(json['category']),
    );
  }
}
