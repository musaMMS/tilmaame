import 'dart:convert';
import 'package:http/http.dart' as http;
import 'On_Bodaring_Model.dart';
import 'car_category_model.dart';


class MyCarApiService {
  static const String baseUrl = "https://apps.piit.us/new/tilmaame/api/v1/";

  /// Fetch cars optionally filtered by categoryId
  static Future<List<MyCar>> fetchCars({int? categoryId}) async {
    final url = Uri.parse('${baseUrl}cars');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final List data = jsonData['data'];

      List<MyCar> cars = data.map((e) => MyCar.fromJson(e)).toList();

      if (categoryId != null) {
        cars = cars.where((car) => car.categoryId == categoryId).toList();
      }

      return cars;
    } else {
      throw Exception('Failed to fetch cars');
    }
  }

  /// Fetch all categories
  static Future<List<MyCarCategory>> fetchCategories() async {
    final url = Uri.parse('${baseUrl}categories');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final List data = jsonData['data'];
      return data.map((e) => MyCarCategory.fromJson(e)).toList();
    } else {
      throw Exception('Failed to fetch categories');
    }
  }
}
