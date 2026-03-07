import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/persian_utils.dart';

enum SeatState { available, booked, selected, driver }

class SeatWidget extends StatelessWidget {
  final int seatNumber;
  final SeatState state;
  final VoidCallback? onTap;
  final String lang;

  const SeatWidget({
    super.key,
    required this.seatNumber,
    required this.state,
    this.onTap,
    required this.lang,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: state == SeatState.available ? onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: _bgColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: _borderColor, width: 1.5),
        ),
        child: Center(
          child: state == SeatState.driver
              ? const Icon(Icons.person, size: 18, color: AppColors.warning)
              : Text(
                  PersianUtils.intToPersian(seatNumber),
                  style: AppTextStyles.labelSmall.copyWith(color: _textColor),
                ),
        ),
      ),
    );
  }

  Color get _bgColor {
    switch (state) {
      case SeatState.available: return AppColors.seatAvailable;
      case SeatState.booked:    return AppColors.seatBooked;
      case SeatState.selected:  return AppColors.seatSelected;
      case SeatState.driver:    return AppColors.seatDriver;
    }
  }

  Color get _borderColor {
    switch (state) {
      case SeatState.available: return AppColors.success;
      case SeatState.booked:    return AppColors.divider;
      case SeatState.selected:  return AppColors.primaryDark;
      case SeatState.driver:    return AppColors.warning;
    }
  }

  Color get _textColor {
    switch (state) {
      case SeatState.available: return AppColors.success;
      case SeatState.booked:    return AppColors.textHint;
      case SeatState.selected:  return AppColors.white;
      case SeatState.driver:    return AppColors.warning;
    }
  }
}

class SeatLegend extends StatelessWidget {
  final String lang;
  const SeatLegend({super.key, required this.lang});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _item(AppColors.seatAvailable, AppColors.success, AppStrings.get(AppStrings.seatAvailable, lang)),
        const SizedBox(width: 16),
        _item(AppColors.seatBooked, AppColors.divider, AppStrings.get(AppStrings.seatBooked, lang)),
        const SizedBox(width: 16),
        _item(AppColors.seatSelected, AppColors.primaryDark, AppStrings.get(AppStrings.seatSelected, lang)),
      ],
    );
  }

  Widget _item(Color bg, Color border, String label) {
    return Row(
      children: [
        Container(
          width: 18, height: 18,
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: border),
          ),
        ),
        const SizedBox(width: 4),
        Text(label, style: AppTextStyles.caption),
      ],
    );
  }
}
