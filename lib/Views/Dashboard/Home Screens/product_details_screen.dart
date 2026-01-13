import 'package:faap/Model/product.dart';
import 'package:faap/Provider/product_provider.dart';
import 'package:faap/UI Helper/colors.dart';
import 'package:faap/UI Helper/custom_appbar.dart';
import 'package:faap/UI Helper/custom_imageloader.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class ProductDetailsScreen extends ConsumerWidget {
  final Product? product;
  const ProductDetailsScreen({super.key, this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the products provider for reactive updates
    final productsResponse = ref.watch(productsProvider);
    final products = productsResponse.data ?? [];
    
    // Find the current product from provider state (reactive)
    final currentProduct = products.firstWhere(
      (p) => p.id == product?.id,
      orElse: () => product!, // Fallback to passed product
    );

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: CustomAppBar(
          title: 'Product Details',
          actions: [
            IconButton(
              icon: Icon(Icons.share, color: AppColors.textPrimary),
              onPressed: () {},
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              // Product Image with Favorite Button
              Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: 1.sw, // Square aspect ratio
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: CustomImageProvider(
                          currentProduct.image.toString(),
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  // Favorite Button - Reactive to provider state
                  Positioned(
                    top: 16.h,
                    right: 16.w,
                    child: IconButton(
                      icon: Icon(
                        currentProduct.isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: currentProduct.isFavorite ? Colors.red : Colors.white,
                        size: 32.sp,
                      ),
                      style: IconButton.styleFrom(
                        backgroundColor: Color.fromARGB((0.3 * 255).round(), 0, 0, 0),
                        padding: EdgeInsets.all(12.w),
                      ),
                      onPressed: () async {
                        if (currentProduct.id != null) {
                          final result = await ref
                              .read(productsProvider.notifier)
                              .toggleFavorite(currentProduct);

                          if (result.isError && context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(result.message ?? 'Failed to update favorite'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        }
                      },
                    ),
                  ),
                ],
              ),
              // Details Section
              Transform.translate(
                offset: Offset(0, -64.h),
                child: Container(
                  padding: EdgeInsets.all(24.w),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24.r),
                      topRight: Radius.circular(24.r),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromARGB(26, 0, 0, 0),
                        blurRadius: 10,
                        offset: const Offset(0, -5),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Product Name
                      Text(
                        currentProduct.title,
                        style: GoogleFonts.inter(
                          fontSize: 28.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(height: 16.h),
                      // Status Box - Dynamic based on risk level
                      Container(
                        padding: EdgeInsets.all(16.w),
                        decoration: BoxDecoration(
                          color: getBackgroundColor(currentProduct.riskLevel),
                          border: Border.all(
                            color: getStatusColor(currentProduct.riskLevel),
                          ),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              getStatusIcon(currentProduct.riskLevel),
                              color: getStatusColor(currentProduct.riskLevel),
                              size: 36.sp,
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    getRiskLevelDisplay(currentProduct.riskLevel),
                                    style: GoogleFonts.inter(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.w600,
                                      color: getStatusColor(currentProduct.riskLevel),
                                    ),
                                  ),
                                  SizedBox(height: 4.h),
                                  Text(
                                    currentProduct.description,
                                    style: GoogleFonts.inter(
                                      fontSize: 14.sp,
                                      color: getStatusColor(currentProduct.riskLevel),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Icon(
                              Icons.chevron_right,
                              color: getStatusColor(currentProduct.riskLevel),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 32.h),
                      // Additive 1
                      if (currentProduct.harmfulIngredients != null && 
                          currentProduct.harmfulIngredients!.isNotEmpty) ...[
                        Text(
                          'Identified Additives (${currentProduct.harmfulIngredients!.length})',
                          style: GoogleFonts.inter(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        SizedBox(height: 16.h),
                        ...currentProduct.harmfulIngredients!.map((ingredient) {
                          return Column(
                            children: [
                              _buildAdditiveItem(
                                icon: getStatusIcon(ingredient.risk_level),
                                iconColor: getStatusColor(
                                  ingredient.risk_level,
                                ),
                                backgroundColor: getBackgroundColor(
                                  ingredient.risk_level,
                                ),
                                name: ingredient.ingredientName,
                                risk: getRiskLevelDisplay(
                                  ingredient.risk_level,
                                ),
                                riskColor: getStatusColor(
                                  ingredient.risk_level,
                                ),
                              ),
                              SizedBox(height: 12.h),
                            ],
                          );
                        }).toList(),
                        SizedBox(height: 20.h),
                        GestureDetector(
                          onTap: () async {
                            final uri = Uri.parse('https://faapscan.chassinc.org/sources_refrence.html');
                            if (!await launchUrl(uri, mode: LaunchMode.inAppWebView)) {
                              print('Could not launch the reference link');
                            }
                          },
                          child: Text(
                            'Sources & References',
                            style: TextStyle(fontSize: 14.sp, color: Colors.blue, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAdditiveItem({
    required IconData icon,
    required Color iconColor,
    required Color backgroundColor,
    required String name,
    required String risk,
    required Color riskColor,
  }) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.r)),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: backgroundColor,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 24.sp),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: GoogleFonts.inter(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  risk,
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: riskColor,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right, color: AppColors.textSecondary),
        ],
      ),
    );
  }

  Color getStatusColor(String riskLevel) {
    switch (riskLevel.toLowerCase()) {
      case 'high_risk':
        return Colors.red;
      case 'moderate_risk':
        return Colors.orange;
      case 'low_risk':
        return Colors.green;
      case 'safe':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  Color getBackgroundColor(String riskLevel) {
    final base = getStatusColor(riskLevel);
    final a = (0.1 * 255).round().clamp(0, 255);
    final r = (base.r * 255.0).round().clamp(0, 255);
    final g = (base.g * 255.0).round().clamp(0, 255);
    final b = (base.b * 255.0).round().clamp(0, 255);
    return Color.fromARGB(a, r, g, b);
  }

  IconData getStatusIcon(String riskLevel) {
    switch (riskLevel.toLowerCase()) {
      case 'high_risk':
        return Icons.warning;
      case 'moderate_risk':
        return Icons.info;
      case 'low_risk':
        return Icons.check_circle;
      case 'safe':
        return Icons.health_and_safety;
      default:
        return Icons.help;
    }
  }

  String getRiskLevelDisplay(String riskLevel) {
    switch (riskLevel.toLowerCase()) {
      case 'high_risk':
        return 'High Risk';
      case 'moderate_risk':
        return 'Medium Risk';
      case 'low_risk':
        return 'Safe to Consume';
      case 'safe':
        return 'Very Safe';
      default:
        return 'Unknown Risk Level';
    }
  }
}
