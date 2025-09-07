import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';

class ScanOverlay extends StatelessWidget {
  final bool isScanning;
  
  const ScanOverlay({
    super.key,
    required this.isScanning,
  });
  
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final scanAreaSize = size.width * 0.7;
    
    return Stack(
      children: [
        // Dark overlay with cutout
        ColorFiltered(
          colorFilter: ColorFilter.mode(
            AppColors.black.withOpacity(0.5),
            BlendMode.srcOut,
          ),
          child: Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                  color: Colors.transparent,
                ),
                child: Align(
                  alignment: Alignment.center,
                  child: Container(
                    height: scanAreaSize,
                    width: scanAreaSize,
                    decoration: BoxDecoration(
                      color: AppColors.black,
                      borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        
        // Scan frame
        Center(
          child: Container(
            height: scanAreaSize,
            width: scanAreaSize,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
              border: Border.all(
                color: isScanning ? AppColors.primaryGreen : AppColors.white,
                width: 2,
              ),
            ),
            child: Stack(
              children: [
                // Corner decorations
                ..._buildCorners(scanAreaSize, isScanning),
                
                // Scan line animation
                if (isScanning)
                  Positioned(
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 2,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.primaryGreen.withOpacity(0),
                            AppColors.primaryGreen,
                            AppColors.primaryGreen.withOpacity(0),
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primaryGreen.withOpacity(0.5),
                            blurRadius: 8,
                            spreadRadius: 4,
                          ),
                        ],
                      ),
                    ),
                  )
                      .animate(onPlay: (controller) => controller.repeat())
                      .slideY(
                        begin: 0,
                        end: scanAreaSize / 2 - 1,
                        duration: 2.seconds,
                        curve: Curves.easeInOut,
                      )
                      .then()
                      .slideY(
                        begin: scanAreaSize / 2 - 1,
                        end: 0,
                        duration: 2.seconds,
                        curve: Curves.easeInOut,
                      ),
              ],
            ),
          ),
        ),
        
        // Instructions
        Positioned(
          bottom: size.height * 0.15,
          left: 0,
          right: 0,
          child: Text(
            isScanning ? 'Position barcode within frame' : 'Ready to scan',
            style: TextStyle(
              color: AppColors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
              shadows: [
                Shadow(
                  color: AppColors.black.withOpacity(0.5),
                  offset: const Offset(0, 2),
                  blurRadius: 4,
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
  
  List<Widget> _buildCorners(double size, bool isScanning) {
    const cornerSize = 40.0;
    const cornerThickness = 4.0;
    final color = isScanning ? AppColors.primaryGreen : AppColors.white;
    
    return [
      // Top left
      Positioned(
        top: 0,
        left: 0,
        child: Container(
          width: cornerSize,
          height: cornerThickness,
          color: color,
        ),
      ),
      Positioned(
        top: 0,
        left: 0,
        child: Container(
          width: cornerThickness,
          height: cornerSize,
          color: color,
        ),
      ),
      
      // Top right
      Positioned(
        top: 0,
        right: 0,
        child: Container(
          width: cornerSize,
          height: cornerThickness,
          color: color,
        ),
      ),
      Positioned(
        top: 0,
        right: 0,
        child: Container(
          width: cornerThickness,
          height: cornerSize,
          color: color,
        ),
      ),
      
      // Bottom left
      Positioned(
        bottom: 0,
        left: 0,
        child: Container(
          width: cornerSize,
          height: cornerThickness,
          color: color,
        ),
      ),
      Positioned(
        bottom: 0,
        left: 0,
        child: Container(
          width: cornerThickness,
          height: cornerSize,
          color: color,
        ),
      ),
      
      // Bottom right
      Positioned(
        bottom: 0,
        right: 0,
        child: Container(
          width: cornerSize,
          height: cornerThickness,
          color: color,
        ),
      ),
      Positioned(
        bottom: 0,
        right: 0,
        child: Container(
          width: cornerThickness,
          height: cornerSize,
          color: color,
        ),
      ),
    ];
  }
}