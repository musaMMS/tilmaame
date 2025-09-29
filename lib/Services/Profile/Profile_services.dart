
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
class ApiService {
  final String baseUrl = "https://apps.piit.us/new/tilmaame/api/v1";

  Future<ProfileUpdateResponse> updateProfile({

    required String name,
    required String email,
    required String phone,
    String? password,
    String? confirmPassword,
    File? drivingLicense,
  }) async {
    try {

      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("auth_token");

      if (token == null || token.isEmpty) {
        throw Exception("No token found. Please login first.");
      }

      final dio = Dio();

      final formData = FormData.fromMap({
        "name": name,
        "email": email,
        "phone": phone,
        if (password != null && password.isNotEmpty)
          "password": password,
        if (password != null && password.isNotEmpty)
          "password_confirmation": confirmPassword ?? "",
        if (drivingLicense != null)
          "license": await MultipartFile.fromFile(drivingLicense.path),
      });

      final response = await dio.post(
        "$baseUrl/profile-update",
        data: formData,
        options: Options(
          headers: {
            "Authorization": "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwczovL2FwcHMucGlpdC51cy9uZXcvdGlsbWFhbWUvYXBpL3YxL2xvZ2luIiwiaWF0IjoxNzU4NjAzMzExLCJleHAiOjE3NTk4MTI5MTEsIm5iZiI6MTc1ODYwMzMxMSwianRpIjoiU0JWNWFUZVI1U0RlTXQweiIsInN1YiI6IjIyIiwicHJ2IjoiMjNiZDVjODk0OWY2MDBhZGIzOWU3MDFjNDAwODcyZGI3YTU5NzZmNyJ9.9SUWOkPuhn5EuzcmqK4fAh2K2wiTNZoq8BDjxSc1kkI", // 🔑 dynamic token
            "Accept": "application/json",
          },
        ),
      );

      if (response.statusCode == 200) {
        return ProfileUpdateResponse.fromJson(response.data);
      } else {
        throw Exception(
            "Profile update failed: ${response.statusMessage ?? 'Unknown error'}");
      }
    } on DioException catch (e) {
      throw Exception("Profile update failed: ${e.message}");
    } catch (e) {
      throw Exception("Profile update failed: $e");
    }
  }
}

class ProfileUpdateResponse {
  final bool success;
  final String message;

  ProfileUpdateResponse({
    required this.success,
    required this.message,
  });

  factory ProfileUpdateResponse.fromJson(Map<String, dynamic> json) {
    return ProfileUpdateResponse(
      success: json["success"] ?? false,
      message: json["message"] ?? "",
    );
  }
}
