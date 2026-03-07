import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/router/app_router.dart';
import '../../providers/language_provider.dart';

class MainShell extends ConsumerWidget {
  final Widget child;
  const MainShell({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lang     = ref.watch(languageProvider);
    final location = GoRouterState.of(context).uri.toString();

    int _index = 0;
    if (location.startsWith(AppRoutes.myTrips))    _index = 1;
    if (location.startsWith(AppRoutes.profileRoute)) _index = 2;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: child,
        bottomNavigationBar: Container(
          decoration: const BoxDecoration(
            border: Border(top: BorderSide(color: AppColors.divider)),
          ),
          child: BottomNavigationBar(
            currentIndex: _index,
            onTap: (i) {
              switch (i) {
                case 0: context.go(AppRoutes.home);
                case 1: context.go(AppRoutes.myTrips);
                case 2: context.go(AppRoutes.profileRoute);
              }
            },
            items: [
              BottomNavigationBarItem(
                icon: const Icon(Icons.home_outlined),
                activeIcon: const Icon(Icons.home),
                label: AppStrings.get(AppStrings.home, lang),
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.luggage_outlined),
                activeIcon: const Icon(Icons.luggage),
                label: AppStrings.get(AppStrings.myTrips, lang),
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.person_outlined),
                activeIcon: const Icon(Icons.person),
                label: AppStrings.get(AppStrings.profile, lang),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
