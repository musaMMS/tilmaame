import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String baseUrl = "https://apps.piit.us/new/tilmaame/api/v1";
  static const String tokenKey = 'auth_token';
  static const String userKey = 'user_id';

  /// 🔹 Login
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final url = Uri.parse("$baseUrl/login");
      final response = await http
          .post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "User-Agent": "FlutterApp/1.0"
        },
        body: jsonEncode({"email": email.trim(), "password": password.trim()}),
      )
          .timeout(const Duration(seconds: 20));

      if (response.statusCode != 200) {
        return {
          "success": false,
          "message": "Login failed: ${response.statusCode} - ${response.body}"
        };
      }

      final data = jsonDecode(response.body);

      final token = data['authorisation']?['token']?.toString() ?? "";
      final userId = data['user']?['id']?.toString() ?? "";

      if (token.isEmpty || userId.isEmpty) {
        return {"success": false, "message": "Invalid server response"};
      }

      // 🔒 Save token & user ID
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(tokenKey, token);
      await prefs.setString(userKey, userId);

      print("✅ Token & UserID saved successfully");

      return {"success": true, "token": token, "userId": userId};
    } on TimeoutException {
      return {"success": false, "message": "Server timeout, try again"};
    } catch (e) {
      return {"success": false, "message": "Login Error: $e"};
    }
  }

  /// 🔹 Get token safely
  Future<String?> getToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(tokenKey);
    } catch (e) {
      print("⚠️ SharedPreferences getToken error: $e");
      return null;
    }
  }

  /// 🔹 Get user ID safely
  Future<String?> getUserId() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(userKey);
    } catch (e) {
      print("⚠️ SharedPreferences getUserId error: $e");
      return null;
    }
  }

  /// 🔹 Logout
  Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(tokenKey);
      await prefs.remove(userKey);
      print("✅ Logged out successfully");
    } catch (e) {
      print("⚠️ Logout error: $e");
    }
  }

  /// 🔹 Check login status
  Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  /// 🔹 Optional: Check server connectivity before login
  Future<bool> isServerReachable() async {
    try {
      final response = await http
          .get(
        Uri.parse("$baseUrl/cars"), // simple GET endpoint
        headers: {
          "Accept": "application/json",
          "User-Agent": "FlutterApp/1.0"
        },
      )
          .timeout(const Duration(seconds: 10));
      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }
}
