import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import 'pdf_files.dart';

part 'app_database.g.dart';

final databaseProvider = Provider<AppDatabase>((ref) {
  return AppDatabase();
});

@DriftDatabase(tables: [PdfFiles])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'pdf_scanner.sqlite'));
    return NativeDatabase(file);
  });
}

extension PdfFileDao on AppDatabase {
  Future<void> insertPdf(PdfFilesCompanion entry) =>
      into(pdfFiles).insert(entry);

  Future<List<PdfFile>> getAllPdfs() => select(pdfFiles).get();

  Future<void> deletePdf(String id) =>
      (delete(pdfFiles)..where((tbl) => tbl.id.equals(id))).go();

  Future<void> renamePdf(String id, String newName) => (update(pdfFiles)..where(
    (tbl) => tbl.id.equals(id),
  )).write(PdfFilesCompanion(name: Value(newName)));

  Future<void> updatePdfPaths(String id, String pathsJson) {
    return (update(pdfFiles)..where(
      (tbl) => tbl.id.equals(id),
    )).write(PdfFilesCompanion(pathsJson: Value(pathsJson)));
  }
}
