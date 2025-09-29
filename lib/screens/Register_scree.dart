import 'package:flutter/material.dart';
import '../Services/Log_In/Log_In_Api_Servicews.dart' show ApiService;
import '../Services/Register/Register_Api_Services.dart';
import '../widget/Network_image.dart';
import 'LogIn_screen.dart';
import 'Screen_Services/Booking_screwen.dart';

class RegisterScreen extends StatefulWidget {
  final String carName;
  final int amount; // amount as int
  final String carId; // carId as string
  final VoidCallback? onRegisterSuc;

  const RegisterScreen({
    super.key,
    required this.carName,
    required this.amount,
    required this.carId, // pass carId as parameter
    this.onRegisterSuc,
  });

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  final ApiService apiService = ApiService();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Banner
            Image.network(
              NetworkImages.banner,
              fit: BoxFit.cover,
              height: 220,
              width: double.infinity,
            ),
            const SizedBox(height: 20),

            // Register Title
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.deepOrange,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: const Text(
                "Register",
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
                  TextSpan(text: "Register  ", style: TextStyle(color: Colors.black)),
                  TextSpan(text: "As ", style: TextStyle(color: Colors.deepOrange)),
                  TextSpan(text: "A New User", style: TextStyle(color: Colors.black)),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Form Card
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
                      buildTextField("Name", Icons.person, controller: nameController),
                      const SizedBox(height: 12),
                      buildTextField("Phone", Icons.phone, controller: phoneController),
                      const SizedBox(height: 12),
                      buildTextField("Email Address", Icons.email, controller: emailController),
                      const SizedBox(height: 12),
                      buildTextField("Password", Icons.lock, isPassword: true, controller: passwordController),
                      const SizedBox(height: 12),
                      buildTextField("Confirm Password", Icons.lock_outline, isPassword: true, controller: confirmPasswordController),
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
                          onPressed: isLoading ? null : _registerUser,
                          child: isLoading
                              ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                          )
                              : const Text(
                            "Register",
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

  Future<void> _registerUser() async {
    if (nameController.text.isEmpty ||
        phoneController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      _showMessage("Please fill all fields");
      return;
    }

    if (passwordController.text != confirmPasswordController.text) {
      _showMessage("Passwords do not match");
      return;
    }

    setState(() => isLoading = true);

    try {
      final response = await apiService.register(
        nameController.text.trim(),
        phoneController.text.trim(),
        emailController.text.trim(),
        passwordController.text.trim(),
      );

      if (response['success'] == true) {
        _showMessage(response['message'] ?? "Registration successful!", success: true);

        // Navigate to LogInScreen with updated callback
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => LogInScreen(
              onLoginSuc: (String userId, String token) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => BookingFormPage(
                      carName: widget.carName,
                      amount: widget.amount,
                      carId: widget.carId,
                      userId: userId,
                    ),
                  ),
                );
              },
            ),
          ),
        );
      } else if (response['errors'] != null) {
        String errorMsg = (response['errors'] as Map).values.map((e) => e[0]).join('\n');
        _showMessage(errorMsg);
      } else {
        _showMessage(response['message'] ?? "Something went wrong.");
      }
    } catch (e) {
      _showMessage("Unable to connect to server. Please check your internet.");
    } finally {
      setState(() => isLoading = false);
    }
  }


  void _showMessage(String message, {bool success = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: success ? Colors.green : Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Widget buildTextField(String label, IconData icon, {bool isPassword = false, TextEditingController? controller}) {
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
