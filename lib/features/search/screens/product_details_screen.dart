import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/services/api_service.dart';
import '../../../shared/widgets/primary_button.dart';
import '../../scanning/models/product_model.dart';
import '../../scanning/widgets/risk_assessment_card.dart';
import '../../scanning/widgets/nutritional_info_card.dart';

class ProductDetailsScreen extends StatefulWidget {
  final String productId;
  
  const ProductDetailsScreen({
    super.key,
    required this.productId,
  });

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  ProductModel? product;
  bool isLoading = true;
  
  @override
  void initState() {
    super.initState();
    _loadProductDetails();
  }
  
  Future<void> _loadProductDetails() async {
    try {
      // In a real app, this would fetch from API using productId
      // For demo, we'll use mock data
      final apiService = ApiService();
      final result = await apiService.getProductByBarcode(widget.productId);
      
      setState(() {
        product = result;
        isLoading = false;
      });
    } catch (e) {
      print('Error loading product details: $e');
      setState(() {
        isLoading = false;
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            color: AppColors.primaryGreen,
          ),
        ),
      );
    }
    
    if (product == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Product Not Found'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: AppColors.gray400,
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                'Product not found',
                style: AppTypography.h4.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              PrimaryButton(
                onPressed: () => context.pop(),
                text: 'Go Back',
              ),
            ],
          ),
        ),
      );
    }
    
    final riskColor = AppColors.getRiskColor(product!.riskLevel);
    
    return Scaffold(
      backgroundColor: AppColors.backgroundSecondary,
      body: CustomScrollView(
        slivers: [
          // Product Image Header
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: AppColors.white,
            leading: IconButton(
              onPressed: () => context.pop(),
              icon: Container(
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: AppColors.black.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.arrow_back,
                  color: AppColors.white,
                ),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: product!.imageUrl != null
                  ? CachedNetworkImage(
                      imageUrl: product!.imageUrl!,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: AppColors.gray100,
                        child: Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primaryGreen,
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: AppColors.gray100,
                        child: Icon(
                          Icons.image_not_supported,
                          size: 64,
                          color: AppColors.gray400,
                        ),
                      ),
                    )
                  : Container(
                      color: AppColors.gray100,
                      child: Icon(
                        Icons.shopping_basket,
                        size: 64,
                        color: AppColors.gray400,
                      ),
                    ),
            ),
          ),
          
          // Product Info
          SliverToBoxAdapter(
            child: Container(
              color: AppColors.white,
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Name
                  Text(
                    product!.name,
                    style: AppTypography.h3.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  )
                      .animate()
                      .fadeIn(duration: 300.ms),
                  
                  const SizedBox(height: AppSpacing.sm),
                  
                  // Brand and Category
                  Row(
                    children: [
                      if (product!.brand != null) ...[
                        Text(
                          product!.brand!,
                          style: AppTypography.body.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        if (product!.category != null) ...[
                          const SizedBox(width: AppSpacing.sm),
                          Text(
                            '•',
                            style: AppTypography.body.copyWith(
                              color: AppColors.textTertiary,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                        ],
                      ],
                      if (product!.category != null)
                        Text(
                          product!.category!,
                          style: AppTypography.body.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                    ],
                  )
                      .animate()
                      .fadeIn(delay: 200.ms),
                  
                  const SizedBox(height: AppSpacing.lg),
                  
                  // Barcode
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.sm,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.gray100,
                      borderRadius: BorderRadius.circular(AppSpacing.radiusRound),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.qr_code,
                          size: AppSpacing.iconSm,
                          color: AppColors.textTertiary,
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Text(
                          product!.barcode,
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.textTertiary,
                            fontFamily: 'RobotoMono',
                          ),
                        ),
                      ],
                    ),
                  )
                      .animate()
                      .fadeIn(delay: 300.ms),
                ],
              ),
            ),
          ),
          
          const SliverToBoxAdapter(
            child: SizedBox(height: AppSpacing.md),
          ),
          
          // Risk Assessment
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: RiskAssessmentCard(
                riskLevel: product!.riskLevel,
                additiveCount: product!.additives.length,
              ),
            )
                .animate()
                .fadeIn(delay: 400.ms)
                .slideX(begin: -0.1, end: 0),
          ),
          
          const SliverToBoxAdapter(
            child: SizedBox(height: AppSpacing.xl),
          ),
          
          // Ingredients
          if (product!.ingredients.isNotEmpty) ...[
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: _buildSection(
                  title: 'Ingredients',
                  content: Text(
                    product!.ingredients.join(', '),
                    style: AppTypography.body.copyWith(
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                  ),
                ),
              )
                  .animate()
                  .fadeIn(delay: 500.ms)
                  .slideX(begin: -0.1, end: 0),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(height: AppSpacing.xl),
            ),
          ],
          
          // Additives
          if (product!.additives.isNotEmpty) ...[
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: _buildSection(
                  title: 'Additives & Preservatives',
                  content: Wrap(
                    spacing: AppSpacing.sm,
                    runSpacing: AppSpacing.sm,
                    children: product!.additives.map((additive) {
                      return GestureDetector(
                        onTap: () {
                          context.push('${AppRoutes.additiveDetails}/$additive');
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.md,
                            vertical: AppSpacing.sm,
                          ),
                          decoration: BoxDecoration(
                            color: riskColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(AppSpacing.radiusRound),
                            border: Border.all(
                              color: riskColor.withOpacity(0.3),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                additive,
                                style: AppTypography.bodySmall.copyWith(
                                  color: riskColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(width: AppSpacing.xs),
                              Icon(
                                Icons.arrow_forward_ios,
                                size: 12,
                                color: riskColor,
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              )
                  .animate()
                  .fadeIn(delay: 600.ms)
                  .slideX(begin: -0.1, end: 0),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(height: AppSpacing.xl),
            ),
          ],
          
          // Nutritional Info
          if (product!.nutritionalInfo.isNotEmpty) ...[
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: NutritionalInfoCard(
                  nutritionalInfo: product!.nutritionalInfo,
                ),
              )
                  .animate()
                  .fadeIn(delay: 700.ms)
                  .slideY(begin: 0.1, end: 0),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(height: AppSpacing.xl),
            ),
          ],
          
          // Action Buttons
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                children: [
                  PrimaryButton(
                    onPressed: () {
                      context.push(
                        AppRoutes.scanResults,
                        extra: {
                          'barcode': product!.barcode,
                          'productData': product!.toJson(),
                        },
                      );
                    },
                    text: 'View Full Analysis',
                    icon: Icons.analytics,
                    width: double.infinity,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  PrimaryButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Premium feature: Find alternatives'),
                        ),
                      );
                    },
                    text: 'Find Alternatives',
                    icon: Icons.search,
                    isOutlined: true,
                    width: double.infinity,
                  ),
                ],
              ),
            )
                .animate()
                .fadeIn(delay: 800.ms),
          ),
          
          const SliverToBoxAdapter(
            child: SizedBox(height: AppSpacing.xl),
          ),
        ],
      ),
    );
  }
  
  Widget _buildSection({
    required String title,
    required Widget content,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        boxShadow: AppShadows.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTypography.h5.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          content,
        ],
      ),
    );
  }
}