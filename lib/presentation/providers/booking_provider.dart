import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/booking_model.dart';
import '../../data/mock_data.dart';

class BookingFormState {
  final String passengerName;
  final String passengerPhone;
  final String nationalId;
  final String emergencyContact;
  final PaymentMethod paymentMethod;
  final bool isLoading;
  final String? error;

  const BookingFormState({
    this.passengerName = '',
    this.passengerPhone = '',
    this.nationalId = '',
    this.emergencyContact = '',
    this.paymentMethod = PaymentMethod.atPickup,
    this.isLoading = false,
    this.error,
  });

  BookingFormState copyWith({
    String? passengerName,
    String? passengerPhone,
    String? nationalId,
    String? emergencyContact,
    PaymentMethod? paymentMethod,
    bool? isLoading,
    String? error,
  }) {
    return BookingFormState(
      passengerName: passengerName ?? this.passengerName,
      passengerPhone: passengerPhone ?? this.passengerPhone,
      nationalId: nationalId ?? this.nationalId,
      emergencyContact: emergencyContact ?? this.emergencyContact,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

final bookingFormProvider = StateNotifierProvider<BookingFormNotifier, BookingFormState>(
  (ref) => BookingFormNotifier(),
);

class BookingFormNotifier extends StateNotifier<BookingFormState> {
  BookingFormNotifier() : super(const BookingFormState());

  void setName(String v)            => state = state.copyWith(passengerName: v);
  void setPhone(String v)           => state = state.copyWith(passengerPhone: v);
  void setNationalId(String v)      => state = state.copyWith(nationalId: v);
  void setEmergencyContact(String v) => state = state.copyWith(emergencyContact: v);
  void setPaymentMethod(PaymentMethod p) => state = state.copyWith(paymentMethod: p);

  Future<BookingModel?> confirmBooking({
    required String tripId,
    required String userId,
    required int seatNumber,
    required double price,
  }) async {
    if (state.passengerName.isEmpty || state.passengerPhone.isEmpty) {
      state = state.copyWith(error: 'missing_fields');
      return null;
    }

    state = state.copyWith(isLoading: true, error: null);
    await Future.delayed(const Duration(seconds: 1));

    final trip = MockData.tripById(tripId);
    if (trip == null) {
      state = state.copyWith(isLoading: false, error: 'trip_not_found');
      return null;
    }

    final booking = BookingModel(
      id: 'BK${DateTime.now().millisecondsSinceEpoch}',
      tripId: tripId,
      userId: userId,
      passengerName: state.passengerName,
      passengerPhone: state.passengerPhone,
      passengerNationalId: state.nationalId,
      seatNumber: seatNumber,
      totalPrice: price,
      status: BookingStatus.confirmed,
      paymentMethod: state.paymentMethod,
      bookedAt: DateTime.now(),
      fromCityFa: trip.fromCity.nameFa,
      fromCityPs: trip.fromCity.namePs,
      toCityFa: trip.toCity.nameFa,
      toCityPs: trip.toCity.namePs,
      departureTime: trip.departureTime,
      driverName: trip.driverName,
      vehiclePlate: trip.vehicle.plate,
    );

    MockData.sampleBookings.add(booking);
    state = state.copyWith(isLoading: false);
    return booking;
  }

  void reset() => state = const BookingFormState();
}

// User bookings
final userBookingsProvider = Provider<List<BookingModel>>((ref) {
  return MockData.sampleBookings;
});

final bookingByIdProvider = Provider.family<BookingModel?, String>((ref, id) {
  return MockData.bookingById(id);
});
