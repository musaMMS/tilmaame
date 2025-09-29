class AppInfo {
  final String name;
  final String description;
  final String logo;
  final String favicon;
  final String phone;
  final String email;
  final String address;

  AppInfo({
    required this.name,
    required this.description,
    required this.logo,
    required this.favicon,
    required this.phone,
    required this.email,
    required this.address,
  });

  factory AppInfo.fromJson(Map<String, dynamic> json) {
    return AppInfo(
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      logo: json['logo'] ?? '',
      favicon: json['favicon'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      address: json['address'] ?? '',
    );
  }
}
