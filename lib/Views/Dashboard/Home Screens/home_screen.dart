import 'package:faap/Model/product.dart';
import 'package:faap/Provider/product_provider.dart';
import 'package:faap/UI Helper/Product/listproduct.dart';
import 'package:faap/UI Helper/colors.dart';
import 'package:faap/Views/Dashboard/Home Screens/see_all_products_screen.dart';
import 'package:faap/Views/Dashboard/Home%20Screens/product_details_screen.dart';
import 'package:faap/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Load products on first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(productsProvider.notifier).getProducts();
    });
  }

  // Calculate health score based on products
  int _calculateHealthScore(List<Product> products) {
    if (products.isEmpty) return 85; // Default score

    int totalScore = 0;
    for (var product in products) {
      // Assign scores based on risk level
      switch (product.riskLevel.toLowerCase()) {
        case 'safe':
          totalScore += 100;
          break;
        case 'low_risk':
          totalScore += 80;
          break;
        case 'moderate_risk':
          totalScore += 60;
          break;
        case 'high_risk':
          totalScore += 30;
          break;
        default:
          totalScore += 70;
      }
    }

    return (totalScore / products.length).round();
  }

  // Get grade color based on risk level
  Color _getRiskColor(String riskLevel) {
    switch (riskLevel.toLowerCase()) {
      case 'safe':
        return Colors.green;
      case 'low_risk':
        return Colors.lightGreen;
      case 'moderate_risk':
        return Colors.orange;
      case 'high_risk':
        return Colors.red;
      default:
        return AppColors.textSecondary;
    }
  }

  // Get grade letter based on risk level
  String _getGrade(String riskLevel) {
    switch (riskLevel.toLowerCase()) {
      case 'safe':
        return 'A+';
      case 'low_risk':
        return 'A';
      case 'moderate_risk':
        return 'C+';
      case 'high_risk':
        return 'D';
      default:
        return 'B';
    }
  }

  // Format date for display
  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Scanned today';
    } else if (difference.inDays == 1) {
      return 'Scanned yesterday';
    } else if (difference.inDays < 7) {
      return 'Scanned ${difference.inDays} days ago';
    } else {
      return 'Scanned on ${DateFormat('MMM d').format(date)}';
    }
  }

  @override
  Widget build(BuildContext context) {
    final response = ref.watch(productsProvider);
    final products = response.data ?? [];
    final recentProducts = products.take(5).toList(); // Show 5 most recent products
    final healthScore = _calculateHealthScore(products);
    return Container(
      color: AppColors.white,
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Padding(
                padding: EdgeInsets.all(16.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(Icons.menu, color: AppColors.textPrimary),
                      onPressed: () => Scaffold.of(context).openDrawer(),
                    ),
                    Text(
                      'My Health',
                      style: GoogleFonts.inter(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.notifications_none_sharp,
                        color: AppColors.textSecondary,
                      ),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
              //TODO UNCOMMENT WHEN START SCORE COUNT
              // Health Score
              // Padding(
              //   padding: EdgeInsets.symmetric(horizontal: 16.w),
              //   child: Container(
              //     width: double.infinity,
              //     padding: EdgeInsets.all(24.w),
              //     decoration: BoxDecoration(
              //       color: AppColors.primary.withOpacity(0.1),
              //       borderRadius: BorderRadius.circular(16.r),
              //     ),
              //     child: Column(
              //       children: [
              //         Text(
              //           'Your Health Score',
              //           style: GoogleFonts.notoSans(
              //             fontSize: 14.sp,
              //             color: AppColors.textSecondary,
              //           ),
              //         ),
              //         SizedBox(height: 8.h),
              //         Text(
              //           '$healthScore',
              //           style: GoogleFonts.inter(
              //             fontSize: 60.sp,
              //             fontWeight: FontWeight.bold,
              //             color: AppColors.primary,
              //           ),
              //         ),
              //         SizedBox(height: 8.h),
              //         Text(
              //           products.isEmpty
              //               ? 'Start scanning to see your score'
              //               : 'Based on ${products.length} recent ${products.length == 1 ? 'scan' : 'scans'}',
              //           style: GoogleFonts.notoSans(
              //             fontSize: 12.sp,
              //             color: AppColors.textSecondary,
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
              // Recent Scans Header
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Recent Scans',
                      style: GoogleFonts.inter(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        navigatorKey.currentState?.push(
                          MaterialPageRoute(
                            builder: (_) => const SeeAllProductsScreen(),
                          ),
                        );
                      },
                      child: Text(
                        'See all',
                        style: GoogleFonts.inter(
                          fontSize: 14.sp,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Recent Scans List
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Builder(
                  builder: (context) {
                    // Show loading indicator ONLY when products are empty AND loading
                    if (response.isLoading && recentProducts.isEmpty) {
                      return Center(
                        child: Container(
                          height: 200.h,
                          alignment: Alignment.center,
                          child: const CircularProgressIndicator(
                            color: AppColors.primary,
                          ),
                        ),
                      );
                    }

                    // Show error message
                    if (response.isError && recentProducts.isEmpty) {
                      return Center(
                        child: Padding(
                          padding: EdgeInsets.all(32.h),
                          child: Column(
                            children: [
                              Icon(
                                Icons.error_outline,
                                size: 48.sp,
                                color: AppColors.textSecondary,
                              ),
                              SizedBox(height: 16.h),
                              Text(
                                response.message ?? 'Failed to load products',
                                style: GoogleFonts.inter(
                                  fontSize: 14.sp,
                                  color: AppColors.textSecondary,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 16.h),
                              ElevatedButton(
                                onPressed: () => ref
                                    .read(productsProvider.notifier)
                                    .getProducts(),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                ),
                                child: const Text('Retry'),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    // Show empty state (not loading, no products)
                    if (recentProducts.isEmpty) {
                      return Center(
                        child: Padding(
                          padding: EdgeInsets.all(32.h),
                          child: Column(
                            children: [
                              Icon(
                                Icons.qr_code_scanner,
                                size: 64.sp,
                                color: AppColors.textSecondary,
                              ),
                              SizedBox(height: 16.h),
                              Text(
                                'No scans yet',
                                style: GoogleFonts.inter(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              SizedBox(height: 8.h),
                              Text(
                                'Tap the scan button to analyze\nyour first product',
                                style: GoogleFonts.inter(
                                  fontSize: 14.sp,
                                  color: AppColors.textSecondary,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    // Show actual products from Supabase
                    // If loading with existing products, show products while updating in background
                    return Column(
                      children: recentProducts
                          .asMap()
                          .entries
                          .map(
                            (entry) {
                              final index = entry.key;
                              final product = entry.value;
                              return Column(
                                children: [
                                  ScanItemWidget(
                                    name: product.title,
                                    date: _formatDate(product.createdAt),
                                    grade: _getGrade(product.riskLevel),
                                    gradeColor: _getRiskColor(product.riskLevel),
                                    imageUrl: product.image ?? '',
                                    onTap: () {
                                      navigatorKey.currentState?.push(
                                        MaterialPageRoute(
                                          builder: (_) => ProductDetailsScreen(
                                            product: product,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  if (index < recentProducts.length - 1)
                                    SizedBox(height: 12.h),
                                ],
                              );
                            },
                          )
                          .toList(),
                    );
                  },
                ),
              ),
              SizedBox(height: 24.h), // Add bottom padding
            ],
          ),
        ),
      ),
    );
  }
}
