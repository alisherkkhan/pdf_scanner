import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:pdf_scanner/generated/assets/assets.gen.dart';
import 'package:pdf_scanner/src/core/theme/colors.dart';

import '../controller/sort_order_controller.dart';

class FilterBar extends ConsumerWidget {
  const FilterBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sortOrder = ref.watch(sortOrderProvider);

    void toggleSortOrder() {
      ref.read(sortOrderProvider.notifier).state =
          sortOrder == SortOrder.newestFirst
              ? SortOrder.oldestFirst
              : SortOrder.newestFirst;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'documents.title'.tr(),
            style: const TextStyle(
              color: AppColors.text,
              fontSize: 21,
              fontWeight: FontWeight.w500,
            ),
          ),
          CupertinoButton(
            onPressed: toggleSortOrder,
            padding: EdgeInsets.zero,
            pressedOpacity: 0.6,
            child: Container(
              height: 34,
              width: 34,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(34),
              ),
              child: Align(
                child: Assets.icons.swap.svg(
                  height: 20,
                  width: 20,
                  colorFilter: const ColorFilter.mode(
                    AppColors.white,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
