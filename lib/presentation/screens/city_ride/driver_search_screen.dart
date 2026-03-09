import 'dart:async';
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
import '../../providers/city_ride_provider.dart';
import '../../providers/language_provider.dart';
import 'active_ride_screen.dart';

/// Animated "Searching for drivers" screen with Google Map + radar effect.
/// Auto-matches a driver after ~3 seconds and shows the driver card.
class DriverSearchScreen extends ConsumerStatefulWidget {
  final CityRideBooking booking;

  const DriverSearchScreen({super.key, required this.booking});

  @override
  ConsumerState<DriverSearchScreen> createState() => _DriverSearchScreenState();
}

class _DriverSearchScreenState extends ConsumerState<DriverSearchScreen>
    with TickerProviderStateMixin {
  // ── Animations ────────────────────────────────────────────────────────────
  late AnimationController _radarAnim;     // pulsing radar circles
  late AnimationController _dotAnim;       // blinking driver dots
  late AnimationController _slideAnim;     // bottom sheet slide-in
  late AnimationController _checkAnim;     // checkmark scale

  // ── State ─────────────────────────────────────────────────────────────────
  bool _driverFound = false;
  Timer? _matchTimer;
  Timer? _dotTimer;
  GoogleMapController? _mapController;
  final List<bool> _dotVisible = [true, true, true, true, true];

  @override
  void initState() {
    super.initState();

    _radarAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat();

    _dotAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..repeat(reverse: true);

    _slideAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );

    _checkAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    // Kick off the provider search
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(activeRideProvider.notifier).startSearch(widget.booking);
    });

    // Blink dots independently
    _dotTimer = Timer.periodic(const Duration(milliseconds: 400), (_) {
      if (!mounted) return;
      final idx = math.Random().nextInt(_dotVisible.length);
      setState(() => _dotVisible[idx] = !_dotVisible[idx]);
    });

    // Auto-match driver after 3.5 seconds
    _matchTimer = Timer(const Duration(milliseconds: 3500), () {
      if (!mounted) return;
      setState(() => _driverFound = true);
      _slideAnim.forward();
      _checkAnim.forward();
    });
  }

  @override
  void dispose() {
    _radarAnim.dispose();
    _dotAnim.dispose();
    _slideAnim.dispose();
    _checkAnim.dispose();
    _matchTimer?.cancel();
    _dotTimer?.cancel();
    _mapController?.dispose();
    super.dispose();
  }

  void _confirmDriver() {
    ref.read(activeRideProvider.notifier).driverAccepted();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => const ActiveRideScreen(),
      ),
    );
  }

  void _cancelSearch() {
    ref.read(activeRideProvider.notifier).reset();
    Navigator.of(context).pop();
  }

  // ── Map markers ───────────────────────────────────────────────────────────
  Set<Marker> get _markers {
    final pickup = widget.booking.pickup;
    final drivers = MockData.nearbyDrivers;
    return {
      // Pickup marker
      Marker(
        markerId: const MarkerId('pickup'),
        position: LatLng(pickup.lat, pickup.lng),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        infoWindow: InfoWindow(title: pickup.nameFa),
      ),
      // Driver markers
      for (int i = 0; i < drivers.length; i++)
        if (_dotVisible[i % _dotVisible.length])
          Marker(
            markerId: MarkerId('driver_$i'),
            position: LatLng(drivers[i].lat, drivers[i].lng),
            icon: BitmapDescriptor.defaultMarkerWithHue(
                _driverFound && i == 0
                    ? BitmapDescriptor.hueBlue
                    : BitmapDescriptor.hueYellow),
            infoWindow: InfoWindow(title: drivers[i].name),
          ),
    };
  }

  @override
  Widget build(BuildContext context) {
    final lang   = ref.watch(languageProvider);
    final top    = MediaQuery.of(context).padding.top;
    final bottom = MediaQuery.of(context).padding.bottom;
    final pickup = widget.booking.pickup;
    final driver = widget.booking.driver;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Stack(
          children: [
            // ── Full-screen Google Map ─────────────────────────────────────
            GoogleMap(
              onMapCreated: (c) {
                _mapController = c;
              },
              initialCameraPosition: CameraPosition(
                target: LatLng(pickup.lat, pickup.lng),
                zoom: 14.0,
              ),
              markers: _markers,
              zoomControlsEnabled: false,
              myLocationButtonEnabled: false,
              mapType: MapType.normal,
            ),

            // ── Radar overlay (visible while searching) ───────────────────
            if (!_driverFound)
              Positioned.fill(
                child: IgnorePointer(
                  child: AnimatedBuilder(
                    animation: _radarAnim,
                    builder: (_, __) {
                      return CustomPaint(
                        painter: _RadarPainter(
                          center: Offset(
                            MediaQuery.of(context).size.width / 2,
                            MediaQuery.of(context).size.height * 0.42,
                          ),
                          progress: _radarAnim.value,
                          color: AppColors.rideBlue,
                        ),
                      );
                    },
                  ),
                ),
              ),

            // ── Top bar ───────────────────────────────────────────────────
            Positioned(
              top: 0, left: 0, right: 0,
              child: Container(
                padding: EdgeInsets.fromLTRB(16, top + 12, 16, 16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.55),
                      Colors.transparent,
                    ],
                  ),
                ),
                child: Row(
                  children: [
                    // Back / cancel
                    _circleBtn(
                      icon: Icons.close_rounded,
                      color: AppColors.white,
                      bg: Colors.black38,
                      onTap: _cancelSearch,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _driverFound
                            ? AppStrings.get(AppStrings.driverFound, lang)
                            : AppStrings.get(AppStrings.searchingDriver, lang),
                        style: AppTextStyles.headline3
                            .copyWith(color: AppColors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ── Searching pulsing badge (center of map) ───────────────────
            if (!_driverFound)
              Positioned(
                top: top + 70,
                left: 0,
                right: 0,
                child: Center(
                  child: AnimatedBuilder(
                    animation: _dotAnim,
                    builder: (_, child) => Opacity(
                      opacity: 0.7 + _dotAnim.value * 0.3,
                      child: child,
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        color: AppColors.rideBlue,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: AppColors.rideShadow,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation(AppColors.white),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            AppStrings.get(AppStrings.nearbyDrivers, lang),
                            style: AppTextStyles.labelMedium
                                .copyWith(color: AppColors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

            // ── Bottom sheet — slide up when driver found ─────────────────
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 1),
                  end: Offset.zero,
                ).animate(CurvedAnimation(
                  parent: _slideAnim,
                  curve: Curves.easeOutCubic,
                )),
                child: _buildDriverFoundSheet(lang, driver, bottom),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Driver found bottom sheet ─────────────────────────────────────────────
  Widget _buildDriverFoundSheet(String lang, dynamic driver, double bottom) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: [
          BoxShadow(color: Colors.black26, blurRadius: 20, offset: Offset(0, -4)),
        ],
      ),
      padding: EdgeInsets.fromLTRB(20, 20, 20, bottom + 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Handle
          Center(
            child: Container(
              width: 40, height: 4,
              decoration: BoxDecoration(
                color: AppColors.divider,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // "Driver Found!" header with animated check
          Row(
            children: [
              ScaleTransition(
                scale: CurvedAnimation(
                    parent: _checkAnim, curve: Curves.elasticOut),
                child: Container(
                  width: 40, height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.success.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check_circle_rounded,
                      color: AppColors.success, size: 26),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.get(AppStrings.driverFound, lang),
                      style: AppTextStyles.headline3
                          .copyWith(color: AppColors.success),
                    ),
                    Text(
                      AppStrings.get(AppStrings.driverArriving, lang),
                      style: AppTextStyles.bodySmall
                          .copyWith(color: AppColors.textTertiary),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          const Divider(height: 1),
          const SizedBox(height: 18),

          // Driver info row
          Row(
            children: [
              // Avatar
              Container(
                width: 58, height: 58,
                decoration: BoxDecoration(
                  gradient: AppColors.rideGradient,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(driver.photoInitials,
                      style: AppTextStyles.headline2
                          .copyWith(color: AppColors.white, fontSize: 24)),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(driver.name,
                        style: AppTextStyles.labelLarge
                            .copyWith(fontSize: 16)),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.star_rounded,
                            color: AppColors.warning, size: 16),
                        const SizedBox(width: 4),
                        Text(PersianUtils.doubleToPersian(driver.rating,
                                decimals: 1),
                            style: AppTextStyles.bodyMedium),
                        const SizedBox(width: 10),
                        Text(
                          '${PersianUtils.intToPersian(driver.totalTrips)} ${AppStrings.get(AppStrings.trips, lang)}',
                          style: AppTextStyles.bodySmall
                              .copyWith(color: AppColors.textTertiary),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // ETA badge
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.rideBlueSurface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.rideBlueBorder),
                ),
                child: Column(
                  children: [
                    Text(
                      PersianUtils.intToPersian(
                          widget.booking.option.minWaitMin),
                      style: AppTextStyles.headline3
                          .copyWith(color: AppColors.rideBlue),
                    ),
                    Text(
                      AppStrings.get(AppStrings.minute, lang),
                      style: AppTextStyles.labelSmall
                          .copyWith(color: AppColors.rideBlue),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Vehicle chip row
          Row(
            children: [
              _infoChip(
                icon: Icons.directions_car_rounded,
                label: '${driver.vehicleMake} ${driver.vehicleModel}',
              ),
              const SizedBox(width: 10),
              _infoChip(
                icon: Icons.pin_rounded,
                label: driver.plate,
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Track Ride button
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
                onTap: _confirmDriver,
                borderRadius: BorderRadius.circular(18),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 17),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.gps_fixed_rounded,
                          color: AppColors.white, size: 22),
                      const SizedBox(width: 10),
                      Text(
                        AppStrings.get(AppStrings.trackRideNow, lang),
                        style: AppTextStyles.buttonText.copyWith(
                            fontSize: 17, color: AppColors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
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

  Widget _circleBtn({
    required IconData icon,
    required Color color,
    required Color bg,
    required VoidCallback onTap,
  }) {
    return Material(
      color: bg,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Icon(icon, color: color, size: 20),
        ),
      ),
    );
  }
}

// ── Radar painter ─────────────────────────────────────────────────────────────

class _RadarPainter extends CustomPainter {
  final Offset center;
  final double progress;
  final Color color;

  _RadarPainter({
    required this.center,
    required this.progress,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    const numRings = 3;
    for (int i = 0; i < numRings; i++) {
      final t = (progress + i / numRings) % 1.0;
      final radius = 40 + t * 140;
      final opacity = (1 - t) * 0.25;
      final paint = Paint()
        ..color = color.withValues(alpha: opacity)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5;
      canvas.drawCircle(center, radius, paint);
    }
  }

  @override
  bool shouldRepaint(_RadarPainter old) =>
      old.progress != progress || old.center != center;
}
