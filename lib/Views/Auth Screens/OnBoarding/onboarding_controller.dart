import 'package:faap/Services/user_preferences_service.dart';
import 'package:faap/Views/Permission%20screen/notification_screen.dart';
import 'package:faap/main.dart';
import 'package:flutter/material.dart';

import '../Signin/signinscreen.dart';

class OnBoardingController {
  final PageController pageController = PageController();
  int currentPage = 0;

  final List<Map<String, String>> pages = [
    {
      'title': 'Discover the Truth Behind Your Food',
      'subtitle':
          'Scan product to instantly identify harmful additives and make healthier choices.',
      'image':
          'https://lh3.googleusercontent.com/aida-public/AB6AXuDOry9aIpHLKHgx9ojf0wx30pGpLp0VGZG56sGnynGxJUpEp_imw3XAoMbSYAGVh8Ub1khW4dDjy7p8JMKHYGpTjiG8EqBfkeUP31y4gJy-4fyriCBLnGLlQhAHkf_dP7dzQF9qas9Y-OeFYACF_aTM_IATavoG9SiabMCIKFFOwOlqU83LxYrwjpGkHuCe9bd3RZpm-kgVUUEdVX-SqXVPRsrx32XaYKw7r0vzqoXlOwwthkfmHYQxDcSxsdmfDz1HdHqLBFLCu4mE',
    },
    {
      'title': 'Scan Easily and Quickly',
      'subtitle': 'Point your camera at any product and get instant results.',
      'image':
          'https://lh3.googleusercontent.com/aida-public/AB6AXuDOry9aIpHLKHgx9ojf0wx30pGpLp0VGZG56sGnynGxJUpEp_imw3XAoMbSYAGVh8Ub1khW4dDjy7p8JMKHYGpTjiG8EqBfkeUP31y4gJy-4fyriCBLnGLlQhAHkf_dP7dzQF9qas9Y-OeFYACF_aTM_IATavoG9SiabMCIKFFOwOlqU83LxYrwjpGkHuCe9bd3RZpm-kgVUUEdVX-SqXVPRsrx32XaYKw7r0vzqoXlOwwthkfmHYQxDcSxsdmfDz1HdHqLBFLCu4mE',
    },
    {
      'title': 'Make Informed Choices',
      'subtitle':
          'Choose healthier options based on detailed ingredient analysis.',
      'image':
          'https://lh3.googleusercontent.com/aida-public/AB6AXuDOry9aIpHLKHgx9ojf0wx30pGpLp0VGZG56sGnynGxJUpEp_imw3XAoMbSYAGVh8Ub1khW4dDjy7p8JMKHYGpTjiG8EqBfkeUP31y4gJy-4fyriCBLnGLlQhAHkf_dP7dzQF9qas9Y-OeFYACF_aTM_IATavoG9SiabMCIKFFOwOlqU83LxYrwjpGkHuCe9bd3RZpm-kgVUUEdVX-SqXVPRsrx32XaYKw7r0vzqoXlOwwthkfmHYQxDcSxsdmfDz1HdHqLBFLCu4mE',
    },
  ];

  void onPageChanged(int index) {
    currentPage = index;
  }

  void nextPage() async {
    if (currentPage < pages.length - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // Mark onboarding as completed
      await UserPreferencesService.setOnboardingCompleted(true);
      print('✅ Onboarding completed - showing notification screen');

      navigatorKey.currentState!.pushReplacement(
        MaterialPageRoute(builder: (_) => const NotificationScreen()),
      );
    }
  }

  void skip() async {
    // Mark onboarding as completed even when skipped
    await UserPreferencesService.setOnboardingCompleted(true);
    print('⏭️ Onboarding skipped - showing notification screen');

    navigatorKey.currentState!.pushReplacement(
      MaterialPageRoute(builder: (_) => const NotificationScreen()),
    );
  }

  void dispose() {
    pageController.dispose();
  }
}