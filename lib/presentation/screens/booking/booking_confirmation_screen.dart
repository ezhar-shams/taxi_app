import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/router/app_router.dart';
import '../../providers/language_provider.dart';
import '../../providers/booking_provider.dart';
import '../../widgets/custom_button.dart';
import '../../../core/utils/persian_utils.dart';

class BookingConfirmationScreen extends ConsumerWidget {
  final String bookingId;
  const BookingConfirmationScreen({super.key, required this.bookingId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lang    = ref.watch(languageProvider);
    final booking = ref.watch(bookingByIdProvider(bookingId));

    if (booking == null) {
      return Scaffold(appBar: AppBar(), body: Center(child: Text(AppStrings.get(AppStrings.somethingWentWrong, lang))));
    }

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppDimensions.spaceMD),
            child: Column(
              children: [
                const SizedBox(height: 32),
                // Success icon
                Container(
                  width: 96, height: 96,
                  decoration: const BoxDecoration(color: AppColors.successLight, shape: BoxShape.circle),
                  child: const Icon(Icons.check_circle, color: AppColors.success, size: 56),
                ),
                const SizedBox(height: 20),
                Text(AppStrings.get(AppStrings.bookingSuccess, lang), style: AppTextStyles.headline1, textAlign: TextAlign.center),
                const SizedBox(height: 8),
                Text(
                  '${AppStrings.get(AppStrings.bookingId, lang)}: ${booking.id}',
                  style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                ),
                const SizedBox(height: 32),
                // Booking details card
                Container(
                  padding: AppDimensions.cardPadding,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(AppDimensions.cardBorderRadius),
                    border: Border.all(color: AppColors.divider),
                  ),
                  child: Column(
                    children: [
                      _row(AppStrings.get(AppStrings.from, lang), booking.fromCity(lang)),
                      _row(AppStrings.get(AppStrings.to, lang), booking.toCity(lang)),
                      _row(AppStrings.get(AppStrings.departure, lang),
                        PersianUtils.formatTime(booking.departureTime)),
                      _row(AppStrings.get(AppStrings.seat, lang), '${booking.seatNumber}'),
                      _row(AppStrings.get(AppStrings.driverName, lang), booking.driverName),
                      _row(AppStrings.get(AppStrings.plateNumber, lang), booking.vehiclePlate),
                      const Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(AppStrings.get(AppStrings.totalPrice, lang), style: AppTextStyles.headline3),
                          Text('${PersianUtils.formatPrice(booking.totalPrice)} ${AppStrings.get(AppStrings.afghani, lang)}', style: AppTextStyles.priceText),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                CustomButton(
                  label: AppStrings.get(AppStrings.viewTicket, lang),
                  onPressed: () => context.go(AppRoutes.ticketPath(booking.id)),
                ),
                const SizedBox(height: 12),
                CustomButton(
                  label: AppStrings.get(AppStrings.home, lang),
                  variant: ButtonVariant.outline,
                  onPressed: () => context.go(AppRoutes.home),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
          Text(value, style: AppTextStyles.labelMedium),
        ],
      ),
    );
  }
}
