import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_shadows.dart';
import '../../core/router/app_routes.dart';

class BottomNavScaffold extends StatelessWidget {
  final Widget child;
  
  const BottomNavScaffold({
    super.key,
    required this.child,
  });
  
  int _getCurrentIndex(String location) {
    if (location.startsWith(AppRoutes.home)) return 0;
    if (location.startsWith(AppRoutes.search)) return 1;
    if (location.startsWith(AppRoutes.scan)) return 2;
    if (location.startsWith(AppRoutes.health)) return 3;
    if (location.startsWith(AppRoutes.profile)) return 4;
    return 0;
  }
  
  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    final currentIndex = _getCurrentIndex(location);
    
    return Scaffold(
      body: child,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          boxShadow: AppShadows.floatingShadow,
        ),
        child: SafeArea(
          child: Container(
            height: AppSpacing.bottomNavHeight,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(
                  context: context,
                  icon: Icons.home_outlined,
                  activeIcon: Icons.home,
                  label: 'Home',
                  index: 0,
                  currentIndex: currentIndex,
                  route: AppRoutes.home,
                ),
                _buildNavItem(
                  context: context,
                  icon: Icons.search_outlined,
                  activeIcon: Icons.search,
                  label: 'Search',
                  index: 1,
                  currentIndex: currentIndex,
                  route: AppRoutes.search,
                ),
                _buildScanButton(context),
                _buildNavItem(
                  context: context,
                  icon: Icons.insights_outlined,
                  activeIcon: Icons.insights,
                  label: 'Health',
                  index: 3,
                  currentIndex: currentIndex,
                  route: AppRoutes.health,
                ),
                _buildNavItem(
                  context: context,
                  icon: Icons.person_outline,
                  activeIcon: Icons.person,
                  label: 'Profile',
                  index: 4,
                  currentIndex: currentIndex,
                  route: AppRoutes.profile,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildNavItem({
    required BuildContext context,
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required int index,
    required int currentIndex,
    required String route,
  }) {
    final isActive = index == currentIndex;
    
    return Expanded(
      child: InkWell(
        onTap: () => context.go(route),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isActive ? activeIcon : icon,
                color: isActive ? AppColors.primaryGreen : AppColors.gray500,
                size: AppSpacing.iconMd,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                label,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                  color: isActive ? AppColors.primaryGreen : AppColors.gray500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildScanButton(BuildContext context) {
    return GestureDetector(
      onTap: () => context.go(AppRoutes.scan),
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryGreen.withOpacity(0.3),
              offset: const Offset(0, 4),
              blurRadius: 8,
              spreadRadius: 0,
            ),
          ],
        ),
        child: const Icon(
          Icons.qr_code_scanner,
          color: AppColors.white,
          size: 28,
        ),
      ),
    );
  }
}