class MyCarCategory {
  final int id;
  final String name;
  final String slug;
  final String icon;

  MyCarCategory({
    required this.id,
    required this.name,
    required this.slug,
    required this.icon,
  });

  factory MyCarCategory.fromJson(Map<String, dynamic> json) {
    return MyCarCategory(
      id: json['id'],
      name: json['name'],
      slug: json['slug'],
      icon: json['icon'] ?? '',
    );
  }
}
