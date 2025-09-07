import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/services/database_service.dart';
import '../../../shared/widgets/primary_button.dart';
import '../../search/models/additive_model.dart';
import '../models/product_model.dart';
import '../widgets/product_header.dart';
import '../widgets/risk_assessment_card.dart';
import '../widgets/additive_list_item.dart';
import '../widgets/nutritional_info_card.dart';
import '../widgets/action_buttons.dart';

class ScanResultsScreen extends StatefulWidget {
  final String barcode;
  final Map<String, dynamic>? productData;
  
  const ScanResultsScreen({
    super.key,
    required this.barcode,
    this.productData,
  });

  @override
  State<ScanResultsScreen> createState() => _ScanResultsScreenState();
}

class _ScanResultsScreenState extends State<ScanResultsScreen> {
  late ProductModel product;
  List<AdditiveModel> additiveDetails = [];
  bool isLoading = true;
  
  @override
  void initState() {
    super.initState();
    _initializeData();
  }
  
  Future<void> _initializeData() async {
    if (widget.productData != null) {
      product = ProductModel.fromJson(widget.productData!);
      await _loadAdditiveDetails();
    } else {
      // Load from barcode if no data provided
      // This would typically fetch from API
    }
  }
  
  Future<void> _loadAdditiveDetails() async {
    try {
      final db = DatabaseService.instance;
      final details = <AdditiveModel>[];
      
      for (final additiveCode in product.additives) {
        final additive = await db.getAdditive(additiveCode);
        if (additive != null) {
          details.add(additive);
        }
      }
      
      setState(() {
        additiveDetails = details;
        isLoading = false;
      });
    } catch (e) {
      print('Error loading additive details: $e');
      setState(() {
        isLoading = false;
      });
    }
  }
  
  void _shareResults() {
    final riskEmoji = product.riskLevel == 'high' ? '⚠️' :
                     product.riskLevel == 'medium' ? '⚡' : '✅';
    
    final shareText = '''
Check out what I found with FAAP Scan!

Product: ${product.name}
Brand: ${product.brand ?? 'Unknown'}
Risk Level: $riskEmoji ${product.riskLevel.toUpperCase()}
Additives: ${product.additives.join(', ')}

Download FAAP Scan to check your food safety!
''';
    
    Share.share(shareText);
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
    
    final riskColor = AppColors.getRiskColor(product.riskLevel);
    
    return Scaffold(
      backgroundColor: AppColors.backgroundSecondary,
      body: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            expandedHeight: 260,
            pinned: true,
            backgroundColor: riskColor,
            leading: IconButton(
              onPressed: () => context.pop(),
              icon: Container(
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: AppColors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.arrow_back,
                  color: AppColors.white,
                ),
              ),
            ),
            actions: [
              IconButton(
                onPressed: _shareResults,
                icon: Container(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: AppColors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.share,
                    color: AppColors.white,
                  ),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      riskColor,
                      riskColor.withOpacity(0.8),
                    ],
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: AppSpacing.xxl),
                      Icon(
                        product.riskLevel == 'high' ? Icons.warning :
                        product.riskLevel == 'medium' ? Icons.info :
                        Icons.check_circle,
                        size: 64,
                        color: AppColors.white,
                      )
                          .animate()
                          .scale(
                            duration: 600.ms,
                            curve: Curves.elasticOut,
                          ),
                      const SizedBox(height: AppSpacing.lg),
                      Text(
                        product.riskLevel == 'high' ? 'High Risk Product' :
                        product.riskLevel == 'medium' ? 'Moderate Risk' :
                        'Low Risk Product',
                        style: AppTypography.h3.copyWith(
                          color: AppColors.white,
                        ),
                      )
                          .animate()
                          .fadeIn(delay: 300.ms),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        '${product.additives.length} additives detected',
                        style: AppTypography.body.copyWith(
                          color: AppColors.white.withOpacity(0.9),
                        ),
                      )
                          .animate()
                          .fadeIn(delay: 400.ms),
                    ],
                  ),
                ),
              ),
            ),
          ),
          
          // Product Header
          SliverToBoxAdapter(
            child: Transform.translate(
              offset: const Offset(0, -20),
              child: ProductHeader(product: product),
            )
                .animate()
                .fadeIn(delay: 200.ms)
                .slideY(begin: 0.1, end: 0),
          ),
          
          // Risk Assessment
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: RiskAssessmentCard(
                riskLevel: product.riskLevel,
                additiveCount: product.additives.length,
              ),
            )
                .animate()
                .fadeIn(delay: 300.ms)
                .slideX(begin: -0.1, end: 0),
          ),
          
          const SliverToBoxAdapter(
            child: SizedBox(height: AppSpacing.xl),
          ),
          
          // Additives Section
          if (additiveDetails.isNotEmpty) ...[
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: Text(
                  'Additives Found',
                  style: AppTypography.h5.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
              )
                  .animate()
                  .fadeIn(delay: 400.ms),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(height: AppSpacing.md),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg,
                      vertical: AppSpacing.sm,
                    ),
                    child: AdditiveListItem(
                      additive: additiveDetails[index],
                      onTap: () {
                        context.push(
                          '${AppRoutes.additiveDetails}/${additiveDetails[index].code}',
                        );
                      },
                    ),
                  )
                      .animate()
                      .fadeIn(delay: Duration(milliseconds: 500 + (index * 100)))
                      .slideX(begin: 0.1, end: 0);
                },
                childCount: additiveDetails.length,
              ),
            ),
          ],
          
          const SliverToBoxAdapter(
            child: SizedBox(height: AppSpacing.xl),
          ),
          
          // Nutritional Info
          if (product.nutritionalInfo.isNotEmpty) ...[
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: Text(
                  'Nutritional Information',
                  style: AppTypography.h5.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
              )
                  .animate()
                  .fadeIn(delay: 600.ms),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(height: AppSpacing.md),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: NutritionalInfoCard(
                  nutritionalInfo: product.nutritionalInfo,
                ),
              )
                  .animate()
                  .fadeIn(delay: 700.ms)
                  .slideY(begin: 0.1, end: 0),
            ),
          ],
          
          const SliverToBoxAdapter(
            child: SizedBox(height: AppSpacing.xl),
          ),
          
          // Action Buttons
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: ActionButtons(
                product: product,
                onFindAlternatives: () {
                  // Navigate to alternatives
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Premium feature: Find healthier alternatives'),
                      action: SnackBarAction(
                        label: 'Upgrade',
                        onPressed: null,
                      ),
                    ),
                  );
                },
                onAddToAvoidList: () async {
                  // Add harmful additives to avoid list
                  final db = DatabaseService.instance;
                  for (final additive in product.additives) {
                    await db.addToAvoidList(additive, 'From product: ${product.name}');
                  }
                  
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Added additives to your avoid list'),
                      ),
                    );
                  }
                },
              ),
            )
                .animate()
                .fadeIn(delay: 800.ms),
          ),
          
          const SliverToBoxAdapter(
            child: SizedBox(height: AppSpacing.xxxl),
          ),
        ],
      ),
    );
  }
}