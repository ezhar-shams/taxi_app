import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/utils/persian_utils.dart';
import '../../../data/models/city_ride_model.dart';
import '../../providers/city_ride_provider.dart';
import '../../providers/language_provider.dart';
import 'ride_summary_screen.dart';

/// Full-screen live ride tracking screen.
/// Reads [activeRideProvider]; auto-transitions between:
///   driverAccepted → driverArrived → inProgress → completed
class ActiveRideScreen extends ConsumerStatefulWidget {
  const ActiveRideScreen({super.key});

  @override
  ConsumerState<ActiveRideScreen> createState() => _ActiveRideScreenState();
}

class _ActiveRideScreenState extends ConsumerState<ActiveRideScreen>
    with SingleTickerProviderStateMixin {
  GoogleMapController? _mapController;
  late AnimationController _pulseAnim;
  RideStatus? _lastObservedStatus;

  @override
  void initState() {
    super.initState();
    _pulseAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseAnim.dispose();
    _mapController?.dispose();
    super.dispose();
  }

  // ── Camera centering ──────────────────────────────────────────────────────

  void _centerOnDriver(DriverPosition pos) {
    _mapController?.animateCamera(
      CameraUpdate.newLatLng(LatLng(pos.lat, pos.lng)),
    );
  }

  // ── Map primitives ────────────────────────────────────────────────────────

  Set<Marker> _buildMarkers(ActiveRide ride) {
    return {
      // Driver (animated car icon — blue)
      Marker(
        markerId: const MarkerId('driver'),
        position: LatLng(ride.driverPos.lat, ride.driverPos.lng),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        infoWindow: InfoWindow(title: ride.booking.driver.name),
      ),
      // Pickup (green)
      Marker(
        markerId: const MarkerId('pickup'),
        position: LatLng(ride.booking.pickup.lat, ride.booking.pickup.lng),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        infoWindow: InfoWindow(title: ride.booking.pickup.nameFa),
      ),
      // Destination (red)
      Marker(
        markerId: const MarkerId('dest'),
        position: LatLng(
            ride.booking.destination.lat, ride.booking.destination.lng),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        infoWindow: InfoWindow(title: ride.booking.destination.nameFa),
      ),
    };
  }

  Set<Polyline> _buildPolylines(ActiveRide ride) {
    return {
      Polyline(
        polylineId: const PolylineId('route'),
        points: [
          LatLng(ride.booking.pickup.lat, ride.booking.pickup.lng),
          LatLng(ride.booking.destination.lat, ride.booking.destination.lng),
        ],
        color: AppColors.rideBlue.withValues(alpha: 0.6),
        width: 4,
        patterns: const [],
      ),
      // Driver → pickup dashed line (when driver is arriving)
      if (ride.status == RideStatus.driverAccepted)
        Polyline(
          polylineId: const PolylineId('driver_path'),
          points: [
            LatLng(ride.driverPos.lat, ride.driverPos.lng),
            LatLng(ride.booking.pickup.lat, ride.booking.pickup.lng),
          ],
          color: AppColors.success.withValues(alpha: 0.8),
          width: 3,
          patterns: const [],
        ),
    };
  }

  // ── Navigation to summary ─────────────────────────────────────────────────

  void _goToSummary() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const RideSummaryScreen()),
    );
  }

  // ── BUILD ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final lang   = ref.watch(languageProvider);
    final ride   = ref.watch(activeRideProvider);
    final top    = MediaQuery.of(context).padding.top;
    final bottom = MediaQuery.of(context).padding.bottom;

    // If ride completed, navigate to summary
    if (ride != null && ride.status == RideStatus.completed) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_lastObservedStatus != RideStatus.completed) {
          _lastObservedStatus = RideStatus.completed;
          _goToSummary();
        }
      });
    }

    if (ride == null) {
      return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: AppColors.background,
          body: Center(
            child: Text(AppStrings.get(AppStrings.searchingDriver, lang),
                style: AppTextStyles.bodyMedium),
          ),
        ),
      );
    }

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Stack(
          children: [
            // ── Full-screen map ────────────────────────────────────────────
            GoogleMap(
              onMapCreated: (c) {
                _mapController = c;
                _centerOnDriver(ride.driverPos);
              },
              initialCameraPosition: CameraPosition(
                target: LatLng(ride.driverPos.lat, ride.driverPos.lng),
                zoom: 14.5,
              ),
              markers: _buildMarkers(ride),
              polylines: _buildPolylines(ride),
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              mapType: MapType.normal,
            ),

            // ── Status header bar ──────────────────────────────────────────
            Positioned(
              top: 0, left: 0, right: 0,
              child: _buildStatusHeader(ride, lang, top),
            ),

            // ── Bottom panel ───────────────────────────────────────────────
            Positioned(
              bottom: 0, left: 0, right: 0,
              child: _buildBottomPanel(ride, lang, bottom),
            ),

            // ── Center-on-driver floating button ──────────────────────────
            Positioned(
              bottom: _bottomPanelHeight(ride) + 16,
              right: 16,
              child: Material(
                color: AppColors.white,
                shape: const CircleBorder(),
                elevation: 4,
                child: InkWell(
                  onTap: () => _centerOnDriver(ride.driverPos),
                  customBorder: const CircleBorder(),
                  child: const Padding(
                    padding: EdgeInsets.all(12),
                    child: Icon(Icons.gps_fixed_rounded,
                        color: AppColors.rideBlue, size: 22),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  double _bottomPanelHeight(ActiveRide ride) {
    switch (ride.status) {
      case RideStatus.driverAccepted:
        return 210;
      case RideStatus.driverArrived:
        return 210;
      case RideStatus.inProgress:
        return 180;
      default:
        return 180;
    }
  }

  // ── Status header ─────────────────────────────────────────────────────────
  Widget _buildStatusHeader(ActiveRide ride, String lang, double top) {
    Color headerColor;
    IconData headerIcon;
    String headerText;

    switch (ride.status) {
      case RideStatus.driverAccepted:
        headerColor = AppColors.rideBlue;
        headerIcon  = Icons.directions_car_filled_rounded;
        headerText  = AppStrings.get(AppStrings.driverArriving, lang);
        break;
      case RideStatus.driverArrived:
        headerColor = AppColors.success;
        headerIcon  = Icons.location_on_rounded;
        headerText  = AppStrings.get(AppStrings.driverArrivedMsg, lang);
        break;
      case RideStatus.inProgress:
        headerColor = AppColors.rideBlue;
        headerIcon  = Icons.play_circle_filled_rounded;
        headerText  = AppStrings.get(AppStrings.rideInProgress, lang);
        break;
      default:
        headerColor = AppColors.rideBlue;
        headerIcon  = Icons.directions_car_rounded;
        headerText  = '';
    }

    return Container(
      decoration: BoxDecoration(
        color: headerColor,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: headerColor.withValues(alpha: 0.4),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: EdgeInsets.fromLTRB(16, top + 14, 16, 16),
      child: Row(
        children: [
          AnimatedBuilder(
            animation: _pulseAnim,
            builder: (_, child) => Transform.scale(
              scale: 1.0 + _pulseAnim.value * 0.12,
              child: child,
            ),
            child: Icon(headerIcon, color: AppColors.white, size: 26),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(headerText,
                style: AppTextStyles.headline3
                    .copyWith(color: AppColors.white)),
          ),
          // ETA or timer display
          _buildHeaderBadge(ride, lang),
        ],
      ),
    );
  }

  Widget _buildHeaderBadge(ActiveRide ride, String lang) {
    String text;
    if (ride.status == RideStatus.driverAccepted) {
      final m = ride.etaToPickupSec ~/ 60;
      final s = ride.etaToPickupSec % 60;
      text = '${PersianUtils.intToPersian(m)}:'
          '${PersianUtils.intToPersian(s).padLeft(2, '۰')}';
    } else if (ride.status == RideStatus.inProgress) {
      final m = ride.elapsedTripSec ~/ 60;
      final s = ride.elapsedTripSec % 60;
      text = '${PersianUtils.intToPersian(m)}:'
          '${PersianUtils.intToPersian(s).padLeft(2, '۰')}';
    } else {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.22),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(text,
          style: AppTextStyles.labelLarge.copyWith(
              color: AppColors.white,
              fontWeight: FontWeight.w800,
              fontFeatures: const [])),
    );
  }

  // ── Bottom panel ──────────────────────────────────────────────────────────
  Widget _buildBottomPanel(ActiveRide ride, String lang, double bottom) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
              color: Colors.black12, blurRadius: 16, offset: Offset(0, -2)),
        ],
      ),
      padding: EdgeInsets.fromLTRB(20, 20, 20, bottom + 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            width: 40, height: 4,
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: AppColors.divider,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          if (ride.status == RideStatus.driverAccepted)
            _buildArrivingPanel(ride, lang)
          else if (ride.status == RideStatus.driverArrived)
            _buildArrivedPanel(ride, lang)
          else if (ride.status == RideStatus.inProgress)
            _buildInProgressPanel(ride, lang)
          else
            const SizedBox.shrink(),
        ],
      ),
    );
  }

  // Panel: driver arriving → show cancel + driver info
  Widget _buildArrivingPanel(ActiveRide ride, String lang) {
    final driver = ride.booking.driver;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _miniDriverCard(driver, lang),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {
                  ref.read(activeRideProvider.notifier).cancelRide();
                  Navigator.of(context).popUntil((r) => r.isFirst);
                },
                icon: const Icon(Icons.cancel_outlined, size: 18),
                label: Text(AppStrings.get(AppStrings.cancelRide, lang)),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.error,
                  side: BorderSide(
                      color: AppColors.error.withValues(alpha: 0.5)),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.rideBlueSurface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.rideBlueBorder),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                child: Column(
                  children: [
                    Text(
                      AppStrings.get(AppStrings.driverEta, lang),
                      style: AppTextStyles.labelSmall
                          .copyWith(color: AppColors.rideBlue),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${PersianUtils.intToPersian(ride.etaToPickupSec ~/ 60)} ${AppStrings.get(AppStrings.minute, lang)}',
                      style: AppTextStyles.headline3
                          .copyWith(color: AppColors.rideBlue),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Panel: driver arrived → show "Start Ride" button
  Widget _buildArrivedPanel(ActiveRide ride, String lang) {
    final driver = ride.booking.driver;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _miniDriverCard(driver, lang),
        const SizedBox(height: 14),
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF2E7D32), Color(0xFF66BB6A)],
              begin: Alignment.centerRight,
              end: Alignment.centerLeft,
            ),
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: AppColors.success.withValues(alpha: 0.4),
                blurRadius: 14,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(18),
            child: InkWell(
              onTap: () =>
                  ref.read(activeRideProvider.notifier).startTrip(),
              borderRadius: BorderRadius.circular(18),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 17),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.play_arrow_rounded,
                        color: AppColors.white, size: 26),
                    const SizedBox(width: 10),
                    Text(
                      AppStrings.get(AppStrings.startRide, lang),
                      style: AppTextStyles.buttonText.copyWith(
                          fontSize: 18, color: AppColors.white),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Panel: in progress → stats + "End Ride"
  Widget _buildInProgressPanel(ActiveRide ride, String lang) {
    final elapsedMin = ride.elapsedTripSec ~/ 60;
    final elapsedSec = ride.elapsedTripSec % 60;
    final timeStr =
        '${PersianUtils.intToPersian(elapsedMin)}:${PersianUtils.intToPersian(elapsedSec).padLeft(2, '۰')}';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Stats row
        Row(
          children: [
            Expanded(
              child: _statTile(
                icon: Icons.schedule_rounded,
                label: AppStrings.get(AppStrings.elapsedTime, lang),
                value: timeStr,
                color: AppColors.rideBlue,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _statTile(
                icon: Icons.straighten_rounded,
                label: AppStrings.get(AppStrings.distanceKm, lang),
                value:
                    '${PersianUtils.doubleToPersian(ride.booking.distanceKm, decimals: 1)} km',
                color: AppColors.rideBlue,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _statTile(
                icon: Icons.attach_money_rounded,
                label: AppStrings.get(AppStrings.estimatedPrice, lang),
                value: PersianUtils.formatPrice(ride.booking.totalPrice),
                color: AppColors.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        // End ride button
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
              onTap: () => ref.read(activeRideProvider.notifier).endTrip(),
              borderRadius: BorderRadius.circular(18),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 17),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.stop_circle_rounded,
                        color: AppColors.white, size: 24),
                    const SizedBox(width: 10),
                    Text(
                      AppStrings.get(AppStrings.endRide, lang),
                      style: AppTextStyles.buttonText.copyWith(
                          fontSize: 18, color: AppColors.white),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  Widget _miniDriverCard(MockDriver driver, String lang) {
    return Row(
      children: [
        Container(
          width: 48, height: 48,
          decoration: BoxDecoration(
            gradient: AppColors.rideGradient,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(driver.photoInitials,
                style: AppTextStyles.headline3
                    .copyWith(color: AppColors.white)),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(driver.name, style: AppTextStyles.labelLarge),
              Row(
                children: [
                  const Icon(Icons.star_rounded,
                      color: AppColors.warning, size: 14),
                  const SizedBox(width: 3),
                  Text(
                    PersianUtils.doubleToPersian(driver.rating, decimals: 1),
                    style: AppTextStyles.bodySmall,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${driver.vehicleMake} ${driver.vehicleModel}',
                    style: AppTextStyles.bodySmall
                        .copyWith(color: AppColors.textTertiary),
                  ),
                ],
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: AppColors.surfaceVariant,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            driver.plate,
            style: AppTextStyles.labelSmall
                .copyWith(fontWeight: FontWeight.w700),
          ),
        ),
      ],
    );
  }

  Widget _statTile({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.15)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(height: 4),
          Text(value,
              style: AppTextStyles.labelMedium.copyWith(color: color),
              textAlign: TextAlign.center),
          Text(label,
              style: AppTextStyles.labelSmall
                  .copyWith(color: AppColors.textTertiary),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }
}
