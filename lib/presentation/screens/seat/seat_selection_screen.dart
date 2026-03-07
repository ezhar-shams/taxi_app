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
import '../../widgets/seat_widget.dart';
import '../../widgets/custom_button.dart';
import '../../../core/utils/persian_utils.dart';

class SeatSelectionScreen extends ConsumerWidget {
  final String tripId;
  const SeatSelectionScreen({super.key, required this.tripId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lang     = ref.watch(languageProvider);
    final trip     = ref.watch(tripByIdProvider(tripId));
    final selected = ref.watch(selectedSeatProvider);

    if (trip == null) {
      return Scaffold(appBar: AppBar(), body: Center(child: Text(AppStrings.get(AppStrings.noTripsFound, lang))));
    }

    final total   = trip.vehicle.totalSeats;
    final booked  = trip.bookedSeats;
    final columns = total <= 5 ? 3 : 4;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: Text(AppStrings.get(AppStrings.selectSeat, lang)),
        ),
        body: Column(
          children: [
            // Route summary
            Container(
              margin: const EdgeInsets.all(AppDimensions.spaceMD),
              padding: AppDimensions.cardPadding,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(AppDimensions.cardBorderRadius),
                border: Border.all(color: AppColors.divider),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(trip.fromCity.name(lang), style: AppTextStyles.headline3),
                  const Icon(Icons.arrow_back_ios, size: 16, color: AppColors.textSecondary),
                  Text(trip.toCity.name(lang), style: AppTextStyles.headline3),
                ],
              ),
            ),
            // Legend
            SeatLegend(lang: lang),
            const SizedBox(height: 24),
            // Vehicle interior diagram
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 32),
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppColors.divider),
                ),
                child: Column(
                  children: [
                    // Driver seat at top
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: SeatWidget(seatNumber: 0, state: SeatState.driver, lang: lang),
                    ),
                    const Divider(),
                    // Passenger seats
                    Expanded(
                      child: GridView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: total - 1,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: columns,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                          childAspectRatio: 1,
                        ),
                        itemBuilder: (_, i) {
                          final seatNum = i + 2;
                          final isBooked   = booked.contains(seatNum);
                          final isSelected = selected == seatNum;
                          return SeatWidget(
                            seatNumber: seatNum,
                            state: isBooked
                                ? SeatState.booked
                                : isSelected
                                    ? SeatState.selected
                                    : SeatState.available,
                            lang: lang,
                            onTap: () => ref.read(selectedSeatProvider.notifier).state = seatNum,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Bottom bar
            Container(
              padding: const EdgeInsets.all(AppDimensions.spaceMD),
              child: Column(
                children: [
                  if (selected != null) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('${AppStrings.get(AppStrings.seat, lang)} ${PersianUtils.intToPersian(selected)}', style: AppTextStyles.labelLarge),
                        Text(
                          '${PersianUtils.formatPrice(trip.price)} ${AppStrings.get(AppStrings.afghani, lang)}',
                          style: AppTextStyles.priceText,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                  ],
                  CustomButton(
                    label: AppStrings.get(AppStrings.continueBooking, lang),
                    onPressed: selected == null
                        ? null
                        : () => context.push(AppRoutes.bookingPath(tripId) + '?seat=$selected'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
