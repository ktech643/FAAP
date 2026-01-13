import 'package:faap/UI Helper/custom_imageloader.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../onboarding_controller.dart';

class OnBoardingView extends StatefulWidget {
  const OnBoardingView({super.key});

  @override
  State<OnBoardingView> createState() => _OnBoardingViewState();
}

class _OnBoardingViewState extends State<OnBoardingView> {
  final OnBoardingController _controller = OnBoardingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print("REBUILR>>>>>>>>>>>>>>>>>>>>>>>");
    }
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB), // background
      body: Stack(
        children: [
          // Header
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: _controller.skip,
                    child: Text(
                      'Skip',
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF6B7280), // text-secondary
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Main content
          Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _controller.pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _controller.onPageChanged(index);
                    });
                  },
                  itemCount: _controller.pages.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Image
                          CustomImageLoader(
                            imageUrl: _controller.pages[index]['image']!,
                            height: 320.h,
                            fit: BoxFit.contain,
                          ),
                          SizedBox(height: 48.h),
                          // Title
                          Text(
                            _controller.pages[index]['title']!,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              fontSize: 28.sp,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF111827), // text-primary
                            ),
                          ),
                          SizedBox(height: 16.h),
                          // Subtitle
                          Text(
                            _controller.pages[index]['subtitle']!,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              fontSize: 16.sp,
                              color: const Color(0xFF6B7280), // text-secondary
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              // Footer
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Dots
                    Row(
                      children: List.generate(
                        _controller.pages.length,
                        (index) => Container(
                          margin: EdgeInsets.only(right: 8.w),
                          height: 10.h,
                          width: 10.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color:
                                _controller.currentPage == index
                                    ? const Color(0xFF4CE652) // primary
                                    : const Color(0xFFE5E7EB), // gray-200
                          ),
                        ),
                      ),
                    ),
                    // Button
                    ElevatedButton(
                      onPressed: _controller.nextPage,
                      style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        padding: EdgeInsets.all(16.w),
                        backgroundColor: const Color(0xFF4CE652), // primary
                        shadowColor: const Color(0xFF4CE652).withOpacity(0.3),
                        elevation: 4,
                      ),
                      child: const Icon(
                        Icons.arrow_forward,
                        color: Color(0xFF111827), // text-primary
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
