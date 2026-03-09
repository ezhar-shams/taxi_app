import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/utils/persian_utils.dart';
import '../../../data/mock_data.dart';
import '../../../data/models/city_ride_model.dart';
import '../../providers/language_provider.dart';
import '../../providers/city_ride_provider.dart';
import 'driver_search_screen.dart';

class CityRideResultsScreen extends ConsumerStatefulWidget {
  final String pickupId;
  final String destId;

  const CityRideResultsScreen({
    super.key,
    required this.pickupId,
    required this.destId,
  });

  @override
  ConsumerState<CityRideResultsScreen> createState() =>
      _CityRideResultsScreenState();
}

class _CityRideResultsScreenState
    extends ConsumerState<CityRideResultsScreen>
    with SingleTickerProviderStateMixin {
  late final PickupLocation pickup;
  late final PickupLocation dest;
  late final double roadKm;
  late final int etaMin;

  GoogleMapController? _mapController;
  late AnimationController _cardAnim;

  @override
  void initState() {
    super.initState();
    pickup = MockData.locationById(widget.pickupId) ?? MockData.cityLocations.first;
    dest   = MockData.locationById(widget.destId)   ?? MockData.cityLocations.last;
    final crow = pickup.distanceTo(dest);
    roadKm = crow * 1.35; // road-factor over straight line
    etaMin = math.max(5, math.min(135, (roadKm / 25 * 60).round()));

    _cardAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..forward();
  }

  @override
  void dispose() {
    _cardAnim.dispose();
    _mapController?.dispose();
    super.dispose();
  }

  Set<Marker> get _markers {
    return {
      Marker(
        markerId: const MarkerId('pickup'),
        position: LatLng(pickup.lat, pickup.lng),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        infoWindow: InfoWindow(title: pickup.nameFa),
      ),
      Marker(
        markerId: const MarkerId('dest'),
        position: LatLng(dest.lat, dest.lng),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        infoWindow: InfoWindow(title: dest.nameFa),
      ),
    };
  }

  Set<Polyline> get _polylines => {
        Polyline(
          polylineId: const PolylineId('route'),
          points: [
            LatLng(pickup.lat, pickup.lng),
            LatLng(dest.lat, dest.lng),
          ],
          color: AppColors.rideBlue,
          width: 4,
          patterns: const [],
        ),
      };

  LatLngBounds get _bounds {
    final swLat = math.min(pickup.lat, dest.lat) - 0.01;
    final swLng = math.min(pickup.lng, dest.lng) - 0.01;
    final neLat = math.max(pickup.lat, dest.lat) + 0.01;
    final neLng = math.max(pickup.lng, dest.lng) + 0.01;
    return LatLngBounds(
      southwest: LatLng(swLat, swLng),
      northeast: LatLng(neLat, neLng),
    );
  }

  void _fitBounds() {
    _mapController?.animateCamera(
      CameraUpdate.newLatLngBounds(_bounds, 60),
    );
  }

  void _onOptionSelect(String id) {
    ref.read(selectedRideOptionProvider.notifier).state = id;
  }

  void _requestRide() {
    final optionId = ref.read(selectedRideOptionProvider);
    if (optionId == null) return;
    final option  = MockData.rideOptionById(optionId)!;
    final driver  = MockData.driverForOption(optionId);
    final price   = option.estimatedPrice(roadKm);
    final booking = CityRideBooking(
      id: 'SR${DateTime.now().millisecondsSinceEpoch % 100000}',
      pickup: pickup,
      destination: dest,
      option: option,
      driver: driver,
      distanceKm: roadKm,
      totalPrice: price,
      etaMinutes: etaMin,
      bookedAt: DateTime.now(),
    );
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => DriverSearchScreen(booking: booking),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final lang = ref.watch(languageProvider);
    final selectedId = ref.watch(selectedRideOptionProvider);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Column(
          children: [
            // ── Map header ───────────────────────────────────────────────
            _buildMapHeader(lang),

            // ── Ride options + button ─────────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 14),
                    // Section title
                    Text(
                      AppStrings.get(AppStrings.chooseRideType, lang),
                      style: AppTextStyles.headline3,
                    ),
                    const SizedBox(height: 12),
                    // Option cards
                    ...MockData.rideOptions.asMap().entries.map((e) {
                      final idx = e.key;
                      final opt = e.value;
                      final delay = idx * 0.12;
                      return AnimatedBuilder(
                        animation: _cardAnim,
                        builder: (_, child) {
                          final t = math.max(
                              0.0,
                              math.min(1.0, (_cardAnim.value - delay) / 0.5));
                          return Opacity(
                            opacity: t,
                            child: Transform.translate(
                              offset: Offset(0, 24 * (1 - t)),
                              child: child,
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: _RideOptionCard(
                            option: opt,
                            lang: lang,
                            distKm: roadKm,
                            etaMin: etaMin,
                            isSelected: selectedId == opt.id,
                            onTap: () => _onOptionSelect(opt.id),
                          ),
                        ),
                      );
                    }),
                    const SizedBox(height: 6),
                    // Request button
                    _buildRequestButton(lang, selectedId),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMapHeader(String lang) {
    final top = MediaQuery.of(context).padding.top;
    return SizedBox(
      height: top + 260,
      child: Stack(
        children: [
          // Map
          GoogleMap(
            onMapCreated: (c) {
              _mapController = c;
              Future.delayed(const Duration(milliseconds: 600), _fitBounds);
            },
            initialCameraPosition: CameraPosition(
              target: LatLng(pickup.lat, pickup.lng),
              zoom: 12,
            ),
            markers: _markers,
            polylines: _polylines,
            zoomControlsEnabled: false,
            myLocationButtonEnabled: false,
            mapType: MapType.normal,
            padding: EdgeInsets.only(top: top + 60),
          ),

          // Back button
          Positioned(
            top: top + 10, right: 16,
            child: _CircleBtn(
              onTap: () => Navigator.of(context).pop(),
              child: const Icon(Icons.arrow_forward_ios_rounded,
                  size: 18, color: AppColors.textPrimary),
            ),
          ),

          // Route summary chip at bottom of map
          Positioned(
            bottom: 0, left: 0, right: 0,
            child: Container(
              decoration: const BoxDecoration(
                color: AppColors.white,
                borderRadius:
                    BorderRadius.vertical(top: Radius.circular(20)),
              ),
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              child: Row(
                children: [
                  // Pickup dot
                  const _RouteDot(color: AppColors.success),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      pickup.name(lang),
                      style: AppTextStyles.bodyMedium
                          .copyWith(fontWeight: FontWeight.w600),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  // Arrow
                  const Icon(Icons.arrow_back_ios_rounded,
                      size: 14, color: AppColors.textTertiary),
                  const SizedBox(width: 8),
                  // Dest dot
                  const _RouteDot(color: AppColors.error),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      dest.name(lang),
                      style: AppTextStyles.bodyMedium
                          .copyWith(fontWeight: FontWeight.w600),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  // Distance badge
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.rideBlueSurface,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${PersianUtils.doubleToPersian(roadKm, decimals: 1)} km',
                      style: AppTextStyles.labelSmall
                          .copyWith(color: AppColors.rideBlue),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRequestButton(String lang, String? selectedId) {
    final active = selectedId != null;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      decoration: BoxDecoration(
        gradient: active ? AppColors.rideGradient : null,
        color: active ? null : AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(18),
        boxShadow: active ? AppColors.rideShadow : [],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          onTap: active ? _requestRide : null,
          borderRadius: BorderRadius.circular(18),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 17),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.hail_rounded,
                    color: AppColors.white, size: 22),
                const SizedBox(width: 10),
                Text(
                  AppStrings.get(AppStrings.requestRide, lang),
                  style: AppTextStyles.buttonText.copyWith(
                    fontSize: 17,
                    color: active
                        ? AppColors.white
                        : AppColors.textDisabled,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Ride Option Card ────────────────────────────────────────────────────────

class _RideOptionCard extends StatelessWidget {
  final CityRideOption option;
  final String lang;
  final double distKm;
  final int etaMin;
  final bool isSelected;
  final VoidCallback onTap;

  const _RideOptionCard({
    required this.option,
    required this.lang,
    required this.distKm,
    required this.etaMin,
    required this.isSelected,
    required this.onTap,
  });

  IconData get _icon {
    switch (option.vehicleType) {
      case CityRideVehicleType.economy:
        return Icons.directions_car_outlined;
      case CityRideVehicleType.comfort:
        return Icons.directions_car_filled_rounded;
      case CityRideVehicleType.suv:
        return Icons.airport_shuttle_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final price = option.estimatedPrice(distKm);
    final wait =
        '${PersianUtils.intToPersian(option.minWaitMin)}-${PersianUtils.intToPersian(option.maxWaitMin)} دقیقه';

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.rideBlueSurface : AppColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isSelected ? AppColors.rideBlue : AppColors.divider,
          width: isSelected ? 2 : 1,
        ),
        boxShadow: isSelected ? AppColors.rideShadow : AppColors.cardShadowSm,
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                // Icon
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.rideBlue
                        : AppColors.surfaceVariant,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(_icon,
                      color: isSelected
                          ? AppColors.white
                          : AppColors.textSecondary,
                      size: 28),
                ),
                const SizedBox(width: 14),

                // Name + description + wait
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(option.name(lang),
                          style: AppTextStyles.labelLarge.copyWith(
                            color: isSelected
                                ? AppColors.rideBlue
                                : AppColors.textPrimary,
                          )),
                      const SizedBox(height: 3),
                      Text(option.desc(lang),
                          style: AppTextStyles.bodySmall
                              .copyWith(color: AppColors.textTertiary),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          const Icon(Icons.schedule_rounded,
                              size: 13, color: AppColors.textHint),
                          const SizedBox(width: 4),
                          Text(wait,
                              style: AppTextStyles.labelSmall
                                  .copyWith(color: AppColors.textHint)),
                          const SizedBox(width: 12),
                          const Icon(Icons.people_alt_outlined,
                              size: 13, color: AppColors.textHint),
                          const SizedBox(width: 4),
                          Text(
                            '${PersianUtils.intToPersian(option.capacity)} نفر',
                            style: AppTextStyles.labelSmall
                                .copyWith(color: AppColors.textHint),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Price
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      PersianUtils.formatPrice(price),
                      style: AppTextStyles.headline3.copyWith(
                        color: isSelected
                            ? AppColors.rideBlue
                            : AppColors.textPrimary,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      'افغانی',
                      style: AppTextStyles.labelSmall
                          .copyWith(color: AppColors.textTertiary),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Helpers ─────────────────────────────────────────────────────────────────

class _CircleBtn extends StatelessWidget {
  final Widget child;
  final VoidCallback onTap;

  const _CircleBtn({required this.child, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.white,
      shape: const CircleBorder(),
      elevation: 3,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Padding(padding: const EdgeInsets.all(10), child: child),
      ),
    );
  }
}

class _RouteDot extends StatelessWidget {
  final Color color;

  const _RouteDot({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}
