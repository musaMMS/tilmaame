class Booking {
  final int id;
  final String carId;
  final String orderNumber;
  final String carTitle;
  final String startDate;
  final String endDate;
  final int amount;
  final String status;
  final String? checkoutUrl;

  Booking({
    required this.id,
    required this.carId,
    required this.orderNumber,
    required this.carTitle,
    required this.startDate,
    required this.endDate,
    required this.amount,
    required this.status,
    this.checkoutUrl,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: int.parse(json['id'].toString()),
      carId: json['car_id'].toString(),
      orderNumber: json['order_number'] ?? '',
      carTitle: json['car_title'] ?? '',
      startDate: json['start_date'] ?? '',
      endDate: json['end_date'] ?? '',
      amount: int.parse(json['amount'].toString()),
      status: json['status'] ?? 'Pending',
      checkoutUrl: json['checkout_url'],
    );
  }
}
