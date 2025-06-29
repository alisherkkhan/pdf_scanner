// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $PdfFilesTable extends PdfFiles with TableInfo<$PdfFilesTable, PdfFile> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PdfFilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pathsJsonMeta = const VerificationMeta(
    'pathsJson',
  );
  @override
  late final GeneratedColumn<String> pathsJson = GeneratedColumn<String>(
    'paths_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, pathsJson, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'pdf_files';
  @override
  VerificationContext validateIntegrity(
    Insertable<PdfFile> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('paths_json')) {
      context.handle(
        _pathsJsonMeta,
        pathsJson.isAcceptableOrUnknown(data['paths_json']!, _pathsJsonMeta),
      );
    } else if (isInserting) {
      context.missing(_pathsJsonMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PdfFile map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PdfFile(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}id'],
          )!,
      name:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}name'],
          )!,
      pathsJson:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}paths_json'],
          )!,
      createdAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}created_at'],
          )!,
    );
  }

  @override
  $PdfFilesTable createAlias(String alias) {
    return $PdfFilesTable(attachedDatabase, alias);
  }
}

class PdfFile extends DataClass implements Insertable<PdfFile> {
  final String id;
  final String name;
  final String pathsJson;
  final DateTime createdAt;
  const PdfFile({
    required this.id,
    required this.name,
    required this.pathsJson,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['paths_json'] = Variable<String>(pathsJson);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  PdfFilesCompanion toCompanion(bool nullToAbsent) {
    return PdfFilesCompanion(
      id: Value(id),
      name: Value(name),
      pathsJson: Value(pathsJson),
      createdAt: Value(createdAt),
    );
  }

  factory PdfFile.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PdfFile(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      pathsJson: serializer.fromJson<String>(json['pathsJson']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'pathsJson': serializer.toJson<String>(pathsJson),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  PdfFile copyWith({
    String? id,
    String? name,
    String? pathsJson,
    DateTime? createdAt,
  }) => PdfFile(
    id: id ?? this.id,
    name: name ?? this.name,
    pathsJson: pathsJson ?? this.pathsJson,
    createdAt: createdAt ?? this.createdAt,
  );
  PdfFile copyWithCompanion(PdfFilesCompanion data) {
    return PdfFile(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      pathsJson: data.pathsJson.present ? data.pathsJson.value : this.pathsJson,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PdfFile(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('pathsJson: $pathsJson, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, pathsJson, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PdfFile &&
          other.id == this.id &&
          other.name == this.name &&
          other.pathsJson == this.pathsJson &&
          other.createdAt == this.createdAt);
}

class PdfFilesCompanion extends UpdateCompanion<PdfFile> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> pathsJson;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const PdfFilesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.pathsJson = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PdfFilesCompanion.insert({
    required String id,
    required String name,
    required String pathsJson,
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       pathsJson = Value(pathsJson),
       createdAt = Value(createdAt);
  static Insertable<PdfFile> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? pathsJson,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (pathsJson != null) 'paths_json': pathsJson,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PdfFilesCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? pathsJson,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return PdfFilesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      pathsJson: pathsJson ?? this.pathsJson,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (pathsJson.present) {
      map['paths_json'] = Variable<String>(pathsJson.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PdfFilesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('pathsJson: $pathsJson, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $PdfFilesTable pdfFiles = $PdfFilesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [pdfFiles];
}

typedef $$PdfFilesTableCreateCompanionBuilder =
    PdfFilesCompanion Function({
      required String id,
      required String name,
      required String pathsJson,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$PdfFilesTableUpdateCompanionBuilder =
    PdfFilesCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> pathsJson,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$PdfFilesTableFilterComposer
    extends Composer<_$AppDatabase, $PdfFilesTable> {
  $$PdfFilesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get pathsJson => $composableBuilder(
    column: $table.pathsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PdfFilesTableOrderingComposer
    extends Composer<_$AppDatabase, $PdfFilesTable> {
  $$PdfFilesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pathsJson => $composableBuilder(
    column: $table.pathsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PdfFilesTableAnnotationComposer
    extends Composer<_$AppDatabase, $PdfFilesTable> {
  $$PdfFilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get pathsJson =>
      $composableBuilder(column: $table.pathsJson, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$PdfFilesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PdfFilesTable,
          PdfFile,
          $$PdfFilesTableFilterComposer,
          $$PdfFilesTableOrderingComposer,
          $$PdfFilesTableAnnotationComposer,
          $$PdfFilesTableCreateCompanionBuilder,
          $$PdfFilesTableUpdateCompanionBuilder,
          (PdfFile, BaseReferences<_$AppDatabase, $PdfFilesTable, PdfFile>),
          PdfFile,
          PrefetchHooks Function()
        > {
  $$PdfFilesTableTableManager(_$AppDatabase db, $PdfFilesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$PdfFilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$PdfFilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$PdfFilesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> pathsJson = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PdfFilesCompanion(
                id: id,
                name: name,
                pathsJson: pathsJson,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required String pathsJson,
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => PdfFilesCompanion.insert(
                id: id,
                name: name,
                pathsJson: pathsJson,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PdfFilesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PdfFilesTable,
      PdfFile,
      $$PdfFilesTableFilterComposer,
      $$PdfFilesTableOrderingComposer,
      $$PdfFilesTableAnnotationComposer,
      $$PdfFilesTableCreateCompanionBuilder,
      $$PdfFilesTableUpdateCompanionBuilder,
      (PdfFile, BaseReferences<_$AppDatabase, $PdfFilesTable, PdfFile>),
      PdfFile,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$PdfFilesTableTableManager get pdfFiles =>
      $$PdfFilesTableTableManager(_db, _db.pdfFiles);
}
