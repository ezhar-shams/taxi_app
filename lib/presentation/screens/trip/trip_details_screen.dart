import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/router/app_router.dart';
import '../../providers/language_provider.dart';
import '../../providers/trip_provider.dart';
import '../../widgets/custom_button.dart';
import '../../../core/utils/persian_utils.dart';
import '../../../data/models/trip_model.dart';

class TripDetailsScreen extends ConsumerWidget {
  final String tripId;
  const TripDetailsScreen({super.key, required this.tripId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lang = ref.watch(languageProvider);
    final trip = ref.watch(tripByIdProvider(tripId));

    if (trip == null) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(child: Text(AppStrings.get(AppStrings.noTripsFound, lang))),
      );
    }

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: CustomScrollView(
          slivers: [
            // Hero header
            SliverAppBar(
              expandedHeight: 180,
              pinned: true,
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.white,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  color: AppColors.primary,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 48),
                        Text(trip.fromCity.name(lang), style: AppTextStyles.headline2.copyWith(color: AppColors.white)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(trip.durationText, style: AppTextStyles.bodySmall.copyWith(color: AppColors.white.withOpacity(0.8))),
                            const Icon(Icons.arrow_back, color: AppColors.white, size: 16),
                          ],
                        ),
                        Text(trip.toCity.name(lang), style: AppTextStyles.headline2.copyWith(color: AppColors.white)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: AppDimensions.screenPadding.copyWith(top: 16, bottom: 16),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // Times card
                  _card(children: [
                    _row(AppStrings.get(AppStrings.departure, lang),
                        PersianUtils.formatTime(trip.departureTime)),
                    _row(AppStrings.get(AppStrings.arrival, lang),
                        PersianUtils.formatTime(trip.arrivalTime)),
                    _row(AppStrings.get(AppStrings.duration, lang),
                        PersianUtils.formatDuration(trip.arrivalTime.difference(trip.departureTime), lang)),
                    _row(AppStrings.get(AppStrings.seatsAvailable, lang),
                        PersianUtils.intToPersian(trip.availableSeats)),
                  ]),
                  const SizedBox(height: 16),
                  // Price card
                  _card(children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(AppStrings.get(AppStrings.price, lang), style: AppTextStyles.bodyLarge),
                        Text(
                          '${PersianUtils.formatPrice(trip.price)} ${AppStrings.get(AppStrings.afghani, lang)}',
                          style: AppTextStyles.priceText,
                        ),
                      ],
                    ),
                  ]),
                  const SizedBox(height: 16),
                  // Driver card
                  _card(children: [
                    Text(AppStrings.get(AppStrings.driverInfo, lang), style: AppTextStyles.headline3),
                    const SizedBox(height: 12),
                    _row(AppStrings.get(AppStrings.driverName, lang), trip.driverName),
                    _row(AppStrings.get(AppStrings.companyName, lang), trip.companyName),
                    _row(AppStrings.get(AppStrings.rating, lang), '${PersianUtils.toPersianDigits(trip.driverRating.toStringAsFixed(1))} ★'),
                  ]),
                  const SizedBox(height: 16),
                  // Vehicle card
                  _card(children: [
                    Text(AppStrings.get(AppStrings.vehicleInfo, lang), style: AppTextStyles.headline3),
                    const SizedBox(height: 12),
                    _row(AppStrings.get(AppStrings.vehicleType, lang), _vehicleLabel(trip.vehicle.type, lang)),
                    _row(AppStrings.get(AppStrings.plateNumber, lang), trip.vehicle.plate),
                    if (trip.vehicle.hasAc)
                      _row(AppStrings.get(AppStrings.ac, lang), '✓'),
                    if (trip.vehicle.hasWifi)
                      _row(AppStrings.get(AppStrings.wifi, lang), '✓'),
                  ]),
                  const SizedBox(height: 32),
                  CustomButton(
                    label: AppStrings.get(AppStrings.selectSeat, lang),
                    onPressed: () => context.push(AppRoutes.seatPath(tripId)),
                  ),
                  const SizedBox(height: 16),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _card({required List<Widget> children}) {
    return Container(
      padding: AppDimensions.cardPadding,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppDimensions.cardBorderRadius),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: children),
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
          Text(value, style: AppTextStyles.labelMedium),
        ],
      ),
    );
  }

  String _vehicleLabel(VehicleType t, String lang) {
    switch (t) {
      case VehicleType.sedan:   return AppStrings.get(AppStrings.sedan, lang);
      case VehicleType.suv:     return AppStrings.get(AppStrings.suv, lang);
      case VehicleType.van:     return AppStrings.get(AppStrings.van, lang);
      case VehicleType.minibus: return AppStrings.get(AppStrings.minibus, lang);
    }
  }
}
