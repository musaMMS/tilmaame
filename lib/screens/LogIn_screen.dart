import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'Home_screen.dart';
import 'Register_scree.dart';

class LogInScreen extends StatefulWidget {
  final Function(String userId, String token)? onLoginSuc;

  const LogInScreen({super.key, this.onLoginSuc});

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  // ✅ safe setState
  void safeSetState(VoidCallback fn) {
    if (mounted) setState(fn);
  }

  // ✅ Login function updated
  Future<void> loginUser(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      showMessage("Email & Password required!");
      return;
    }

    safeSetState(() => isLoading = true);

    try {
      final uri = Uri.parse("https://apps.piit.us/new/tilmaame/api/v1/login");

      debugPrint("🌍 Trying to login...");
      debugPrint("➡️ URL: $uri");
      debugPrint("➡️ Email: $email");

      final response = await http.post(
        uri,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode({"email": email.trim(), "password": password.trim()}),
      ).timeout(const Duration(seconds: 20));

      debugPrint("📩 Status Code: ${response.statusCode}");
      debugPrint("📩 Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final userId = data['user']?['id']?.toString() ?? "";
        final token = data['authorisation']?['token']?.toString() ?? "";

        if (token.isEmpty || userId.isEmpty) {
          showMessage("Invalid server response");
          return;
        }

        // ✅ Save token & user_id safely
        try {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString("auth_token", token);
          await prefs.setString("user_id", userId);
          debugPrint("✅ Token & UserID saved successfully");
        } catch (e) {
          debugPrint("❌ SharedPreferences Save Error: $e");
        }

        widget.onLoginSuc?.call(userId, token);

        showMessage("Login Successful", success: true);
        Get.offAll(() => const HomePage());
      } else {
        String message = "Login failed";
        try {
          final errorData = json.decode(response.body);
          message = errorData['message'] ?? message;
        } catch (e) {
          debugPrint("❌ Response parse error: $e");
        }
        showMessage(message);
      }
    } on TimeoutException {
      showMessage("⏳ Server timeout, try again.");
      debugPrint("❌ TimeoutException: Server not responding within 20s");
    } on http.ClientException catch (e) {
      showMessage("Network error: $e");
      debugPrint("❌ ClientException: $e");
    } catch (e) {
      showMessage("Unexpected error: $e");
      debugPrint("❌ Unexpected Error: $e");
    } finally {
      safeSetState(() => isLoading = false);
    }
  }



  void showMessage(String message, {bool success = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: success ? Colors.green : Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.network(
              "https://apps.piit.us/new/tilmaame/assets/frontend/img/top_banner_2.png",
              fit: BoxFit.cover,
              height: 220,
              width: double.infinity,
            ),
            const SizedBox(height: 40),

            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: () => Get.offAll(() => const HomePage()),
                child: const Text(
                  "Skip",
                  style: TextStyle(color: Colors.deepOrange, fontWeight: FontWeight.bold),
                ),
              ),
            ),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.deepOrange,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                "LOGIN",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
            ),
            const SizedBox(height: 20),

            RichText(
              text: const TextSpan(
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                children: [
                  TextSpan(text: "Login ", style: TextStyle(color: Colors.black)),
                  TextSpan(text: "To ", style: TextStyle(color: Colors.deepOrange)),
                  TextSpan(text: "Your Account", style: TextStyle(color: Colors.black)),
                ],
              ),
            ),
            const SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Don't Have An Account? "),
                GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RegisterScreen(
                        carName: 'Toyota RAV4',
                        amount: 5000,
                        carId: '1',
                      ),
                    ),
                  ),
                  child: const Text(
                    "Register Here",
                    style: TextStyle(
                      color: Colors.deepOrange,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Card(
                elevation: 6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      buildTextField("Your Email", Icons.email, controller: emailController),
                      const SizedBox(height: 12),
                      buildTextField("Password", Icons.lock, isPassword: true, controller: passwordController),
                      const SizedBox(height: 20),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            backgroundColor: Colors.deepOrange,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          onPressed: isLoading
                              ? null
                              : () {
                            loginUser(emailController.text, passwordController.text);
                          },
                          child: isLoading
                              ? const CircularProgressIndicator(color: Colors.white)
                              : const Text(
                            "Login",
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTextField(String label, IconData icon,
      {bool isPassword = false, TextEditingController? controller}) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.deepOrange),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.deepOrange, width: 2),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}

