// lib/src/core/utils/pdf_generator.dart
import 'dart:io';
import 'dart:typed_data';
import 'package:pdf/widgets.dart' as pw;

Future<Uint8List> generatePdfBytes(List<String> imagePaths) async {
  final pdf = pw.Document();

  for (final path in imagePaths) {
    final bytes = await File(path).readAsBytes();
    final image = pw.MemoryImage(bytes);
    pdf.addPage(pw.Page(build: (context) => pw.Center(child: pw.Image(image))));
  }

  return pdf.save();
}
