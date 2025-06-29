import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pdf_scanner/src/core/theme/colors.dart';
import 'package:pdf_scanner/src/features/documents/screen/documents_screen.dart';
import 'package:pdf_scanner/src/features/onboarding/controller/onboarding_controller.dart';
import 'package:pdf_scanner/src/features/onboarding/screen/onboarding_screen.dart';

class AppScreen extends ConsumerWidget {
  const AppScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final onboardingAsync = ref.watch(onboardingControllerProvider);

    return Scaffold(
      backgroundColor: AppColors.white,
      body: onboardingAsync.when(
        data: (hasSeenOnboarding) {
          if (hasSeenOnboarding) {
            return const Scaffold(body: DocumentsScreen());
          } else {
            return const OnboardingScreen();
          }
        },
        loading: () {
          return Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        },
        error: (e, _) => Center(child: Text('Ошибка: $e')),
      ),
    );
  }
}
