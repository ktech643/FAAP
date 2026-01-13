import 'package:faap/Services/permission_service.dart';
import 'package:faap/Services/user_preferences_service.dart';
import 'package:faap/Views/Dashboard/dashboard_screen.dart';
import 'package:faap/Views/Permission%20screen/notification_screen.dart';
import 'package:faap/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../UI Helper/colors.dart';
import '../OnBoarding/onboarding.dart';
import '../Provider/auth_provider.dart';
import '../Signin/signinscreen.dart';

class SplashScreenView extends ConsumerStatefulWidget {
  const SplashScreenView({super.key});

  @override
  ConsumerState<SplashScreenView> createState() => _SplashScreenViewState();
}

class _SplashScreenViewState extends ConsumerState<SplashScreenView>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  late AnimationController _progressController;
  late Animation<double> _progressAnimation;
  late SplashScreenController _controller;

  @override
  void initState() {
    super.initState();
    _controller = SplashScreenController();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
    _fadeController.forward();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _progressAnimation = Tween<double>(begin: 0.4, end: 0.6).animate(
      CurvedAnimation(parent: _progressController, curve: Curves.easeInOut),
    );

    // Check auth status and navigate accordingly
    Future.microtask(() async {
      final authNotifier = ref.read(authProvider.notifier);
      final isSignedIn = await authNotifier.checkAndSaveUserSignedIn();
      
      // Wait a minimum of 2 seconds for splash animation
      await Future.delayed(const Duration(seconds: 2));

      if (!mounted) return;

      if (isSignedIn) {
        // User is logged in
        final hasCompletedOnboarding = await UserPreferencesService.hasCompletedOnboarding();
        
        if (!hasCompletedOnboarding) {
          // First time login - show onboarding
          print('✅ User signed in but first time - showing onboarding');
          navigatorKey.currentState!.pushReplacement(
            MaterialPageRoute(builder: (_) => const OnBoardingView()),
          );
        } else {
          // Returning user - check notification permission
          final hasNotificationPermission = await PermissionService.isNotificationPermissionGranted();
          
          if (!hasNotificationPermission) {
            // Show notification permission screen
            print('✅ User signed in, returning user, but no notification permission - showing permission screen');
            navigatorKey.currentState!.pushReplacement(
              MaterialPageRoute(builder: (_) => const NotificationScreen()),
            );
          } else {
            // Go directly to dashboard
            print('✅ User signed in, returning user, has permissions - going to dashboard');
            navigatorKey.currentState!.pushReplacement(
              MaterialPageRoute(builder: (_) => const DashboardScreen()),
            );
          }
        }
      } else {
        // User not signed in - go to sign in screen
        print('❌ User not signed in - showing sign in screen');
        navigatorKey.currentState!.pushReplacement(
          MaterialPageRoute(builder: (_) => const SignInScreenView()),
        );
      }
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _pulseController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: AnimatedBuilder(
          animation: _fadeAnimation,
          builder: (context, child) {
            return Opacity(
              opacity: _fadeAnimation.value,
              child: Transform.translate(
                offset: Offset(0, 20 * (1 - _fadeAnimation.value)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ScaleTransition(
                      scale: _pulseAnimation,
                      child: SvgPicture.asset('assets/Icons/logo-white.svg'),
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      'FAAP',
                      style: GoogleFonts.inter(
                        fontSize: 48.sp, // approx text-5xl
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: -1, // tracking-tighter
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Container(
                      width: 64.w, // w-16
                      height: 6.h, // h-1.5
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(3.r),
                      ),
                      child: AnimatedBuilder(
                        animation: _progressAnimation,
                        builder: (context, child) {
                          return FractionallySizedBox(
                            alignment: Alignment.centerLeft,
                            widthFactor: _progressAnimation.value,
                            child: Container(
                              height: 6.h,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(3.r),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class SplashScreenController {
  void startSplashTimer(Function onComplete) {
    Future.delayed(const Duration(seconds: 4), () => onComplete());
  }
}
