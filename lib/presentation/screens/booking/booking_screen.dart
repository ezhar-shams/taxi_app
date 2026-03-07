import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/router/app_router.dart';
import '../../providers/language_provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/trip_provider.dart';
import '../../providers/booking_provider.dart';
import '../../widgets/custom_button.dart';
import '../../../data/models/booking_model.dart';
import '../../../core/utils/persian_utils.dart';

class BookingScreen extends ConsumerStatefulWidget {
  final String tripId;
  final int selectedSeat;
  const BookingScreen({super.key, required this.tripId, required this.selectedSeat});

  @override
  ConsumerState<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends ConsumerState<BookingScreen> {
  final _formKey   = GlobalKey<FormState>();
  final _nameCtrl  = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _idCtrl    = TextEditingController();
  final _emCtrl    = TextEditingController();

  @override
  void dispose() {
    _nameCtrl.dispose(); _phoneCtrl.dispose();
    _idCtrl.dispose(); _emCtrl.dispose();
    super.dispose();
  }

  Future<void> _confirm() async {
    if (!_formKey.currentState!.validate()) return;
    final authState = ref.read(authProvider);
    final trip    = ref.read(tripByIdProvider(widget.tripId));
    if (trip == null) return;

    ref.read(bookingFormProvider.notifier)
      ..setName(_nameCtrl.text.trim())
      ..setPhone(_phoneCtrl.text.trim())
      ..setNationalId(_idCtrl.text.trim())
      ..setEmergencyContact(_emCtrl.text.trim());

    final booking = await ref.read(bookingFormProvider.notifier).confirmBooking(
      tripId: widget.tripId,
      userId: authState.user?.id ?? 'guest',
      seatNumber: widget.selectedSeat,
      price: trip.price,
    );

    if (booking != null && mounted) {
      context.go('${AppRoutes.confirmation}?id=${booking.id}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final lang    = ref.watch(languageProvider);
    final trip    = ref.watch(tripByIdProvider(widget.tripId));
    final booking = ref.watch(bookingFormProvider);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(title: Text(AppStrings.get(AppStrings.bookingProcess, lang))),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimensions.spaceMD),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Trip summary
                if (trip != null) Container(
                  padding: AppDimensions.cardPadding,
                  decoration: BoxDecoration(
                    color: AppColors.primarySurface,
                    borderRadius: BorderRadius.circular(AppDimensions.cardBorderRadius),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('${trip.fromCity.name(lang)} ← ${trip.toCity.name(lang)}', style: AppTextStyles.labelLarge),
                      Text(
                        '${PersianUtils.formatPrice(trip.price)} ${AppStrings.get(AppStrings.afghani, lang)}',
                        style: AppTextStyles.priceText,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Text(AppStrings.get(AppStrings.passengerInfo, lang), style: AppTextStyles.headline3),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _nameCtrl,
                  decoration: InputDecoration(
                    labelText: AppStrings.get(AppStrings.fullName, lang),
                    prefixIcon: const Icon(Icons.person_outlined),
                  ),
                  validator: (v) => v == null || v.trim().isEmpty
                      ? AppStrings.get(AppStrings.fieldRequired, lang) : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _phoneCtrl,
                  keyboardType: TextInputType.phone,
                  textDirection: TextDirection.ltr,
                  decoration: InputDecoration(
                    labelText: AppStrings.get(AppStrings.phoneNumber, lang),
                    prefixIcon: const Icon(Icons.phone_outlined),
                  ),
                  validator: (v) => v == null || v.trim().length < 10
                      ? AppStrings.get(AppStrings.invalidPhone, lang) : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _idCtrl,
                  keyboardType: TextInputType.number,
                  textDirection: TextDirection.ltr,
                  decoration: InputDecoration(
                    labelText: AppStrings.get(AppStrings.nationalId, lang),
                    prefixIcon: const Icon(Icons.badge_outlined),
                  ),
                  validator: (v) => v == null || v.trim().isEmpty
                      ? AppStrings.get(AppStrings.fieldRequired, lang) : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _emCtrl,
                  keyboardType: TextInputType.phone,
                  textDirection: TextDirection.ltr,
                  decoration: InputDecoration(
                    labelText: AppStrings.get(AppStrings.emergencyContact, lang),
                    prefixIcon: const Icon(Icons.emergency_outlined),
                  ),
                ),
                const SizedBox(height: 20),
                Text(AppStrings.get(AppStrings.paymentMethod, lang), style: AppTextStyles.headline3),
                const SizedBox(height: 12),
                _PaymentOption(
                  label: AppStrings.get(AppStrings.payAtPickup, lang),
                  selected: booking.paymentMethod == PaymentMethod.atPickup,
                  icon: Icons.money,
                  onTap: () => ref.read(bookingFormProvider.notifier).setPaymentMethod(PaymentMethod.atPickup),
                ),
                const SizedBox(height: 8),
                _PaymentOption(
                  label: AppStrings.get(AppStrings.onlinePayment, lang),
                  selected: booking.paymentMethod == PaymentMethod.online,
                  icon: Icons.credit_card_outlined,
                  onTap: () => ref.read(bookingFormProvider.notifier).setPaymentMethod(PaymentMethod.online),
                ),
                const SizedBox(height: 28),
                if (trip != null) Container(
                  padding: AppDimensions.cardPadding,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(AppDimensions.cardBorderRadius),
                    border: Border.all(color: AppColors.divider),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(AppStrings.get(AppStrings.totalPrice, lang), style: AppTextStyles.headline3),
                      Text(
                        '${PersianUtils.formatPrice(trip.price)} ${AppStrings.get(AppStrings.afghani, lang)}',
                        style: AppTextStyles.priceText,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                CustomButton(
                  label: AppStrings.get(AppStrings.confirmBooking, lang),
                  onPressed: _confirm,
                  isLoading: booking.isLoading,
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PaymentOption extends StatelessWidget {
  final String label;
  final bool selected;
  final IconData icon;
  final VoidCallback onTap;

  const _PaymentOption({required this.label, required this.selected, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: selected ? AppColors.primarySurface : AppColors.white,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
          border: Border.all(color: selected ? AppColors.primary : AppColors.divider, width: selected ? 2 : 1),
        ),
        child: Row(
          children: [
            Icon(icon, color: selected ? AppColors.primary : AppColors.textSecondary),
            const SizedBox(width: 12),
            Text(label, style: AppTextStyles.bodyLarge),
            const Spacer(),
            if (selected) const Icon(Icons.check_circle, color: AppColors.primary),
          ],
        ),
      ),
    );
  }
}
