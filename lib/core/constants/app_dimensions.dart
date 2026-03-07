import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppDimensions {
  AppDimensions._();

  static const double radiusXS   = 4.0;
  static const double radiusSM   = 8.0;
  static const double radiusMD   = 12.0;
  static const double radiusLG   = 16.0;
  static const double radiusXL   = 24.0;
  static const double radiusFull = 999.0;

  static const double spaceXXS = 4.0;
  static const double spaceXS  = 8.0;
  static const double spaceSM  = 12.0;
  static const double spaceMD  = 16.0;
  static const double spaceLG  = 24.0;
  static const double spaceXL  = 32.0;
  static const double spaceXXL = 48.0;

  static const double buttonHeight      = 52.0;
  static const double inputHeight       = 52.0;
  static const double appBarHeight      = 60.0;
  static const double bottomNavHeight   = 64.0;
  static const double cardBorderRadius  = 16.0;

  static const EdgeInsets screenPadding = EdgeInsets.symmetric(horizontal: 16.0);
  static const EdgeInsets cardPadding   = EdgeInsets.all(16.0);
}

class AppShadows {
  AppShadows._();

  static const List<BoxShadow> cardShadow = [
    BoxShadow(
      color: AppColors.shadow,
      blurRadius: 12,
      offset: Offset(0, 4),
    ),
  ];

  static const List<BoxShadow> buttonShadow = [
    BoxShadow(
      color: Color(0x33B22222),
      blurRadius: 12,
      offset: Offset(0, 6),
    ),
  ];
}
