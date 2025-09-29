class User {
  final int id;
  final String name;
  final String slug;
  final String type;
  final String email;
  final String? emailVerifiedAt;
  final String? image;
  final String? license;
  final String? designation;
  final String mobile;
  final String? address;
  final int status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String token;

  User({
    required this.id,
    required this.name,
    required this.slug,
    required this.type,
    required this.email,
    this.emailVerifiedAt,
    this.image,
    this.license,
    this.designation,
    required this.mobile,
    this.address,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.token,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['user']['id'],
      name: json['user']['name'],
      slug: json['user']['slug'],
      type: json['user']['type'],
      email: json['user']['email'],
      emailVerifiedAt: json['user']['email_verified_at'],
      image: json['user']['image'],
      license: json['user']['license'],
      designation: json['user']['designation'],
      mobile: json['user']['mobile'],
      address: json['user']['address'],
      status: json['user']['status'],
      createdAt: DateTime.parse(json['user']['created_at']),
      updatedAt: DateTime.parse(json['user']['updated_at']),
      token: json['authorisation']['token'],
    );
  }
}
