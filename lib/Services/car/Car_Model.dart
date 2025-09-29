class Car {
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
  final Category category;
  final String? carType; // ✅ added

  Car({
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
    this.carType, // ✅ nullable
  });

  static const String baseUrl = "https://apps.piit.us/new/tilmaame/";

  /// 🔹 Always return valid full URL (image fallback)
  static String _fullUrl(String base, String? path, String fallback) {
    if (path == null || path.trim().isEmpty) {
      return base + fallback; // default placeholder
    }
    if (path.startsWith("http")) return path;
    if (base.endsWith("/") && path.startsWith("/")) {
      return base + path.substring(1);
    } else if (!base.endsWith("/") && !path.startsWith("/")) {
      return "$base/$path";
    } else {
      return base + path;
    }
  }

  factory Car.fromJson(Map<String, dynamic> json) {
    return Car(
      id: json["id"] ?? 0,
      title: json["title"] ?? "",
      slug: json["slug"] ?? "",
      categoryId: json["category_id"] ?? 0,
      brand: json["brand"],
      image: _fullUrl(baseUrl, json["image"], "uploads/no-image.png"),
      price: json["price"]?.toString() ?? "0",
      number: json["number"],
      description: json["description"] ?? "",
      features: json["features"] ?? "",
      status: json["status"] ?? 0,
      category: Category.fromJson(json["category"] ?? {}),
      carType: json["car_type"], // ✅ handle carType from API
    );
  }
}

class Category {
  final int id;
  final String name;
  final String slug;
  final String icon;

  Category({
    required this.id,
    required this.name,
    required this.slug,
    required this.icon,
  });

  static const String baseUrl = "https://apps.piit.us/new/tilmaame/";

  static String _fullUrl(String base, String? path, String fallback) {
    if (path == null || path.trim().isEmpty) {
      return base + fallback;
    }
    if (path.startsWith("http")) return path;
    if (base.endsWith("/") && path.startsWith("/")) {
      return base + path.substring(1);
    } else if (!base.endsWith("/") && !path.startsWith("/")) {
      return "$base/$path";
    } else {
      return base + path;
    }
  }

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json["id"] ?? 0,
      name: json["name"] ?? "",
      slug: json["slug"] ?? "",
      icon: _fullUrl(baseUrl, json["icon"], "uploads/no-icon.png"),
    );
  }
}
