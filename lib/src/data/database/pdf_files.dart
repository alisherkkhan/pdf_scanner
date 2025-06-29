import 'package:drift/drift.dart';

class PdfFiles extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get pathsJson => text()(); // тут JSON массива путей
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
