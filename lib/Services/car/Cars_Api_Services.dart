import 'dart:convert';
import 'package:http/http.dart' as http;
import 'Car_Model.dart';

class ApiService {
  static const String baseUrl = "https://apps.piit.us/new/tilmaame/api/v1/";

  static Future<List<Car>> fetchCars() async {
    final url = Uri.parse("${baseUrl}cars");

    print("➡️ Requesting: $url");

    final response = await http.get(
      url,
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "User-Agent":
        "Mozilla/5.0 (Windows NT 10.0; Win64; x64) "
            "AppleWebKit/537.36 (KHTML, like Gecko) "
            "Chrome/140.0.0.0 Safari/537.36",
      },
    );

    print("⬅️ Status: ${response.statusCode}");

    if (response.statusCode == 200) {
      final body = json.decode(response.body);

      // Debug API response
      print("⬅️ API Body success: ${body["success"]}");
      print("⬅️ Total Cars: ${body["data"]?.length}");

      if (body["success"] == true && body["data"] != null) {
        List data = body["data"];

        return data.map<Car>((e) {
          final car = Car.fromJson(e);
          print("🚗 Car: ${car.title}, image: ${car.image}");
          return car;
        }).toList();
      } else {
        throw Exception("⚠️ API returned success=false or no data");
      }
    } else {
      throw Exception("❌ Failed to fetch cars: ${response.statusCode}");
    }
  }
}
