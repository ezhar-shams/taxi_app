enum BookingStatus { confirmed, cancelled, completed, pending }
enum PaymentMethod { online, atPickup }

class BookingModel {
  final String id;
  final String tripId;
  final String userId;
  final String passengerName;
  final String passengerPhone;
  final String passengerNationalId;
  final int seatNumber;
  final double totalPrice;
  final BookingStatus status;
  final PaymentMethod paymentMethod;
  final DateTime bookedAt;

  // Denormalized for display
  final String fromCityFa;
  final String fromCityPs;
  final String toCityFa;
  final String toCityPs;
  final DateTime departureTime;
  final String driverName;
  final String vehiclePlate;

  const BookingModel({
    required this.id,
    required this.tripId,
    required this.userId,
    required this.passengerName,
    required this.passengerPhone,
    required this.passengerNationalId,
    required this.seatNumber,
    required this.totalPrice,
    required this.status,
    required this.paymentMethod,
    required this.bookedAt,
    required this.fromCityFa,
    required this.fromCityPs,
    required this.toCityFa,
    required this.toCityPs,
    required this.departureTime,
    required this.driverName,
    required this.vehiclePlate,
  });

  String fromCity(String lang) => lang == 'ps' ? fromCityPs : fromCityFa;
  String toCity(String lang)   => lang == 'ps' ? toCityPs   : toCityFa;

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['id'] as String,
      tripId: json['trip_id'] as String,
      userId: json['user_id'] as String,
      passengerName: json['passenger_name'] as String,
      passengerPhone: json['passenger_phone'] as String,
      passengerNationalId: json['passenger_national_id'] as String? ?? '',
      seatNumber: json['seat_number'] as int,
      totalPrice: (json['total_price'] as num).toDouble(),
      status: BookingStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => BookingStatus.pending,
      ),
      paymentMethod: PaymentMethod.values.firstWhere(
        (e) => e.name == json['payment_method'],
        orElse: () => PaymentMethod.atPickup,
      ),
      bookedAt: DateTime.parse(json['booked_at'] as String),
      fromCityFa: json['from_city_fa'] as String,
      fromCityPs: json['from_city_ps'] as String,
      toCityFa: json['to_city_fa'] as String,
      toCityPs: json['to_city_ps'] as String,
      departureTime: DateTime.parse(json['departure_time'] as String),
      driverName: json['driver_name'] as String,
      vehiclePlate: json['vehicle_plate'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'trip_id': tripId,
    'user_id': userId,
    'passenger_name': passengerName,
    'passenger_phone': passengerPhone,
    'passenger_national_id': passengerNationalId,
    'seat_number': seatNumber,
    'total_price': totalPrice,
    'status': status.name,
    'payment_method': paymentMethod.name,
    'booked_at': bookedAt.toIso8601String(),
    'from_city_fa': fromCityFa,
    'from_city_ps': fromCityPs,
    'to_city_fa': toCityFa,
    'to_city_ps': toCityPs,
    'departure_time': departureTime.toIso8601String(),
    'driver_name': driverName,
    'vehicle_plate': vehiclePlate,
  };
}
