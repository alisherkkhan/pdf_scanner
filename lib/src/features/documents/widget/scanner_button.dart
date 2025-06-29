import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pdf_scanner/generated/assets/assets.gen.dart';
import 'package:pdf_scanner/src/core/theme/colors.dart';

class ScannerButton extends StatelessWidget {
  final VoidCallback onPressed;
  const ScannerButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: SafeArea(
        child: SizedBox(
          height: 82,
          child: Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: Container(
                  height: 68,
                  width: 264,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(68),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha((0.05 * 255).round()),
                        spreadRadius: 1,
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: CupertinoButton(
                  onPressed: onPressed,
                  padding: EdgeInsets.zero,
                  pressedOpacity: 0.8,
                  child: Container(
                    height: 82,
                    width: 82,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(82),
                      border: Border.all(width: 3, color: AppColors.white),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha((0.05 * 255).round()),
                          spreadRadius: 1,
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Align(
                      child: Assets.icons.scanner.svg(height: 42, width: 42),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
