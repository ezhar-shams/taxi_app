import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/utils/persian_utils.dart';
import '../../data/models/trip_model.dart';

/// Premium trip card used in search results and home screen recents.
class PremiumTripCard extends StatelessWidget {
  final TripModel trip;
  final String lang;
  final VoidCallback? onTap;

  const PremiumTripCard({
    super.key,
    required this.trip,
    required this.lang,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final dep  = trip.departureTime;
    final arr  = trip.arrivalTime;
    final dur  = arr.difference(dep);
    final depS = PersianUtils.formatTime(dep);
    final arrS = PersianUtils.formatTime(arr);
    final durS = PersianUtils.formatDuration(dur, lang);
    final priceS = PersianUtils.formatPrice(trip.price);
    final availS = PersianUtils.intToPersian(trip.availableSeats);
    final ratingS = PersianUtils.toPersianDigits(trip.driverRating.toStringAsFixed(1));

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppDimensions.cardBorderRadius),
          boxShadow: AppColors.cardShadow,
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Top strip: company + rating ──────────────────────────────────
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: const BoxDecoration(
                gradient: AppColors.primaryGradient,
              ),
              child: Row(
                children: [
                  const Icon(Icons.directions_car, color: AppColors.white, size: 16),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      trip.companyName,
                      style: AppTextStyles.labelMedium.copyWith(color: AppColors.white),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.star, color: AppColors.accent, size: 13),
                        const SizedBox(width: 3),
                        Text(ratingS, style: AppTextStyles.labelSmall.copyWith(color: AppColors.white)),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // ── Body ─────────────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                children: [
                  // Route & times
                  Row(
                    children: [
                      // Departure
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(depS, style: AppTextStyles.headline3.copyWith(color: AppColors.textPrimary)),
                            const SizedBox(height: 2),
                            Text(
                              trip.fromCity.name(lang),
                              style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      // Duration indicator
                      Expanded(
                        child: Column(
                          children: [
                            Text(durS, style: AppTextStyles.labelSmall.copyWith(color: AppColors.textTertiary)),
                            const SizedBox(height: 4),
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  height: 2,
                                  color: AppColors.divider,
                                  width: double.infinity,
                                ),
                                const Icon(Icons.arrow_forward, size: 14, color: AppColors.primary),
                              ],
                            ),
                            if (trip.stops.isNotEmpty) ...[
                              const SizedBox(height: 4),
                              Text(
                                lang == 'ps'
                                    ? '${PersianUtils.intToPersian(trip.stops.length)} توقف'
                                    : '${PersianUtils.intToPersian(trip.stops.length)} توقف',
                                style: AppTextStyles.labelSmall.copyWith(color: AppColors.textTertiary),
                              ),
                            ],
                          ],
                        ),
                      ),
                      // Arrival
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(arrS, style: AppTextStyles.headline3.copyWith(color: AppColors.textPrimary)),
                            const SizedBox(height: 2),
                            Text(
                              trip.toCity.name(lang),
                              style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                              textAlign: TextAlign.end,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),
                  const Divider(height: 1, color: AppColors.divider),
                  const SizedBox(height: 10),

                  // Vehicle info + price
                  Row(
                    children: [
                      // Vehicle type badge
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primarySurface,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          _vehicleLabel(trip.vehicle.type, lang),
                          style: AppTextStyles.labelSmall.copyWith(color: AppColors.primary),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Seats
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.event_seat_outlined, size: 14, color: AppColors.textSecondary),
                          const SizedBox(width: 4),
                          Text(
                            '$availS ${lang == 'ps' ? 'سیټ' : 'صندلی'}',
                            style: AppTextStyles.labelSmall.copyWith(color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                      if (trip.vehicle.hasAc) ...[
                        const SizedBox(width: 8),
                        const Icon(Icons.ac_unit, size: 14, color: AppColors.info),
                      ],
                      const Spacer(),
                      // Price
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '$priceS ${lang == 'ps' ? 'افغاني' : 'افغانی'}',
                            style: AppTextStyles.labelLarge.copyWith(color: AppColors.primary),
                          ),
                          Text(
                            lang == 'ps' ? 'فی کس' : 'هر نفر',
                            style: AppTextStyles.labelSmall.copyWith(color: AppColors.textTertiary),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _vehicleLabel(VehicleType type, String lang) {
    switch (type) {
      case VehicleType.sedan:   return lang == 'ps' ? 'سدان' : 'سدان';
      case VehicleType.suv:     return 'SUV';
      case VehicleType.van:     return lang == 'ps' ? 'ون' : 'ون';
      case VehicleType.minibus: return lang == 'ps' ? 'مینی بس' : 'مینی‌بس';
    }
  }
}
