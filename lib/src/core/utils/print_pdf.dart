import 'dart:io';
import 'package:flutter/foundation.dart'; // для compute
import 'package:fpdart/fpdart.dart';
import 'package:pdf_scanner/src/core/helper/type_defs.dart';
import 'package:printing/printing.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf_scanner/src/core/utils/pdf_generator.dart';

class PrintUtils {
  static FutureEither<void> printFromImagePaths({
    required List<String> imagePaths,
    required String name,
  }) async {
    try {
      final pdfBytes = await compute(generatePdfBytes, imagePaths);

      final dir = await getTemporaryDirectory();
      final filePath = '${dir.path}/$name.pdf';
      final file = File(filePath);
      await file.writeAsBytes(pdfBytes);

      await Printing.layoutPdf(onLayout: (_) async => pdfBytes, name: name);

      return right(null);
    } catch (e) {
      return left(Failure(message: 'Ошибка при печати: $e'));
    }
  }
}
