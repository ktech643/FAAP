import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_spacing.dart';
import '../providers/onboarding_provider.dart';

class HealthProfileSetup extends StatelessWidget {
  const HealthProfileSetup({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<OnboardingProvider>(
      builder: (context, provider, _) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.xl),
              
              // Title
              Text(
                'Personalize Your Experience',
                style: AppTypography.h3.copyWith(
                  color: AppColors.textPrimary,
                ),
              )
                  .animate()
                  .fadeIn(duration: 300.ms),
              
              const SizedBox(height: AppSpacing.sm),
              
              Text(
                'Help us tailor recommendations to your needs',
                style: AppTypography.body.copyWith(
                  color: AppColors.textSecondary,
                ),
              )
                  .animate()
                  .fadeIn(delay: 100.ms),
              
              const SizedBox(height: AppSpacing.xxl),
              
              // Allergies section
              _buildSection(
                title: 'Allergies & Intolerances',
                child: Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.sm,
                  children: provider.availableAllergies.map((allergy) {
                    return _buildChip(
                      label: allergy,
                      selected: provider.isAllergySelected(allergy),
                      onTap: () => provider.toggleAllergy(allergy),
                    );
                  }).toList(),
                ),
                delay: 200.ms,
              ),
              
              const SizedBox(height: AppSpacing.xl),
              
              // Dietary restrictions section
              _buildSection(
                title: 'Dietary Preferences',
                child: Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.sm,
                  children: provider.availableDietaryRestrictions.map((restriction) {
                    return _buildChip(
                      label: restriction,
                      selected: provider.isDietaryRestrictionSelected(restriction),
                      onTap: () => provider.toggleDietaryRestriction(restriction),
                    );
                  }).toList(),
                ),
                delay: 300.ms,
              ),
              
              const SizedBox(height: AppSpacing.xl),
              
              // Health goals section
              _buildSection(
                title: 'Health Goal',
                subtitle: 'Select your primary health goal',
                child: Column(
                  children: provider.availableHealthGoals.map((goal) {
                    return _buildRadioTile(
                      title: goal,
                      value: goal,
                      groupValue: provider.healthGoal,
                      onChanged: (value) => provider.setHealthGoal(value),
                    );
                  }).toList(),
                ),
                delay: 400.ms,
              ),
              
              const SizedBox(height: AppSpacing.xl),
              
              // Settings section
              _buildSection(
                title: 'App Settings',
                child: Column(
                  children: [
                    _buildSwitchTile(
                      title: 'Enable Notifications',
                      subtitle: 'Get alerts about high-risk products',
                      value: provider.enableNotifications,
                      onChanged: provider.setEnableNotifications,
                      icon: Icons.notifications_outlined,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _buildSwitchTile(
                      title: 'Health Tracking',
                      subtitle: 'Track your additive consumption over time',
                      value: provider.enableHealthTracking,
                      onChanged: provider.setEnableHealthTracking,
                      icon: Icons.insights_outlined,
                    ),
                  ],
                ),
                delay: 500.ms,
              ),
              
              const SizedBox(height: AppSpacing.xxl),
            ],
          ),
        );
      },
    );
  }
  
  Widget _buildSection({
    required String title,
    String? subtitle,
    required Widget child,
    required Duration delay,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTypography.h5.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: AppSpacing.xs),
          Text(
            subtitle,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
        const SizedBox(height: AppSpacing.md),
        child,
      ],
    )
        .animate()
        .fadeIn(delay: delay)
        .slideY(begin: 0.1, end: 0);
  }
  
  Widget _buildChip({
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: selected ? AppColors.primaryGreen : AppColors.gray100,
          borderRadius: BorderRadius.circular(AppSpacing.radiusRound),
          border: Border.all(
            color: selected ? AppColors.primaryGreen : AppColors.borderLight,
          ),
        ),
        child: Text(
          label,
          style: AppTypography.bodySmall.copyWith(
            color: selected ? AppColors.white : AppColors.textPrimary,
            fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }
  
  Widget _buildRadioTile({
    required String title,
    required String value,
    required String? groupValue,
    required ValueChanged<String?> onChanged,
  }) {
    final isSelected = value == groupValue;
    
    return GestureDetector(
      onTap: () => onChanged(value),
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.sm),
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryGreen.withOpacity(0.05) : AppColors.gray50,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          border: Border.all(
            color: isSelected ? AppColors.primaryGreen : AppColors.borderLight,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Radio<String>(
              value: value,
              groupValue: groupValue,
              onChanged: onChanged,
              activeColor: AppColors.primaryGreen,
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                title,
                style: AppTypography.body.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    required IconData icon,
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
              color: value
                  ? AppColors.primaryGreen.withOpacity(0.1)
                  : AppColors.gray200,
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            ),
            child: Icon(
              icon,
              color: value ? AppColors.primaryGreen : AppColors.gray600,
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
                  subtitle,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.primaryGreen,
          ),
        ],
      ),
    );
  }
}