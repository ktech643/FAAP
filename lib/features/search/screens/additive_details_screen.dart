import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/services/database_service.dart';
import '../../../core/services/analytics_service.dart';
import '../../../shared/widgets/primary_button.dart';
import '../models/additive_model.dart';

class AdditiveDetailsScreen extends StatefulWidget {
  final String additiveId;
  
  const AdditiveDetailsScreen({
    super.key,
    required this.additiveId,
  });

  @override
  State<AdditiveDetailsScreen> createState() => _AdditiveDetailsScreenState();
}

class _AdditiveDetailsScreenState extends State<AdditiveDetailsScreen> {
  AdditiveModel? additive;
  bool isLoading = true;
  bool isInAvoidList = false;
  
  @override
  void initState() {
    super.initState();
    _loadAdditiveDetails();
  }
  
  Future<void> _loadAdditiveDetails() async {
    try {
      final db = DatabaseService.instance;
      final result = await db.getAdditive(widget.additiveId);
      
      if (result != null) {
        final avoidList = await db.getAvoidList();
        
        setState(() {
          additive = result;
          isInAvoidList = avoidList.contains(widget.additiveId);
          isLoading = false;
        });
        
        // Log analytics
        await AnalyticsService.instance.logAdditiveView(
          additiveCode: result.code,
          additiveName: result.name,
        );
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading additive details: $e');
      setState(() {
        isLoading = false;
      });
    }
  }
  
  Future<void> _toggleAvoidList() async {
    if (additive == null) return;
    
    final db = DatabaseService.instance;
    
    if (isInAvoidList) {
      await db.removeFromAvoidList(additive!.code);
      await AnalyticsService.instance.logAvoidListAction(
        action: 'remove',
        additiveCode: additive!.code,
      );
    } else {
      await db.addToAvoidList(additive!.code, 'User preference');
      await AnalyticsService.instance.logAvoidListAction(
        action: 'add',
        additiveCode: additive!.code,
      );
    }
    
    setState(() {
      isInAvoidList = !isInAvoidList;
    });
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isInAvoidList
                ? 'Added to avoid list'
                : 'Removed from avoid list',
          ),
        ),
      );
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
    
    if (additive == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Additive Not Found'),
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
                'Additive not found',
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
    
    final riskColor = AppColors.getRiskColor(additive!.riskLevel);
    
    return Scaffold(
      backgroundColor: AppColors.backgroundSecondary,
      body: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            expandedHeight: 200,
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
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.xl,
                          vertical: AppSpacing.lg,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(AppSpacing.radiusRound),
                        ),
                        child: Text(
                          additive!.code,
                          style: AppTypography.h2.copyWith(
                            color: AppColors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                          .animate()
                          .scale(
                            duration: 600.ms,
                            curve: Curves.elasticOut,
                          ),
                      const SizedBox(height: AppSpacing.lg),
                      Text(
                        additive!.name,
                        style: AppTypography.h4.copyWith(
                          color: AppColors.white,
                        ),
                        textAlign: TextAlign.center,
                      )
                          .animate()
                          .fadeIn(delay: 300.ms),
                    ],
                  ),
                ),
              ),
            ),
          ),
          
          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Risk Level Card
                  _buildRiskLevelCard(riskColor)
                      .animate()
                      .fadeIn(delay: 200.ms)
                      .slideY(begin: 0.1, end: 0),
                  
                  const SizedBox(height: AppSpacing.xl),
                  
                  // Description
                  if (additive!.description != null) ...[
                    _buildSection(
                      title: 'Description',
                      content: Text(
                        additive!.description!,
                        style: AppTypography.body.copyWith(
                          color: AppColors.textSecondary,
                          height: 1.5,
                        ),
                      ),
                    )
                        .animate()
                        .fadeIn(delay: 300.ms)
                        .slideX(begin: -0.1, end: 0),
                    const SizedBox(height: AppSpacing.xl),
                  ],
                  
                  // Health Impacts
                  if (additive!.healthImpacts.isNotEmpty) ...[
                    _buildSection(
                      title: 'Health Impacts',
                      content: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: additive!.healthImpacts.map((impact) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.warning_amber_rounded,
                                  size: AppSpacing.iconSm,
                                  color: AppColors.warning,
                                ),
                                const SizedBox(width: AppSpacing.sm),
                                Expanded(
                                  child: Text(
                                    impact,
                                    style: AppTypography.body.copyWith(
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    )
                        .animate()
                        .fadeIn(delay: 400.ms)
                        .slideX(begin: -0.1, end: 0),
                    const SizedBox(height: AppSpacing.xl),
                  ],
                  
                  // Common Products
                  if (additive!.commonProducts.isNotEmpty) ...[
                    _buildSection(
                      title: 'Commonly Found In',
                      content: Wrap(
                        spacing: AppSpacing.sm,
                        runSpacing: AppSpacing.sm,
                        children: additive!.commonProducts.map((product) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.md,
                              vertical: AppSpacing.sm,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.gray100,
                              borderRadius: BorderRadius.circular(AppSpacing.radiusRound),
                            ),
                            child: Text(
                              product,
                              style: AppTypography.bodySmall.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    )
                        .animate()
                        .fadeIn(delay: 500.ms)
                        .slideX(begin: -0.1, end: 0),
                    const SizedBox(height: AppSpacing.xl),
                  ],
                  
                  // Alternatives
                  if (additive!.alternatives.isNotEmpty) ...[
                    _buildSection(
                      title: 'Natural Alternatives',
                      content: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: additive!.alternatives.map((alternative) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.eco,
                                  size: AppSpacing.iconSm,
                                  color: AppColors.success,
                                ),
                                const SizedBox(width: AppSpacing.sm),
                                Text(
                                  alternative,
                                  style: AppTypography.body.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    )
                        .animate()
                        .fadeIn(delay: 600.ms)
                        .slideX(begin: -0.1, end: 0),
                    const SizedBox(height: AppSpacing.xl),
                  ],
                  
                  // Action Button
                  PrimaryButton(
                    onPressed: _toggleAvoidList,
                    text: isInAvoidList
                        ? 'Remove from Avoid List'
                        : 'Add to Avoid List',
                    icon: isInAvoidList ? Icons.check : Icons.block,
                    backgroundColor: isInAvoidList
                        ? AppColors.gray600
                        : AppColors.error,
                    width: double.infinity,
                  )
                      .animate()
                      .fadeIn(delay: 700.ms)
                      .scale(
                        begin: const Offset(0.9, 0.9),
                        end: const Offset(1, 1),
                      ),
                  
                  const SizedBox(height: AppSpacing.xxxl),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildRiskLevelCard(Color riskColor) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: riskColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(
          color: riskColor.withOpacity(0.2),
        ),
      ),
      child: Row(
        children: [
          Icon(
            additive!.riskLevel == 'high' ? Icons.warning :
            additive!.riskLevel == 'medium' ? Icons.info :
            Icons.check_circle,
            size: AppSpacing.iconLg,
            color: riskColor,
          ),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Risk Level',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  '${additive!.riskLevel.toUpperCase()} RISK',
                  style: AppTypography.h5.copyWith(
                    color: riskColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
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