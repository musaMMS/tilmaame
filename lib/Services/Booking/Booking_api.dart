import 'dart:convert';
import 'package:http/http.dart' as http;
import 'Booking_Model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookingService {
  static const String baseUrl = "https://apps.piit.us/new/tilmaame/api/v1";

  /// Fetch bookings
  Future<List<Booking>> fetchBookings() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("auth_token") ?? "";

    if (token.isEmpty) throw Exception("User not logged in");

    final response = await http.get(
      Uri.parse("$baseUrl/bookings"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token", // ✅ dynamic token use
      },
    );

    print("📥 FetchBookings: ${response.body}");

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> bookingsJson =
      data["data"] is List ? data["data"] : [data["data"]];
      return bookingsJson.map((json) => Booking.fromJson(json)).toList();
    } else {
      throw Exception("Failed: ${response.body}");
    }
  }

  /// Initiate Sifalo Payment
  Future<String?> initiateSifaloPayment(int bookingId, int amount) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("auth_token") ?? "";

    if (token.isEmpty) throw Exception("User not logged in");

    final response = await http.post(
      Uri.parse("$baseUrl/sifalo/initiate/$bookingId"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token", // ✅ dynamic token use
      },
      body: jsonEncode({"amount": amount}),
    );

    print("📤 Initiate Payment: ${response.body}");

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data["checkout_url"];
    } else {
      throw Exception("Payment failed: ${response.body}");
    }
  }
}
