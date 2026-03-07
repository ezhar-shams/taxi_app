import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_strings.dart';
import '../../../data/models/trip_model.dart';
import '../../../core/utils/persian_utils.dart';

class TripCardWidget extends StatelessWidget {
  final TripModel trip;
  final String lang;
  final VoidCallback? onTap;

  const TripCardWidget({
    super.key,
    required this.trip,
    required this.lang,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppDimensions.cardBorderRadius),
          border: Border.all(color: AppColors.divider),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: AppDimensions.cardPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _routeRow(),
              const SizedBox(height: 12),
              const Divider(height: 1),
              const SizedBox(height: 12),
              _detailsRow(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _routeRow() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(trip.fromCity.name(lang), style: AppTextStyles.headline3),
              Text(
                PersianUtils.formatTime(trip.departureTime),
                style: AppTextStyles.bodySmall,
              ),
            ],
          ),
        ),
        Column(
          children: [
            const Icon(Icons.arrow_forward, color: AppColors.primary, size: 20),
            Text(trip.durationText, style: AppTextStyles.caption),
          ],
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(trip.toCity.name(lang), style: AppTextStyles.headline3),
              Text(
                PersianUtils.formatTime(trip.arrivalTime),
                style: AppTextStyles.bodySmall,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _detailsRow() {
    return Row(
      children: [
        _chip(_vehicleLabel(), AppColors.infoLight, AppColors.info),
        const SizedBox(width: 8),
        _chip(
          '${trip.availableSeats} ${AppStrings.get(AppStrings.seatsAvailable, lang)}',
          AppColors.successLight,
          AppColors.success,
        ),
        const Spacer(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${PersianUtils.formatPrice(trip.price)} ${AppStrings.get(AppStrings.afghani, lang)}',
              style: AppTextStyles.priceText,
            ),
            Text(AppStrings.get(AppStrings.perSeat, lang), style: AppTextStyles.caption),
          ],
        ),
      ],
    );
  }

  Widget _chip(String label, Color bg, Color fg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
      ),
      child: Text(label, style: AppTextStyles.caption.copyWith(color: fg)),
    );
  }

  String _vehicleLabel() {
    switch (trip.vehicle.type) {
      case VehicleType.sedan:   return AppStrings.get(AppStrings.sedan, lang);
      case VehicleType.suv:     return AppStrings.get(AppStrings.suv, lang);
      case VehicleType.van:     return AppStrings.get(AppStrings.van, lang);
      case VehicleType.minibus: return AppStrings.get(AppStrings.minibus, lang);
    }
  }
}
