import 'dart:convert';
import 'package:http/http.dart' as http;
import 'Payment_model.dart';

class PaymentService {
  static const String baseUrl = "https://apps.piit.us/new/tilmaame/api/v1";

  Future<Payment> submitPayment({
    required String name,
    required String phone,
    required String amount,
    required String transactionId,
    required String senderAccount,
    required String reference,
    String? note,
    String? bookingId,
  }) async {
    final url = Uri.parse("$baseUrl/payment-store");

    final body = {
      "name": name,
      "phone": phone,
      "amount": amount,
      "transaction_id": transactionId,
      "sender_account": senderAccount,
      "reference": reference,
      "note": note ?? "",
      "booking_id": bookingId ?? "",
    };

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode(body),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Payment.fromJson(data);
      } else {
        throw Exception("Server error: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Network error: $e");
    }
  }
}
