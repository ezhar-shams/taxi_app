import 'dart:math' as math;

// ─── Ride lifecycle ───────────────────────────────────────────────────────────

/// Full ride lifecycle states (mirrors a real Uber-style flow).
enum RideStatus {
  searchingDriver, // Radar animation — finding nearest driver
  driverAccepted,  // Driver matched, en-route to pickup
  driverArrived,   // Driver at pickup location
  inProgress,      // Trip underway — timer counting up
  completed,       // Successfully finished
  cancelled,       // Cancelled by user
}

/// Snapshot of a driver's current GPS position (for animated marker).
class DriverPosition {
  final double lat;
  final double lng;

  const DriverPosition(this.lat, this.lng);

  DriverPosition interpolateTo(DriverPosition target, double t) {
    return DriverPosition(
      lat + (target.lat - lat) * t,
      lng + (target.lng - lng) * t,
    );
  }
}

/// Complete in-flight ride context — drives the entire tracking UI.
class ActiveRide {
  final CityRideBooking booking;
  final RideStatus status;
  final DriverPosition driverPos;
  final int etaToPickupSec;  // countdown: sec until driver at pickup
  final int elapsedTripSec;  // count-up: sec since trip started
  final int? userRating;     // 1-5 stars, only set on completed

  const ActiveRide({
    required this.booking,
    required this.status,
    required this.driverPos,
    required this.etaToPickupSec,
    this.elapsedTripSec = 0,
    this.userRating,
  });

  ActiveRide copyWith({
    RideStatus? status,
    DriverPosition? driverPos,
    int? etaToPickupSec,
    int? elapsedTripSec,
    int? userRating,
  }) {
    return ActiveRide(
      booking: booking,
      status: status ?? this.status,
      driverPos: driverPos ?? this.driverPos,
      etaToPickupSec: etaToPickupSec ?? this.etaToPickupSec,
      elapsedTripSec: elapsedTripSec ?? this.elapsedTripSec,
      userRating: userRating ?? this.userRating,
    );
  }
}

// ─── Pickup location ──────────────────────────────────────────────────────────

/// A specific pickup or dropoff point (neighborhood / landmark).
class PickupLocation {
  final String id;
  final String nameFa;
  final String namePs;
  final String addressFa;
  final String addressPs;
  final String cityId;   // matches CityModel.id
  final double lat;
  final double lng;

  const PickupLocation({
    required this.id,
    required this.nameFa,
    required this.namePs,
    required this.addressFa,
    required this.addressPs,
    required this.cityId,
    required this.lat,
    required this.lng,
  });

  String name(String lang)    => lang == 'ps' ? namePs : nameFa;
  String address(String lang) => lang == 'ps' ? addressPs : addressFa;

  /// Haversine great-circle distance in km.
  double distanceTo(PickupLocation other) {
    const R = 6371.0;
    final dLat = _rad(other.lat - lat);
    final dLng = _rad(other.lng - lng);
    final a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_rad(lat)) * math.cos(_rad(other.lat)) *
            math.sin(dLng / 2) * math.sin(dLng / 2);
    return R * 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
  }

  static double _rad(double deg) => deg * math.pi / 180;

  @override
  bool operator ==(Object other) => other is PickupLocation && id == other.id;
  @override
  int get hashCode => id.hashCode;
}

// ---------------------------------------------------------------------------

enum CityRideVehicleType { economy, comfort, suv }

class CityRideOption {
  final String id;
  final String nameFa;
  final String namePs;
  final String descFa;
  final String descPs;
  final String iconAsset;   // display icon name (we use IconData instead)
  final CityRideVehicleType vehicleType;
  final double baseFare;
  final double perKmFare;
  final int capacity;
  final int minWaitMin;
  final int maxWaitMin;

  const CityRideOption({
    required this.id,
    required this.nameFa,
    required this.namePs,
    required this.descFa,
    required this.descPs,
    this.iconAsset = '',
    required this.vehicleType,
    required this.baseFare,
    required this.perKmFare,
    required this.capacity,
    required this.minWaitMin,
    required this.maxWaitMin,
  });

  String name(String lang) => lang == 'ps' ? namePs : nameFa;
  String desc(String lang) => lang == 'ps' ? descPs : descFa;

  double estimatedPrice(double distKm) => baseFare + (perKmFare * distKm);
}

// ---------------------------------------------------------------------------

class MockDriver {
  final String id;
  final String name;
  final String phone;
  final String vehicleMake;
  final String vehicleModel;
  final String plate;
  final double rating;
  final int totalTrips;
  final String photoInitials; // e.g. "ا" for avatar placeholder
  final double lat;           // driver's initial GPS latitude
  final double lng;           // driver's initial GPS longitude

  const MockDriver({
    required this.id,
    required this.name,
    required this.phone,
    required this.vehicleMake,
    required this.vehicleModel,
    required this.plate,
    required this.rating,
    required this.totalTrips,
    required this.photoInitials,
    required this.lat,
    required this.lng,
  });
}

// ---------------------------------------------------------------------------

class CityRideBooking {
  final String id;
  final PickupLocation pickup;
  final PickupLocation destination;
  final CityRideOption option;
  final MockDriver driver;
  final double distanceKm;
  final double totalPrice;
  final int etaMinutes;
  final DateTime bookedAt;

  const CityRideBooking({
    required this.id,
    required this.pickup,
    required this.destination,
    required this.option,
    required this.driver,
    required this.distanceKm,
    required this.totalPrice,
    required this.etaMinutes,
    required this.bookedAt,
  });
}
