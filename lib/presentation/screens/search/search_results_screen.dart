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
import '../../../core/utils/persian_utils.dart';
import '../../widgets/premium_trip_card.dart';

class SearchResultsScreen extends ConsumerWidget {
  final String fromCity;
  final String toCity;
  final String date;
  final int passengers;

  const SearchResultsScreen({
    super.key,
    required this.fromCity,
    required this.toCity,
    required this.date,
    required this.passengers,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lang   = ref.watch(languageProvider);
    final trips  = ref.watch(filteredTripsProvider);
    final filter = ref.watch(filterProvider);
    final cities = ref.watch(citiesProvider);

    final from = cities.firstWhere((c) => c.id == fromCity, orElse: () => cities.first);
    final to   = cities.firstWhere((c) => c.id == toCity,   orElse: () => cities.last);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: Column(
            children: [
              Text('${from.name(lang)}  →  ${to.name(lang)}',
                  style: AppTextStyles.labelLarge.copyWith(color: AppColors.textPrimary)),
              Text(
                '${PersianUtils.formatDate(DateTime.tryParse(date) ?? DateTime.now(), lang)} · '
                '${PersianUtils.intToPersian(passengers)} ${lang == "ps" ? "کسان" : "مسافر"}',
                style: AppTextStyles.labelSmall.copyWith(color: AppColors.textSecondary),
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.sort),
              tooltip: AppStrings.get(AppStrings.sortBy, lang),
              onPressed: () => _showSortSheet(context, ref, lang, filter),
            ),
          ],
        ),
        body: trips.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.search_off, size: 64, color: AppColors.textHint),
                    const SizedBox(height: 16),
                    Text(AppStrings.get(AppStrings.noTripsFound, lang), style: AppTextStyles.headline3.copyWith(color: AppColors.textSecondary)),
                  ],
                ),
              )
            : ListView.separated(
                padding: const EdgeInsets.all(AppDimensions.spaceMD),
                itemCount: trips.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (_, i) => PremiumTripCard(
                  trip: trips[i],
                  lang: lang,
                  onTap: () => context.push(AppRoutes.tripPath(trips[i].id)),
                ),
              ),
      ),
    );
  }

  void _showSortSheet(BuildContext context, WidgetRef ref, String lang, FilterState filter) {
    showModalBottomSheet(
      context: context,
      builder: (_) => Directionality(
        textDirection: TextDirection.rtl,
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.spaceLG),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(AppStrings.get(AppStrings.sortBy, lang), style: AppTextStyles.headline3),
              const SizedBox(height: 16),
              ...SortOption.values.map((s) {
                final label = _sortLabel(s, lang);
                return ListTile(
                  title: Text(label),
                  leading: Radio<SortOption>(
                    value: s,
                    groupValue: filter.sort,
                    onChanged: (v) {
                      ref.read(filterProvider.notifier).state = FilterState(sort: v!, vehicleFilter: filter.vehicleFilter);
                      Navigator.pop(context);
                    },
                    activeColor: AppColors.primary,
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  String _sortLabel(SortOption s, String lang) {
    switch (s) {
      case SortOption.priceLow:   return AppStrings.get(AppStrings.lowestPrice, lang);
      case SortOption.priceHigh:  return AppStrings.get(AppStrings.highestPrice, lang);
      case SortOption.timeSoonest: return AppStrings.get(AppStrings.earliestTime, lang);
      case SortOption.timeLatest: return AppStrings.get(AppStrings.latestTime, lang);
    }
  }
}
