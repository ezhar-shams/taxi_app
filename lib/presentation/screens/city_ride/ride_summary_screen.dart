import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/utils/persian_utils.dart';
import '../../providers/city_ride_provider.dart';
import '../../providers/language_provider.dart';

/// Trip completion screen shown after driver presses "End Ride".
/// Shows final price, trip stats, driver info, and star rating.
class RideSummaryScreen extends ConsumerStatefulWidget {
  const RideSummaryScreen({super.key});

  @override
  ConsumerState<RideSummaryScreen> createState() => _RideSummaryScreenState();
}

class _RideSummaryScreenState extends ConsumerState<RideSummaryScreen>
    with TickerProviderStateMixin {
  late AnimationController _heroAnim;
  late AnimationController _cardAnim;
  late AnimationController _starAnim;

  int _selectedRating = 0;
  bool _ratingSubmitted = false;

  @override
  void initState() {
    super.initState();
    _heroAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..forward();

    _cardAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    Future.delayed(const Duration(milliseconds: 300),
        () { if (mounted) _cardAnim.forward(); });

    _starAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _heroAnim.dispose();
    _cardAnim.dispose();
    _starAnim.dispose();
    super.dispose();
  }

  void _submitRating(int stars) {
    setState(() {
      _selectedRating = stars;
      _ratingSubmitted = true;
    });
    _starAnim.forward();
    ref.read(activeRideProvider.notifier).rateDriver(stars);
  }

  void _goHome(BuildContext ctx) {
    ref.read(activeRideProvider.notifier).reset();
    // Pop everything back to root
    Navigator.of(ctx).popUntil((r) => r.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    final lang   = ref.watch(languageProvider);
    final ride   = ref.watch(activeRideProvider);
    final top    = MediaQuery.of(context).padding.top;
    final bottom = MediaQuery.of(context).padding.bottom;

    if (ride == null) {
      return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: AppColors.background,
          body: Center(
            child: TextButton(
              onPressed: () => Navigator.of(context).popUntil((r) => r.isFirst),
              child: Text(AppStrings.get(AppStrings.backToHome, lang)),
            ),
          ),
        ),
      );
    }

    final booking = ride.booking;
    final driver  = booking.driver;
    final elapsed = ride.elapsedTripSec;
    final elapsedMin = elapsed ~/ 60;
    final elapsedSec = elapsed % 60;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: CustomScrollView(
          slivers: [
            // ── Hero header ───────────────────────────────────────────────
            SliverToBoxAdapter(
              child: Container(
                decoration: BoxDecoration(
                  gradient: AppColors.rideHeaderGradient,
                  borderRadius: const BorderRadius.vertical(
                      bottom: Radius.circular(36)),
                ),
                padding: EdgeInsets.fromLTRB(20, top + 20, 20, 36),
                child: Column(
                  children: [
                    // Animated checkmark
                    ScaleTransition(
                      scale: CurvedAnimation(
                          parent: _heroAnim, curve: Curves.elasticOut),
                      child: Container(
                        width: 90,
                        height: 90,
                        decoration: BoxDecoration(
                          color: AppColors.white.withValues(alpha: 0.18),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.check_circle_rounded,
                            color: AppColors.white, size: 56),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // "Trip Done"
                    Text(
                      AppStrings.get(AppStrings.rideComplete, lang),
                      style: AppTextStyles.headline1
                          .copyWith(color: AppColors.white),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),

                    // Booking ID badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${AppStrings.get(AppStrings.rideId, lang)}: #${booking.id}',
                        style: AppTextStyles.labelMedium
                            .copyWith(color: AppColors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // ── Fare card ────────────────────────────────────────────
                  FadeTransition(
                    opacity: CurvedAnimation(
                        parent: _cardAnim, curve: Curves.easeOut),
                    child: _card(
                      child: Row(
                        children: [
                          Container(
                            width: 52, height: 52,
                            decoration: BoxDecoration(
                              gradient: AppColors.rideGradient,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Icon(Icons.receipt_long_rounded,
                                color: AppColors.white, size: 26),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppStrings.get(AppStrings.finalPrice, lang),
                                  style: AppTextStyles.labelSmall.copyWith(
                                      color: AppColors.textTertiary),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${PersianUtils.formatPrice(booking.totalPrice)} ${AppStrings.get(AppStrings.afghani, lang)}',
                                  style: AppTextStyles.headline1.copyWith(
                                    color: AppColors.rideBlue,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                Text(
                                  AppStrings.get(AppStrings.payOnArrival, lang),
                                  style: AppTextStyles.bodySmall.copyWith(
                                      color: AppColors.textTertiary),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // ── Stats row ─────────────────────────────────────────────
                  _card(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _summaryStatCol(
                          icon: Icons.straighten_rounded,
                          color: AppColors.rideBlue,
                          value: '${PersianUtils.doubleToPersian(booking.distanceKm, decimals: 1)}',
                          unit: 'km',
                          label: AppStrings.get(AppStrings.distanceKm, lang),
                        ),
                        Container(
                            width: 1,
                            height: 48,
                            color: AppColors.divider),
                        _summaryStatCol(
                          icon: Icons.schedule_rounded,
                          color: AppColors.rideBlue,
                          value: '${PersianUtils.intToPersian(elapsedMin)}:${PersianUtils.intToPersian(elapsedSec).padLeft(2, '۰')}',
                          unit: '',
                          label: AppStrings.get(AppStrings.tripDuration, lang),
                        ),
                        Container(
                            width: 1,
                            height: 48,
                            color: AppColors.divider),
                        _summaryStatCol(
                          icon: Icons.people_alt_outlined,
                          color: AppColors.primary,
                          value: PersianUtils.intToPersian(
                              booking.option.capacity),
                          unit: AppStrings.get(AppStrings.persons, lang),
                          label: AppStrings.get(AppStrings.capacity, lang),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),

                  // ── Driver card ───────────────────────────────────────────
                  _card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppStrings.get(AppStrings.driverDetails, lang),
                          style: AppTextStyles.labelMedium
                              .copyWith(color: AppColors.textTertiary),
                        ),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            Container(
                              width: 56, height: 56,
                              decoration: BoxDecoration(
                                gradient: AppColors.rideGradient,
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(driver.photoInitials,
                                    style: AppTextStyles.headline2
                                        .copyWith(color: AppColors.white)),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(driver.name,
                                      style: AppTextStyles.labelLarge),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      const Icon(Icons.star_rounded,
                                          color: AppColors.warning, size: 15),
                                      const SizedBox(width: 3),
                                      Text(
                                        PersianUtils.doubleToPersian(
                                            driver.rating, decimals: 1),
                                        style: AppTextStyles.bodyMedium,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        '${PersianUtils.intToPersian(driver.totalTrips)} ${AppStrings.get(AppStrings.trips, lang)}',
                                        style: AppTextStyles.bodySmall.copyWith(
                                            color: AppColors.textTertiary),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            _infoChip(
                                icon: Icons.directions_car_rounded,
                                label: '${driver.vehicleMake} ${driver.vehicleModel}'),
                            const SizedBox(width: 8),
                            _infoChip(
                                icon: Icons.pin_rounded,
                                label: driver.plate),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),

                  // ── Route card ────────────────────────────────────────────
                  _card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(AppStrings.get(AppStrings.yourRoute, lang),
                            style: AppTextStyles.labelMedium.copyWith(
                                color: AppColors.textTertiary)),
                        const SizedBox(height: 14),
                        _routeRow(
                          icon: Icons.trip_origin_rounded,
                          color: AppColors.success,
                          text: booking.pickup.name(lang),
                          sub: booking.pickup.address(lang),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 11),
                          child: Container(
                            width: 2, height: 20,
                            color: AppColors.divider,
                          ),
                        ),
                        _routeRow(
                          icon: Icons.location_on_rounded,
                          color: AppColors.error,
                          text: booking.destination.name(lang),
                          sub: booking.destination.address(lang),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),

                  // ── Rating card ───────────────────────────────────────────
                  _card(
                    child: Column(
                      children: [
                        Text(
                          _ratingSubmitted
                              ? AppStrings.get(AppStrings.ratingThanks, lang)
                              : AppStrings.get(AppStrings.rateDriver, lang),
                          style: AppTextStyles.labelMedium.copyWith(
                            color: _ratingSubmitted
                                ? AppColors.success
                                : AppColors.textSecondary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 14),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(5, (i) {
                            final filled = i < (_ratingSubmitted
                                ? _selectedRating
                                : _selectedRating);
                            return GestureDetector(
                              onTap: _ratingSubmitted
                                  ? null
                                  : () => _submitRating(i + 1),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 5),
                                child: Icon(
                                  filled || i < _selectedRating
                                      ? Icons.star_rounded
                                      : Icons.star_border_rounded,
                                  color: i < _selectedRating
                                      ? AppColors.warning
                                      : AppColors.textHint,
                                  size: 38,
                                ),
                              ),
                            );
                          }),
                        ),
                        if (_ratingSubmitted) ...[
                          const SizedBox(height: 10),
                          ScaleTransition(
                            scale: CurvedAnimation(
                                parent: _starAnim,
                                curve: Curves.elasticOut),
                            child: const Icon(Icons.favorite_rounded,
                                color: AppColors.error, size: 28),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // ── Back to home ──────────────────────────────────────────
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: AppColors.rideGradient,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: AppColors.rideShadow,
                    ),
                    child: Material(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(18),
                      child: InkWell(
                        onTap: () => _goHome(context),
                        borderRadius: BorderRadius.circular(18),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 17),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.home_rounded,
                                  color: AppColors.white, size: 24),
                              const SizedBox(width: 10),
                              Text(
                                AppStrings.get(AppStrings.backToHome, lang),
                                style: AppTextStyles.buttonText.copyWith(
                                    fontSize: 17, color: AppColors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: bottom + 16),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  Widget _card({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: AppColors.cardShadow,
      ),
      child: child,
    );
  }

  Widget _summaryStatCol({
    required IconData icon,
    required Color color,
    required String value,
    required String unit,
    required String label,
  }) {
    return Column(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(height: 6),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                  text: value,
                  style: AppTextStyles.headline3.copyWith(color: color)),
              if (unit.isNotEmpty)
                TextSpan(
                  text: ' $unit',
                  style:
                      AppTextStyles.labelSmall.copyWith(color: color),
                ),
            ],
          ),
        ),
        const SizedBox(height: 2),
        Text(label,
            style: AppTextStyles.labelSmall
                .copyWith(color: AppColors.textTertiary),
            textAlign: TextAlign.center),
      ],
    );
  }

  Widget _routeRow({
    required IconData icon,
    required Color color,
    required String text,
    required String sub,
  }) {
    return Row(
      children: [
        Icon(icon, color: color, size: 22),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(text,
                  style: AppTextStyles.bodyMedium
                      .copyWith(fontWeight: FontWeight.w600)),
              Text(sub,
                  style: AppTextStyles.bodySmall
                      .copyWith(color: AppColors.textTertiary),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis),
            ],
          ),
        ),
      ],
    );
  }

  Widget _infoChip({required IconData icon, required String label}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: AppColors.rideBlueSurface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.rideBlueBorder),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppColors.rideBlue, size: 15),
          const SizedBox(width: 6),
          Text(label,
              style: AppTextStyles.labelSmall
                  .copyWith(color: AppColors.rideBlue)),
        ],
      ),
    );
  }
}
