import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pdf_scanner/src/data/database/app_database.dart';

final pdfRepositoryProvider = Provider<PdfRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return PdfRepository(db);
});

class PdfRepository {
  final AppDatabase db;

  PdfRepository(this.db);

  Future<void> add(PdfFilesCompanion entry) => db.insertPdf(entry);
  Future<List<PdfFile>> getAll() => db.getAllPdfs();
  Future<void> delete(String id) => db.deletePdf(id);

  Future<void> rename(String id, String newName) => db.renamePdf(id, newName);

  Future<void> updatePaths({required String id, required String pathsJson}) =>
      db.updatePdfPaths(id, pathsJson);
}
