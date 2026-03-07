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

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lang      = ref.watch(languageProvider);
    final auth      = ref.watch(authProvider);
    final bookingCount = auth.isLoggedIn
        ? ref.watch(userBookingsProvider).where((b) => b.userId == auth.user?.id).length
        : 0;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(title: Text(AppStrings.get(AppStrings.profile, lang))),
        body: SingleChildScrollView(
          child: Column(
            children: [
              // Header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 32),
                color: AppColors.primary,
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 44,
                      backgroundColor: AppColors.white.withOpacity(0.2),
                      child: const Icon(Icons.person, size: 52, color: AppColors.white),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      auth.isLoggedIn ? (auth.user?.fullName ?? '') : AppStrings.get(AppStrings.guest, lang),
                      style: AppTextStyles.headline2.copyWith(color: AppColors.white),
                    ),
                    if (auth.isLoggedIn && auth.user?.phone != null) ...[
                      const SizedBox(height: 4),
                      Text(auth.user!.phone, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.white.withOpacity(0.8))),
                    ],
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                      decoration: BoxDecoration(color: AppColors.white.withOpacity(0.15), borderRadius: BorderRadius.circular(AppDimensions.radiusFull)),
                      child: Text(
                        '${bookingCount} ${AppStrings.get(AppStrings.bookings, lang)}',
                        style: AppTextStyles.labelMedium.copyWith(color: AppColors.white),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Menu items
              if (!auth.isLoggedIn)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spaceMD),
                  child: ElevatedButton(
                    onPressed: () => context.push(AppRoutes.login),
                    child: Text(AppStrings.get(AppStrings.loginOrRegister, lang)),
                  ),
                )
              else ...[
                _MenuItem(icon: Icons.person_outline, label: AppStrings.get(AppStrings.editProfile, lang), onTap: () {}),
                _MenuItem(
                  icon: Icons.language,
                  label: AppStrings.get(AppStrings.changeLanguage, lang),
                  onTap: () => _showLanguageSheet(context, ref, lang),
                ),
                _MenuItem(icon: Icons.notifications_outlined, label: AppStrings.get(AppStrings.notifications, lang), onTap: () {}),
                _MenuItem(icon: Icons.help_outline, label: AppStrings.get(AppStrings.help, lang), onTap: () {}),
                _MenuItem(icon: Icons.info_outline, label: AppStrings.get(AppStrings.about, lang), onTap: () {}),
                const Divider(height: 1),
                _MenuItem(
                  icon: Icons.logout,
                  label: AppStrings.get(AppStrings.logout, lang),
                  iconColor: AppColors.error,
                  labelColor: AppColors.error,
                  onTap: () async {
                    await ref.read(authProvider.notifier).logout();
                    if (context.mounted) context.go(AppRoutes.login);
                  },
                ),
              ],
              const SizedBox(height: 40),
              Text('سفر یار v1.0.0', style: AppTextStyles.caption),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  void _showLanguageSheet(BuildContext context, WidgetRef ref, String lang) {
    showModalBottomSheet(
      context: context,
      builder: (_) => Directionality(
        textDirection: TextDirection.rtl,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Text('🇦🇫', style: TextStyle(fontSize: 24)),
              title: const Text('دری'),
              trailing: lang == 'fa' ? const Icon(Icons.check, color: AppColors.primary) : null,
              onTap: () {
                ref.read(languageProvider.notifier).setLanguage('fa');
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Text('🇦🇫', style: TextStyle(fontSize: 24)),
              title: const Text('پښتو'),
              trailing: lang == 'ps' ? const Icon(Icons.check, color: AppColors.primary) : null,
              onTap: () {
                ref.read(languageProvider.notifier).setLanguage('ps');
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? iconColor;
  final Color? labelColor;

  const _MenuItem({required this.icon, required this.label, required this.onTap, this.iconColor, this.labelColor});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: iconColor ?? AppColors.textSecondary, size: 22),
      title: Text(label, style: AppTextStyles.bodyLarge.copyWith(color: labelColor ?? AppColors.textPrimary)),
      trailing: const Icon(Icons.chevron_left, color: AppColors.textHint, size: 20),
    );
  }
}
