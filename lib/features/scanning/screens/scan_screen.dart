import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/router/app_routes.dart';
import '../../profile/providers/profile_provider.dart';
import '../providers/scan_provider.dart';
import '../widgets/scan_overlay.dart';
import '../widgets/scan_controls.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  
  @override
  void initState() {
    super.initState();
    _setupAnimations();
    
    // Start scanning when screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ScanProvider>().startScanning();
    });
  }
  
  void _setupAnimations() {
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
    
    _pulseAnimation = Tween(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
  }
  
  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }
  
  void _onDetect(BarcodeCapture capture) {
    final List<Barcode> barcodes = capture.barcodes;
    if (barcodes.isEmpty) return;
    
    final barcode = barcodes.first;
    if (barcode.rawValue == null) return;
    
    final scanProvider = context.read<ScanProvider>();
    final profileProvider = context.read<ProfileProvider>();
    
    if (!scanProvider.isProcessing) {
      scanProvider.processBarcode(barcode.rawValue!, profileProvider).then((_) {
        if (scanProvider.state == ScanState.success) {
          // Navigate to results
          context.push(
            AppRoutes.scanResults,
            extra: {
              'barcode': barcode.rawValue!,
              'productData': scanProvider.currentProduct?.toJson(),
            },
          );
        }
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: Consumer<ScanProvider>(
        builder: (context, scanProvider, _) {
          return Stack(
            children: [
              // Camera view
              MobileScanner(
                controller: scanProvider.scannerController,
                onDetect: _onDetect,
              ),
              
              // Scan overlay
              AnimatedBuilder(
                animation: _pulseAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _pulseAnimation.value,
                    child: ScanOverlay(
                      isScanning: scanProvider.state == ScanState.scanning,
                    ),
                  );
                },
              ),
              
              // Top bar
              SafeArea(
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Back button
                      IconButton(
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
                      
                      // Title
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.lg,
                          vertical: AppSpacing.sm,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.black.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(AppSpacing.radiusRound),
                        ),
                        child: Text(
                          'Scan Barcode',
                          style: AppTypography.body.copyWith(
                            color: AppColors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      )
                          .animate()
                          .fadeIn()
                          .slideY(begin: -0.2, end: 0),
                      
                      // Info button
                      IconButton(
                        onPressed: _showScanTips,
                        icon: Container(
                          padding: const EdgeInsets.all(AppSpacing.sm),
                          decoration: BoxDecoration(
                            color: AppColors.black.withOpacity(0.5),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.info_outline,
                            color: AppColors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              // Bottom controls
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: ScanControls(
                  onToggleTorch: () => scanProvider.toggleTorch(),
                  onSwitchCamera: () => scanProvider.switchCamera(),
                  onManualEntry: _showManualEntryDialog,
                ),
              ),
              
              // Processing overlay
              if (scanProvider.state == ScanState.processing)
                Container(
                  color: AppColors.black.withOpacity(0.8),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          color: AppColors.primaryGreen,
                          strokeWidth: 3,
                        ),
                        const SizedBox(height: AppSpacing.xl),
                        Text(
                          'Processing barcode...',
                          style: AppTypography.body.copyWith(
                            color: AppColors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              
              // Error overlay
              if (scanProvider.state == ScanState.error)
                Container(
                  color: AppColors.black.withOpacity(0.8),
                  child: Center(
                    child: Container(
                      margin: const EdgeInsets.all(AppSpacing.xl),
                      padding: const EdgeInsets.all(AppSpacing.xl),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 48,
                            color: AppColors.error,
                          ),
                          const SizedBox(height: AppSpacing.lg),
                          Text(
                            'Scan Failed',
                            style: AppTypography.h4.copyWith(
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Text(
                            scanProvider.errorMessage ?? 'An error occurred',
                            style: AppTypography.body.copyWith(
                              color: AppColors.textSecondary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: AppSpacing.xl),
                          Row(
                            children: [
                              Expanded(
                                child: TextButton(
                                  onPressed: () => scanProvider.reset(),
                                  child: const Text('Try Again'),
                                ),
                              ),
                              const SizedBox(width: AppSpacing.md),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: _showManualEntryDialog,
                                  child: const Text('Manual Entry'),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
  
  void _showScanTips() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSpacing.radiusXl),
        ),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.gray300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              Text(
                'Scanning Tips',
                style: AppTypography.h4.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              _buildTip(
                icon: Icons.center_focus_strong,
                text: 'Hold your device steady and center the barcode in the frame',
              ),
              const SizedBox(height: AppSpacing.md),
              _buildTip(
                icon: Icons.light_mode,
                text: 'Make sure there\'s adequate lighting',
              ),
              const SizedBox(height: AppSpacing.md),
              _buildTip(
                icon: Icons.cleaning_services,
                text: 'Clean the barcode if it\'s dirty or damaged',
              ),
              const SizedBox(height: AppSpacing.md),
              _buildTip(
                icon: Icons.zoom_in,
                text: 'Move closer if the barcode is small',
              ),
              const SizedBox(height: AppSpacing.xl),
            ],
          ),
        );
      },
    );
  }
  
  Widget _buildTip({required IconData icon, required String text}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: AppSpacing.iconSm,
          color: AppColors.primaryGreen,
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Text(
            text,
            style: AppTypography.body.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }
  
  void _showManualEntryDialog() {
    final TextEditingController controller = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Manual Barcode Entry'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              labelText: 'Enter barcode number',
              hintText: 'e.g., 1234567890123',
            ),
            keyboardType: TextInputType.number,
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  Navigator.pop(context);
                  final scanProvider = context.read<ScanProvider>();
                  final profileProvider = context.read<ProfileProvider>();
                  scanProvider.processBarcode(controller.text, profileProvider);
                }
              },
              child: const Text('Search'),
            ),
          ],
        );
      },
    );
  }
}