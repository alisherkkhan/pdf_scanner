import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pdf_scanner/generated/assets/assets.gen.dart' show Assets;
import 'package:pdf_scanner/src/core/theme/colors.dart' show AppColors;
import 'package:pdf_scanner/src/data/database/app_database.dart';

class DocumentCard extends StatelessWidget {
  final int index;
  final PdfFile pdfFile;
  final VoidCallback onPressed;
  final VoidCallback edit;
  const DocumentCard({
    super.key,
    required this.index,
    required this.pdfFile,
    required this.onPressed,
    required this.edit,
  });

  @override
  Widget build(BuildContext context) {
    final title =
        pdfFile.name.trim().isEmpty ? 'Document ${index + 1}' : pdfFile.name;
    final List<dynamic> paths = jsonDecode(pdfFile.pathsJson);
    final String? firstImagePath =
        paths.isNotEmpty ? paths.first.toString() : null;

    final int pageCount = paths.length;

    return CupertinoButton(
      onPressed: onPressed,
      padding: EdgeInsets.zero,
      pressedOpacity: 0.6,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xffF7F7F7),
          borderRadius: BorderRadius.circular(14),
        ),
        padding: const EdgeInsets.only(top: 12, bottom: 12, left: 12, right: 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: FutureBuilder<bool>(
                    future:
                        firstImagePath != null
                            ? File(firstImagePath).exists()
                            : Future.value(false),
                    builder: (context, snapshot) {
                      final exists = snapshot.data ?? false;
                      return exists
                          ? Image.file(
                            File(firstImagePath!),
                            width: 50,
                            height: 64,
                            fit: BoxFit.cover,
                          )
                          : Container(
                            width: 50,
                            height: 64,
                            color: AppColors.white,
                            child: Icon(
                              CupertinoIcons.doc_text,
                              size: 24,
                              color: Colors.grey.shade400,
                            ),
                          );
                    },
                  ),
                ),
                const SizedBox(width: 16),
                // Обновлённая часть
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.45,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                          color: AppColors.text,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      const SizedBox(height: 4),
                      PageDateIndicator(
                        pageNumber: pageCount,
                        date: pdfFile.createdAt,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            CupertinoButton(
              onPressed: edit,
              padding: EdgeInsets.all(8),
              child: Assets.icons.menuKebabVertical.svg(
                height: 24,
                width: 24,
                colorFilter: const ColorFilter.mode(
                  AppColors.primary,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PageDateIndicator extends StatelessWidget {
  final int pageNumber;
  final DateTime date;

  const PageDateIndicator({
    super.key,
    required this.pageNumber,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          '$pageNumber',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey.withAlpha((0.4 * 255).round()),
            fontWeight: FontWeight.w400,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Container(
            width: 1.5,
            height: 14,
            color: Colors.grey.withAlpha((0.4 * 255).round()),
          ),
        ),
        Text(
          _formatDate(date),
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey.withAlpha((0.4 * 255).round()),

            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}
