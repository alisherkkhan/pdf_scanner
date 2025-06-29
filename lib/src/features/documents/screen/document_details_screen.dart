import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:cunning_document_scanner/cunning_document_scanner.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf_scanner/generated/assets/assets.gen.dart';
import 'package:pdf_scanner/src/core/theme/colors.dart';
import 'package:pdf_scanner/src/core/utils/share_pdf.dart';
import 'package:pdf_scanner/src/data/database/app_database.dart';
import 'package:pro_image_editor/pro_image_editor.dart';

import '../controller/pdf_list_controller.dart';

class DocumentDetailsScreen extends ConsumerStatefulWidget {
  final PdfFile pdfFile;
  const DocumentDetailsScreen({super.key, required this.pdfFile});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _DocumentDetailsScreenState();
}

class _DocumentDetailsScreenState extends ConsumerState<DocumentDetailsScreen> {
  late List<String> _paths;
  int _currentPage = 0;
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _paths = List<String>.from(jsonDecode(widget.pdfFile.pathsJson));
  }

  Future<void> _editPage() async {
    final index = _currentPage;
    final edited = await Navigator.push<File?>(
      context,
      MaterialPageRoute(
        builder:
            (_) => ProImageEditor.file(
              File(_paths[index]),
              callbacks: ProImageEditorCallbacks(
                onImageEditingComplete: (Uint8List bytes) async {
                  final tempDir = await getTemporaryDirectory();
                  final newPath =
                      '${tempDir.path}/edited_${DateTime.now().millisecondsSinceEpoch}.jpg';
                  final newFile = await File(newPath).writeAsBytes(bytes);
                  Navigator.pop(context, newFile);
                },
              ),
            ),
      ),
    );

    if (edited != null) {
      setState(() {
        _paths[index] = edited.path;
      });
      await _saveToDatabase();
    }
  }

  Future<void> _addPages() async {
    final newImages = await CunningDocumentScanner.getPictures();
    if (newImages != null && newImages.isNotEmpty) {
      setState(() {
        _paths.addAll(newImages);
      });
      await _saveToDatabase();
    }
  }

  Future<void> _saveToDatabase() async {
    final controller = ref.read(pdfListControllerProvider.notifier);
    await controller.updatePaths(id: widget.pdfFile.id, updatedPaths: _paths);
  }

  void _sharePdf() async {
    context.loaderOverlay.show();

    await SharePdf.shareImagesAsPdf(
      imagePaths: _paths,
      name: widget.pdfFile.name,
    );
    context.loaderOverlay.hide();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _topBar(share: _sharePdf, back: () => Navigator.of(context).pop()),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _paths.length,
                onPageChanged: (index) {
                  setState(() => _currentPage = index);
                },
                itemBuilder: (context, index) {
                  final path = _paths[index];
                  return Padding(
                    padding: const EdgeInsets.all(16),
                    child: Image.file(File(path), fit: BoxFit.contain),
                  );
                },
              ),
            ),
            _filePageList(),
            _bottomBar(edit: _editPage, add: _addPages),
          ],
        ),
      ),
    );
  }

  Widget _filePageList() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: SizedBox(
        height: 67,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: _paths.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                _pageController.jumpToPage(index);
                setState(() => _currentPage = index);
              },
              child: Container(
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  border: Border.all(
                    color:
                        index == _currentPage
                            ? AppColors.primary
                            : Colors.transparent,
                    width: 1,
                  ),
                ),
                child: Image.file(
                  File(_paths[index]),
                  width: 52,
                  height: 67,
                  fit: BoxFit.cover,
                ),
              ),
            );
          },
          separatorBuilder: (_, __) => const SizedBox(width: 12),
        ),
      ),
    );
  }

  Padding _topBar({required VoidCallback share, required VoidCallback back}) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        height: 56,
        width: double.infinity,
        padding: const EdgeInsets.only(left: 6, right: 16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: [
            CupertinoButton(
              onPressed: back,
              padding: EdgeInsets.zero,
              child: Assets.icons.arrowLeft.svg(
                height: 24,
                width: 24,
                colorFilter: const ColorFilter.mode(
                  AppColors.text,
                  BlendMode.srcIn,
                ),
              ),
            ),
            Expanded(
              child: Text(
                widget.pdfFile.name.trim().isEmpty
                    ? 'Document'
                    : widget.pdfFile.name,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                  fontSize: 18,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '| ${_currentPage + 1} of ${_paths.length}',
              style: const TextStyle(color: Colors.grey, fontSize: 17),
            ),
            const SizedBox(width: 12),
            CupertinoButton(
              onPressed: share,
              padding: EdgeInsets.zero,
              child: Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(right: 4),
                    child: Text(
                      'Share',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: AppColors.primary,
                        fontSize: 17,
                      ),
                    ),
                  ),
                  Assets.icons.share.svg(
                    height: 24,
                    width: 24,
                    colorFilter: const ColorFilter.mode(
                      AppColors.primary,
                      BlendMode.srcIn,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _bottomBar({required VoidCallback edit, required VoidCallback add}) {
    return Container(
      height: 120,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(18),
          topRight: Radius.circular(18),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CupertinoButton(
            onPressed: edit,
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                Assets.icons.edit.svg(
                  height: 30,
                  width: 30,
                  colorFilter: const ColorFilter.mode(
                    AppColors.text,
                    BlendMode.srcIn,
                  ),
                ),
                const Text(
                  'Edit',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    color: AppColors.text,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
          CupertinoButton(
            onPressed: add,
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                Assets.icons.file.svg(
                  height: 30,
                  width: 30,
                  colorFilter: const ColorFilter.mode(
                    AppColors.text,
                    BlendMode.srcIn,
                  ),
                ),
                const Text(
                  'Add',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    color: AppColors.text,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
