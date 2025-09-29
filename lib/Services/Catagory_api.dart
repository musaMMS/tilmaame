
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'Catagory_Model.dart';
import 'car/Car_Model.dart' hide Category;

class ApiService {
  static const String baseUrl = "https://apps.piit.us/new/tilmaame/api/v1/";

  static Future<List<Category>> fetchCategories() async {
    final url = Uri.parse("${baseUrl}categories");

    final response = await http.get(url);

    print("➡️ Request: $url");
    print("⬅️ Status: ${response.statusCode}");

    if (response.statusCode == 200) {
      final body = json.decode(response.body);

      print("⬅️ API Response: $body"); // Debug

      if (body["success"] == true && body["data"] != null) {
        List data = body["data"];
        return data.map((e) => Category.fromJson(e)).toList();
      } else {
        throw Exception("⚠️ API returned success=false or empty data");
      }
    } else {
      throw Exception("❌ Failed to fetch categories: ${response.statusCode}");
    }
  }
}
