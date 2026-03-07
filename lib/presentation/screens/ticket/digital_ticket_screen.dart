import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/router/app_router.dart';
import '../../providers/language_provider.dart';
import '../../providers/booking_provider.dart';
import '../../widgets/custom_button.dart';
import '../../../core/utils/persian_utils.dart';

class DigitalTicketScreen extends ConsumerWidget {
  final String bookingId;
  const DigitalTicketScreen({super.key, required this.bookingId});

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
        backgroundColor: AppColors.primary,
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
          title: Text(AppStrings.get(AppStrings.digitalTicket, lang), style: AppTextStyles.headline3.copyWith(color: AppColors.white)),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimensions.spaceMD),
          child: Column(
            children: [
              // Ticket card
              Container(
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  children: [
                    // Header
                    Container(
                      padding: const EdgeInsets.all(AppDimensions.spaceMD),
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(booking.fromCity(lang), style: AppTextStyles.headline2.copyWith(color: AppColors.white)),
                              Text(AppStrings.get(AppStrings.from, lang), style: AppTextStyles.caption.copyWith(color: AppColors.white.withOpacity(0.7))),
                            ],
                          ),
                          const Icon(Icons.arrow_back, color: AppColors.white, size: 28),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(booking.toCity(lang), style: AppTextStyles.headline2.copyWith(color: AppColors.white)),
                              Text(AppStrings.get(AppStrings.to, lang), style: AppTextStyles.caption.copyWith(color: AppColors.white.withOpacity(0.7))),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Dashed divider
                    Row(
                      children: [
                        Container(width: 24, height: 24, decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle)),
                        Expanded(child: Divider(color: AppColors.divider, thickness: 2, indent: 0, endIndent: 0)),
                        Container(width: 24, height: 24, decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle)),
                      ],
                    ),
                    // Details
                    Padding(
                      padding: const EdgeInsets.all(AppDimensions.spaceMD),
                      child: Column(
                        children: [
                          _detailRow(AppStrings.get(AppStrings.passengerInfo, lang), booking.passengerName),
                          _detailRow(AppStrings.get(AppStrings.seat, lang), '${booking.seatNumber}'),
                          _detailRow(AppStrings.get(AppStrings.departure, lang),
                              PersianUtils.formatTime(booking.departureTime)),
                          _detailRow(AppStrings.get(AppStrings.driverName, lang), booking.driverName),
                          _detailRow(AppStrings.get(AppStrings.plateNumber, lang), booking.vehiclePlate),
                          _detailRow(AppStrings.get(AppStrings.totalPrice, lang),
                              '${PersianUtils.formatPrice(booking.totalPrice)} ${AppStrings.get(AppStrings.afghani, lang)}'),
                        ],
                      ),
                    ),
                    // QR code
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(AppDimensions.spaceMD),
                      decoration: const BoxDecoration(
                        color: AppColors.surfaceVariant,
                        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
                      ),
                      child: Column(
                        children: [
                          Text(AppStrings.get(AppStrings.showToDriver, lang), style: AppTextStyles.bodySmall, textAlign: TextAlign.center),
                          const SizedBox(height: 16),
                          Center(
                            child: QrImageView(
                              data: booking.id,
                              size: 180,
                              backgroundColor: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(booking.id, style: AppTextStyles.labelSmall),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              CustomButton(
                label: AppStrings.get(AppStrings.shareTicket, lang),
                variant: ButtonVariant.secondary,
                onPressed: () => Share.share(
                  '${AppStrings.get(AppStrings.digitalTicket, lang)}\n'
                  '${booking.fromCity(lang)} ← ${booking.toCity(lang)}\n'
                  '${AppStrings.get(AppStrings.seat, lang)}: ${booking.seatNumber}\n'
                  '${AppStrings.get(AppStrings.bookingId, lang)}: ${booking.id}',
                ),
                icon: const Icon(Icons.share, color: AppColors.primary, size: 20),
              ),
              const SizedBox(height: 12),
              CustomButton(
                label: AppStrings.get(AppStrings.home, lang),
                variant: ButtonVariant.ghost,
                onPressed: () => context.go(AppRoutes.home),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.bodySmall),
          Text(value, style: AppTextStyles.labelMedium),
        ],
      ),
    );
  }
}
