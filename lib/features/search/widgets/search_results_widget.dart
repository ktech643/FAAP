import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_shadows.dart';
import '../../scanning/models/product_model.dart';
import '../models/additive_model.dart';
import '../providers/search_provider.dart';

class SearchResultsWidget extends StatelessWidget {
  final List<ProductModel> productResults;
  final List<AdditiveModel> additiveResults;
  final List<String> brandResults;
  final SearchType searchType;
  final Function(ProductModel) onProductTapped;
  final Function(AdditiveModel) onAdditiveTapped;
  final Function(String) onBrandTapped;
  
  const SearchResultsWidget({
    super.key,
    required this.productResults,
    required this.additiveResults,
    required this.brandResults,
    required this.searchType,
    required this.onProductTapped,
    required this.onAdditiveTapped,
    required this.onBrandTapped,
  });
  
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        // Products Section
        if (productResults.isNotEmpty &&
            (searchType == SearchType.all || searchType == SearchType.products)) ...[
          _buildSectionHeader('Products', productResults.length),
          const SizedBox(height: AppSpacing.md),
          ...productResults.asMap().entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.md),
              child: _buildProductCard(entry.value)
                  .animate()
                  .fadeIn(delay: Duration(milliseconds: entry.key * 100))
                  .slideX(begin: 0.1, end: 0),
            );
          }),
          const SizedBox(height: AppSpacing.xl),
        ],
        
        // Additives Section
        if (additiveResults.isNotEmpty &&
            (searchType == SearchType.all || searchType == SearchType.additives)) ...[
          _buildSectionHeader('Additives', additiveResults.length),
          const SizedBox(height: AppSpacing.md),
          ...additiveResults.asMap().entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.md),
              child: _buildAdditiveCard(entry.value)
                  .animate()
                  .fadeIn(delay: Duration(milliseconds: entry.key * 100))
                  .slideX(begin: 0.1, end: 0),
            );
          }),
          const SizedBox(height: AppSpacing.xl),
        ],
        
        // Brands Section
        if (brandResults.isNotEmpty &&
            (searchType == SearchType.all || searchType == SearchType.brands)) ...[
          _buildSectionHeader('Brands', brandResults.length),
          const SizedBox(height: AppSpacing.md),
          ...brandResults.asMap().entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: _buildBrandCard(entry.value)
                  .animate()
                  .fadeIn(delay: Duration(milliseconds: entry.key * 100))
                  .slideX(begin: 0.1, end: 0),
            );
          }),
        ],
      ],
    );
  }
  
  Widget _buildSectionHeader(String title, int count) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: AppTypography.h5.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.xs,
          ),
          decoration: BoxDecoration(
            color: AppColors.primaryGreen.withOpacity(0.1),
            borderRadius: BorderRadius.circular(AppSpacing.radiusRound),
          ),
          child: Text(
            '$count results',
            style: AppTypography.caption.copyWith(
              color: AppColors.primaryGreen,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
  
  Widget _buildProductCard(ProductModel product) {
    final riskColor = AppColors.getRiskColor(product.riskLevel);
    
    return GestureDetector(
      onTap: () => onProductTapped(product),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          boxShadow: AppShadows.cardShadow,
        ),
        child: Row(
          children: [
            // Product image placeholder
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: AppColors.gray100,
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              ),
              child: Icon(
                Icons.shopping_basket,
                color: AppColors.gray400,
              ),
            ),
            const SizedBox(width: AppSpacing.lg),
            
            // Product info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: AppTypography.body.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (product.brand != null) ...[
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      product.brand!,
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                  const SizedBox(height: AppSpacing.sm),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.sm,
                          vertical: AppSpacing.xs,
                        ),
                        decoration: BoxDecoration(
                          color: riskColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(AppSpacing.radiusRound),
                        ),
                        child: Text(
                          product.riskLevel.toUpperCase(),
                          style: AppTypography.caption.copyWith(
                            color: riskColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Text(
                        '${product.additives.length} additives',
                        style: AppTypography.caption.copyWith(
                          color: AppColors.textTertiary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Arrow
            Icon(
              Icons.arrow_forward_ios,
              size: AppSpacing.iconSm,
              color: AppColors.textTertiary,
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildAdditiveCard(AdditiveModel additive) {
    final riskColor = AppColors.getRiskColor(additive.riskLevel);
    
    return GestureDetector(
      onTap: () => onAdditiveTapped(additive),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          boxShadow: AppShadows.cardShadow,
        ),
        child: Row(
          children: [
            // Additive code
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: riskColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              ),
              child: Center(
                child: Text(
                  additive.code,
                  style: AppTypography.body.copyWith(
                    color: riskColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.lg),
            
            // Additive info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    additive.name,
                    style: AppTypography.body.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (additive.description != null) ...[
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      additive.description!,
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  const SizedBox(height: AppSpacing.sm),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical: AppSpacing.xs,
                    ),
                    decoration: BoxDecoration(
                      color: riskColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(AppSpacing.radiusRound),
                    ),
                    child: Text(
                      '${additive.riskLevel.toUpperCase()} RISK',
                      style: AppTypography.caption.copyWith(
                        color: riskColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Arrow
            Icon(
              Icons.arrow_forward_ios,
              size: AppSpacing.iconSm,
              color: AppColors.textTertiary,
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildBrandCard(String brand) {
    return GestureDetector(
      onTap: () => onBrandTapped(brand),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          boxShadow: AppShadows.cardShadow,
        ),
        child: Row(
          children: [
            Icon(
              Icons.business,
              color: AppColors.primaryGreen,
              size: AppSpacing.iconMd,
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                brand,
                style: AppTypography.body.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: AppSpacing.iconSm,
              color: AppColors.textTertiary,
            ),
          ],
        ),
      ),
    );
  }
}