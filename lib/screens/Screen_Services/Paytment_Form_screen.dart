import 'package:flutter/material.dart';
import 'package:tilmaame/widget/color.dart';
import '../../Services/Payment/Payment_api.dart';
import '../../Services/Payment/Payment_model.dart';


class PaymentFormScreen extends StatefulWidget {
  final String? bookingId; // Optional: if payment is for a booking
  final String? prefillAmount; // Optional: amount to prefill

  const PaymentFormScreen({super.key, this.bookingId, this.prefillAmount});

  @override
  State<PaymentFormScreen> createState() => _PaymentFormScreenState();
}

class _PaymentFormScreenState extends State<PaymentFormScreen> {
  final formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final amountController = TextEditingController();
  final transactionIdController = TextEditingController();
  final senderAccountController = TextEditingController();
  final referenceController = TextEditingController();
  final noteController = TextEditingController();

  bool isLoading = false;

  final PaymentService paymentService = PaymentService();

  @override
  void initState() {
    super.initState();
    if (widget.prefillAmount != null) {
      amountController.text = widget.prefillAmount!;
    }
  }

  Future<void> submitPayment() async {
    if (!formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    try {
      final Payment payment = await paymentService.submitPayment(
        name: nameController.text,
        phone: phoneController.text,
        amount: amountController.text,
        transactionId: transactionIdController.text,
        senderAccount: senderAccountController.text,
        reference: referenceController.text,
        note: noteController.text,
        bookingId: widget.bookingId,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(payment.message),
          backgroundColor: payment.success ? Colors.green : Colors.red,
        ),
      );

      if (payment.success) {
        formKey.currentState!.reset();
        amountController.text = widget.prefillAmount ?? "";
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: $e"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Custom Payment'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Container(
            width: MediaQuery.of(context).size.width > 600 ? 600 : double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.deepOrange, width: 1.2),
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3))
              ],
            ),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "Make A Custom Payment",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "Zaad/E-dahab: 04206663001",
                    style: TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                  const SizedBox(height: 20),

                  // Name
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: "Name *", border: OutlineInputBorder()),
                    validator: (val) => val!.isEmpty ? "Enter name" : null,
                  ),
                  const SizedBox(height: 15),

                  // Phone + Amount
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: phoneController,
                          decoration: const InputDecoration(labelText: "Phone *", border: OutlineInputBorder()),
                          validator: (val) => val!.isEmpty ? "Enter phone" : null,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextFormField(
                          controller: amountController,
                          decoration: const InputDecoration(labelText: "Amount *", border: OutlineInputBorder()),
                          keyboardType: TextInputType.number,
                          validator: (val) => val!.isEmpty ? "Enter amount" : null,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),

                  // Transaction ID + Sender Account
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: transactionIdController,
                          decoration: const InputDecoration(labelText: "Transaction ID *", border: OutlineInputBorder()),
                          validator: (val) => val!.isEmpty ? "Enter transaction ID" : null,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextFormField(
                          controller: senderAccountController,
                          decoration: const InputDecoration(labelText: "Sender Account No *", border: OutlineInputBorder()),
                          validator: (val) => val!.isEmpty ? "Enter account no" : null,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),

                  // Reference No
                  TextFormField(
                    controller: referenceController,
                    decoration: const InputDecoration(labelText: "Reference/Invoice No *", border: OutlineInputBorder()),
                    validator: (val) => val!.isEmpty ? "Enter reference no" : null,
                  ),
                  const SizedBox(height: 15),

                  // Note
                  TextFormField(
                    controller: noteController,
                    maxLines: 3,
                    decoration: const InputDecoration(labelText: "Note", border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 20),

                  // Submit Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepOrange,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: isLoading ? null : submitPayment,
                      child: isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text("Submit", style: TextStyle(fontSize: 16, color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
