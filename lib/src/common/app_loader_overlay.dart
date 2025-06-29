import 'dart:ui';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:pdf_scanner/generated/assets/assets.gen.dart';
import 'package:pdf_scanner/src/core/theme/colors.dart';

class AppLoaderOverlay extends StatelessWidget {
  const AppLoaderOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // прозрачный blur фон
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
          child: Container(color: Colors.black.withAlpha((0.1 * 255).round())),
        ),
        // индикатор в центре
        SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Assets.images.logo.image(height: 33, width: 150),
              SizedBox(height: 16),
              Text(
                tr('common.please_wait'),
                style: const TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w500,
                  color: AppColors.text,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
