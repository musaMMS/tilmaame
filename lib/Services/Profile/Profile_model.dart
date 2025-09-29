class ProfileUpdateResponse {
  final bool success;
  final String message;

  ProfileUpdateResponse({
    required this.success,
    required this.message,
  });

  factory ProfileUpdateResponse.fromJson(Map<String, dynamic> json) {
    return ProfileUpdateResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? "Something went wrong",
    );
  }
}
