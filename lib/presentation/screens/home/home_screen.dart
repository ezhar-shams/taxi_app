import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/router/app_router.dart';
import '../../../core/utils/persian_utils.dart';
import '../../providers/language_provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/trip_provider.dart';
import '../../widgets/city_selector_bottom_sheet.dart';
import '../../widgets/shamsi_date_picker.dart';
import '../../../data/models/city_model.dart';
import '../../../data/mock_data.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});
  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  CityModel? _fromCity;
  CityModel? _toCity;
  DateTime _date = DateTime.now();
  int _passengers = 1;

  Future<void> _pickDate() async {
    final lang = ref.read(languageProvider);
    final picked = await ShamsiDatePicker.show(
      context,
      initialDate: _date,
      lang: lang,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 90)),
    );
    if (picked != null) setState(() => _date = picked);
  }

  void _swapCities() => setState(() {
    final tmp = _fromCity;
    _fromCity = _toCity;
    _toCity = tmp;
  });

  void _search() {
    final lang = ref.read(languageProvider);
    if (_fromCity == null || _toCity == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppStrings.get(AppStrings.selectCities, lang)),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }
    if (_fromCity!.id == _toCity!.id) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(lang == 'ps'
              ? 'مبدا او مقصد باید توپیر ولري'
              : 'مبدا و مقصد نمی‌توانند یکی باشند'),
          backgroundColor: AppColors.warning,
        ),
      );
      return;
    }
    ref.read(searchParamsProvider.notifier).state = SearchParams(
      fromId: _fromCity!.id,
      toId: _toCity!.id,
      date: _date,
      passengers: _passengers,
    );
    context.push(
      '${AppRoutes.searchResults}'
      '?from=${_fromCity!.id}&to=${_toCity!.id}'
      '&date=${_date.toIso8601String().split("T")[0]}'
      '&passengers=$_passengers',
    );
  }

  @override
  Widget build(BuildContext context) {
    final lang = ref.watch(languageProvider);
    final auth = ref.watch(authProvider);
    final name = auth.user?.fullName;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _buildHeader(lang, name)),
            SliverToBoxAdapter(child: _buildSearchSection(lang)),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
                child: Row(
                  children: [
                    Container(
                      width: 4, height: 20,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      AppStrings.get(AppStrings.popularRoutes, lang),
                      style: AppTextStyles.headline3,
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverGrid(
                delegate: SliverChildBuilderDelegate(
                  (_, i) => _buildRouteCard(MockData.popularRoutes[i], lang),
                  childCount: MockData.popularRoutes.length,
                ),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 1.55,
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 40)),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(String lang, String? name) {
    final top = MediaQuery.of(context).padding.top;
    return Container(
      padding: EdgeInsets.fromLTRB(20, top + 20, 20, 28),
      decoration: const BoxDecoration(gradient: AppColors.headerGradient),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40, height: 40,
                decoration: BoxDecoration(
                  color: AppColors.white.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    '۳۴',
                    style: AppTextStyles.headline3.copyWith(
                        color: AppColors.white, fontWeight: FontWeight.w900),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                AppStrings.get(AppStrings.appName, lang),
                style: AppTextStyles.headline2.copyWith(
                    color: AppColors.white, fontWeight: FontWeight.w800),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {},
                child: Container(
                  width: 40, height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.white.withValues(alpha: 0.18),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.notifications_outlined,
                      color: AppColors.white, size: 20),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Text(
            name != null
                ? '${AppStrings.get(AppStrings.greeting, lang)}، $name!'
                : AppStrings.get(AppStrings.greeting, lang),
            style: AppTextStyles.bodyMedium
                .copyWith(color: AppColors.white.withValues(alpha: 0.8)),
          ),
          const SizedBox(height: 4),
          Text(
            AppStrings.get(AppStrings.readyForJourney, lang),
            style: AppTextStyles.headline2.copyWith(color: AppColors.white),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════
  //  SEARCH SECTION — two separate cards + search button
  // ═══════════════════════════════════════════════════════════════
  Widget _buildSearchSection(String lang) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Card 1 · Route + Date ──────────────────────────
          _buildRouteDateCard(lang),
          const SizedBox(height: 10),
          // ── Card 2 · Passengers ────────────────────────────
          _buildPassengersCard(lang),
          const SizedBox(height: 14),
          // ── Search button ──────────────────────────────────
          _buildSearchButton(lang),
        ],
      ),
    );
  }

  // ── Card 1: From · To · Date  (single horizontal row) ─────────
  Widget _buildRouteDateCard(String lang) {
    final cities = MockData.cities;
    const radius = Radius.circular(20);

    return Container(
      height: 84,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: AppColors.cardShadow,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── From ─────────────────────────────────────────
            Expanded(
              flex: 5,
              child: _inlineField(
                cornerRadius: const BorderRadius.only(
                    topRight: radius, bottomRight: radius),
                dotColor: AppColors.success,
                label: lang == 'ps' ? 'له' : 'از',
                hint: lang == 'ps' ? 'ښار' : 'شهر',
                value: _fromCity?.name(lang),
                onTap: () async {
                  final city = await CitySelectorBottomSheet.show(
                    context,
                    cities: cities,
                    lang: lang,
                    title: AppStrings.get(AppStrings.whereFrom, lang),
                    selectedCity: _fromCity,
                  );
                  if (city != null) setState(() => _fromCity = city);
                },
              ),
            ),

            // ── Swap divider ──────────────────────────────────
            _inlineSwapDivider(),

            // ── To ───────────────────────────────────────────
            Expanded(
              flex: 5,
              child: _inlineField(
                cornerRadius: BorderRadius.zero,
                dotColor: AppColors.error,
                label: lang == 'ps' ? 'مقصد' : 'به',
                hint: lang == 'ps' ? 'ښار' : 'شهر',
                value: _toCity?.name(lang),
                onTap: () async {
                  final city = await CitySelectorBottomSheet.show(
                    context,
                    cities: cities,
                    lang: lang,
                    title: AppStrings.get(AppStrings.whereTo, lang),
                    selectedCity: _toCity,
                  );
                  if (city != null) setState(() => _toCity = city);
                },
              ),
            ),

            // ── Plain vertical divider ────────────────────────
            Center(
              child: Container(
                  width: 1, height: 48, color: AppColors.divider),
            ),

            // ── Date ─────────────────────────────────────────
            Expanded(
              flex: 4,
              child: _inlineDateField(
                cornerRadius: const BorderRadius.only(
                    topLeft: radius, bottomLeft: radius),
                lang: lang,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Card 2: Passengers ──────────────────────────────────────────
  Widget _buildPassengersCard(String lang) {
    final label = AppStrings.get(AppStrings.passengers, lang);
    final sublabel = lang == 'ps' ? 'شمیر وټاکئ' : 'تعداد انتخاب کنید';

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: AppColors.cardShadow,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      child: Row(
        children: [
          // Icon tile
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppColors.primarySurface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.people_alt_outlined,
              color: AppColors.primary,
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          // Labels
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTextStyles.labelSmall
                      .copyWith(color: AppColors.textTertiary, height: 1.2),
                ),
                const SizedBox(height: 3),
                Text(
                  sublabel,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          // Stepper
          _passengerStepper(),
        ],
      ),
    );
  }

  Widget _passengerStepper() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _stepButton(
          icon: Icons.remove_rounded,
          enabled: _passengers > 1,
          onTap: () {
            if (_passengers > 1) setState(() => _passengers--);
          },
        ),
        SizedBox(
          width: 42,
          child: Center(
            child: Text(
              PersianUtils.intToPersian(_passengers),
              style: AppTextStyles.headline2.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
        _stepButton(
          icon: Icons.add_rounded,
          enabled: _passengers < 8,
          onTap: () {
            if (_passengers < 8) setState(() => _passengers++);
          },
        ),
      ],
    );
  }

  Widget _buildSearchButton(String lang) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFCC1230), Color(0xFF8B0000)],
          begin: Alignment.centerRight,
          end: Alignment.centerLeft,
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.38),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          onTap: _search,
          borderRadius: BorderRadius.circular(18),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 17),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.search_rounded,
                  color: AppColors.white,
                  size: 22,
                ),
                const SizedBox(width: 10),
                Text(
                  AppStrings.get(AppStrings.search, lang),
                  style: AppTextStyles.buttonText.copyWith(
                    fontSize: 17,
                    letterSpacing: 0.8,
                    color: AppColors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── Inline field: From or To ────────────────────────────────────
  Widget _inlineField({
    required BorderRadius cornerRadius,
    required Color dotColor,
    required String label,
    required String hint,
    required String? value,
    required VoidCallback onTap,
  }) {
    final bool selected = value != null;
    return Material(
      color: AppColors.white,
      borderRadius: cornerRadius,
      child: InkWell(
        onTap: onTap,
        borderRadius: cornerRadius,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Label row with dot
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: selected ? dotColor : Colors.transparent,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: selected ? dotColor : AppColors.textTertiary,
                        width: 1.5,
                      ),
                    ),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    label,
                    style: AppTextStyles.labelSmall.copyWith(
                      color: AppColors.textTertiary,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              // Value / hint
              Text(
                selected ? value : hint,
                style: selected
                    ? AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                        height: 1.2,
                      )
                    : AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textHint,
                        height: 1.2,
                      ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Inline date field ───────────────────────────────────────────
  Widget _inlineDateField({
    required BorderRadius cornerRadius,
    required String lang,
  }) {
    final dateLabel = lang == 'ps' ? 'نیټه' : 'تاریخ';
    return Material(
      color: AppColors.white,
      borderRadius: cornerRadius,
      child: InkWell(
        onTap: _pickDate,
        borderRadius: cornerRadius,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Label row with calendar icon
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.calendar_today_rounded,
                    size: 9,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    dateLabel,
                    style: AppTextStyles.labelSmall.copyWith(
                      color: AppColors.textTertiary,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              // Shamsi date value — two lines for clean display
              Text(
                PersianUtils.formatDate(_date, lang),
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                  height: 1.2,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Swap divider between From and To ────────────────────────────
  Widget _inlineSwapDivider() {
    return SizedBox(
      width: 28,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Vertical line
          Center(
            child: Container(
              width: 1,
              height: 48,
              color: AppColors.divider,
            ),
          ),
          // Swap button
          GestureDetector(
            onTap: _swapCities,
            child: Container(
              width: 26,
              height: 26,
              decoration: BoxDecoration(
                color: AppColors.white,
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.primaryBorder,
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.13),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(
                Icons.swap_horiz_rounded,
                color: AppColors.primary,
                size: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _stepButton({
    required IconData icon,
    required bool enabled,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: enabled ? AppColors.primarySurface : AppColors.surfaceVariant,
          shape: BoxShape.circle,
          border: Border.all(
            color: enabled ? AppColors.primaryBorder : AppColors.divider,
            width: 1.5,
          ),
        ),
        child: Icon(
          icon,
          size: 18,
          color: enabled ? AppColors.primary : AppColors.textHint,
        ),
      ),
    );
  }

  Widget _buildRouteCard(Map<String, String> route, String lang) {
    final from =
        lang == 'ps' ? route['fromPs']! : route['fromFa']!;
    final to =
        lang == 'ps' ? route['toPs']! : route['toFa']!;
    return GestureDetector(
      onTap: () {
        final now = DateTime.now();
        ref.read(searchParamsProvider.notifier).state = SearchParams(
          fromId: route['fromId']!,
          toId: route['toId']!,
          date: now,
          passengers: 1,
        );
        context.push(
          '${AppRoutes.searchResults}?from=${route["fromId"]}'
          '&to=${route["toId"]}'
          '&date=${now.toIso8601String().split("T")[0]}&passengers=1',
        );
      },
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius:
              BorderRadius.circular(AppDimensions.radiusLG),
          border: Border.all(color: AppColors.divider),
          boxShadow: AppColors.cardShadowSm,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 8, height: 8,
                  decoration: const BoxDecoration(
                      color: AppColors.success,
                      shape: BoxShape.circle),
                ),
                const SizedBox(width: 6),
                Expanded(
                    child: Text(from,
                        style: AppTextStyles.labelLarge,
                        overflow: TextOverflow.ellipsis)),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(right: 7, top: 2, bottom: 2),
              child: Container(
                  width: 2, height: 12, color: AppColors.divider),
            ),
            Row(
              children: [
                Container(
                  width: 8, height: 8,
                  decoration: const BoxDecoration(
                      color: AppColors.error, shape: BoxShape.circle),
                ),
                const SizedBox(width: 6),
                Expanded(
                    child: Text(to,
                        style: AppTextStyles.bodySmall,
                        overflow: TextOverflow.ellipsis)),
              ],
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${route["price"]} ${AppStrings.get(AppStrings.afghani, lang)}',
                  style: AppTextStyles.labelMedium
                      .copyWith(color: AppColors.primary),
                ),
                Text(
                  route['duration']!,
                  style: AppTextStyles.labelSmall
                      .copyWith(color: AppColors.textTertiary),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
