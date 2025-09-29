import 'dart:convert';
import 'package:http/http.dart' as http;
import 'app_info_model.dart';

class AppInfoService {
  static const String baseUrl = "https://apps.piit.us/new/tilmaame/api/v1/company-info";

  static Future<AppInfo> fetchAppInfo() async {
    try {
      final uri = Uri.parse(baseUrl);
      final response = await http.get(uri);

      print("📡 Company Info API CALL → $baseUrl");
      print("📥 Response status: ${response.statusCode}");
      print("📥 Response body: ${response.body}");

      if (response.statusCode == 200) {
        final jsonBody = json.decode(response.body);

        if (jsonBody["success"] == true && jsonBody["data"] != null) {
          return AppInfo.fromJson(jsonBody["data"]);
        } else {
          throw Exception("API returned success=false or data is null");
        }
      } else {
        throw Exception("Failed to load company info, status: ${response.statusCode}");
      }
    } catch (e) {
      print("🔥 fetchAppInfo exception: $e");
      rethrow;
    }
  }
}
