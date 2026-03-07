import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../data/models/city_model.dart';

class CitySelectorBottomSheet extends StatefulWidget {
  final List<CityModel> cities;
  final String lang;
  final String title;
  final CityModel? selectedCity;

  const CitySelectorBottomSheet({
    super.key,
    required this.cities,
    required this.lang,
    required this.title,
    this.selectedCity,
  });

  static Future<CityModel?> show(
    BuildContext context, {
    required List<CityModel> cities,
    required String lang,
    required String title,
    CityModel? selectedCity,
  }) {
    return showModalBottomSheet<CityModel>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      useSafeArea: true,
      builder: (_) => CitySelectorBottomSheet(
        cities: cities, lang: lang, title: title, selectedCity: selectedCity,
      ),
    );
  }

  @override
  State<CitySelectorBottomSheet> createState() => _CitySelectorBottomSheetState();
}

class _CitySelectorBottomSheetState extends State<CitySelectorBottomSheet> {
  String _query = '';

  List<CityModel> get _filtered => widget.cities
      .where((c) => c.name(widget.lang).contains(_query) || c.nameFa.contains(_query) || c.namePs.contains(_query))
      .toList();

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      maxChildSize: 0.95,
      minChildSize: 0.45,
      builder: (_, controller) => Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children:
            [const SizedBox(height: 12),
              Container(width: 40, height: 4,
                decoration: BoxDecoration(color: AppColors.divider, borderRadius: BorderRadius.circular(2))),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    Text(widget.title, style: AppTextStyles.headline3),
                    const SizedBox(height: 12),
                    TextField(
                      onChanged: (v) => setState(() => _query = v),
                      textDirection: TextDirection.rtl,
                      decoration: InputDecoration(
                        hintText: widget.lang == 'ps' ? 'د ښار لټون...' : 'جستجوی شهر...',
                        hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.textHint),
                        prefixIcon: const Icon(Icons.search, color: AppColors.primary),
                        filled: true,
                        fillColor: AppColors.surfaceVariant,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: AppColors.divider),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: ListView.separated(
                  controller: controller,
                  itemCount: _filtered.length,
                  separatorBuilder: (_, __) => const Divider(height: 1, color: AppColors.divider, indent: 56),
                  itemBuilder: (_, i) {
                    final city = _filtered[i];
                    final isSelected = widget.selectedCity?.id == city.id;
                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      leading: Container(
                        width: 40, height: 40,
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.primarySurface : AppColors.surfaceVariant,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Icon(
                            Icons.location_city,
                            color: isSelected ? AppColors.primary : AppColors.textTertiary,
                            size: 18,
                          ),
                        ),
                      ),
                      title: Text(
                        city.name(widget.lang),
                        style: AppTextStyles.bodyLarge.copyWith(
                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.normal,
                          color: isSelected ? AppColors.primary : AppColors.textPrimary,
                        ),
                      ),
                      subtitle: Text(city.province, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textTertiary)),
                      trailing: isSelected
                          ? const Icon(Icons.check_circle, color: AppColors.primary)
                          : const Icon(Icons.arrow_back_ios, size: 14, color: AppColors.textTertiary),
                      onTap: () => Navigator.pop(context, city),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
