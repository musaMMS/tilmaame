import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tilmaame/Screens/Car_details_screen.dart';
import '../../widget/Network_image.dart';
import '../Screen_Services/Dash_Board_Screen.dart';
import '../../widget/color.dart';
import '../Home_screen.dart';

class BookingFormPage extends StatefulWidget {
  final String carId;
  final String carName;
  final int amount;
  final String userId;

  const BookingFormPage({
    super.key,
    required this.carName,
    required this.carId,
    required this.amount, required this.userId,
  });

  @override
  State<BookingFormPage> createState() => _BookingFormPageState();
}

class _BookingFormPageState extends State<BookingFormPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _carNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  DateTime? _startDate;
  DateTime? _endDate;
  String _userId = "";

  @override
  void initState() {
    super.initState();
    _carNameController.text = widget.carName;
    _amountController.text = widget.amount.toString();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userId = prefs.getString('user_id') ?? '';
    });
  }

  void _calculateTotalAmount() {
    if (_startDate != null && _endDate != null) {
      final duration = _endDate!.difference(_startDate!).inDays + 1;
      final totalAmount = duration > 0 ? widget.amount * duration : widget.amount;
      _amountController.text = totalAmount.toString();
    }
  }

  Future<void> _pickDate(BuildContext context, bool isStart) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
          if (_endDate != null && _endDate!.isBefore(_startDate!)) {
            _endDate = null;
          }
        } else {
          _endDate = picked;
        }
        _calculateTotalAmount();
      });
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;
    if (_startDate == null || _endDate == null) {
      Get.snackbar("Error", "Please select start and end dates",
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    if (_userId.isEmpty) {
      Get.snackbar("Error", "You are not logged in",
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    final startDate =
        "${_startDate!.year}-${_startDate!.month.toString().padLeft(2, '0')}-${_startDate!.day.toString().padLeft(2, '0')}";
    final endDate =
        "${_endDate!.year}-${_endDate!.month.toString().padLeft(2, '0')}-${_endDate!.day.toString().padLeft(2, '0')}";

    final bookingData = {
      "car_id": widget.carId,
      "phone": _phoneController.text,
      "amount": _amountController.text,
      "start_date": startDate,
      "end_date": endDate,
      "note": _noteController.text,
      "user_id": _userId, // ✅ dynamic userId
      "order_number": "INV-${DateTime.now().millisecondsSinceEpoch}"
    };

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token') ?? "";

    if (token.isEmpty) {
      Get.snackbar("Error", "You are not logged in",
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    final url =
    Uri.parse("https://apps.piit.us/new/tilmaame/api/v1/booking-store");

    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token", // ✅ dynamic token
        },
        body: json.encode(bookingData),
      );

      print("📤 Booking Request Data: $bookingData");
      print("📥 Booking Response: ${response.statusCode} -> ${response.body}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          Get.snackbar("✅ Success", "Booking Created Successfully",
              backgroundColor: Colors.green, colorText: Colors.white);
          Get.offAll(() => const DashboardScreen(isFromDrawer: false));
        } else {
          Get.snackbar("⚠️ Failed", data['message'] ?? "Booking failed",
              backgroundColor: Colors.red, colorText: Colors.white);
        }
      } else if (response.statusCode == 401) {
        Get.snackbar("❌ Unauthorized", "Please login again",
            backgroundColor: Colors.red, colorText: Colors.white);
        Get.offAll(() => const HomePage());
      } else {
        Get.snackbar("❌ Error", "Server Error: ${response.statusCode}",
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar("❌ Error", "Something went wrong: $e",
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.offAll(() => CarDetailsScreen(
          carId: '',
          title: '',
          image: '',
          price: '',
          features: '',
          description: '',
          carType: '',
          userId: '',
        ));
        return false;
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text(
            "Booking Form",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: AppColors.primary,
          centerTitle: true,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.network(
                  NetworkImages.banner,
                  fit: BoxFit.cover,
                  height: 220,
                  width: double.infinity,
                ),
                const SizedBox(height: 20),
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    "BOOK",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: AppColors.primary),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  "Book ${widget.carName}",
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark),
                ),
                const SizedBox(height: 20),
                Form(
                  key: _formKey,
                  child: Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(color: AppColors.primary),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 20),
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _carNameController,
                            readOnly: true,
                            decoration: InputDecoration(
                              labelText: "Car Name *",
                              border: const OutlineInputBorder(),
                              labelStyle: TextStyle(color: AppColors.textDark),
                            ),
                          ),
                          const SizedBox(height: 15),
                          Row(
                            children: [
                              Expanded(
                                child: InkWell(
                                  onTap: () => _pickDate(context, true),
                                  child: InputDecorator(
                                    decoration: InputDecoration(
                                      labelText: "Booking Start Date *",
                                      border: const OutlineInputBorder(),
                                      labelStyle:
                                      TextStyle(color: AppColors.textDark),
                                    ),
                                    child: Text(_startDate == null
                                        ? "mm/dd/yyyy"
                                        : "${_startDate!.month}/${_startDate!.day}/${_startDate!.year}"),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: InkWell(
                                  onTap: () => _pickDate(context, false),
                                  child: InputDecorator(
                                    decoration: InputDecoration(
                                      labelText: "Booking End Date *",
                                      border: const OutlineInputBorder(),
                                      labelStyle:
                                      TextStyle(color: AppColors.textDark),
                                    ),
                                    child: Text(_endDate == null
                                        ? "mm/dd/yyyy"
                                        : "${_endDate!.month}/${_endDate!.day}/${_endDate!.year}"),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          TextFormField(
                            controller: _phoneController,
                            keyboardType: TextInputType.phone,
                            validator: (value) =>
                            value!.isEmpty ? "Enter phone number" : null,
                            decoration: InputDecoration(
                              labelText: "Phone *",
                              border: const OutlineInputBorder(),
                              labelStyle: TextStyle(color: AppColors.textDark),
                            ),
                          ),
                          const SizedBox(height: 15),
                          TextFormField(
                            controller: _amountController,
                            readOnly: true,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: "Amount *",
                              border: const OutlineInputBorder(),
                              labelStyle: TextStyle(color: AppColors.textDark),
                            ),
                          ),
                          const SizedBox(height: 15),
                          TextFormField(
                            controller: _noteController,
                            maxLines: 3,
                            decoration: InputDecoration(
                              labelText: "Note",
                              border: const OutlineInputBorder(),
                              labelStyle: TextStyle(color: AppColors.textDark),
                            ),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: _submitForm,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text("Submit"),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
