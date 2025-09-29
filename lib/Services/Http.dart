// import 'dart:convert';
// import 'package:http/http.dart' as http;
//
// Future<void> updateProfileApi({
//   required String name,
//   required String email,
//   required String phone,
//   String? password,
// }) async {
//   final url = Uri.parse('https://apps.piit.us/new/tilmaame/api/v1/profile-update');
//
//   final headers = {
//     "Content-Type": "application/json",
//     "Authorization": "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwczovL2FwcHMucGlpdC51cy9uZXcvdGlsbWFhbWUvYXBpL3YxL2xvZ2luIiwiaWF0IjoxNzU4NjAzMzExLCJleHAiOjE3NTk4MTI5MTEsIm5iZiI6MTc1ODYwMzMxMSwianRpIjoiU0JWNWFUZVI1U0RlTXQweiIsInN1YiI6IjIyIiwicHJ2IjoiMjNiZDVjODk0OWY2MDBhZGIzOWU3MDFjNDAwODcyZGI3YTU5NzZmNyJ9.9SUWOkPuhn5EuzcmqK4fAh2K2wiTNZoq8BDjxSc1kkI",
//   };
//
//   final body = jsonEncode({
//     "name": name,
//     "email": email,
//     "phone": phone,
//     if (password != null && password.isNotEmpty) "password": password,
//   });
//
//   final response = await http.post(url, headers: headers, body: body);
//
//   print('Response status: ${response.statusCode}');
//   print('Response body: ${response.body}');
//
//   if (response.statusCode == 200) {
//     final data = json.decode(response.body);
//     if (data['success'] == true) {
//       print("Profile updated successfully: ${data['message']}");
//     } else {
//       print("Update failed: ${data['message']}");
//     }
//   } else {
//     print("HTTP error: ${response.statusCode}");
//   }
// }
