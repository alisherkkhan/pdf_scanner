import 'package:cunning_document_scanner/cunning_document_scanner.dart';
import 'package:fpdart/fpdart.dart';

import 'package:pdf_scanner/src/core/helper/type_defs.dart';

class ScanUtils {
  static FutureEither<List<String>> scanDocuments() async {
    try {
      final List<String>? images = await CunningDocumentScanner.getPictures();

      if (images == null || images.isEmpty) {
        return left(Failure(message: 'Сканирование отменено'));
      }

      return right(images); // просто возвращаем временные пути
    } catch (e) {
      return left(Failure(message: 'Ошибка при сканировании: $e'));
    }
  }
}
