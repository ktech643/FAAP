import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/services/notification_service.dart';
import '../../../shared/widgets/primary_button.dart';
import '../providers/onboarding_provider.dart';
import '../widgets/onboarding_page.dart';
import '../widgets/health_profile_setup.dart';
import '../widgets/onboarding_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  
  final List<OnboardingPageData> _pages = [
    OnboardingPageData(
      title: 'Welcome to FAAP Scan',
      description: 'Your personal food safety companion. Scan any product to instantly know what additives it contains.',
      image: Icons.security,
      color: AppColors.primaryGreen,
    ),
    OnboardingPageData(
      title: 'Instant Barcode Scanning',
      description: 'Simply point your camera at any barcode to get detailed information about food additives and preservatives.',
      image: Icons.qr_code_scanner,
      color: AppColors.primaryBlue,
    ),
    OnboardingPageData(
      title: 'Health Risk Assessment',
      description: 'Get color-coded risk levels for each additive and understand their potential health impacts.',
      image: Icons.health_and_safety,
      color: AppColors.primaryRed,
    ),
    OnboardingPageData(
      title: 'Track Your Health',
      description: 'Monitor your additive consumption over time and make informed decisions about your diet.',
      image: Icons.insights,
      color: AppColors.primaryYellow,
    ),
  ];
  
  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
  
  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }
  
  Future<void> _requestPermissions() async {
    // Request camera permission
    final cameraStatus = await Permission.camera.request();
    
    // Request notification permission
    await NotificationService.instance.requestPermissions();
    
    if (cameraStatus.isGranted) {
      _nextPage();
    } else {
      // Show permission denied dialog
      if (mounted) {
        _showPermissionDialog();
      }
    }
  }
  
  void _showPermissionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Permission Required'),
        content: const Text(
          'Camera permission is required to scan barcodes. Please grant permission in settings.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              openAppSettings();
            },
            child: const Text('Open Settings'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _nextPage();
            },
            child: const Text('Skip'),
          ),
        ],
      ),
    );
  }
  
  void _nextPage() {
    if (_currentPage < _pages.length + 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }
  
  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }
  
  Future<void> _completeOnboarding() async {
    final provider = context.read<OnboardingProvider>();
    
    // Save preferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasCompletedOnboarding', true);
    
    // Save user preferences from provider
    await provider.savePreferences();
    
    // Navigate to home
    if (mounted) {
      context.go(AppRoutes.home);
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            if (_currentPage < _pages.length)
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: TextButton(
                    onPressed: () {
                      _pageController.jumpToPage(_pages.length);
                    },
                    child: Text(
                      'Skip',
                      style: AppTypography.button.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ),
              )
                  .animate()
                  .fadeIn(duration: 300.ms),
            
            // Pages
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                children: [
                  // Welcome pages
                  ..._pages.map((page) => OnboardingPage(data: page)),
                  
                  // Permissions page
                  _buildPermissionsPage(),
                  
                  // Health profile setup
                  const HealthProfileSetup(),
                ],
              ),
            ),
            
            // Bottom controls
            Padding(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: Column(
                children: [
                  // Page indicators
                  OnboardingIndicator(
                    pageCount: _pages.length + 2,
                    currentPage: _currentPage,
                  ),
                  
                  const SizedBox(height: AppSpacing.xl),
                  
                  // Navigation buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Back button
                      if (_currentPage > 0)
                        TextButton(
                          onPressed: _previousPage,
                          child: Row(
                            children: [
                              const Icon(Icons.arrow_back_ios, size: 16),
                              const SizedBox(width: AppSpacing.xs),
                              Text(
                                'Back',
                                style: AppTypography.button,
                              ),
                            ],
                          ),
                        )
                      else
                        const SizedBox(width: 80),
                      
                      // Next/Complete button
                      if (_currentPage < _pages.length + 1)
                        PrimaryButton(
                          onPressed: _currentPage == _pages.length
                              ? _requestPermissions
                              : _nextPage,
                          text: _currentPage == _pages.length
                              ? 'Grant Permissions'
                              : 'Next',
                          icon: Icons.arrow_forward,
                          iconAtEnd: true,
                        )
                      else
                        PrimaryButton(
                          onPressed: _completeOnboarding,
                          text: 'Get Started',
                          icon: Icons.check,
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildPermissionsPage() {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: AppColors.primaryBlue.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.settings,
              size: 50,
              color: AppColors.primaryBlue,
            ),
          )
              .animate()
              .scale(duration: 600.ms, curve: Curves.easeOutBack),
          
          const SizedBox(height: AppSpacing.xxl),
          
          Text(
            'App Permissions',
            style: AppTypography.h2.copyWith(
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          )
              .animate()
              .fadeIn(delay: 300.ms),
          
          const SizedBox(height: AppSpacing.lg),
          
          Text(
            'To provide the best experience, we need your permission for:',
            style: AppTypography.body.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          )
              .animate()
              .fadeIn(delay: 400.ms),
          
          const SizedBox(height: AppSpacing.xxl),
          
          _buildPermissionItem(
            icon: Icons.camera_alt,
            title: 'Camera Access',
            description: 'Required to scan product barcodes',
            delay: 500.ms,
          ),
          
          const SizedBox(height: AppSpacing.lg),
          
          _buildPermissionItem(
            icon: Icons.notifications,
            title: 'Notifications',
            description: 'Get alerts about high-risk products and health updates',
            delay: 600.ms,
          ),
        ],
      ),
    );
  }
  
  Widget _buildPermissionItem({
    required IconData icon,
    required String title,
    required String description,
    required Duration delay,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.gray50,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(
          color: AppColors.borderLight,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.primaryGreen.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            ),
            child: Icon(
              icon,
              color: AppColors.primaryGreen,
            ),
          ),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.h5.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  description,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(delay: delay)
        .slideX(begin: 0.1, end: 0);
  }
}