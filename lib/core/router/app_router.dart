import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../presentation/screens/splash/splash_screen.dart';
import '../../presentation/screens/language/language_selection_screen.dart';
import '../../presentation/screens/auth/login_screen.dart';
import '../../presentation/screens/auth/register_screen.dart';
import '../../presentation/screens/auth/otp_screen.dart';
import '../../presentation/screens/home/home_screen.dart';
import '../../presentation/screens/search/search_results_screen.dart';
import '../../presentation/screens/trip/trip_details_screen.dart';
import '../../presentation/screens/seat/seat_selection_screen.dart';
import '../../presentation/screens/booking/booking_screen.dart';
import '../../presentation/screens/booking/booking_confirmation_screen.dart';
import '../../presentation/screens/ticket/digital_ticket_screen.dart';
import '../../presentation/screens/my_trips/my_trips_screen.dart';
import '../../presentation/screens/profile/profile_screen.dart';
import '../../presentation/screens/main/main_shell.dart';
import '../../presentation/screens/city_ride/city_ride_results_screen.dart';

// Route names
class AppRoutes {
  AppRoutes._();

  static const String splash          = '/';
  static const String languageSelect  = '/language';
  static const String login           = '/login';
  static const String register        = '/register';
  static const String otp             = '/otp';
  static const String home            = '/home';
  static const String searchResults   = '/search';
  static const String tripDetails     = '/trip/:id';
  static const String seatSelection   = '/trip/:id/seat';
  static const String booking         = '/trip/:id/book';
  static const String confirmation    = '/confirmation';
  static const String ticket          = '/ticket/:bookingId';
  static const String myTrips         = '/my-trips';
  static const String profileRoute    = '/profile';
  static const String cityRideResults = '/city-ride';

  static String tripPath(String id)        => '/trip/$id';
  static String seatPath(String id)        => '/trip/$id/seat';
  static String bookingPath(String id)     => '/trip/$id/book';
  static String ticketPath(String bookId)  => '/ticket/$bookId';
  static String cityRidePath({
    required String pickupId,
    required String destId,
  }) => '/city-ride?pickup=$pickupId&dest=$destId';
}

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: false,
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.languageSelect,
        builder: (context, state) => const LanguageSelectionScreen(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.register,
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: AppRoutes.otp,
        builder: (context, state) {
          final phone = state.uri.queryParameters['phone'] ?? '';
          return OtpScreen(phoneNumber: phone);
        },
      ),
      ShellRoute(
        builder: (context, state, child) => MainShell(child: child),
        routes: [
          GoRoute(
            path: AppRoutes.home,
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: AppRoutes.myTrips,
            builder: (context, state) => const MyTripsScreen(),
          ),
          GoRoute(
            path: AppRoutes.profileRoute,
            builder: (context, state) => const ProfileScreen(),
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.searchResults,
        builder: (context, state) {
          final params = state.uri.queryParameters;
          return SearchResultsScreen(
            fromCity: params['from'] ?? '',
            toCity: params['to'] ?? '',
            date: params['date'] ?? '',
            passengers: int.tryParse(params['passengers'] ?? '1') ?? 1,
          );
        },
      ),
      GoRoute(
        path: AppRoutes.tripDetails,
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return TripDetailsScreen(tripId: id);
        },
      ),
      GoRoute(
        path: AppRoutes.seatSelection,
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return SeatSelectionScreen(tripId: id);
        },
      ),
      GoRoute(
        path: AppRoutes.booking,
        builder: (context, state) {
          final params = state.uri.queryParameters;
          final id   = state.pathParameters['id'] ?? '';
          final seat = int.tryParse(params['seat'] ?? '1') ?? 1;
          return BookingScreen(tripId: id, selectedSeat: seat);
        },
      ),
      GoRoute(
        path: AppRoutes.confirmation,
        builder: (context, state) {
          final bookingId = state.uri.queryParameters['id'] ?? '';
          return BookingConfirmationScreen(bookingId: bookingId);
        },
      ),
      GoRoute(
        path: AppRoutes.ticket,
        builder: (context, state) {
          final bookingId = state.pathParameters['bookingId'] ?? '';
          return DigitalTicketScreen(bookingId: bookingId);
        },
      ),
      GoRoute(
        path: AppRoutes.cityRideResults,
        builder: (context, state) {
          final params = state.uri.queryParameters;
          return CityRideResultsScreen(
            pickupId: params['pickup'] ?? '',
            destId:   params['dest']   ?? '',
          );
        },
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('خطا: ${state.error}'),
      ),
    ),
  );
});
