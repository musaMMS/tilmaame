import 'package:flutter/material.dart';
import 'login_screen.dart';

class BookNowDialog extends StatefulWidget {

  const BookNowDialog({super.key});

  @override
  State<BookNowDialog> createState() => _BookNowDialogState();
}

class _BookNowDialogState extends State<BookNowDialog> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController subjectController = TextEditingController();
  final TextEditingController messageController = TextEditingController();

  bool isLoading = false;
  bool isLoggedIn = false;
  void submitForm() {
    if (nameController.text.isEmpty ||
        phoneController.text.isEmpty ||
        subjectController.text.isEmpty ||
        messageController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill all required fields"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Form submitted successfully!"),
        backgroundColor: Colors.green,
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Book Now",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              /// Name
              _textField("Your Name", controller: nameController),
              const SizedBox(height: 12),

              /// Phone + Email (row)
              Row(
                children: [
                  Expanded(child: _textField("Your Phone", controller: phoneController)),
                  const SizedBox(width: 10),
                  Expanded(child: _textField("Your Email (optional)", controller: emailController)),
                ],
              ),
              const SizedBox(height: 12),

              /// Subject
              _textField("Subject", controller: subjectController),
              const SizedBox(height: 12),

              /// Message
              _textField("Message", maxLines: 4, controller: messageController),
              const SizedBox(height: 20),

              /// Book Now Button → Login check & BookingScreen
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  // onPressed: handleBookNow,
                  onPressed: () {  },
                  child: const Text(
                    "Book Now",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _textField(String hint,
      {int maxLines = 1, TextEditingController? controller}) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      ),
    );
  }
}
