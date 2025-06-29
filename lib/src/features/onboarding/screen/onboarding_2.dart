import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:pdf_scanner/generated/assets/assets.gen.dart';
import 'package:pdf_scanner/src/features/onboarding/widget/next_button.dart';
import 'package:pdf_scanner/src/core/theme/colors.dart';

class OnboardingPage2 extends StatelessWidget {
  final VoidCallback next;
  const OnboardingPage2({super.key, required this.next});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.topRight,
          child: Padding(
            padding: const EdgeInsets.only(top: 50),
            child: Assets.images.onboardingVector.image(
              width: 141,
              height: 281,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(28.0),
          child: Column(
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: Assets.images.onboardingVertical2.image(
                      width: 5,
                      height: 98,
                    ),
                  ),
                  SizedBox(
                    height: 110,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'onboarding.title2'.tr(),

                          style: const TextStyle(
                            color: AppColors.text,
                            fontSize: 36,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          'onboarding.desc2'.tr(),
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Expanded(child: Assets.images.onboardingImage2.image()),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: NextButton(onPressed: next),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
