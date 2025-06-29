import 'dart:convert';

import 'package:easy_debounce/easy_debounce.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:pdf_scanner/generated/assets/assets.gen.dart';
import 'package:pdf_scanner/src/common/snackbar.dart';
import 'package:pdf_scanner/src/core/helper/logger.dart';

import 'package:pdf_scanner/src/core/utils/print_pdf.dart';
import 'package:pdf_scanner/src/core/utils/share_pdf.dart';
import 'package:pdf_scanner/src/data/database/app_database.dart';
import 'package:pdf_scanner/src/features/documents/controller/pdf_list_controller.dart';
import 'package:pdf_scanner/src/features/documents/widget/app_search_bar.dart';
import 'package:pdf_scanner/src/core/theme/colors.dart';
import 'package:pdf_scanner/src/features/documents/widget/filter_bar.dart';

import '../widget/document_card.dart';
import '../widget/empty_documents.dart';
import '../widget/scanner_button.dart';
import 'document_details_screen.dart';

class DocumentsScreen extends ConsumerStatefulWidget {
  const DocumentsScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _DocumentsScreenState();
}

class _DocumentsScreenState extends ConsumerState<DocumentsScreen>
    with WidgetsBindingObserver {
  final TextEditingController searchController = TextEditingController();
  bool _isKeyboardVisible = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    final bottomInset = WidgetsBinding.instance.window.viewInsets.bottom;
    final isVisible = bottomInset > 0;
    if (isVisible != _isKeyboardVisible) {
      setState(() {
        _isKeyboardVisible = isVisible;
      });
    }
  }

  void scanDoc() async {
    final controller = ref.read(pdfListControllerProvider.notifier);
    final result = await controller.scanAndAdd();

    result.match(
      (failure) => logger.e('❌ ${failure.message}'),
      (_) => logger.i('✅ Документ успешно добавлен'),
    );
  }

  void _renamePdf(PdfFile pdfFile) {
    final pdfController = ref.read(pdfListControllerProvider.notifier);
    showRenameDialog(
      context: context,
      pdfFile: pdfFile,
      renamePdf: (value) async {
        final result = await pdfController.renamePdf(
          id: pdfFile.id,
          newName: value,
        );

        result.fold(
          (failure) => showErrorSnackBar(context, failure.message),
          (_) => logger.i('✅ Переименовано успешно'),
        );
      },
    );
  }

  void _printPdf(PdfFile pdfFile) async {
    context.loaderOverlay.show();
    final paths = List<String>.from(jsonDecode(pdfFile.pathsJson));

    final result = await PrintUtils.printFromImagePaths(
      imagePaths: paths,
      name: pdfFile.name,
    );


    result.fold(
      (failure) => logger.e('❌ ${failure.message}'),
      (_) => logger.i('🖨️ Печать успешно выполнена'),
    );

    context.loaderOverlay.hide();
  }

  void _sharePdf(PdfFile pdfFile) async {
    context.loaderOverlay.show();
    final List<String> imagePaths = List<String>.from(
      jsonDecode(pdfFile.pathsJson),
    );

    await SharePdf.shareImagesAsPdf(imagePaths: imagePaths, name: pdfFile.name);
    context.loaderOverlay.hide();
  }

  void _delete(PdfFile pdfFile) async {
    final result = await ref
        .read(pdfListControllerProvider.notifier)
        .deletePdf(pdfFile.id);

    result.fold(
      (failure) => showErrorSnackBar(context, failure.message),
      (_) => logger.i('✅ Удалено успешно'),
    );
  }

  void documentDetails(PdfFile pdfFile) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return DocumentDetailsScreen(pdfFile: pdfFile);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pdfListData = ref.watch(pdfListControllerProvider);
    final pdfController = ref.read(pdfListControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        leadingWidth: 0,
        titleSpacing: 18,
        centerTitle: false,
        title: Assets.images.logo.image(height: 33, width: 150),
        backgroundColor: AppColors.background,
        elevation: 0,
        flexibleSpace: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => FocusScope.of(context).unfocus(),
          child: Container(color: AppColors.background),
        ),

        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(72),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: AppSearchBar(
              controller: searchController,
              onChanged: (value) {
                EasyDebounce.debounce(
                  'search-debounce-key',
                  const Duration(milliseconds: 300),
                  () => pdfController.search(value),
                );
              },
            ),
          ),
        ),
      ),
      backgroundColor: AppColors.background,
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => FocusScope.of(context).unfocus(),
        child: Stack(
          children: [
            pdfListData.when(
              loading:
                  () => Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  ),
              error: (error, stackTrace) => SizedBox(),
              data: (pdfList) {
                if (pdfList.isEmpty) return const EmptyDocuments();
                return SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom: 120),
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 18,
                        ),
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Column(
                          children: [
                            FilterBar(),
                            ListView.separated(
                              shrinkWrap: true,
                              padding: EdgeInsets.zero,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: pdfList.length,
                              separatorBuilder:
                                  (_, __) => const SizedBox(height: 14),
                              itemBuilder: (context, index) {
                                final pdfItem = pdfList[index];
                                return DocumentCard(
                                  index: index,
                                  pdfFile: pdfItem,

                                  onPressed: () {
                                    documentDetails(pdfItem);
                                  },
                                  edit: () {
                                    showDocumentActions(
                                      context: context,
                                      rename: () {
                                        _renamePdf(pdfItem);
                                      },
                                      print: () {
                                        _printPdf(pdfItem);
                                      },
                                      share: () {
                                        _sharePdf(pdfItem);
                                      },
                                      delete: () {
                                        _delete(pdfItem);
                                      },
                                    );
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            if (!_isKeyboardVisible) ScannerButton(onPressed: scanDoc),
          ],
        ),
      ),
    );
  }

  void showDocumentActions({
    required BuildContext context,
    required VoidCallback rename,
    required VoidCallback print,
    required VoidCallback share,
    required VoidCallback delete,
  }) {
    showCupertinoModalPopup(
      context: context,
      builder:
          (context) => CupertinoActionSheet(
            actions: [
              CupertinoActionSheetAction(
                onPressed: () {
                  Navigator.pop(context);
                  rename();
                },
                child: Text(
                  'actions.rename'.tr(),
                  style: const TextStyle(color: AppColors.blue),
                ),
              ),
              CupertinoActionSheetAction(
                onPressed: () {
                  Navigator.pop(context);
                  print();
                },
                child: Text(
                  'actions.print'.tr(),
                  style: const TextStyle(color: AppColors.blue),
                ),
              ),
              CupertinoActionSheetAction(
                onPressed: () {
                  Navigator.pop(context);
                  share();
                },
                child: Text(
                  'actions.share'.tr(),
                  style: const TextStyle(color: AppColors.blue),
                ),
              ),
              CupertinoActionSheetAction(
                onPressed: () {
                  Navigator.pop(context);
                  delete();
                },
                isDestructiveAction: true,
                child: Text(
                  'actions.delete'.tr(),
                  style: const TextStyle(color: AppColors.warning),
                ),
              ),
            ],
            cancelButton: CupertinoActionSheetAction(
              onPressed: () => Navigator.pop(context),
              isDefaultAction: true,
              child: Text(
                'actions.cancel'.tr(),
                style: const TextStyle(color: AppColors.blue),
              ),
            ),
          ),
    );
  }

  void showRenameDialog({
    required BuildContext context,
    required PdfFile pdfFile,
    required Function(String value) renamePdf,
  }) {
    final controller = TextEditingController(text: pdfFile.name);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder:
          (context) => Consumer(
            builder: (context, ref, child) {
              return GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => FocusScope.of(context).unfocus(),
                child: Padding(
                  padding: EdgeInsets.only(
                    left: 20,
                    right: 20,
                    bottom: MediaQuery.of(context).viewInsets.bottom + 10,
                    top: 20,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          CupertinoButton(
                            padding: EdgeInsets.zero,
                            child: Assets.icons.close.svg(
                              height: 24,
                              width: 24,
                              colorFilter: const ColorFilter.mode(
                                AppColors.text,
                                BlendMode.srcIn,
                              ),
                            ),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                          Text(
                            'rename.title'.tr(),
                            style: const TextStyle(
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
                          hintText: 'rename.placeholder'.tr(),
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
                            borderSide: const BorderSide(
                              color: Colors.red,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                        child: SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton.icon(
                            icon: Text(
                              'rename.save'.tr(),
                              style: const TextStyle(fontSize: 16),
                            ),
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
                              shadowColor: Colors.red.withAlpha(
                                (0.4 * 255).round(),
                              ),
                            ),
                            onPressed: () async {
                              final newName = controller.text.trim();
                              if (newName.isEmpty) return;
                              renamePdf(newName);
                              Navigator.of(context).pop();
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
    );
  }
}
