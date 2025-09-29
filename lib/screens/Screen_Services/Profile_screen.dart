import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Services/Profile/profile_services.dart';
import '../../widget/Network_image.dart';
import '../../widget/color.dart';
import '../Home_screen.dart';

class ProfileUpdatePage extends StatefulWidget {
  const ProfileUpdatePage({super.key});

  @override
  State<ProfileUpdatePage> createState() => _ProfileUpdatePageState();
}

class _ProfileUpdatePageState extends State<ProfileUpdatePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  File? _drivingLicense;
  bool _isLoading = false;

  // Pick image
  Future<void> _pickImage() async {
    final pickedFile =
    await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _drivingLicense = File(pickedFile.path);
      });
    }
  }

  // Submit profile update
  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("❌ No token found. Please login first."),
            backgroundColor: Colors.red,
          ),
        );
        setState(() => _isLoading = false);
        return;
      }

      debugPrint("➡️ Sending profile update request...");

      final response = await ApiService().updateProfile(
        name: _nameController.text,
        email: _emailController.text,
        phone: _phoneController.text,
        password: _passwordController.text,
        confirmPassword: _confirmPasswordController.text,
        drivingLicense: _drivingLicense,
      );

      if (!mounted) return;

      if (response.success) {
        // ✅ Success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("✅ ${response.message}"),
            backgroundColor: Colors.green,
          ),
        );

        // ✅ Delay দিয়ে HomePage এ নিয়ে যাওয়া
        Future.delayed(const Duration(seconds: 1), () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
          );
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("❌ ${response.message}"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("❌ Error: $e"),
          backgroundColor: Colors.red,
        ),
      );
      debugPrint("❌ Exception: $e");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }


  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text("About Us",style: TextStyle(color:Colors.white),),
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Image.network(
                NetworkImages.banner,
                fit: BoxFit.cover,
                height: 220,
                width: double.infinity,
              ),
              const Text(
                "PROFILE",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Update Your Profile",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: 500,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.orange.shade200),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.orange.shade100.withOpacity(0.5),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    )
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _nameController,
                        decoration: _inputDecoration("Name *"),
                        validator: (v) => v!.isEmpty ? "Enter your name" : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _emailController,
                        decoration: _inputDecoration("Email Address *"),
                        validator: (v) => v!.isEmpty ? "Enter your email" : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _phoneController,
                        decoration: _inputDecoration("Phone *"),
                        validator: (v) => v!.isEmpty ? "Enter your phone" : null,
                      ),
                      const SizedBox(height: 12),

                      Row(
                        children: [
                          ElevatedButton(
                            onPressed: _pickImage,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.button,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text("Choose File"),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              _drivingLicense != null
                                  ? _drivingLicense!.path.split("/").last
                                  : "No file chosen",
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      if (_drivingLicense != null)
                        Container(
                          width: 200,
                          height: 150,
                          decoration: BoxDecoration(
                            border: Border.all(color:AppColors.button),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Image.file(
                            _drivingLicense!,
                            fit: BoxFit.cover,
                          ),
                        ),

                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _passwordController,
                        decoration: _inputDecoration("Password"),
                        obscureText: true,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _confirmPasswordController,
                        decoration: _inputDecoration("Confirm Password"),
                        obscureText: true,
                      ),
                      const SizedBox(height: 20),

                      ElevatedButton(
                        onPressed: _isLoading ? null : _submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.button,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40, vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                            : const Text(
                          "Submit",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
