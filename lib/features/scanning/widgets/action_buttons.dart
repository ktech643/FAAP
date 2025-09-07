import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/widgets/primary_button.dart';
import '../models/product_model.dart';

class ActionButtons extends StatelessWidget {
  final ProductModel product;
  final VoidCallback onFindAlternatives;
  final VoidCallback onAddToAvoidList;
  
  const ActionButtons({
    super.key,
    required this.product,
    required this.onFindAlternatives,
    required this.onAddToAvoidList,
  });
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Primary action - Find alternatives
        if (product.riskLevel != 'low')
          PrimaryButton(
            onPressed: onFindAlternatives,
            text: 'Find Healthier Alternatives',
            icon: Icons.search,
            width: double.infinity,
            backgroundColor: AppColors.success,
          ),
        
        const SizedBox(height: AppSpacing.md),
        
        // Secondary actions
        Row(
          children: [
            if (product.additives.isNotEmpty) ...[
              Expanded(
                child: PrimaryButton(
                  onPressed: onAddToAvoidList,
                  text: 'Avoid These Additives',
                  icon: Icons.block,
                  isOutlined: true,
                  textColor: AppColors.error,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
            ],
            Expanded(
              child: PrimaryButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                text: 'Scan Another',
                icon: Icons.qr_code_scanner,
                isOutlined: true,
              ),
            ),
          ],
        ),
      ],
    );
  }
}