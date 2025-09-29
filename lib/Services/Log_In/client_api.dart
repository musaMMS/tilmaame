import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'Log_In_Api_Servicews.dart';

class ApiClient {
  static const String baseUrl = AuthService.baseUrl;
  final AuthService _auth = AuthService();

  Future<Map<String, dynamic>> get(String path) async {
    final token = await _auth.getToken();
    if (token == null || token.isEmpty) throw Exception("User not logged in");

    final uri = Uri.parse("$baseUrl$path");
    final res = await http.get(uri, headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwczovL2FwcHMucGlpdC51cy9uZXcvdGlsbWFhbWUvYXBpL3YxL2xvZ2luIiwiaWF0IjoxNzU5MTQ1MTIxLCJleHAiOjE3NjAzNTQ3MjEsIm5iZiI6MTc1OTE0NTEyMSwianRpIjoidEx0bWlqM3VPQXlKbXVBRiIsInN1YiI6IjM5IiwicHJ2IjoiMjNiZDVjODk0OWY2MDBhZGIzOWU3MDFjNDAwODcyZGI3YTU5NzZmNyJ9.aIxcBN8n4aDgBF4minTTMM3CUkuYNQ5NhdFD59fZ9uo",
    });

    print("GET $uri => ${res.statusCode}");
    print("Body (first 300 chars): ${res.body.substring(0, min(res.body.length, 300))}");

    // If server returned HTML page (e.g., login page/403/500 HTML)
    if (res.body.trimLeft().startsWith('<')) {
      throw Exception("Invalid response (HTML) from server: ${res.body.substring(0, min(res.body.length, 400))}");
    }

    if (res.statusCode == 200) {
      return json.decode(res.body) as Map<String, dynamic>;
    } else if (res.statusCode == 401) {
      // token invalid/expired — clear and force re-login
      await _auth.logout();
      throw Exception("Unauthorized (401). Token removed, please login again.");
    } else {
      throw Exception("Request failed: ${res.statusCode} - ${res.body}");
    }
  }

  Future<Map<String, dynamic>> post(String path, Map body) async {
    final token = await _auth.getToken();
    if (token == null || token.isEmpty) throw Exception("User not logged in");

    final uri = Uri.parse("$baseUrl$path");
    final res = await http.post(
      uri,
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwczovL2FwcHMucGlpdC51cy9uZXcvdGlsbWFhbWUvYXBpL3YxL2xvZ2luIiwiaWF0IjoxNzU5MTQ1MTIxLCJleHAiOjE3NjAzNTQ3MjEsIm5iZiI6MTc1OTE0NTEyMSwianRpIjoidEx0bWlqM3VPQXlKbXVBRiIsInN1YiI6IjM5IiwicHJ2IjoiMjNiZDVjODk0OWY2MDBhZGIzOWU3MDFjNDAwODcyZGI3YTU5NzZmNyJ9.aIxcBN8n4aDgBF4minTTMM3CUkuYNQ5NhdFD59fZ9uo",
      },
      body: jsonEncode(body),
    );

    print("POST $uri => ${res.statusCode}");
    print("Body (first 300 chars): ${res.body.substring(0, min(res.body.length, 300))}");

    if (res.body.trimLeft().startsWith('<')) {
      throw Exception("Invalid response (HTML) from server: ${res.body.substring(0, min(res.body.length, 400))}");
    }

    if (res.statusCode == 200) {
      return json.decode(res.body) as Map<String, dynamic>;
    } else if (res.statusCode == 401) {
      await _auth.logout();
      throw Exception("Unauthorized (401). Token removed, please login again.");
    } else {
      throw Exception("Request failed: ${res.statusCode} - ${res.body}");
    }
  }
}
