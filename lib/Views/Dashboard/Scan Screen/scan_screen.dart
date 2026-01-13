import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../Provider/product_provider.dart';
import '../../../UI Helper/colors.dart';

class ScanScreen extends ConsumerStatefulWidget {
  const ScanScreen({super.key});

  @override
  ConsumerState<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends ConsumerState<ScanScreen>
    with WidgetsBindingObserver {
  CameraController? _cameraController;
  CameraDescription? _backCamera;
  TextEditingController barcodeController = TextEditingController();
  bool _isTorchOn = false;
  bool _cameraInitialized = false;
  String? _cameraErrorMessage;
  File? _capturedImage; // Store the captured image
  bool _isAnalyzing = false; // Track if analyzing

  // Initialize camera and pick a back camera if available
  Future<void> _initCamera() async {
    try {
      _cameraErrorMessage = null;
      setState(() {});
      final cameras = await availableCameras();
      // Prefer a back-facing camera
      _backCamera = cameras.firstWhere(
        (c) => c.lensDirection == CameraLensDirection.back,
        orElse:
            () => cameras.isNotEmpty ? cameras.first : throw 'No cameras found',
      );

      _cameraController = CameraController(
        _backCamera!,
        ResolutionPreset.high,
        enableAudio: false,
      );

      await _cameraController!.initialize();
      if (!mounted) return;
      setState(() {
        _cameraInitialized = true;
      });
    } catch (e) {
      // Initialization failed — leave _cameraInitialized false
      // If it's a permission or camera access error, give a helpful message
      final err = e.toString();
      if (err.toLowerCase().contains('permission') ||
          err.toLowerCase().contains('access')) {
        _cameraErrorMessage =
            'Camera access denied. Please grant camera permission in device settings.';
      } else {
        _cameraErrorMessage = err;
      }
      if (mounted) {
        setState(() {});
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Camera init failed: $e')));
      }
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initCamera();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? cameraController = _cameraController;
    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }
    if (state == AppLifecycleState.inactive) {
      // Free up resources when app is inactive
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      // Reinitialize when app resumes
      _initCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    final scanLoading = ref.watch(scanLoadingProvider);

    return Scaffold(
      body: Stack(
        children: [
          // Show captured image if available, otherwise show camera preview
          if (_capturedImage != null)
            // Display the captured image
            SizedBox.expand(
              child: Image.file(
                _capturedImage!,
                fit: BoxFit.cover,
              ),
            )
          else if (_cameraInitialized &&
              _cameraController != null &&
              _cameraController!.value.isInitialized)
            // Camera view background (CameraPreview)
            SizedBox.expand(
              child: CameraPreview(_cameraController!, child: Container()),
            )
          else
            // Placeholder while camera initializes or if there's an error
            Container(
              color: Colors.black,
              child:
                  _cameraErrorMessage != null
                      ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 24.w),
                              child: Text(
                                'Camera error: $_cameraErrorMessage',
                                textAlign: TextAlign.center,
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                            SizedBox(height: 12.h),
                            ElevatedButton(
                              onPressed: () {
                                _initCamera();
                              },
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      )
                      : const SizedBox.shrink(),
            ),
          // Overlay
          Container(
            color:
                _isAnalyzing
                    ? const Color.fromRGBO(0, 0, 0, 0.7)
                    : const Color.fromRGBO(0, 0, 0, 0.3),
          ),
          // Header
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              child: Row(
                mainAxisAlignment:
                    _capturedImage != null
                        ? MainAxisAlignment.spaceBetween
                        : MainAxisAlignment.center,
                children: [
                  // Show back button when image is captured
                  if (_capturedImage != null)
                    IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.white, size: 30.sp),
                      onPressed: () {
                        setState(() {
                          _capturedImage = null;
                          _isAnalyzing = false;
                        });
                      },
                    ),
                  Text(
                    _capturedImage != null ? 'Analyzing...' : 'Scan Product',
                    style: GoogleFonts.inter(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  if (_capturedImage != null)
                    SizedBox(width: 44.w), // Balance the row
                ],
              ),
            ),
          ),
          // Main content
          if (_isAnalyzing)
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(
                    color: AppColors.primary,
                    strokeWidth: 4,
                  ),
                  SizedBox(height: 24.h),
                  Text(
                    'Analyzing product...',
                    style: GoogleFonts.inter(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'This may take a few seconds',
                    style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            )
          else if (_capturedImage == null)
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Barcode frame overlay
                  Container(
                    width: 0.8.sw,
                    height: 0.3.sh,
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.primary, width: 4.w),
                      borderRadius: BorderRadius.circular(24.r),
                    ),
                  ),
                ],
              ),
            ),
          // Footer - Only show when no image is captured
          if (_capturedImage == null)
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(bottom: 32.h),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Flashlight button
                    Container(
                      margin: EdgeInsets.only(bottom: 32.h),
                      child: IconButton(
                        icon: Icon(
                          _isTorchOn ? Icons.flashlight_on : Icons.flashlight_off,
                          color: Colors.white,
                          size: 30.sp,
                        ),
                        onPressed: () async {
                          if (_cameraController == null) return;
                          try {
                            setState(() => _isTorchOn = !_isTorchOn);
                            await _cameraController!.setFlashMode(
                              _isTorchOn ? FlashMode.torch : FlashMode.off,
                            );
                          } catch (e) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Torch error: $e')),
                              );
                            }
                          }
                        },
                        style: IconButton.styleFrom(
                          backgroundColor: const Color.fromRGBO(0, 0, 0, 0.5),
                          padding: EdgeInsets.all(16.w),
                        ),
                      ),
                    ),

                    // Photo capture button
                    Container(
                      margin: EdgeInsets.only(bottom: 32.h),
                      child: IconButton(
                        icon:
                            scanLoading
                                ? SizedBox(
                                  width: 20.w,
                                  height: 20.h,
                                  child: const CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                                : Icon(
                                  Icons.camera_alt,
                                  color: Colors.white,
                                  size: 30.sp,
                                ),
                        onPressed:
                            scanLoading
                                ? null
                                : () async {
                                  try {
                                    ref.read(scanLoadingProvider.notifier).state =
                                        true;

                                    if (_cameraController == null ||
                                        !_cameraController!.value.isInitialized) {
                                      throw 'Camera not initialized';
                                    }

                                    // Capture the image
                                    final XFile captured =
                                        await _cameraController!.takePicture();
                                    final File imageFile = File(captured.path);

                                    // Show the captured image
                                    setState(() {
                                      _capturedImage = imageFile;
                                      _isAnalyzing = true;
                                    });

                                    ref.read(scanLoadingProvider.notifier).state =
                                        false;

                                    // Analyze the image
                                    final result = await ref
                                        .read(productsProvider.notifier)
                                        .scanProductFromFile(imageFile);

                                    setState(() {
                                      _isAnalyzing = false;
                                    });

                                    if (result.isSuccess && context.mounted) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Product scanned successfully!',
                                          ),
                                          backgroundColor: Colors.green,
                                        ),
                                      );
                                      // Reset to camera view after success
                                      setState(() {
                                        _capturedImage = null;
                                      });
                                    } else if (result.isError &&
                                        context.mounted) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'Error: ${result.message}',
                                          ),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                      // Keep showing the image so user can retry or go back
                                    }
                                  } catch (e) {
                                    ref.read(scanLoadingProvider.notifier).state =
                                        false;
                                    setState(() {
                                      _isAnalyzing = false;
                                    });
                                    if (context.mounted) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'Error capturing image: $e',
                                          ),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                    }
                                  }
                                },
                        style: IconButton.styleFrom(
                          backgroundColor: const Color.fromRGBO(0, 0, 0, 0.5),
                          padding: EdgeInsets.all(16.w),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
