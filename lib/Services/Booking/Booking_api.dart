// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'Booking_Model.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class BookingService {
//   static const String baseUrl = "https://apps.piit.us/new/tilmaame/api/v1";
//
//   /// 🔹 Fetch all bookings for the logged-in user
//   Future<List<Booking>> fetchBookings() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final token = prefs.getString('auth_token') ?? "";
//
//       if (token.isEmpty) {
//         throw Exception("User not logged in");
//       }
//
//       final response = await http.get(
//         Uri.parse("$baseUrl/bookings"),
//         headers: {
//           "Content-Type": "application/json",
//           "Authorization": "Bearer $token",
//         },
//       );
//
//       print("📥 FetchBookings Status: ${response.statusCode}");
//       print("📥 FetchBookings Body: ${response.body}");
//
//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//
//         if (data["success"] != true || data["data"] == null) {
//           throw Exception(data["message"] ?? "No bookings found");
//         }
//
//         final List<dynamic> bookingsJson =
//         data["data"] is List ? data["data"] : [data["data"]];
//
//         return bookingsJson.map((json) => Booking.fromJson(json)).toList();
//       } else if (response.statusCode == 401) {
//         throw Exception("Unauthorized: Please login again");
//       } else {
//         throw Exception("Failed to load bookings: ${response.body}");
//       }
//     } catch (e) {
//       print("❌ FetchBookings Error: $e");
//       rethrow;
//     }
//   }
//
//   /// 🔹 Initiate Sifalo Payment for a booking by ID & Amount
//   Future<String?> initiateSifaloPayment(int bookingId, int amount) async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final token = prefs.getString('auth_token') ?? "";
//
//       if (token.isEmpty) {
//         throw Exception("User not logged in");
//       }
//
//       final apiUrl = "$baseUrl/sifalo/initiate/$bookingId";
//
//       final response = await http.post(
//         Uri.parse(apiUrl),
//         headers: {
//           "Content-Type": "application/json",
//           "Authorization": "Bearer $token",
//         },
//         body: jsonEncode({
//           "amount": amount,
//         }),
//       );
//
//       print("📤 InitiatePayment Request: {bookingId: $bookingId, amount: $amount}");
//       print("📥 InitiatePayment Status: ${response.statusCode}");
//       print("📥 InitiatePayment Body: ${response.body}");
//
//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         return data['checkout_url']; // ✅ directly return
//       } else if (response.statusCode == 401) {
//         throw Exception("Unauthorized: Please login again");
//       } else {
//         throw Exception("Failed to initiate payment: ${response.body}");
//       }
//     } catch (e) {
//       print("❌ InitiatePayment Error: $e");
//       rethrow;
//     }
//   }
// }
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'Booking_Model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookingService {
  static const String baseUrl = "https://apps.piit.us/new/tilmaame/api/v1";

  /// Fetch all bookings
  Future<List<Booking>> fetchBookings() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token') ?? "";
    if (token.isEmpty) throw Exception("User not logged in");

    final response = await http.get(
      Uri.parse("$baseUrl/bookings"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwczovL2FwcHMucGlpdC51cy9uZXcvdGlsbWFhbWUvYXBpL3YxL2xvZ2luIiwiaWF0IjoxNzU4Nzc1MzQ2LCJleHAiOjE3NTk5ODQ5NDYsIm5iZiI6MTc1ODc3NTM0NiwianRpIjoiREhGNDlWWUZhbGtnNUc4RSIsInN1YiI6IjM5IiwicHJ2IjoiMjNiZDVjODk0OWY2MDBhZGIzOWU3MDFjNDAwODcyZGI3YTU5NzZmNyJ9.Tytey-Usr3qq4fpKdS0hHjg8kkuFM7rmDUo7tS9kbio",
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data["success"] != true || data["data"] == null) {
        throw Exception(data["message"] ?? "No bookings found");
      }
      final List<dynamic> bookingsJson = data["data"] is List
          ? data["data"]
          : [data["data"]];
      return bookingsJson.map((json) => Booking.fromJson(json)).toList();
    } else if (response.statusCode == 401) {
      throw Exception("Unauthorized: Please login again");
    } else {
      throw Exception("Failed to load bookings: ${response.body}");
    }
  }

  /// Initiate Sifalo Payment
  Future<String?> initiateSifaloPayment(int bookingId, int amount) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token') ?? "";
    if (token.isEmpty) throw Exception("User not logged in");

    final apiUrl = "$baseUrl/sifalo/initiate/$bookingId";

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwczovL2FwcHMucGlpdC51cy9uZXcvdGlsbWFhbWUvYXBpL3YxL2xvZ2luIiwiaWF0IjoxNzU4Nzc1MzQ2LCJleHAiOjE3NTk5ODQ5NDYsIm5iZiI6MTc1ODc3NTM0NiwianRpIjoiREhGNDlWWUZhbGtnNUc4RSIsInN1YiI6IjM5IiwicHJ2IjoiMjNiZDVjODk0OWY2MDBhZGIzOWU3MDFjNDAwODcyZGI3YTU5NzZmNyJ9.Tytey-Usr3qq4fpKdS0hHjg8kkuFM7rmDUo7tS9kbio",
      },
      body: jsonEncode({"amount": amount}),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final checkoutUrl = data['checkout_url'];
      if (checkoutUrl != null && checkoutUrl.isNotEmpty) return checkoutUrl;
      throw Exception("Payment URL not available");
    } else if (response.statusCode == 401) {
      throw Exception("Unauthorized: Please login again");
    } else {
      throw Exception("Failed to initiate payment: ${response.body}");
    }
  }
}
