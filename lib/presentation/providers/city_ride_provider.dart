import 'dart:async';
import 'dart:math' as math;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/city_ride_model.dart';

// ── Search state ─────────────────────────────────────────────────────────────

class CityRideSearchState {
  final PickupLocation? pickup;
  final PickupLocation? destination;

  const CityRideSearchState({this.pickup, this.destination});

  CityRideSearchState copyWith({
    PickupLocation? pickup,
    PickupLocation? destination,
    bool clearPickup = false,
    bool clearDest = false,
  }) {
    return CityRideSearchState(
      pickup:      clearPickup  ? null : pickup      ?? this.pickup,
      destination: clearDest   ? null : destination  ?? this.destination,
    );
  }
}

final cityRideSearchProvider =
    StateProvider<CityRideSearchState>((ref) => const CityRideSearchState());

// ── Selected ride option ──────────────────────────────────────────────────────

final selectedRideOptionProvider = StateProvider<String?>((ref) => null);

// ── Active booking (legacy — kept for compatibility) ─────────────────────────

final cityRideBookingProvider =
    StateProvider<CityRideBooking?>((ref) => null);

// ── Full ride state machine ───────────────────────────────────────────────────

/// Manages the entire ride lifecycle with timer-driven state transitions.
class ActiveRideNotifier extends StateNotifier<ActiveRide?> {
  ActiveRideNotifier() : super(null);

  Timer? _timer;
  DriverPosition? _pickupTarget;

  // ── Initial search phase ──────────────────────────────────────────────────

  /// Called when user presses "Request Ride". Creates initial state.
  void startSearch(CityRideBooking booking) {
    _timer?.cancel();
    final rng = math.Random();
    // Place driver 0.5-1.5 km away from pickup (random offset)
    final offsetLat = (rng.nextDouble() - 0.5) * 0.015;
    final offsetLng = (rng.nextDouble() - 0.5) * 0.015;
    final initialDriverPos = DriverPosition(
      booking.driver.lat + offsetLat,
      booking.driver.lng + offsetLng,
    );
    _pickupTarget = DriverPosition(booking.pickup.lat, booking.pickup.lng);

    state = ActiveRide(
      booking: booking,
      status: RideStatus.searchingDriver,
      driverPos: initialDriverPos,
      etaToPickupSec: booking.option.minWaitMin * 6, // 3min→18s, 5min→30s
    );
  }

  // ── Driver accepted ───────────────────────────────────────────────────────

  /// Called after DriverSearchScreen shows the match. Starts moving driver.
  void driverAccepted() {
    if (state == null) return;
    _timer?.cancel();
    state = state!.copyWith(status: RideStatus.driverAccepted);
    _startDriverArrivalCountdown();
  }

  void _startDriverArrivalCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (state == null) { _timer?.cancel(); return; }
      final newEta = state!.etaToPickupSec - 1;
      if (newEta <= 0) {
        _timer?.cancel();
        state = state!.copyWith(
          status: RideStatus.driverArrived,
          etaToPickupSec: 0,
          driverPos: _pickupTarget ?? state!.driverPos,
        );
      } else {
        // Smoothly move driver toward pickup
        final t = 1 - (newEta / state!.etaToPickupSec);
        final newPos = state!.driverPos.interpolateTo(
          _pickupTarget ?? state!.driverPos,
          math.min(0.06, t * 0.08),
        );
        state = state!.copyWith(etaToPickupSec: newEta, driverPos: newPos);
      }
    });
  }

  // ── Trip started ──────────────────────────────────────────────────────────

  /// Called when user (or driver) presses "Start Ride".
  void startTrip() {
    if (state == null) return;
    _timer?.cancel();
    state = state!.copyWith(status: RideStatus.inProgress, elapsedTripSec: 0);
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (state == null) { _timer?.cancel(); return; }
      state = state!.copyWith(elapsedTripSec: state!.elapsedTripSec + 1);
    });
  }

  // ── Trip ended ────────────────────────────────────────────────────────────

  /// Called when driver presses "End Ride".
  void endTrip() {
    _timer?.cancel();
    if (state == null) return;
    state = state!.copyWith(status: RideStatus.completed);
  }

  // ── Rating ────────────────────────────────────────────────────────────────

  void rateDriver(int stars) {
    if (state == null) return;
    state = state!.copyWith(userRating: stars);
  }

  // ── Cancel ────────────────────────────────────────────────────────────────

  void cancelRide() {
    _timer?.cancel();
    if (state == null) return;
    state = state!.copyWith(status: RideStatus.cancelled);
  }

  // ── Reset ─────────────────────────────────────────────────────────────────

  void reset() {
    _timer?.cancel();
    _pickupTarget = null;
    state = null;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

final activeRideProvider =
    StateNotifierProvider<ActiveRideNotifier, ActiveRide?>(
  (_) => ActiveRideNotifier(),
);

