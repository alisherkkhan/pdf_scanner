import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pdf_scanner/src/features/documents/screen/documents_screen.dart';
import 'package:pdf_scanner/src/features/onboarding/controller/onboarding_controller.dart';

import 'onboarding_1.dart';
import 'onboarding_2.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();
  int currentPage = 0;

  void nextPage() {
    _pageController.animateToPage(
      1,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    // showSystemReviewDialog();
  }

  void showSystemReviewDialog() async {
    // final inAppReview = InAppReview.instance;

    // if (await inAppReview.isAvailable()) {
    //   inAppReview.requestReview();
    // } else {
    //   inAppReview.openStoreListing(appStoreId: '');
    // }
  }

  void complete() async {
    final result =
        await ref
            .read(onboardingControllerProvider.notifier)
            .completeOnboarding();

    result.fold((l) {}, (r) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const DocumentsScreen()),
      );
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              onPageChanged: (index) => setState(() => currentPage = index),
              children: [
                OnboardingPage1(next: nextPage),
                OnboardingPage2(next: complete),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
