import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../data/mock_data.dart';
import '../../../data/models/city_ride_model.dart';

/// Full-screen Google Map location picker.
/// The user pans the map; a center pin shows the selected point.
/// A search bar filters predefined locations.
/// Returns a [PickupLocation] or null if cancelled.
class MapLocationPickerScreen extends StatefulWidget {
  final String titleFa;
  final String titlePs;
  final String lang;
  final PickupLocation? initialLocation;

  const MapLocationPickerScreen({
    super.key,
    required this.titleFa,
    required this.titlePs,
    required this.lang,
    this.initialLocation,
  });

  String get title => lang == 'ps' ? titlePs : titleFa;

  /// Convenience push helper.
  static Future<PickupLocation?> show(
    BuildContext context, {
    required String titleFa,
    required String titlePs,
    required String lang,
    PickupLocation? initialLocation,
  }) {
    return Navigator.of(context).push<PickupLocation>(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => MapLocationPickerScreen(
          titleFa: titleFa,
          titlePs: titlePs,
          lang: lang,
          initialLocation: initialLocation,
        ),
      ),
    );
  }

  @override
  State<MapLocationPickerScreen> createState() =>
      _MapLocationPickerScreenState();
}

class _MapLocationPickerScreenState extends State<MapLocationPickerScreen> {
  GoogleMapController? _mapController;
  LatLng _centerLatLng = const LatLng(34.5260, 69.1776); // Kabul default
  PickupLocation? _snappedLocation;

  final TextEditingController _searchCtrl = TextEditingController();
  bool _showSearch = false;
  String _query = '';

  List<PickupLocation> get _allLocations => MockData.cityLocations;

  List<PickupLocation> get _filtered {
    if (_query.isEmpty) return _allLocations;
    final q = _query.toLowerCase();
    return _allLocations.where((l) {
      return l.nameFa.toLowerCase().contains(q) ||
          l.namePs.toLowerCase().contains(q) ||
          l.addressFa.toLowerCase().contains(q) ||
          l.addressPs.toLowerCase().contains(q);
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    if (widget.initialLocation != null) {
      _centerLatLng =
          LatLng(widget.initialLocation!.lat, widget.initialLocation!.lng);
      _snappedLocation = widget.initialLocation;
    }
    _searchCtrl.addListener(() => setState(() => _query = _searchCtrl.text));
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    _mapController?.dispose();
    super.dispose();
  }

  void _onCameraIdle() {
    // Snap to nearest predefined location within 2 km
    PickupLocation? nearest;
    double minDist = double.infinity;
    final pivot = PickupLocation(
      id: '__tmp',
      nameFa: '', namePs: '', addressFa: '', addressPs: '',
      cityId: '', lat: _centerLatLng.latitude, lng: _centerLatLng.longitude,
    );
    for (final loc in _allLocations) {
      final d = pivot.distanceTo(loc);
      if (d < minDist) { minDist = d; nearest = loc; }
    }
    setState(() {
      _snappedLocation = (minDist <= 3.0) ? nearest : nearest; // always snap to nearest
    });
  }

  void _selectLocation(PickupLocation loc) {
    setState(() {
      _snappedLocation = loc;
      _centerLatLng = LatLng(loc.lat, loc.lng);
      _showSearch = false;
      _searchCtrl.clear();
    });
    _mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(_centerLatLng, 15),
    );
  }

  void _confirm() {
    if (_snappedLocation != null) {
      Navigator.of(context).pop(_snappedLocation);
    }
  }

  /// Center the map on Kabul default or last known position.
  /// On web, the native Google Maps button handles real GPS.
  void _goToMyLocation() {
    // Default to Kabul city center as a fallback; the user can pan from there.
    const kabulCenter = LatLng(34.5260, 69.1776);
    setState(() => _centerLatLng = kabulCenter);
    _mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(kabulCenter, 14),
    );
  }

  @override
  Widget build(BuildContext context) {
    final lang = widget.lang;
    final top = MediaQuery.of(context).padding.top;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: Stack(
          children: [
            // ── Google Map ────────────────────────────────────────────────
            GoogleMap(
              onMapCreated: (c) {
                _mapController = c;
                if (widget.initialLocation != null) {
                  Future.delayed(const Duration(milliseconds: 300), () {
                    _mapController?.animateCamera(
                      CameraUpdate.newLatLngZoom(_centerLatLng, 15),
                    );
                  });
                }
              },
              initialCameraPosition: CameraPosition(
                target: _centerLatLng,
                zoom: 14,
              ),
              onCameraMove: (pos) {
                setState(() => _centerLatLng = pos.target);
              },
              onCameraIdle: _onCameraIdle,
              myLocationEnabled: true,
              myLocationButtonEnabled: false, // we add our own below
              zoomControlsEnabled: false,
              mapType: MapType.normal,
              padding: EdgeInsets.only(top: top + 80, bottom: 180),
            ),

            // ── Center pin ────────────────────────────────────────────────
            Center(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 40),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 36, height: 36,
                      decoration: BoxDecoration(
                        color: AppColors.rideBlue,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.white, width: 3),
                        boxShadow: AppColors.rideShadow,
                      ),
                      child: const Icon(Icons.location_on,
                          color: AppColors.white, size: 18),
                    ),
                    Container(
                      width: 2, height: 18,
                      color: AppColors.rideBlue,
                    ),
                    Container(
                      width: 8, height: 8,
                      decoration: BoxDecoration(
                        color: AppColors.rideBlue.withValues(alpha: 0.4),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ── Top bar + search ──────────────────────────────────────────
            Positioned(
              top: 0, left: 0, right: 0,
              child: SafeArea(
                bottom: false,
                child: Column(
                  children: [
                    // Title bar
                    Container(
                      color: AppColors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 10),
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () => Navigator.of(context).pop(),
                            icon: const Icon(Icons.arrow_back_ios_new_rounded,
                                size: 20),
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              widget.title,
                              style: AppTextStyles.headline3,
                            ),
                          ),
                          // Search icon
                          IconButton(
                            onPressed: () {
                              setState(() => _showSearch = !_showSearch);
                              if (!_showSearch) _searchCtrl.clear();
                            },
                            icon: Icon(
                              _showSearch
                                  ? Icons.close_rounded
                                  : Icons.search_rounded,
                              color: AppColors.rideBlue,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Search field (expandable)
                    AnimatedCrossFade(
                      duration: const Duration(milliseconds: 200),
                      crossFadeState: _showSearch
                          ? CrossFadeState.showFirst
                          : CrossFadeState.showSecond,
                      firstChild: Container(
                        color: AppColors.white,
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                        child: TextField(
                          controller: _searchCtrl,
                          autofocus: true,
                          textDirection: TextDirection.rtl,
                          decoration: InputDecoration(
                            hintText:
                                AppStrings.get(AppStrings.searchLocation, lang),
                            hintStyle: AppTextStyles.bodySmall
                                .copyWith(color: AppColors.textHint),
                            prefixIcon: const Icon(Icons.search,
                                color: AppColors.rideBlue),
                            filled: true,
                            fillColor: AppColors.rideBlueSurface,
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                      secondChild: const SizedBox.shrink(),
                    ),

                    // Search results list
                    if (_showSearch && _filtered.isNotEmpty)
                      Container(
                        color: AppColors.white,
                        constraints: const BoxConstraints(maxHeight: 280),
                        child: ListView.separated(
                          shrinkWrap: true,
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          itemCount: math.min(_filtered.length, 12),
                          separatorBuilder: (_, __) => const Divider(
                              height: 1, indent: 56),
                          itemBuilder: (_, i) {
                            final loc = _filtered[i];
                            return ListTile(
                              leading: Container(
                                width: 36, height: 36,
                                decoration: BoxDecoration(
                                  color: AppColors.rideBlueSurface,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(Icons.place_outlined,
                                    color: AppColors.rideBlue, size: 20),
                              ),
                              title: Text(loc.name(lang),
                                  style: AppTextStyles.labelLarge),
                              subtitle: Text(loc.address(lang),
                                  style: AppTextStyles.bodySmall.copyWith(
                                      color: AppColors.textTertiary),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis),
                              onTap: () => _selectLocation(loc),
                            );
                          },
                        ),
                      ),
                  ],
                ),
              ),
            ),

            // ── My Location floating button ───────────────────────────────
            Positioned(
              bottom: 210,
              left: 16,
              child: Material(
                color: AppColors.white,
                shape: const CircleBorder(),
                elevation: 4,
                child: InkWell(
                  onTap: _goToMyLocation,
                  customBorder: const CircleBorder(),
                  child: const Padding(
                    padding: EdgeInsets.all(12),
                    child: Icon(Icons.my_location_rounded,
                        color: AppColors.rideBlue, size: 22),
                  ),
                ),
              ),
            ),

            // ── Bottom panel: address + confirm ───────────────────────────
            Positioned(
              bottom: 0, left: 0, right: 0,
              child: SafeArea(
                top: false,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(24)),
                    boxShadow: AppColors.cardShadow,
                  ),
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Location name
                      if (_snappedLocation != null) ...[
                        Row(
                          children: [
                            Container(
                              width: 42, height: 42,
                              decoration: BoxDecoration(
                                color: AppColors.rideBlueSurface,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(Icons.location_on_rounded,
                                  color: AppColors.rideBlue, size: 22),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _snappedLocation!.name(lang),
                                    style: AppTextStyles.labelLarge
                                        .copyWith(color: AppColors.textPrimary),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    _snappedLocation!.address(lang),
                                    style: AppTextStyles.bodySmall.copyWith(
                                        color: AppColors.textTertiary),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                      ] else
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Text(
                            AppStrings.get(AppStrings.moveMapToSelect, lang),
                            style: AppTextStyles.bodyMedium
                                .copyWith(color: AppColors.textTertiary),
                            textAlign: TextAlign.center,
                          ),
                        ),

                      // Confirm button
                      DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: AppColors.rideGradient,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: AppColors.rideShadow,
                        ),
                        child: Material(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(16),
                          child: InkWell(
                            onTap: _snappedLocation != null ? _confirm : null,
                            borderRadius: BorderRadius.circular(16),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 16),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.check_circle_outline_rounded,
                                      color: AppColors.white, size: 22),
                                  const SizedBox(width: 10),
                                  Text(
                                    AppStrings.get(
                                        AppStrings.confirmLocation, lang),
                                    style: AppTextStyles.buttonText
                                        .copyWith(color: AppColors.white),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
