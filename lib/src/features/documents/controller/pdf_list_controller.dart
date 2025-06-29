import 'dart:convert';
import 'dart:io' show File;

import 'package:drift/drift.dart' as drift;
import 'package:fpdart/fpdart.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:pdf_scanner/src/core/helper/logger.dart';
import 'package:pdf_scanner/src/core/helper/type_defs.dart';
import 'package:pdf_scanner/src/core/utils/pdf_scanner.dart';
import 'package:pdf_scanner/src/data/database/app_database.dart';
import 'package:pdf_scanner/src/data/repository/pdf_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

import 'sort_order_controller.dart';

part 'pdf_list_controller.g.dart';

@Riverpod(keepAlive: true)
class PdfListController extends _$PdfListController {
  late final PdfRepository _repo;
  List<PdfFile> _allPdfs = [];

  @override
  Future<List<PdfFile>> build() async {
    _repo = ref.watch(pdfRepositoryProvider);
    _allPdfs = _sortPdfList(await _repo.getAll());

    // ✅ Подписка на изменения sortOrderProvider
    ref.listen<SortOrder>(sortOrderProvider, (prev, next) {
      _allPdfs = _sortPdfList(_allPdfs);
      state = AsyncData(_allPdfs); // обновляем UI
      logger.i('🔁 Сортировка обновлена: $next');
    });

    return _allPdfs;
  }

  FutureEither<void> addPdf(PdfFilesCompanion entry) async {
    return await handleRepoCall(() async {
      logger.i('👉 ДОБАВЛЕНИЕ PDF В БАЗУ');
      await _repo.add(entry);
      _allPdfs = _sortPdfList(await _repo.getAll());
      logger.i('📄 Получено ${_allPdfs.length} PDF после добавления');
      state = AsyncData(_allPdfs);
    });
  }

  FutureEither<void> deletePdf(String id) async {
    return await handleRepoCall(() async {
      await _repo.delete(id);
      _allPdfs = _sortPdfList(await _repo.getAll());
      state = AsyncData(_allPdfs);
    });
  }

  FutureEither<void> renamePdf({
    required String id,
    required String newName,
  }) async {
    return await handleRepoCall(() async {
      await _repo.rename(id, newName);
      _allPdfs = _sortPdfList(await _repo.getAll());
      state = AsyncData(_allPdfs);
    });
  }

  void search(String query) {
    try {
      if (query.trim().isEmpty) {
        state = AsyncData(_allPdfs);
        return;
      }

      final filtered =
          _allPdfs
              .where(
                (pdf) => pdf.name.toLowerCase().contains(query.toLowerCase()),
              )
              .toList();

      state = AsyncData(filtered);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  FutureEither<void> scanAndAdd() async {
    final result = await ScanUtils.scanDocuments(); // возвращает временные пути

    return await result.match((failure) => left(failure), (tempPaths) async {
      return await handleRepoCall(() async {
        final appDir = await getApplicationDocumentsDirectory();
        final uuid = const Uuid();
        final now = DateTime.now();
        final fileName =
            'Document ${DateFormat('yyyy-MM-dd_HH-mm-ss').format(now)}';

        final savedPaths = <String>[];

        for (final tempPath in tempPaths) {
          final extension = p.extension(tempPath);
          final newPath = p.join(appDir.path, '${uuid.v4()}$extension');
          final file = File(tempPath);

          if (await file.exists()) {
            final copiedFile = await file.copy(newPath);
            if (await copiedFile.exists()) {
              savedPaths.add(copiedFile.path);
            }
          }
        }

        if (savedPaths.isEmpty) {
          throw Exception('❌ Не удалось сохранить ни одного изображения');
        }

        await _repo.add(
          PdfFilesCompanion(
            id: drift.Value(uuid.v4()),
            name: drift.Value(fileName),
            pathsJson: drift.Value(jsonEncode(savedPaths)),
            createdAt: drift.Value(now),
          ),
        );

        _allPdfs = _sortPdfList(await _repo.getAll());
        state = AsyncData(_allPdfs);
      });
    });
  }

  FutureEither<void> updatePaths({
    required String id,
    required List<String> updatedPaths,
  }) async {
    return await handleRepoCall(() async {
      final json = jsonEncode(updatedPaths);
      await _repo.updatePaths(id: id, pathsJson: json);
      _allPdfs = _sortPdfList(await _repo.getAll());
      state = AsyncData(_allPdfs);
    });
  }

  List<PdfFile> _sortPdfList(List<PdfFile> list) {
    final sortOrder = ref.read(sortOrderProvider);

    return [...list]..sort((a, b) {
      final aDate = a.createdAt;
      final bDate = b.createdAt;

      return sortOrder == SortOrder.newestFirst
          ? bDate.compareTo(aDate)
          : aDate.compareTo(bDate);
    });
  }
}
