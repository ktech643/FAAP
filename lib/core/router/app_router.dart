import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../features/onboarding/screens/splash_screen.dart';
import '../../features/onboarding/screens/onboarding_screen.dart';
import '../../features/home/screens/home_screen.dart';
import '../../features/scanning/screens/scan_screen.dart';
import '../../features/scanning/screens/scan_results_screen.dart';
import '../../features/search/screens/search_screen.dart';
import '../../features/search/screens/additive_details_screen.dart';
import '../../features/search/screens/product_details_screen.dart';
import '../../features/health/screens/health_dashboard_screen.dart';
import '../../features/profile/screens/profile_screen.dart';
import '../../features/profile/screens/settings_screen.dart';
import '../../features/profile/screens/premium_screen.dart';
import '../../shared/widgets/bottom_nav_scaffold.dart';
import 'app_routes.dart';

class AppRouter {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final _shellNavigatorKey = GlobalKey<NavigatorState>();
  
  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: true,
    redirect: (context, state) async {
      final prefs = await SharedPreferences.getInstance();
      final hasCompletedOnboarding = prefs.getBool('hasCompletedOnboarding') ?? false;
      
      final isOnSplash = state.matchedLocation == AppRoutes.splash;
      final isOnOnboarding = state.matchedLocation.startsWith(AppRoutes.onboarding);
      
      if (isOnSplash) {
        return null; // Let splash screen handle navigation
      }
      
      if (!hasCompletedOnboarding && !isOnOnboarding) {
        return AppRoutes.onboarding;
      }
      
      return null;
    },
    routes: [
      // Splash Screen
      GoRoute(
        path: AppRoutes.splash,
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const SplashScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      ),
      
      // Onboarding Flow
      GoRoute(
        path: AppRoutes.onboarding,
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const OnboardingScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      ),
      
      // Main App Shell with Bottom Navigation
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) {
          return BottomNavScaffold(child: child);
        },
        routes: [
          // Home Tab
          GoRoute(
            path: AppRoutes.home,
            pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: const HomeScreen(),
            ),
          ),
          
          // Search Tab
          GoRoute(
            path: AppRoutes.search,
            pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: const SearchScreen(),
            ),
          ),
          
          // Scan Tab (Center)
          GoRoute(
            path: AppRoutes.scan,
            pageBuilder: (context, state) => CustomTransitionPage(
              key: state.pageKey,
              child: const ScanScreen(),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return FadeTransition(
                  opacity: animation,
                  child: ScaleTransition(
                    scale: animation,
                    child: child,
                  ),
                );
              },
            ),
          ),
          
          // Health Tab
          GoRoute(
            path: AppRoutes.health,
            pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: const HealthDashboardScreen(),
            ),
          ),
          
          // Profile Tab
          GoRoute(
            path: AppRoutes.profile,
            pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: const ProfileScreen(),
            ),
          ),
        ],
      ),
      
      // Full Screen Routes
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: AppRoutes.scanResults,
        pageBuilder: (context, state) {
          final args = state.extra as Map<String, dynamic>?;
          return CustomTransitionPage(
            key: state.pageKey,
            child: ScanResultsScreen(
              barcode: args?['barcode'] ?? '',
              productData: args?['productData'],
            ),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              const begin = Offset(0.0, 1.0);
              const end = Offset.zero;
              const curve = Curves.ease;
              
              var tween = Tween(begin: begin, end: end).chain(
                CurveTween(curve: curve),
              );
              
              return SlideTransition(
                position: animation.drive(tween),
                child: child,
              );
            },
          );
        },
      ),
      
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '${AppRoutes.additiveDetails}/:id',
        pageBuilder: (context, state) {
          final additiveId = state.pathParameters['id']!;
          return CustomTransitionPage(
            key: state.pageKey,
            child: AdditiveDetailsScreen(additiveId: additiveId),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return SlideTransition(
                position: animation.drive(
                  Tween(begin: const Offset(1.0, 0.0), end: Offset.zero).chain(
                    CurveTween(curve: Curves.easeInOut),
                  ),
                ),
                child: child,
              );
            },
          );
        },
      ),
      
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '${AppRoutes.productDetails}/:id',
        pageBuilder: (context, state) {
          final productId = state.pathParameters['id']!;
          return CustomTransitionPage(
            key: state.pageKey,
            child: ProductDetailsScreen(productId: productId),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return SlideTransition(
                position: animation.drive(
                  Tween(begin: const Offset(1.0, 0.0), end: Offset.zero).chain(
                    CurveTween(curve: Curves.easeInOut),
                  ),
                ),
                child: child,
              );
            },
          );
        },
      ),
      
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: AppRoutes.settings,
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const SettingsScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position: animation.drive(
                Tween(begin: const Offset(1.0, 0.0), end: Offset.zero).chain(
                  CurveTween(curve: Curves.easeInOut),
                ),
              ),
              child: child,
            );
          },
        ),
      ),
      
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: AppRoutes.premium,
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const PremiumScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(0.0, 1.0);
            const end = Offset.zero;
            const curve = Curves.ease;
            
            var tween = Tween(begin: begin, end: end).chain(
              CurveTween(curve: curve),
            );
            
            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
        ),
      ),
    ],
  );
}