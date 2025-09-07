import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/widgets/primary_button.dart';
import '../providers/profile_provider.dart';
import '../../onboarding/providers/onboarding_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late OnboardingProvider _onboardingProvider;
  bool _hasChanges = false;
  
  @override
  void initState() {
    super.initState();
    final profileProvider = context.read<ProfileProvider>();
    _nameController = TextEditingController(text: profileProvider.userName ?? '');
    _emailController = TextEditingController(text: profileProvider.userEmail ?? '');
    
    _onboardingProvider = OnboardingProvider();
    _onboardingProvider.loadPreferences();
    
    _nameController.addListener(_onChanged);
    _emailController.addListener(_onChanged);
  }
  
  void _onChanged() {
    setState(() {
      _hasChanges = true;
    });
  }
  
  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }
  
  Future<void> _saveChanges() async {
    final profileProvider = context.read<ProfileProvider>();
    
    if (_nameController.text.isNotEmpty) {
      await profileProvider.updateUserName(_nameController.text);
    }
    
    if (_emailController.text.isNotEmpty) {
      await profileProvider.updateUserEmail(_emailController.text);
    }
    
    await _onboardingProvider.savePreferences();
    
    setState(() {
      _hasChanges = false;
    });
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Settings saved successfully'),
        ),
      );
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundSecondary,
      appBar: AppBar(
        title: const Text('Settings'),
        actions: [
          if (_hasChanges)
            TextButton(
              onPressed: _saveChanges,
              child: Text(
                'Save',
                style: TextStyle(color: AppColors.primaryGreen),
              ),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Personal Information
            Text(
              'Personal Information',
              style: AppTypography.h5.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
              ),
              child: Column(
                children: [
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Name',
                      hintText: 'Enter your name',
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      hintText: 'Enter your email',
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: AppSpacing.xl),
            
            // Health Preferences
            Text(
              'Health Preferences',
              style: AppTypography.h5.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
              ),
              child: ChangeNotifierProvider.value(
                value: _onboardingProvider,
                child: Consumer<OnboardingProvider>(
                  builder: (context, provider, _) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Allergies
                        Text(
                          'Allergies & Intolerances',
                          style: AppTypography.body.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Wrap(
                          spacing: AppSpacing.sm,
                          runSpacing: AppSpacing.sm,
                          children: provider.availableAllergies.map((allergy) {
                            final isSelected = provider.isAllergySelected(allergy);
                            return GestureDetector(
                              onTap: () {
                                provider.toggleAllergy(allergy);
                                _onChanged();
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppSpacing.md,
                                  vertical: AppSpacing.sm,
                                ),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppColors.primaryGreen
                                      : AppColors.gray100,
                                  borderRadius: BorderRadius.circular(
                                    AppSpacing.radiusRound,
                                  ),
                                  border: Border.all(
                                    color: isSelected
                                        ? AppColors.primaryGreen
                                        : AppColors.borderLight,
                                  ),
                                ),
                                child: Text(
                                  allergy,
                                  style: AppTypography.bodySmall.copyWith(
                                    color: isSelected
                                        ? AppColors.white
                                        : AppColors.textPrimary,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        
                        const SizedBox(height: AppSpacing.xl),
                        
                        // Dietary Restrictions
                        Text(
                          'Dietary Preferences',
                          style: AppTypography.body.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Wrap(
                          spacing: AppSpacing.sm,
                          runSpacing: AppSpacing.sm,
                          children: provider.availableDietaryRestrictions.map((restriction) {
                            final isSelected = provider.isDietaryRestrictionSelected(restriction);
                            return GestureDetector(
                              onTap: () {
                                provider.toggleDietaryRestriction(restriction);
                                _onChanged();
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppSpacing.md,
                                  vertical: AppSpacing.sm,
                                ),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppColors.primaryGreen
                                      : AppColors.gray100,
                                  borderRadius: BorderRadius.circular(
                                    AppSpacing.radiusRound,
                                  ),
                                  border: Border.all(
                                    color: isSelected
                                        ? AppColors.primaryGreen
                                        : AppColors.borderLight,
                                  ),
                                ),
                                child: Text(
                                  restriction,
                                  style: AppTypography.bodySmall.copyWith(
                                    color: isSelected
                                        ? AppColors.white
                                        : AppColors.textPrimary,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
            
            const SizedBox(height: AppSpacing.xl),
            
            // App Settings
            Text(
              'App Settings',
              style: AppTypography.h5.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
              ),
              child: ChangeNotifierProvider.value(
                value: _onboardingProvider,
                child: Consumer<OnboardingProvider>(
                  builder: (context, provider, _) {
                    return Column(
                      children: [
                        SwitchListTile(
                          title: const Text('Enable Notifications'),
                          subtitle: const Text('Get alerts about high-risk products'),
                          value: provider.enableNotifications,
                          onChanged: (value) {
                            provider.setEnableNotifications(value);
                            _onChanged();
                          },
                          activeColor: AppColors.primaryGreen,
                        ),
                        const Divider(height: 1),
                        SwitchListTile(
                          title: const Text('Health Tracking'),
                          subtitle: const Text('Track your additive consumption'),
                          value: provider.enableHealthTracking,
                          onChanged: (value) {
                            provider.setEnableHealthTracking(value);
                            _onChanged();
                          },
                          activeColor: AppColors.primaryGreen,
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
            
            const SizedBox(height: AppSpacing.xxxl),
          ],
        ),
      ),
    );
  }
}