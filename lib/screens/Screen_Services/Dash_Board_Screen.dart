import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tilmaame/Screens/Home_screen.dart';
import '../../Services/Booking/Booking_api.dart';
import '../../widget/color.dart';
import '../../Services/Booking/Booking_Model.dart';
import 'Booking_screwen.dart';
import 'Paytment_Form_screen.dart';

import 'Web_view.dart';

class DashboardScreen extends StatefulWidget {
  final bool isFromDrawer;
  final bool isFromBooking;
  const DashboardScreen({super.key,  this.isFromDrawer = false, this.isFromBooking =false});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late Future<List<Booking>> futureBookings;
  final BookingService bookingService = BookingService();

  @override
  void initState() {
    super.initState();
    futureBookings = bookingService.fetchBookings();
  }

  bool get isMobile => MediaQuery.of(context).size.width < 600;

  /// 🎯 Open checkout URL inside WebView
  void openPaymentWebView(String checkoutUrl, int amount) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentWebView(
          checkoutUrl: checkoutUrl,
          amount: amount,
        ),
      ),
    );
  }
  ///  Launch Sifalo payment
  Future<void> launchSifaloPayment(int bookingId, int amount) async {
    try {
      final checkoutUrl = await bookingService.initiateSifaloPayment(bookingId, amount);

      if (checkoutUrl != null && checkoutUrl.isNotEmpty) {
        openPaymentWebView(checkoutUrl, amount);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("❌ Payment URL not available")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("❌ Error: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (widget.isFromDrawer) {
          Get.offAll(() => const HomePage());
          return false;
        } else if (widget.isFromBooking) {
          Get.offAll(() => BookingFormPage(
            carName: '',
            carId: '',
            amount: 0,
            userId: '',
          ));
          return false;
        }
        return true; // default back
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text(
            "Dashboard",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: AppColors.primary,
          centerTitle: true,
        ),
        body: FutureBuilder<List<Booking>>(
          future: futureBookings,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                  child: CircularProgressIndicator(color: AppColors.primary));
            } else if (snapshot.hasError) {
              return Center(
                  child: Text(
                    "❌ Error: ${snapshot.error}",
                    style: TextStyle(color: AppColors.textDark),
                  ));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                  child: Text(
                    "⚠️ No bookings found",
                    style: TextStyle(color: AppColors.textLight),
                  ));
            }

            final bookings = snapshot.data!;

            if (isMobile) {
              return ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: bookings.length,
                itemBuilder: (context, index) {
                  final b = bookings[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(b.carTitle,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16)),
                          const SizedBox(height: 6),
                          Text("Invoice: ${b.orderNumber}"),
                          Text("Start: ${b.startDate}"),
                          Text("End: ${b.endDate}"),
                          Text("Amount: ৳${b.amount}"),
                          const SizedBox(height: 6),
                          Text(
                            b.status.toLowerCase() == "confirmed"
                                ? "Confirmed"
                                : b.status,
                            style: TextStyle(
                                color: b.status.toLowerCase() == "confirmed"
                                    ? Colors.green
                                    : Colors.orange,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                PaymentFormScreen(
                                                    bookingId: b.orderNumber,
                                                    prefillAmount: b.amount
                                                        .toString())));
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.primary,
                                      foregroundColor: Colors.white),
                                  child: const Text("Pay"),
                                ),
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: () {
                                    launchSifaloPayment(
                                        b.id, b.amount); // use numeric bookingId
                                  },
                                  style: OutlinedButton.styleFrom(
                                      side: const BorderSide(color: Colors.red),
                                      foregroundColor: Colors.red),
                                  child: Text(
                                      "Pay via Sifalo (৳${b.amount})"),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }

            return const Center(
                child: Text("Desktop/Table view code "));
          },
        ),
      ),
    );
  }
}


