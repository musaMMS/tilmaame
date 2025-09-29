class Payment {
  final bool success;
  final String message;
  final String? data;

  Payment({required this.success, required this.message, this.data});

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data']?.toString(),
    );
  }
}
