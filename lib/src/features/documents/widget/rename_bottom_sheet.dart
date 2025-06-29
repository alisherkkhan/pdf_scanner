import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pdf_scanner/generated/assets/assets.gen.dart' show Assets;
import 'package:pdf_scanner/src/core/theme/colors.dart';

void showRenameDialog(BuildContext context) {
  final TextEditingController controller = TextEditingController(
    text: 'Document',
  );

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (context) {
      final viewInsets = MediaQuery.of(context).viewInsets.bottom;
      final isKeyboardOpen = viewInsets > 0;

      return AnimatedPadding(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.only(bottom: viewInsets),
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            20,
            isKeyboardOpen ? 12 : 24,
            20,
            isKeyboardOpen ? 12 : 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: () => Navigator.of(context).pop(),
                    child: Assets.icons.close.svg(
                      height: 24,
                      width: 24,
                      colorFilter: const ColorFilter.mode(
                        AppColors.text,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Rename',
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w600,
                      color: AppColors.text,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              TextField(
                controller: controller,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 14,
                    horizontal: 16,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: Colors.red),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: Colors.red),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: Colors.red, width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton.icon(
                  icon: const Text('Save', style: TextStyle(fontSize: 16)),
                  label: Assets.icons.check.svg(
                    height: 24,
                    width: 24,
                    colorFilter: const ColorFilter.mode(
                      AppColors.white,
                      BlendMode.srcIn,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 4,
                    shadowColor: Colors.red.withAlpha((0.4 * 255).round()),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(controller.text.trim());
                  },
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
