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
import '../../providers/booking_provider.dart';
import '../../../data/models/booking_model.dart';
import '../../../core/utils/persian_utils.dart';

class MyTripsScreen extends ConsumerStatefulWidget {
  const MyTripsScreen({super.key});

  @override
  ConsumerState<MyTripsScreen> createState() => _MyTripsScreenState();
}

class _MyTripsScreenState extends ConsumerState<MyTripsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lang     = ref.watch(languageProvider);
    final auth     = ref.watch(authProvider);
    final bookings = ref.watch(userBookingsProvider)
        .where((b) => b.userId == (auth.user?.id ?? '')).toList();

    final upcoming  = bookings.where((b) => b.status == BookingStatus.confirmed || b.status == BookingStatus.pending).toList();
    final completed = bookings.where((b) => b.status == BookingStatus.completed).toList();
    final cancelled = bookings.where((b) => b.status == BookingStatus.cancelled).toList();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: Text(AppStrings.get(AppStrings.myTrips, lang)),
          bottom: TabBar(
            controller: _tabController,
            labelColor: AppColors.primary,
            indicatorColor: AppColors.primary,
            unselectedLabelColor: AppColors.textSecondary,
            tabs: [
              Tab(text: AppStrings.get(AppStrings.upcoming, lang)),
              Tab(text: AppStrings.get(AppStrings.completed, lang)),
              Tab(text: AppStrings.get(AppStrings.cancelled, lang)),
            ],
          ),
        ),
        body: !auth.isLoggedIn
            ? _buildLoginPrompt(lang)
            : TabBarView(
                controller: _tabController,
                children: [
                  _BookingList(bookings: upcoming, lang: lang, showTicketButton: true),
                  _BookingList(bookings: completed, lang: lang, showTicketButton: true),
                  _BookingList(bookings: cancelled, lang: lang, showTicketButton: false),
                ],
              ),
      ),
    );
  }

  Widget _buildLoginPrompt(String lang) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.login, size: 72, color: AppColors.textHint),
          const SizedBox(height: 16),
          Text(AppStrings.get(AppStrings.loginRequired, lang), style: AppTextStyles.bodyLarge, textAlign: TextAlign.center),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => context.push(AppRoutes.login),
            child: Text(AppStrings.get(AppStrings.login, lang)),
          ),
        ],
      ),
    );
  }
}

class _BookingList extends ConsumerWidget {
  final List<BookingModel> bookings;
  final String lang;
  final bool showTicketButton;

  const _BookingList({required this.bookings, required this.lang, required this.showTicketButton});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (bookings.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.confirmation_number_outlined, size: 72, color: AppColors.textHint),
            const SizedBox(height: 16),
            Text(AppStrings.get(AppStrings.noBookings, lang), style: AppTextStyles.bodyLarge, textAlign: TextAlign.center),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(AppDimensions.spaceMD),
      itemCount: bookings.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, i) => _BookingCard(booking: bookings[i], lang: lang, showTicketButton: showTicketButton),
    );
  }
}

class _BookingCard extends StatelessWidget {
  final BookingModel booking;
  final String lang;
  final bool showTicketButton;

  const _BookingCard({required this.booking, required this.lang, required this.showTicketButton});

  Color get _statusColor {
    switch (booking.status) {
      case BookingStatus.confirmed: return AppColors.success;
      case BookingStatus.pending:   return AppColors.warning;
      case BookingStatus.cancelled: return AppColors.error;
      case BookingStatus.completed: return AppColors.textSecondary;
    }
  }

  String _statusLabel() {
    switch (booking.status) {
      case BookingStatus.confirmed: return AppStrings.confirmed[lang] ?? '';
      case BookingStatus.pending:   return AppStrings.pending[lang] ?? '';
      case BookingStatus.cancelled: return AppStrings.cancelled[lang] ?? '';
      case BookingStatus.completed: return AppStrings.completed[lang] ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppDimensions.cardPadding,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppDimensions.cardBorderRadius),
        boxShadow: AppShadows.cardShadow,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${booking.fromCity(lang)} ← ${booking.toCity(lang)}', style: AppTextStyles.headline3),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: _statusColor.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
                child: Text(_statusLabel(), style: AppTextStyles.labelSmall.copyWith(color: _statusColor)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.access_time, size: 14, color: AppColors.textSecondary),
              const SizedBox(width: 4),
              Text(PersianUtils.formatTime(booking.departureTime),
                  style: AppTextStyles.bodySmall),
              const SizedBox(width: 12),
              const Icon(Icons.chair_outlined, size: 14, color: AppColors.textSecondary),
              const SizedBox(width: 4),
              Text('${AppStrings.get(AppStrings.seat, lang)} ${booking.seatNumber}', style: AppTextStyles.bodySmall),
              const Spacer(),
              Text('${PersianUtils.formatPrice(booking.totalPrice)} ${AppStrings.get(AppStrings.afghani, lang)}', style: AppTextStyles.priceText),
            ],
          ),
          if (showTicketButton) ...[
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => context.push(AppRoutes.ticketPath(booking.id)),
                icon: const Icon(Icons.qr_code, size: 18),
                label: Text(AppStrings.get(AppStrings.viewTicket, lang)),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
