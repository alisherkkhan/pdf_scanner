import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:pdf_scanner/src/core/utils/pdf_generator.dart';

class SharePdf {
  static Future<void> shareImagesAsPdf({
    required List<String> imagePaths,
    required String name,
  }) async {
    final pdfBytes = await compute(generatePdfBytes, imagePaths);

    final tempDir = await getTemporaryDirectory();
    final sanitizedName =
        name.trim().isEmpty
            ? 'document'
            : name.replaceAll(RegExp(r'[\\/:*?"<>|]'), '_');

    final pdfPath =
        '${tempDir.path}/${sanitizedName}_${DateTime.now().millisecondsSinceEpoch}.pdf';
    final pdfFile = File(pdfPath);
    await pdfFile.writeAsBytes(pdfBytes);

    await Share.shareXFiles([XFile(pdfFile.path)], text: '📄 $sanitizedName');
  }
}
