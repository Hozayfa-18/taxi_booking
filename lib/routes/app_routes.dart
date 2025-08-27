import 'package:flutter/material.dart';
import '../presentation/trip_summary_screen/trip_summary_screen.dart';
import '../presentation/splash_screen/splash_screen.dart';
import '../presentation/history_screen/history_screen.dart';
import '../presentation/ride_tracking_screen/ride_tracking_screen.dart';
import '../presentation/fare_selection_screen/fare_selection_screen.dart';
import '../presentation/booking_confirmation_screen/booking_confirmation_screen.dart';
import '../presentation/profile_screen/profile_screen.dart';
import '../presentation/home_screen/home_screen.dart';
import '../presentation/driver_details_screen/driver_details_screen.dart';
import '../presentation/payment_methods_screen/payment_methods_screen.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String tripSummary = '/trip-summary-screen';
  static const String splash = '/splash-screen';
  static const String history = '/history-screen';
  static const String rideTracking = '/ride-tracking-screen';
  static const String fareSelection = '/fare-selection-screen';
  static const String bookingConfirmation = '/booking-confirmation-screen';
  static const String profile = '/profile-screen';
  static const String home = '/home-screen';
  static const String driverDetails = '/driver-details-screen';
  static const String paymentMethods = '/payment-methods-screen';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const SplashScreen(),
    tripSummary: (context) => const TripSummaryScreen(),
    splash: (context) => const SplashScreen(),
    history: (context) => const HistoryScreen(),
    rideTracking: (context) => const RideTrackingScreen(),
    fareSelection: (context) => const FareSelectionScreen(),
    bookingConfirmation: (context) => const BookingConfirmationScreen(),
    profile: (context) => const ProfileScreen(),
    home: (context) => const HomeScreen(),
    driverDetails: (context) => const DriverDetailsScreen(),
    paymentMethods: (context) => const PaymentMethodsScreen(),
    // TODO: Add your other routes here
  };
}
