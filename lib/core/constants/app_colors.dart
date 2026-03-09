import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Brand Primary  Sair34 Crimson
  static const Color primary        = Color(0xFFC0392B);
  static const Color primaryDark    = Color(0xFF922B21);
  static const Color primaryLight   = Color(0xFFE74C3C);
  static const Color primarySurface = Color(0xFFFDF2F1);
  static const Color primaryBorder  = Color(0xFFF5B7B1);

  // Accent  Warm Gold
  static const Color accent         = Color(0xFFD4A017);
  static const Color accentSurface  = Color(0xFFFDF8E7);

  // Neutrals
  static const Color white          = Color(0xFFFFFFFF);
  static const Color background     = Color(0xFFF5F6FA);
  static const Color surface        = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF0F2F5);
  static const Color divider        = Color(0xFFEAECF0);
  static const Color border         = Color(0xFFDDE1E8);

  // Text
  static const Color textPrimary    = Color(0xFF0F1923);
  static const Color textSecondary  = Color(0xFF5D6778);
  static const Color textTertiary   = Color(0xFF8E97A8);
  static const Color textHint       = Color(0xFFB0B9C6);
  static const Color textDisabled   = Color(0xFFD0D5DE);
  static const Color textInverse    = Color(0xFFFFFFFF);

  // Status
  static const Color success        = Color(0xFF1A9E5C);
  static const Color successLight   = Color(0xFFE8F8EF);
  static const Color warning        = Color(0xFFE67E22);
  static const Color warningLight   = Color(0xFFFEF5EC);
  static const Color error          = Color(0xFFC0392B);
  static const Color errorLight     = Color(0xFFFDF2F1);
  static const Color info           = Color(0xFF2980B9);
  static const Color infoLight      = Color(0xFFEBF5FB);

  // Seat map
  static const Color seatAvailable  = Color(0xFFE8F8EF);
  static const Color seatAvailBorder= Color(0xFF1A9E5C);
  static const Color seatBooked     = Color(0xFFF0F2F5);
  static const Color seatBookedBdr  = Color(0xFFDDE1E8);
  static const Color seatSelected   = Color(0xFFC0392B);
  static const Color seatDriver     = Color(0xFFFEF5EC);
  static const Color seatDriverBdr  = Color(0xFFE67E22);

  // ── Ride (city-taxi) — uses the Sair34 crimson brand palette ─────────────
  static const Color rideBlue        = Color(0xFFC0392B);   // = primary
  static const Color rideBlueDark    = Color(0xFF922B21);   // = primaryDark
  static const Color rideBlueLight   = Color(0xFFE74C3C);   // = primaryLight
  static const Color rideBlueSurface = Color(0xFFFDF2F1);   // = primarySurface
  static const Color rideBlueBorder  = Color(0xFFF5B7B1);   // = primaryBorder

  static const LinearGradient rideGradient = LinearGradient(
    begin: Alignment.centerRight,
    end: Alignment.centerLeft,
    colors: [Color(0xFFE74C3C), Color(0xFF922B21)],
  );
  static const LinearGradient rideHeaderGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFAD1F1F), Color(0xFFC0392B)],
  );

  static List<BoxShadow> get rideShadow => [
    BoxShadow(
      color: const Color(0xFFC0392B).withValues(alpha: 0.35),
      blurRadius: 16,
      offset: const Offset(0, 6),
    ),
  ];

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft, end: Alignment.bottomRight,
    colors: [Color(0xFFC0392B), Color(0xFF922B21)],
  );
  static const LinearGradient headerGradient = LinearGradient(
    begin: Alignment.topCenter, end: Alignment.bottomCenter,
    colors: [Color(0xFFAD1F1F), Color(0xFFC0392B)],
  );

  // Shadows
  static const Color shadow         = Color(0x10000000);
  static const Color shadowMedium   = Color(0x1A000000);
  static const Color shadowDark     = Color(0x26000000);

  static List<BoxShadow> get cardShadow => [
    const BoxShadow(color: Color(0x08000000), blurRadius: 0, spreadRadius: 1),
    const BoxShadow(color: Color(0x14000000), blurRadius: 16, offset: Offset(0, 4)),
  ];
  static List<BoxShadow> get cardShadowSm => [
    const BoxShadow(color: Color(0x10000000), blurRadius: 8, offset: Offset(0, 2)),
  ];
  static List<BoxShadow> get primaryShadow => [
    BoxShadow(color: const Color(0xFFC0392B).withValues(alpha: 0.35), blurRadius: 16, offset: const Offset(0, 6)),
  ];
}
