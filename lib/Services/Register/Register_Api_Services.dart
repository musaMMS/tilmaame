import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "https://apps.piit.us/new/tilmaame/api/v1";

  /// Register User
  Future<Map<String, dynamic>> register(
      String name, String phone, String email, String password) async {
    final url = Uri.parse("$baseUrl/register");

    print("👉 API HIT: $url");
    print("📩 Sending data: $name | $phone | $email | $password");

    try {
      final response = await http.post(
        url,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json", // important for JSON body
        },
        body: jsonEncode({
          "name": name,
          "phone": phone,  // backend expects 'phone'
          "email": email,
          "password": password,
        }),
      );

      print("📥 Response Code: ${response.statusCode}");
      print("📥 Response Body: ${response.body}");

      final Map<String, dynamic> resBody = jsonDecode(response.body);

      // Success
      if (response.statusCode == 200 || response.statusCode == 201) {
        return {
          "success": true,
          "message": resBody['message'] ?? "Registration successful!",
          "data": resBody['data'] ?? {},
        };
      }

      // Validation error (422)
      if (response.statusCode == 422) {
        return {
          "success": false,
          "message": resBody['message'] ?? "Validation error",
          "errors": resBody['errors'] ?? {},
        };
      }

      // Other errors
      return {
        "success": false,
        "message": "Server error: ${response.statusCode}",
      };
    } catch (e) {
      print("❌ Exception: $e");
      return {"success": false, "message": "Exception: $e"};
    }
  }
}
