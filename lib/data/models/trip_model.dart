import 'city_model.dart';

enum VehicleType { sedan, suv, van, minibus }

class VehicleModel {
  final String id;
  final String make;
  final String model;
  final String plate;
  final int totalSeats;
  final VehicleType type;
  final bool hasAc;
  final bool hasWifi;
  final int luggageAllowanceKg;

  const VehicleModel({
    required this.id,
    required this.make,
    required this.model,
    required this.plate,
    required this.totalSeats,
    required this.type,
    required this.hasAc,
    required this.hasWifi,
    required this.luggageAllowanceKg,
  });

  factory VehicleModel.fromJson(Map<String, dynamic> json) {
    return VehicleModel(
      id: json['id'] as String,
      make: json['make'] as String,
      model: json['model'] as String,
      plate: json['plate'] as String,
      totalSeats: json['total_seats'] as int,
      type: VehicleType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => VehicleType.sedan,
      ),
      hasAc: json['has_ac'] as bool? ?? false,
      hasWifi: json['has_wifi'] as bool? ?? false,
      luggageAllowanceKg: json['luggage_kg'] as int? ?? 20,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'make': make,
    'model': model,
    'plate': plate,
    'total_seats': totalSeats,
    'type': type.name,
    'has_ac': hasAc,
    'has_wifi': hasWifi,
    'luggage_kg': luggageAllowanceKg,
  };
}

class TripModel {
  final String id;
  final CityModel fromCity;
  final CityModel toCity;
  final DateTime departureTime;
  final DateTime arrivalTime;
  final double price;
  final String driderId;
  final String driverName;
  final String companyName;
  final double driverRating;
  final VehicleModel vehicle;
  final List<int> bookedSeats;
  final List<String> stops;
  final String status;

  const TripModel({
    required this.id,
    required this.fromCity,
    required this.toCity,
    required this.departureTime,
    required this.arrivalTime,
    required this.price,
    required this.driderId,
    required this.driverName,
    required this.companyName,
    required this.driverRating,
    required this.vehicle,
    required this.bookedSeats,
    required this.stops,
    required this.status,
  });

  int get availableSeats => vehicle.totalSeats - bookedSeats.length - 1; // -1 for driver

  Duration get duration => arrivalTime.difference(departureTime);

  String get durationText {
    final h = duration.inHours;
    final m = duration.inMinutes % 60;
    if (m == 0) return '$h ساعت';
    return '$h ساعت $m دقیقه';
  }

  factory TripModel.fromJson(Map<String, dynamic> json) {
    return TripModel(
      id: json['id'] as String,
      fromCity: CityModel.fromJson(json['from_city'] as Map<String, dynamic>),
      toCity: CityModel.fromJson(json['to_city'] as Map<String, dynamic>),
      departureTime: DateTime.parse(json['departure_time'] as String),
      arrivalTime: DateTime.parse(json['arrival_time'] as String),
      price: (json['price'] as num).toDouble(),
      driderId: json['driver_id'] as String,
      driverName: json['driver_name'] as String,
      companyName: json['company_name'] as String,
      driverRating: (json['driver_rating'] as num).toDouble(),
      vehicle: VehicleModel.fromJson(json['vehicle'] as Map<String, dynamic>),
      bookedSeats: List<int>.from(json['booked_seats'] as List),
      stops: List<String>.from(json['stops'] as List? ?? []),
      status: json['status'] as String? ?? 'active',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'from_city': fromCity.toJson(),
    'to_city': toCity.toJson(),
    'departure_time': departureTime.toIso8601String(),
    'arrival_time': arrivalTime.toIso8601String(),
    'price': price,
    'driver_id': driderId,
    'driver_name': driverName,
    'company_name': companyName,
    'driver_rating': driverRating,
    'vehicle': vehicle.toJson(),
    'booked_seats': bookedSeats,
    'stops': stops,
    'status': status,
  };
}
