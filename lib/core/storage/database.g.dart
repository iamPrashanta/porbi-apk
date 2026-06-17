// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $BooksTable extends Books with TableInfo<$BooksTable, BooksData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BooksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _authorMeta = const VerificationMeta('author');
  @override
  late final GeneratedColumn<String> author = GeneratedColumn<String>(
      'author', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _filePathMeta =
      const VerificationMeta('filePath');
  @override
  late final GeneratedColumn<String> filePath = GeneratedColumn<String>(
      'file_path', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _fileTypeMeta =
      const VerificationMeta('fileType');
  @override
  late final GeneratedColumn<String> fileType = GeneratedColumn<String>(
      'file_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _fileSizeMeta =
      const VerificationMeta('fileSize');
  @override
  late final GeneratedColumn<int> fileSize = GeneratedColumn<int>(
      'file_size', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _coverPathMeta =
      const VerificationMeta('coverPath');
  @override
  late final GeneratedColumn<String> coverPath = GeneratedColumn<String>(
      'cover_path', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _lastOpenedMeta =
      const VerificationMeta('lastOpened');
  @override
  late final GeneratedColumn<DateTime> lastOpened = GeneratedColumn<DateTime>(
      'last_opened', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _addedAtMeta =
      const VerificationMeta('addedAt');
  @override
  late final GeneratedColumn<DateTime> addedAt = GeneratedColumn<DateTime>(
      'added_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _isFavoriteMeta =
      const VerificationMeta('isFavorite');
  @override
  late final GeneratedColumn<bool> isFavorite = GeneratedColumn<bool>(
      'is_favorite', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_favorite" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _totalPagesMeta =
      const VerificationMeta('totalPages');
  @override
  late final GeneratedColumn<int> totalPages = GeneratedColumn<int>(
      'total_pages', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _currentPageMeta =
      const VerificationMeta('currentPage');
  @override
  late final GeneratedColumn<int> currentPage = GeneratedColumn<int>(
      'current_page', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _readingProgressMeta =
      const VerificationMeta('readingProgress');
  @override
  late final GeneratedColumn<double> readingProgress = GeneratedColumn<double>(
      'reading_progress', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _fileHashMeta =
      const VerificationMeta('fileHash');
  @override
  late final GeneratedColumn<String> fileHash = GeneratedColumn<String>(
      'file_hash', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        title,
        author,
        filePath,
        fileType,
        fileSize,
        coverPath,
        lastOpened,
        addedAt,
        isFavorite,
        totalPages,
        currentPage,
        readingProgress,
        fileHash
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'books';
  @override
  VerificationContext validateIntegrity(Insertable<BooksData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('author')) {
      context.handle(_authorMeta,
          author.isAcceptableOrUnknown(data['author']!, _authorMeta));
    }
    if (data.containsKey('file_path')) {
      context.handle(_filePathMeta,
          filePath.isAcceptableOrUnknown(data['file_path']!, _filePathMeta));
    } else if (isInserting) {
      context.missing(_filePathMeta);
    }
    if (data.containsKey('file_type')) {
      context.handle(_fileTypeMeta,
          fileType.isAcceptableOrUnknown(data['file_type']!, _fileTypeMeta));
    } else if (isInserting) {
      context.missing(_fileTypeMeta);
    }
    if (data.containsKey('file_size')) {
      context.handle(_fileSizeMeta,
          fileSize.isAcceptableOrUnknown(data['file_size']!, _fileSizeMeta));
    }
    if (data.containsKey('cover_path')) {
      context.handle(_coverPathMeta,
          coverPath.isAcceptableOrUnknown(data['cover_path']!, _coverPathMeta));
    }
    if (data.containsKey('last_opened')) {
      context.handle(
          _lastOpenedMeta,
          lastOpened.isAcceptableOrUnknown(
              data['last_opened']!, _lastOpenedMeta));
    }
    if (data.containsKey('added_at')) {
      context.handle(_addedAtMeta,
          addedAt.isAcceptableOrUnknown(data['added_at']!, _addedAtMeta));
    } else if (isInserting) {
      context.missing(_addedAtMeta);
    }
    if (data.containsKey('is_favorite')) {
      context.handle(
          _isFavoriteMeta,
          isFavorite.isAcceptableOrUnknown(
              data['is_favorite']!, _isFavoriteMeta));
    }
    if (data.containsKey('total_pages')) {
      context.handle(
          _totalPagesMeta,
          totalPages.isAcceptableOrUnknown(
              data['total_pages']!, _totalPagesMeta));
    }
    if (data.containsKey('current_page')) {
      context.handle(
          _currentPageMeta,
          currentPage.isAcceptableOrUnknown(
              data['current_page']!, _currentPageMeta));
    }
    if (data.containsKey('reading_progress')) {
      context.handle(
          _readingProgressMeta,
          readingProgress.isAcceptableOrUnknown(
              data['reading_progress']!, _readingProgressMeta));
    }
    if (data.containsKey('file_hash')) {
      context.handle(_fileHashMeta,
          fileHash.isAcceptableOrUnknown(data['file_hash']!, _fileHashMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BooksData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BooksData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      author: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}author']),
      filePath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}file_path'])!,
      fileType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}file_type'])!,
      fileSize: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}file_size'])!,
      coverPath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}cover_path']),
      lastOpened: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}last_opened']),
      addedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}added_at'])!,
      isFavorite: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_favorite'])!,
      totalPages: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}total_pages'])!,
      currentPage: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}current_page'])!,
      readingProgress: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}reading_progress'])!,
      fileHash: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}file_hash']),
    );
  }

  @override
  $BooksTable createAlias(String alias) {
    return $BooksTable(attachedDatabase, alias);
  }
}

class BooksData extends DataClass implements Insertable<BooksData> {
  final String id;
  final String title;
  final String? author;
  final String filePath;
  final String fileType;
  final int fileSize;
  final String? coverPath;
  final DateTime? lastOpened;
  final DateTime addedAt;
  final bool isFavorite;
  final int totalPages;
  final int currentPage;
  final double readingProgress;
  final String? fileHash;
  const BooksData(
      {required this.id,
      required this.title,
      this.author,
      required this.filePath,
      required this.fileType,
      required this.fileSize,
      this.coverPath,
      this.lastOpened,
      required this.addedAt,
      required this.isFavorite,
      required this.totalPages,
      required this.currentPage,
      required this.readingProgress,
      this.fileHash});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || author != null) {
      map['author'] = Variable<String>(author);
    }
    map['file_path'] = Variable<String>(filePath);
    map['file_type'] = Variable<String>(fileType);
    map['file_size'] = Variable<int>(fileSize);
    if (!nullToAbsent || coverPath != null) {
      map['cover_path'] = Variable<String>(coverPath);
    }
    if (!nullToAbsent || lastOpened != null) {
      map['last_opened'] = Variable<DateTime>(lastOpened);
    }
    map['added_at'] = Variable<DateTime>(addedAt);
    map['is_favorite'] = Variable<bool>(isFavorite);
    map['total_pages'] = Variable<int>(totalPages);
    map['current_page'] = Variable<int>(currentPage);
    map['reading_progress'] = Variable<double>(readingProgress);
    if (!nullToAbsent || fileHash != null) {
      map['file_hash'] = Variable<String>(fileHash);
    }
    return map;
  }

  BooksCompanion toCompanion(bool nullToAbsent) {
    return BooksCompanion(
      id: Value(id),
      title: Value(title),
      author:
          author == null && nullToAbsent ? const Value.absent() : Value(author),
      filePath: Value(filePath),
      fileType: Value(fileType),
      fileSize: Value(fileSize),
      coverPath: coverPath == null && nullToAbsent
          ? const Value.absent()
          : Value(coverPath),
      lastOpened: lastOpened == null && nullToAbsent
          ? const Value.absent()
          : Value(lastOpened),
      addedAt: Value(addedAt),
      isFavorite: Value(isFavorite),
      totalPages: Value(totalPages),
      currentPage: Value(currentPage),
      readingProgress: Value(readingProgress),
      fileHash: fileHash == null && nullToAbsent
          ? const Value.absent()
          : Value(fileHash),
    );
  }

  factory BooksData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BooksData(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      author: serializer.fromJson<String?>(json['author']),
      filePath: serializer.fromJson<String>(json['filePath']),
      fileType: serializer.fromJson<String>(json['fileType']),
      fileSize: serializer.fromJson<int>(json['fileSize']),
      coverPath: serializer.fromJson<String?>(json['coverPath']),
      lastOpened: serializer.fromJson<DateTime?>(json['lastOpened']),
      addedAt: serializer.fromJson<DateTime>(json['addedAt']),
      isFavorite: serializer.fromJson<bool>(json['isFavorite']),
      totalPages: serializer.fromJson<int>(json['totalPages']),
      currentPage: serializer.fromJson<int>(json['currentPage']),
      readingProgress: serializer.fromJson<double>(json['readingProgress']),
      fileHash: serializer.fromJson<String?>(json['fileHash']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'author': serializer.toJson<String?>(author),
      'filePath': serializer.toJson<String>(filePath),
      'fileType': serializer.toJson<String>(fileType),
      'fileSize': serializer.toJson<int>(fileSize),
      'coverPath': serializer.toJson<String?>(coverPath),
      'lastOpened': serializer.toJson<DateTime?>(lastOpened),
      'addedAt': serializer.toJson<DateTime>(addedAt),
      'isFavorite': serializer.toJson<bool>(isFavorite),
      'totalPages': serializer.toJson<int>(totalPages),
      'currentPage': serializer.toJson<int>(currentPage),
      'readingProgress': serializer.toJson<double>(readingProgress),
      'fileHash': serializer.toJson<String?>(fileHash),
    };
  }

  BooksData copyWith(
          {String? id,
          String? title,
          Value<String?> author = const Value.absent(),
          String? filePath,
          String? fileType,
          int? fileSize,
          Value<String?> coverPath = const Value.absent(),
          Value<DateTime?> lastOpened = const Value.absent(),
          DateTime? addedAt,
          bool? isFavorite,
          int? totalPages,
          int? currentPage,
          double? readingProgress,
          Value<String?> fileHash = const Value.absent()}) =>
      BooksData(
        id: id ?? this.id,
        title: title ?? this.title,
        author: author.present ? author.value : this.author,
        filePath: filePath ?? this.filePath,
        fileType: fileType ?? this.fileType,
        fileSize: fileSize ?? this.fileSize,
        coverPath: coverPath.present ? coverPath.value : this.coverPath,
        lastOpened: lastOpened.present ? lastOpened.value : this.lastOpened,
        addedAt: addedAt ?? this.addedAt,
        isFavorite: isFavorite ?? this.isFavorite,
        totalPages: totalPages ?? this.totalPages,
        currentPage: currentPage ?? this.currentPage,
        readingProgress: readingProgress ?? this.readingProgress,
        fileHash: fileHash.present ? fileHash.value : this.fileHash,
      );
  BooksData copyWithCompanion(BooksCompanion data) {
    return BooksData(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      author: data.author.present ? data.author.value : this.author,
      filePath: data.filePath.present ? data.filePath.value : this.filePath,
      fileType: data.fileType.present ? data.fileType.value : this.fileType,
      fileSize: data.fileSize.present ? data.fileSize.value : this.fileSize,
      coverPath: data.coverPath.present ? data.coverPath.value : this.coverPath,
      lastOpened:
          data.lastOpened.present ? data.lastOpened.value : this.lastOpened,
      addedAt: data.addedAt.present ? data.addedAt.value : this.addedAt,
      isFavorite:
          data.isFavorite.present ? data.isFavorite.value : this.isFavorite,
      totalPages:
          data.totalPages.present ? data.totalPages.value : this.totalPages,
      currentPage:
          data.currentPage.present ? data.currentPage.value : this.currentPage,
      readingProgress: data.readingProgress.present
          ? data.readingProgress.value
          : this.readingProgress,
      fileHash: data.fileHash.present ? data.fileHash.value : this.fileHash,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BooksData(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('author: $author, ')
          ..write('filePath: $filePath, ')
          ..write('fileType: $fileType, ')
          ..write('fileSize: $fileSize, ')
          ..write('coverPath: $coverPath, ')
          ..write('lastOpened: $lastOpened, ')
          ..write('addedAt: $addedAt, ')
          ..write('isFavorite: $isFavorite, ')
          ..write('totalPages: $totalPages, ')
          ..write('currentPage: $currentPage, ')
          ..write('readingProgress: $readingProgress, ')
          ..write('fileHash: $fileHash')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      title,
      author,
      filePath,
      fileType,
      fileSize,
      coverPath,
      lastOpened,
      addedAt,
      isFavorite,
      totalPages,
      currentPage,
      readingProgress,
      fileHash);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BooksData &&
          other.id == this.id &&
          other.title == this.title &&
          other.author == this.author &&
          other.filePath == this.filePath &&
          other.fileType == this.fileType &&
          other.fileSize == this.fileSize &&
          other.coverPath == this.coverPath &&
          other.lastOpened == this.lastOpened &&
          other.addedAt == this.addedAt &&
          other.isFavorite == this.isFavorite &&
          other.totalPages == this.totalPages &&
          other.currentPage == this.currentPage &&
          other.readingProgress == this.readingProgress &&
          other.fileHash == this.fileHash);
}

class BooksCompanion extends UpdateCompanion<BooksData> {
  final Value<String> id;
  final Value<String> title;
  final Value<String?> author;
  final Value<String> filePath;
  final Value<String> fileType;
  final Value<int> fileSize;
  final Value<String?> coverPath;
  final Value<DateTime?> lastOpened;
  final Value<DateTime> addedAt;
  final Value<bool> isFavorite;
  final Value<int> totalPages;
  final Value<int> currentPage;
  final Value<double> readingProgress;
  final Value<String?> fileHash;
  final Value<int> rowid;
  const BooksCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.author = const Value.absent(),
    this.filePath = const Value.absent(),
    this.fileType = const Value.absent(),
    this.fileSize = const Value.absent(),
    this.coverPath = const Value.absent(),
    this.lastOpened = const Value.absent(),
    this.addedAt = const Value.absent(),
    this.isFavorite = const Value.absent(),
    this.totalPages = const Value.absent(),
    this.currentPage = const Value.absent(),
    this.readingProgress = const Value.absent(),
    this.fileHash = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BooksCompanion.insert({
    required String id,
    required String title,
    this.author = const Value.absent(),
    required String filePath,
    required String fileType,
    this.fileSize = const Value.absent(),
    this.coverPath = const Value.absent(),
    this.lastOpened = const Value.absent(),
    required DateTime addedAt,
    this.isFavorite = const Value.absent(),
    this.totalPages = const Value.absent(),
    this.currentPage = const Value.absent(),
    this.readingProgress = const Value.absent(),
    this.fileHash = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        title = Value(title),
        filePath = Value(filePath),
        fileType = Value(fileType),
        addedAt = Value(addedAt);
  static Insertable<BooksData> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? author,
    Expression<String>? filePath,
    Expression<String>? fileType,
    Expression<int>? fileSize,
    Expression<String>? coverPath,
    Expression<DateTime>? lastOpened,
    Expression<DateTime>? addedAt,
    Expression<bool>? isFavorite,
    Expression<int>? totalPages,
    Expression<int>? currentPage,
    Expression<double>? readingProgress,
    Expression<String>? fileHash,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (author != null) 'author': author,
      if (filePath != null) 'file_path': filePath,
      if (fileType != null) 'file_type': fileType,
      if (fileSize != null) 'file_size': fileSize,
      if (coverPath != null) 'cover_path': coverPath,
      if (lastOpened != null) 'last_opened': lastOpened,
      if (addedAt != null) 'added_at': addedAt,
      if (isFavorite != null) 'is_favorite': isFavorite,
      if (totalPages != null) 'total_pages': totalPages,
      if (currentPage != null) 'current_page': currentPage,
      if (readingProgress != null) 'reading_progress': readingProgress,
      if (fileHash != null) 'file_hash': fileHash,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BooksCompanion copyWith(
      {Value<String>? id,
      Value<String>? title,
      Value<String?>? author,
      Value<String>? filePath,
      Value<String>? fileType,
      Value<int>? fileSize,
      Value<String?>? coverPath,
      Value<DateTime?>? lastOpened,
      Value<DateTime>? addedAt,
      Value<bool>? isFavorite,
      Value<int>? totalPages,
      Value<int>? currentPage,
      Value<double>? readingProgress,
      Value<String?>? fileHash,
      Value<int>? rowid}) {
    return BooksCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      author: author ?? this.author,
      filePath: filePath ?? this.filePath,
      fileType: fileType ?? this.fileType,
      fileSize: fileSize ?? this.fileSize,
      coverPath: coverPath ?? this.coverPath,
      lastOpened: lastOpened ?? this.lastOpened,
      addedAt: addedAt ?? this.addedAt,
      isFavorite: isFavorite ?? this.isFavorite,
      totalPages: totalPages ?? this.totalPages,
      currentPage: currentPage ?? this.currentPage,
      readingProgress: readingProgress ?? this.readingProgress,
      fileHash: fileHash ?? this.fileHash,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (author.present) {
      map['author'] = Variable<String>(author.value);
    }
    if (filePath.present) {
      map['file_path'] = Variable<String>(filePath.value);
    }
    if (fileType.present) {
      map['file_type'] = Variable<String>(fileType.value);
    }
    if (fileSize.present) {
      map['file_size'] = Variable<int>(fileSize.value);
    }
    if (coverPath.present) {
      map['cover_path'] = Variable<String>(coverPath.value);
    }
    if (lastOpened.present) {
      map['last_opened'] = Variable<DateTime>(lastOpened.value);
    }
    if (addedAt.present) {
      map['added_at'] = Variable<DateTime>(addedAt.value);
    }
    if (isFavorite.present) {
      map['is_favorite'] = Variable<bool>(isFavorite.value);
    }
    if (totalPages.present) {
      map['total_pages'] = Variable<int>(totalPages.value);
    }
    if (currentPage.present) {
      map['current_page'] = Variable<int>(currentPage.value);
    }
    if (readingProgress.present) {
      map['reading_progress'] = Variable<double>(readingProgress.value);
    }
    if (fileHash.present) {
      map['file_hash'] = Variable<String>(fileHash.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BooksCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('author: $author, ')
          ..write('filePath: $filePath, ')
          ..write('fileType: $fileType, ')
          ..write('fileSize: $fileSize, ')
          ..write('coverPath: $coverPath, ')
          ..write('lastOpened: $lastOpened, ')
          ..write('addedAt: $addedAt, ')
          ..write('isFavorite: $isFavorite, ')
          ..write('totalPages: $totalPages, ')
          ..write('currentPage: $currentPage, ')
          ..write('readingProgress: $readingProgress, ')
          ..write('fileHash: $fileHash, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BookmarksTable extends Bookmarks
    with TableInfo<$BookmarksTable, BookmarksData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BookmarksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _bookIdMeta = const VerificationMeta('bookId');
  @override
  late final GeneratedColumn<String> bookId = GeneratedColumn<String>(
      'book_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES books (id)'));
  static const VerificationMeta _positionMeta =
      const VerificationMeta('position');
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
      'position', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _chapterIndexMeta =
      const VerificationMeta('chapterIndex');
  @override
  late final GeneratedColumn<int> chapterIndex = GeneratedColumn<int>(
      'chapter_index', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _excerptMeta =
      const VerificationMeta('excerpt');
  @override
  late final GeneratedColumn<String> excerpt = GeneratedColumn<String>(
      'excerpt', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _previewTextMeta =
      const VerificationMeta('previewText');
  @override
  late final GeneratedColumn<String> previewText = GeneratedColumn<String>(
      'preview_text', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _scrollOffsetMeta =
      const VerificationMeta('scrollOffset');
  @override
  late final GeneratedColumn<int> scrollOffset = GeneratedColumn<int>(
      'scroll_offset', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        bookId,
        position,
        chapterIndex,
        title,
        excerpt,
        previewText,
        scrollOffset,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'bookmarks';
  @override
  VerificationContext validateIntegrity(Insertable<BookmarksData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('book_id')) {
      context.handle(_bookIdMeta,
          bookId.isAcceptableOrUnknown(data['book_id']!, _bookIdMeta));
    } else if (isInserting) {
      context.missing(_bookIdMeta);
    }
    if (data.containsKey('position')) {
      context.handle(_positionMeta,
          position.isAcceptableOrUnknown(data['position']!, _positionMeta));
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    if (data.containsKey('chapter_index')) {
      context.handle(
          _chapterIndexMeta,
          chapterIndex.isAcceptableOrUnknown(
              data['chapter_index']!, _chapterIndexMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('excerpt')) {
      context.handle(_excerptMeta,
          excerpt.isAcceptableOrUnknown(data['excerpt']!, _excerptMeta));
    }
    if (data.containsKey('preview_text')) {
      context.handle(
          _previewTextMeta,
          previewText.isAcceptableOrUnknown(
              data['preview_text']!, _previewTextMeta));
    }
    if (data.containsKey('scroll_offset')) {
      context.handle(
          _scrollOffsetMeta,
          scrollOffset.isAcceptableOrUnknown(
              data['scroll_offset']!, _scrollOffsetMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BookmarksData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BookmarksData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      bookId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}book_id'])!,
      position: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}position'])!,
      chapterIndex: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}chapter_index']),
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      excerpt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}excerpt']),
      previewText: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}preview_text']),
      scrollOffset: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}scroll_offset']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $BookmarksTable createAlias(String alias) {
    return $BookmarksTable(attachedDatabase, alias);
  }
}

class BookmarksData extends DataClass implements Insertable<BookmarksData> {
  final String id;
  final String bookId;
  final int position;
  final int? chapterIndex;
  final String title;
  final String? excerpt;
  final String? previewText;
  final int? scrollOffset;
  final DateTime createdAt;
  const BookmarksData(
      {required this.id,
      required this.bookId,
      required this.position,
      this.chapterIndex,
      required this.title,
      this.excerpt,
      this.previewText,
      this.scrollOffset,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['book_id'] = Variable<String>(bookId);
    map['position'] = Variable<int>(position);
    if (!nullToAbsent || chapterIndex != null) {
      map['chapter_index'] = Variable<int>(chapterIndex);
    }
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || excerpt != null) {
      map['excerpt'] = Variable<String>(excerpt);
    }
    if (!nullToAbsent || previewText != null) {
      map['preview_text'] = Variable<String>(previewText);
    }
    if (!nullToAbsent || scrollOffset != null) {
      map['scroll_offset'] = Variable<int>(scrollOffset);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  BookmarksCompanion toCompanion(bool nullToAbsent) {
    return BookmarksCompanion(
      id: Value(id),
      bookId: Value(bookId),
      position: Value(position),
      chapterIndex: chapterIndex == null && nullToAbsent
          ? const Value.absent()
          : Value(chapterIndex),
      title: Value(title),
      excerpt: excerpt == null && nullToAbsent
          ? const Value.absent()
          : Value(excerpt),
      previewText: previewText == null && nullToAbsent
          ? const Value.absent()
          : Value(previewText),
      scrollOffset: scrollOffset == null && nullToAbsent
          ? const Value.absent()
          : Value(scrollOffset),
      createdAt: Value(createdAt),
    );
  }

  factory BookmarksData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BookmarksData(
      id: serializer.fromJson<String>(json['id']),
      bookId: serializer.fromJson<String>(json['bookId']),
      position: serializer.fromJson<int>(json['position']),
      chapterIndex: serializer.fromJson<int?>(json['chapterIndex']),
      title: serializer.fromJson<String>(json['title']),
      excerpt: serializer.fromJson<String?>(json['excerpt']),
      previewText: serializer.fromJson<String?>(json['previewText']),
      scrollOffset: serializer.fromJson<int?>(json['scrollOffset']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'bookId': serializer.toJson<String>(bookId),
      'position': serializer.toJson<int>(position),
      'chapterIndex': serializer.toJson<int?>(chapterIndex),
      'title': serializer.toJson<String>(title),
      'excerpt': serializer.toJson<String?>(excerpt),
      'previewText': serializer.toJson<String?>(previewText),
      'scrollOffset': serializer.toJson<int?>(scrollOffset),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  BookmarksData copyWith(
          {String? id,
          String? bookId,
          int? position,
          Value<int?> chapterIndex = const Value.absent(),
          String? title,
          Value<String?> excerpt = const Value.absent(),
          Value<String?> previewText = const Value.absent(),
          Value<int?> scrollOffset = const Value.absent(),
          DateTime? createdAt}) =>
      BookmarksData(
        id: id ?? this.id,
        bookId: bookId ?? this.bookId,
        position: position ?? this.position,
        chapterIndex:
            chapterIndex.present ? chapterIndex.value : this.chapterIndex,
        title: title ?? this.title,
        excerpt: excerpt.present ? excerpt.value : this.excerpt,
        previewText: previewText.present ? previewText.value : this.previewText,
        scrollOffset:
            scrollOffset.present ? scrollOffset.value : this.scrollOffset,
        createdAt: createdAt ?? this.createdAt,
      );
  BookmarksData copyWithCompanion(BookmarksCompanion data) {
    return BookmarksData(
      id: data.id.present ? data.id.value : this.id,
      bookId: data.bookId.present ? data.bookId.value : this.bookId,
      position: data.position.present ? data.position.value : this.position,
      chapterIndex: data.chapterIndex.present
          ? data.chapterIndex.value
          : this.chapterIndex,
      title: data.title.present ? data.title.value : this.title,
      excerpt: data.excerpt.present ? data.excerpt.value : this.excerpt,
      previewText:
          data.previewText.present ? data.previewText.value : this.previewText,
      scrollOffset: data.scrollOffset.present
          ? data.scrollOffset.value
          : this.scrollOffset,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BookmarksData(')
          ..write('id: $id, ')
          ..write('bookId: $bookId, ')
          ..write('position: $position, ')
          ..write('chapterIndex: $chapterIndex, ')
          ..write('title: $title, ')
          ..write('excerpt: $excerpt, ')
          ..write('previewText: $previewText, ')
          ..write('scrollOffset: $scrollOffset, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, bookId, position, chapterIndex, title,
      excerpt, previewText, scrollOffset, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BookmarksData &&
          other.id == this.id &&
          other.bookId == this.bookId &&
          other.position == this.position &&
          other.chapterIndex == this.chapterIndex &&
          other.title == this.title &&
          other.excerpt == this.excerpt &&
          other.previewText == this.previewText &&
          other.scrollOffset == this.scrollOffset &&
          other.createdAt == this.createdAt);
}

class BookmarksCompanion extends UpdateCompanion<BookmarksData> {
  final Value<String> id;
  final Value<String> bookId;
  final Value<int> position;
  final Value<int?> chapterIndex;
  final Value<String> title;
  final Value<String?> excerpt;
  final Value<String?> previewText;
  final Value<int?> scrollOffset;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const BookmarksCompanion({
    this.id = const Value.absent(),
    this.bookId = const Value.absent(),
    this.position = const Value.absent(),
    this.chapterIndex = const Value.absent(),
    this.title = const Value.absent(),
    this.excerpt = const Value.absent(),
    this.previewText = const Value.absent(),
    this.scrollOffset = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BookmarksCompanion.insert({
    required String id,
    required String bookId,
    required int position,
    this.chapterIndex = const Value.absent(),
    required String title,
    this.excerpt = const Value.absent(),
    this.previewText = const Value.absent(),
    this.scrollOffset = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        bookId = Value(bookId),
        position = Value(position),
        title = Value(title),
        createdAt = Value(createdAt);
  static Insertable<BookmarksData> custom({
    Expression<String>? id,
    Expression<String>? bookId,
    Expression<int>? position,
    Expression<int>? chapterIndex,
    Expression<String>? title,
    Expression<String>? excerpt,
    Expression<String>? previewText,
    Expression<int>? scrollOffset,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (bookId != null) 'book_id': bookId,
      if (position != null) 'position': position,
      if (chapterIndex != null) 'chapter_index': chapterIndex,
      if (title != null) 'title': title,
      if (excerpt != null) 'excerpt': excerpt,
      if (previewText != null) 'preview_text': previewText,
      if (scrollOffset != null) 'scroll_offset': scrollOffset,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BookmarksCompanion copyWith(
      {Value<String>? id,
      Value<String>? bookId,
      Value<int>? position,
      Value<int?>? chapterIndex,
      Value<String>? title,
      Value<String?>? excerpt,
      Value<String?>? previewText,
      Value<int?>? scrollOffset,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return BookmarksCompanion(
      id: id ?? this.id,
      bookId: bookId ?? this.bookId,
      position: position ?? this.position,
      chapterIndex: chapterIndex ?? this.chapterIndex,
      title: title ?? this.title,
      excerpt: excerpt ?? this.excerpt,
      previewText: previewText ?? this.previewText,
      scrollOffset: scrollOffset ?? this.scrollOffset,
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
    if (bookId.present) {
      map['book_id'] = Variable<String>(bookId.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (chapterIndex.present) {
      map['chapter_index'] = Variable<int>(chapterIndex.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (excerpt.present) {
      map['excerpt'] = Variable<String>(excerpt.value);
    }
    if (previewText.present) {
      map['preview_text'] = Variable<String>(previewText.value);
    }
    if (scrollOffset.present) {
      map['scroll_offset'] = Variable<int>(scrollOffset.value);
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
    return (StringBuffer('BookmarksCompanion(')
          ..write('id: $id, ')
          ..write('bookId: $bookId, ')
          ..write('position: $position, ')
          ..write('chapterIndex: $chapterIndex, ')
          ..write('title: $title, ')
          ..write('excerpt: $excerpt, ')
          ..write('previewText: $previewText, ')
          ..write('scrollOffset: $scrollOffset, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $NotesTable extends Notes with TableInfo<$NotesTable, NotesData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NotesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _bookIdMeta = const VerificationMeta('bookId');
  @override
  late final GeneratedColumn<String> bookId = GeneratedColumn<String>(
      'book_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES books (id)'));
  static const VerificationMeta _selectedTextMeta =
      const VerificationMeta('selectedText');
  @override
  late final GeneratedColumn<String> selectedText = GeneratedColumn<String>(
      'selected_text', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _noteContentMeta =
      const VerificationMeta('noteContent');
  @override
  late final GeneratedColumn<String> noteContent = GeneratedColumn<String>(
      'note_content', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _positionMeta =
      const VerificationMeta('position');
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
      'position', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _chapterIndexMeta =
      const VerificationMeta('chapterIndex');
  @override
  late final GeneratedColumn<int> chapterIndex = GeneratedColumn<int>(
      'chapter_index', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        bookId,
        selectedText,
        noteContent,
        position,
        chapterIndex,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'notes';
  @override
  VerificationContext validateIntegrity(Insertable<NotesData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('book_id')) {
      context.handle(_bookIdMeta,
          bookId.isAcceptableOrUnknown(data['book_id']!, _bookIdMeta));
    } else if (isInserting) {
      context.missing(_bookIdMeta);
    }
    if (data.containsKey('selected_text')) {
      context.handle(
          _selectedTextMeta,
          selectedText.isAcceptableOrUnknown(
              data['selected_text']!, _selectedTextMeta));
    } else if (isInserting) {
      context.missing(_selectedTextMeta);
    }
    if (data.containsKey('note_content')) {
      context.handle(
          _noteContentMeta,
          noteContent.isAcceptableOrUnknown(
              data['note_content']!, _noteContentMeta));
    } else if (isInserting) {
      context.missing(_noteContentMeta);
    }
    if (data.containsKey('position')) {
      context.handle(_positionMeta,
          position.isAcceptableOrUnknown(data['position']!, _positionMeta));
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    if (data.containsKey('chapter_index')) {
      context.handle(
          _chapterIndexMeta,
          chapterIndex.isAcceptableOrUnknown(
              data['chapter_index']!, _chapterIndexMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  NotesData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return NotesData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      bookId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}book_id'])!,
      selectedText: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}selected_text'])!,
      noteContent: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}note_content'])!,
      position: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}position'])!,
      chapterIndex: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}chapter_index']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at']),
    );
  }

  @override
  $NotesTable createAlias(String alias) {
    return $NotesTable(attachedDatabase, alias);
  }
}

class NotesData extends DataClass implements Insertable<NotesData> {
  final String id;
  final String bookId;
  final String selectedText;
  final String noteContent;
  final int position;
  final int? chapterIndex;
  final DateTime createdAt;
  final DateTime? updatedAt;
  const NotesData(
      {required this.id,
      required this.bookId,
      required this.selectedText,
      required this.noteContent,
      required this.position,
      this.chapterIndex,
      required this.createdAt,
      this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['book_id'] = Variable<String>(bookId);
    map['selected_text'] = Variable<String>(selectedText);
    map['note_content'] = Variable<String>(noteContent);
    map['position'] = Variable<int>(position);
    if (!nullToAbsent || chapterIndex != null) {
      map['chapter_index'] = Variable<int>(chapterIndex);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    return map;
  }

  NotesCompanion toCompanion(bool nullToAbsent) {
    return NotesCompanion(
      id: Value(id),
      bookId: Value(bookId),
      selectedText: Value(selectedText),
      noteContent: Value(noteContent),
      position: Value(position),
      chapterIndex: chapterIndex == null && nullToAbsent
          ? const Value.absent()
          : Value(chapterIndex),
      createdAt: Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  factory NotesData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return NotesData(
      id: serializer.fromJson<String>(json['id']),
      bookId: serializer.fromJson<String>(json['bookId']),
      selectedText: serializer.fromJson<String>(json['selectedText']),
      noteContent: serializer.fromJson<String>(json['noteContent']),
      position: serializer.fromJson<int>(json['position']),
      chapterIndex: serializer.fromJson<int?>(json['chapterIndex']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'bookId': serializer.toJson<String>(bookId),
      'selectedText': serializer.toJson<String>(selectedText),
      'noteContent': serializer.toJson<String>(noteContent),
      'position': serializer.toJson<int>(position),
      'chapterIndex': serializer.toJson<int?>(chapterIndex),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
    };
  }

  NotesData copyWith(
          {String? id,
          String? bookId,
          String? selectedText,
          String? noteContent,
          int? position,
          Value<int?> chapterIndex = const Value.absent(),
          DateTime? createdAt,
          Value<DateTime?> updatedAt = const Value.absent()}) =>
      NotesData(
        id: id ?? this.id,
        bookId: bookId ?? this.bookId,
        selectedText: selectedText ?? this.selectedText,
        noteContent: noteContent ?? this.noteContent,
        position: position ?? this.position,
        chapterIndex:
            chapterIndex.present ? chapterIndex.value : this.chapterIndex,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
      );
  NotesData copyWithCompanion(NotesCompanion data) {
    return NotesData(
      id: data.id.present ? data.id.value : this.id,
      bookId: data.bookId.present ? data.bookId.value : this.bookId,
      selectedText: data.selectedText.present
          ? data.selectedText.value
          : this.selectedText,
      noteContent:
          data.noteContent.present ? data.noteContent.value : this.noteContent,
      position: data.position.present ? data.position.value : this.position,
      chapterIndex: data.chapterIndex.present
          ? data.chapterIndex.value
          : this.chapterIndex,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('NotesData(')
          ..write('id: $id, ')
          ..write('bookId: $bookId, ')
          ..write('selectedText: $selectedText, ')
          ..write('noteContent: $noteContent, ')
          ..write('position: $position, ')
          ..write('chapterIndex: $chapterIndex, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, bookId, selectedText, noteContent,
      position, chapterIndex, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is NotesData &&
          other.id == this.id &&
          other.bookId == this.bookId &&
          other.selectedText == this.selectedText &&
          other.noteContent == this.noteContent &&
          other.position == this.position &&
          other.chapterIndex == this.chapterIndex &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class NotesCompanion extends UpdateCompanion<NotesData> {
  final Value<String> id;
  final Value<String> bookId;
  final Value<String> selectedText;
  final Value<String> noteContent;
  final Value<int> position;
  final Value<int?> chapterIndex;
  final Value<DateTime> createdAt;
  final Value<DateTime?> updatedAt;
  final Value<int> rowid;
  const NotesCompanion({
    this.id = const Value.absent(),
    this.bookId = const Value.absent(),
    this.selectedText = const Value.absent(),
    this.noteContent = const Value.absent(),
    this.position = const Value.absent(),
    this.chapterIndex = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  NotesCompanion.insert({
    required String id,
    required String bookId,
    required String selectedText,
    required String noteContent,
    required int position,
    this.chapterIndex = const Value.absent(),
    required DateTime createdAt,
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        bookId = Value(bookId),
        selectedText = Value(selectedText),
        noteContent = Value(noteContent),
        position = Value(position),
        createdAt = Value(createdAt);
  static Insertable<NotesData> custom({
    Expression<String>? id,
    Expression<String>? bookId,
    Expression<String>? selectedText,
    Expression<String>? noteContent,
    Expression<int>? position,
    Expression<int>? chapterIndex,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (bookId != null) 'book_id': bookId,
      if (selectedText != null) 'selected_text': selectedText,
      if (noteContent != null) 'note_content': noteContent,
      if (position != null) 'position': position,
      if (chapterIndex != null) 'chapter_index': chapterIndex,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  NotesCompanion copyWith(
      {Value<String>? id,
      Value<String>? bookId,
      Value<String>? selectedText,
      Value<String>? noteContent,
      Value<int>? position,
      Value<int?>? chapterIndex,
      Value<DateTime>? createdAt,
      Value<DateTime?>? updatedAt,
      Value<int>? rowid}) {
    return NotesCompanion(
      id: id ?? this.id,
      bookId: bookId ?? this.bookId,
      selectedText: selectedText ?? this.selectedText,
      noteContent: noteContent ?? this.noteContent,
      position: position ?? this.position,
      chapterIndex: chapterIndex ?? this.chapterIndex,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (bookId.present) {
      map['book_id'] = Variable<String>(bookId.value);
    }
    if (selectedText.present) {
      map['selected_text'] = Variable<String>(selectedText.value);
    }
    if (noteContent.present) {
      map['note_content'] = Variable<String>(noteContent.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (chapterIndex.present) {
      map['chapter_index'] = Variable<int>(chapterIndex.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NotesCompanion(')
          ..write('id: $id, ')
          ..write('bookId: $bookId, ')
          ..write('selectedText: $selectedText, ')
          ..write('noteContent: $noteContent, ')
          ..write('position: $position, ')
          ..write('chapterIndex: $chapterIndex, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ReadingProgressesTable extends ReadingProgresses
    with TableInfo<$ReadingProgressesTable, ReadingProgressesData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReadingProgressesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _bookIdMeta = const VerificationMeta('bookId');
  @override
  late final GeneratedColumn<String> bookId = GeneratedColumn<String>(
      'book_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES books (id)'));
  static const VerificationMeta _positionMeta =
      const VerificationMeta('position');
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
      'position', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _percentageMeta =
      const VerificationMeta('percentage');
  @override
  late final GeneratedColumn<double> percentage = GeneratedColumn<double>(
      'percentage', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _lastReadMeta =
      const VerificationMeta('lastRead');
  @override
  late final GeneratedColumn<DateTime> lastRead = GeneratedColumn<DateTime>(
      'last_read', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _chapterIndexMeta =
      const VerificationMeta('chapterIndex');
  @override
  late final GeneratedColumn<int> chapterIndex = GeneratedColumn<int>(
      'chapter_index', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _scrollOffsetMeta =
      const VerificationMeta('scrollOffset');
  @override
  late final GeneratedColumn<int> scrollOffset = GeneratedColumn<int>(
      'scroll_offset', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, bookId, position, percentage, lastRead, chapterIndex, scrollOffset];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'reading_progresses';
  @override
  VerificationContext validateIntegrity(
      Insertable<ReadingProgressesData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('book_id')) {
      context.handle(_bookIdMeta,
          bookId.isAcceptableOrUnknown(data['book_id']!, _bookIdMeta));
    } else if (isInserting) {
      context.missing(_bookIdMeta);
    }
    if (data.containsKey('position')) {
      context.handle(_positionMeta,
          position.isAcceptableOrUnknown(data['position']!, _positionMeta));
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    if (data.containsKey('percentage')) {
      context.handle(
          _percentageMeta,
          percentage.isAcceptableOrUnknown(
              data['percentage']!, _percentageMeta));
    } else if (isInserting) {
      context.missing(_percentageMeta);
    }
    if (data.containsKey('last_read')) {
      context.handle(_lastReadMeta,
          lastRead.isAcceptableOrUnknown(data['last_read']!, _lastReadMeta));
    } else if (isInserting) {
      context.missing(_lastReadMeta);
    }
    if (data.containsKey('chapter_index')) {
      context.handle(
          _chapterIndexMeta,
          chapterIndex.isAcceptableOrUnknown(
              data['chapter_index']!, _chapterIndexMeta));
    }
    if (data.containsKey('scroll_offset')) {
      context.handle(
          _scrollOffsetMeta,
          scrollOffset.isAcceptableOrUnknown(
              data['scroll_offset']!, _scrollOffsetMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ReadingProgressesData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ReadingProgressesData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      bookId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}book_id'])!,
      position: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}position'])!,
      percentage: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}percentage'])!,
      lastRead: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}last_read'])!,
      chapterIndex: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}chapter_index'])!,
      scrollOffset: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}scroll_offset']),
    );
  }

  @override
  $ReadingProgressesTable createAlias(String alias) {
    return $ReadingProgressesTable(attachedDatabase, alias);
  }
}

class ReadingProgressesData extends DataClass
    implements Insertable<ReadingProgressesData> {
  final String id;
  final String bookId;
  final int position;
  final double percentage;
  final DateTime lastRead;
  final int chapterIndex;
  final int? scrollOffset;
  const ReadingProgressesData(
      {required this.id,
      required this.bookId,
      required this.position,
      required this.percentage,
      required this.lastRead,
      required this.chapterIndex,
      this.scrollOffset});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['book_id'] = Variable<String>(bookId);
    map['position'] = Variable<int>(position);
    map['percentage'] = Variable<double>(percentage);
    map['last_read'] = Variable<DateTime>(lastRead);
    map['chapter_index'] = Variable<int>(chapterIndex);
    if (!nullToAbsent || scrollOffset != null) {
      map['scroll_offset'] = Variable<int>(scrollOffset);
    }
    return map;
  }

  ReadingProgressesCompanion toCompanion(bool nullToAbsent) {
    return ReadingProgressesCompanion(
      id: Value(id),
      bookId: Value(bookId),
      position: Value(position),
      percentage: Value(percentage),
      lastRead: Value(lastRead),
      chapterIndex: Value(chapterIndex),
      scrollOffset: scrollOffset == null && nullToAbsent
          ? const Value.absent()
          : Value(scrollOffset),
    );
  }

  factory ReadingProgressesData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ReadingProgressesData(
      id: serializer.fromJson<String>(json['id']),
      bookId: serializer.fromJson<String>(json['bookId']),
      position: serializer.fromJson<int>(json['position']),
      percentage: serializer.fromJson<double>(json['percentage']),
      lastRead: serializer.fromJson<DateTime>(json['lastRead']),
      chapterIndex: serializer.fromJson<int>(json['chapterIndex']),
      scrollOffset: serializer.fromJson<int?>(json['scrollOffset']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'bookId': serializer.toJson<String>(bookId),
      'position': serializer.toJson<int>(position),
      'percentage': serializer.toJson<double>(percentage),
      'lastRead': serializer.toJson<DateTime>(lastRead),
      'chapterIndex': serializer.toJson<int>(chapterIndex),
      'scrollOffset': serializer.toJson<int?>(scrollOffset),
    };
  }

  ReadingProgressesData copyWith(
          {String? id,
          String? bookId,
          int? position,
          double? percentage,
          DateTime? lastRead,
          int? chapterIndex,
          Value<int?> scrollOffset = const Value.absent()}) =>
      ReadingProgressesData(
        id: id ?? this.id,
        bookId: bookId ?? this.bookId,
        position: position ?? this.position,
        percentage: percentage ?? this.percentage,
        lastRead: lastRead ?? this.lastRead,
        chapterIndex: chapterIndex ?? this.chapterIndex,
        scrollOffset:
            scrollOffset.present ? scrollOffset.value : this.scrollOffset,
      );
  ReadingProgressesData copyWithCompanion(ReadingProgressesCompanion data) {
    return ReadingProgressesData(
      id: data.id.present ? data.id.value : this.id,
      bookId: data.bookId.present ? data.bookId.value : this.bookId,
      position: data.position.present ? data.position.value : this.position,
      percentage:
          data.percentage.present ? data.percentage.value : this.percentage,
      lastRead: data.lastRead.present ? data.lastRead.value : this.lastRead,
      chapterIndex: data.chapterIndex.present
          ? data.chapterIndex.value
          : this.chapterIndex,
      scrollOffset: data.scrollOffset.present
          ? data.scrollOffset.value
          : this.scrollOffset,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ReadingProgressesData(')
          ..write('id: $id, ')
          ..write('bookId: $bookId, ')
          ..write('position: $position, ')
          ..write('percentage: $percentage, ')
          ..write('lastRead: $lastRead, ')
          ..write('chapterIndex: $chapterIndex, ')
          ..write('scrollOffset: $scrollOffset')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, bookId, position, percentage, lastRead, chapterIndex, scrollOffset);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ReadingProgressesData &&
          other.id == this.id &&
          other.bookId == this.bookId &&
          other.position == this.position &&
          other.percentage == this.percentage &&
          other.lastRead == this.lastRead &&
          other.chapterIndex == this.chapterIndex &&
          other.scrollOffset == this.scrollOffset);
}

class ReadingProgressesCompanion
    extends UpdateCompanion<ReadingProgressesData> {
  final Value<String> id;
  final Value<String> bookId;
  final Value<int> position;
  final Value<double> percentage;
  final Value<DateTime> lastRead;
  final Value<int> chapterIndex;
  final Value<int?> scrollOffset;
  final Value<int> rowid;
  const ReadingProgressesCompanion({
    this.id = const Value.absent(),
    this.bookId = const Value.absent(),
    this.position = const Value.absent(),
    this.percentage = const Value.absent(),
    this.lastRead = const Value.absent(),
    this.chapterIndex = const Value.absent(),
    this.scrollOffset = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ReadingProgressesCompanion.insert({
    required String id,
    required String bookId,
    required int position,
    required double percentage,
    required DateTime lastRead,
    this.chapterIndex = const Value.absent(),
    this.scrollOffset = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        bookId = Value(bookId),
        position = Value(position),
        percentage = Value(percentage),
        lastRead = Value(lastRead);
  static Insertable<ReadingProgressesData> custom({
    Expression<String>? id,
    Expression<String>? bookId,
    Expression<int>? position,
    Expression<double>? percentage,
    Expression<DateTime>? lastRead,
    Expression<int>? chapterIndex,
    Expression<int>? scrollOffset,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (bookId != null) 'book_id': bookId,
      if (position != null) 'position': position,
      if (percentage != null) 'percentage': percentage,
      if (lastRead != null) 'last_read': lastRead,
      if (chapterIndex != null) 'chapter_index': chapterIndex,
      if (scrollOffset != null) 'scroll_offset': scrollOffset,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ReadingProgressesCompanion copyWith(
      {Value<String>? id,
      Value<String>? bookId,
      Value<int>? position,
      Value<double>? percentage,
      Value<DateTime>? lastRead,
      Value<int>? chapterIndex,
      Value<int?>? scrollOffset,
      Value<int>? rowid}) {
    return ReadingProgressesCompanion(
      id: id ?? this.id,
      bookId: bookId ?? this.bookId,
      position: position ?? this.position,
      percentage: percentage ?? this.percentage,
      lastRead: lastRead ?? this.lastRead,
      chapterIndex: chapterIndex ?? this.chapterIndex,
      scrollOffset: scrollOffset ?? this.scrollOffset,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (bookId.present) {
      map['book_id'] = Variable<String>(bookId.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (percentage.present) {
      map['percentage'] = Variable<double>(percentage.value);
    }
    if (lastRead.present) {
      map['last_read'] = Variable<DateTime>(lastRead.value);
    }
    if (chapterIndex.present) {
      map['chapter_index'] = Variable<int>(chapterIndex.value);
    }
    if (scrollOffset.present) {
      map['scroll_offset'] = Variable<int>(scrollOffset.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReadingProgressesCompanion(')
          ..write('id: $id, ')
          ..write('bookId: $bookId, ')
          ..write('position: $position, ')
          ..write('percentage: $percentage, ')
          ..write('lastRead: $lastRead, ')
          ..write('chapterIndex: $chapterIndex, ')
          ..write('scrollOffset: $scrollOffset, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ReaderPreferencesTable extends ReaderPreferences
    with TableInfo<$ReaderPreferencesTable, ReaderPreferencesData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReaderPreferencesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('global'));
  static const VerificationMeta _themeModeMeta =
      const VerificationMeta('themeMode');
  @override
  late final GeneratedColumn<String> themeMode = GeneratedColumn<String>(
      'theme_mode', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('light'));
  static const VerificationMeta _fontSizeMeta =
      const VerificationMeta('fontSize');
  @override
  late final GeneratedColumn<double> fontSize = GeneratedColumn<double>(
      'font_size', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(16.0));
  static const VerificationMeta _lineHeightMeta =
      const VerificationMeta('lineHeight');
  @override
  late final GeneratedColumn<double> lineHeight = GeneratedColumn<double>(
      'line_height', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(1.5));
  static const VerificationMeta _horizontalMarginMeta =
      const VerificationMeta('horizontalMargin');
  @override
  late final GeneratedColumn<double> horizontalMargin = GeneratedColumn<double>(
      'horizontal_margin', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(16.0));
  static const VerificationMeta _fontFamilyMeta =
      const VerificationMeta('fontFamily');
  @override
  late final GeneratedColumn<String> fontFamily = GeneratedColumn<String>(
      'font_family', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('System'));
  static const VerificationMeta _fullscreenEnabledMeta =
      const VerificationMeta('fullscreenEnabled');
  @override
  late final GeneratedColumn<bool> fullscreenEnabled = GeneratedColumn<bool>(
      'fullscreen_enabled', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("fullscreen_enabled" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _autoHideControlsMeta =
      const VerificationMeta('autoHideControls');
  @override
  late final GeneratedColumn<bool> autoHideControls = GeneratedColumn<bool>(
      'auto_hide_controls', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("auto_hide_controls" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _justifiedTextMeta =
      const VerificationMeta('justifiedText');
  @override
  late final GeneratedColumn<bool> justifiedText = GeneratedColumn<bool>(
      'justified_text', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("justified_text" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _brightnessOverrideMeta =
      const VerificationMeta('brightnessOverride');
  @override
  late final GeneratedColumn<double> brightnessOverride =
      GeneratedColumn<double>('brightness_override', aliasedName, true,
          type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _paragraphSpacingMeta =
      const VerificationMeta('paragraphSpacing');
  @override
  late final GeneratedColumn<double> paragraphSpacing = GeneratedColumn<double>(
      'paragraph_spacing', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(16.0));
  static const VerificationMeta _textAlignMeta =
      const VerificationMeta('textAlign');
  @override
  late final GeneratedColumn<String> textAlign = GeneratedColumn<String>(
      'text_align', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('left'));
  static const VerificationMeta _showPageProgressMeta =
      const VerificationMeta('showPageProgress');
  @override
  late final GeneratedColumn<bool> showPageProgress = GeneratedColumn<bool>(
      'show_page_progress', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("show_page_progress" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _showBatteryStatusMeta =
      const VerificationMeta('showBatteryStatus');
  @override
  late final GeneratedColumn<bool> showBatteryStatus = GeneratedColumn<bool>(
      'show_battery_status', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("show_battery_status" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _showClockMeta =
      const VerificationMeta('showClock');
  @override
  late final GeneratedColumn<bool> showClock = GeneratedColumn<bool>(
      'show_clock', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("show_clock" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _tapToTurnPageMeta =
      const VerificationMeta('tapToTurnPage');
  @override
  late final GeneratedColumn<bool> tapToTurnPage = GeneratedColumn<bool>(
      'tap_to_turn_page', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("tap_to_turn_page" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _keepScreenAwakeMeta =
      const VerificationMeta('keepScreenAwake');
  @override
  late final GeneratedColumn<bool> keepScreenAwake = GeneratedColumn<bool>(
      'keep_screen_awake', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("keep_screen_awake" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        themeMode,
        fontSize,
        lineHeight,
        horizontalMargin,
        fontFamily,
        fullscreenEnabled,
        autoHideControls,
        justifiedText,
        brightnessOverride,
        paragraphSpacing,
        textAlign,
        showPageProgress,
        showBatteryStatus,
        showClock,
        tapToTurnPage,
        keepScreenAwake,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'reader_preferences';
  @override
  VerificationContext validateIntegrity(
      Insertable<ReaderPreferencesData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('theme_mode')) {
      context.handle(_themeModeMeta,
          themeMode.isAcceptableOrUnknown(data['theme_mode']!, _themeModeMeta));
    }
    if (data.containsKey('font_size')) {
      context.handle(_fontSizeMeta,
          fontSize.isAcceptableOrUnknown(data['font_size']!, _fontSizeMeta));
    }
    if (data.containsKey('line_height')) {
      context.handle(
          _lineHeightMeta,
          lineHeight.isAcceptableOrUnknown(
              data['line_height']!, _lineHeightMeta));
    }
    if (data.containsKey('horizontal_margin')) {
      context.handle(
          _horizontalMarginMeta,
          horizontalMargin.isAcceptableOrUnknown(
              data['horizontal_margin']!, _horizontalMarginMeta));
    }
    if (data.containsKey('font_family')) {
      context.handle(
          _fontFamilyMeta,
          fontFamily.isAcceptableOrUnknown(
              data['font_family']!, _fontFamilyMeta));
    }
    if (data.containsKey('fullscreen_enabled')) {
      context.handle(
          _fullscreenEnabledMeta,
          fullscreenEnabled.isAcceptableOrUnknown(
              data['fullscreen_enabled']!, _fullscreenEnabledMeta));
    }
    if (data.containsKey('auto_hide_controls')) {
      context.handle(
          _autoHideControlsMeta,
          autoHideControls.isAcceptableOrUnknown(
              data['auto_hide_controls']!, _autoHideControlsMeta));
    }
    if (data.containsKey('justified_text')) {
      context.handle(
          _justifiedTextMeta,
          justifiedText.isAcceptableOrUnknown(
              data['justified_text']!, _justifiedTextMeta));
    }
    if (data.containsKey('brightness_override')) {
      context.handle(
          _brightnessOverrideMeta,
          brightnessOverride.isAcceptableOrUnknown(
              data['brightness_override']!, _brightnessOverrideMeta));
    }
    if (data.containsKey('paragraph_spacing')) {
      context.handle(
          _paragraphSpacingMeta,
          paragraphSpacing.isAcceptableOrUnknown(
              data['paragraph_spacing']!, _paragraphSpacingMeta));
    }
    if (data.containsKey('text_align')) {
      context.handle(_textAlignMeta,
          textAlign.isAcceptableOrUnknown(data['text_align']!, _textAlignMeta));
    }
    if (data.containsKey('show_page_progress')) {
      context.handle(
          _showPageProgressMeta,
          showPageProgress.isAcceptableOrUnknown(
              data['show_page_progress']!, _showPageProgressMeta));
    }
    if (data.containsKey('show_battery_status')) {
      context.handle(
          _showBatteryStatusMeta,
          showBatteryStatus.isAcceptableOrUnknown(
              data['show_battery_status']!, _showBatteryStatusMeta));
    }
    if (data.containsKey('show_clock')) {
      context.handle(_showClockMeta,
          showClock.isAcceptableOrUnknown(data['show_clock']!, _showClockMeta));
    }
    if (data.containsKey('tap_to_turn_page')) {
      context.handle(
          _tapToTurnPageMeta,
          tapToTurnPage.isAcceptableOrUnknown(
              data['tap_to_turn_page']!, _tapToTurnPageMeta));
    }
    if (data.containsKey('keep_screen_awake')) {
      context.handle(
          _keepScreenAwakeMeta,
          keepScreenAwake.isAcceptableOrUnknown(
              data['keep_screen_awake']!, _keepScreenAwakeMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ReaderPreferencesData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ReaderPreferencesData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      themeMode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}theme_mode'])!,
      fontSize: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}font_size'])!,
      lineHeight: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}line_height'])!,
      horizontalMargin: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}horizontal_margin'])!,
      fontFamily: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}font_family'])!,
      fullscreenEnabled: attachedDatabase.typeMapping.read(
          DriftSqlType.bool, data['${effectivePrefix}fullscreen_enabled'])!,
      autoHideControls: attachedDatabase.typeMapping.read(
          DriftSqlType.bool, data['${effectivePrefix}auto_hide_controls'])!,
      justifiedText: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}justified_text'])!,
      brightnessOverride: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}brightness_override']),
      paragraphSpacing: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}paragraph_spacing'])!,
      textAlign: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}text_align'])!,
      showPageProgress: attachedDatabase.typeMapping.read(
          DriftSqlType.bool, data['${effectivePrefix}show_page_progress'])!,
      showBatteryStatus: attachedDatabase.typeMapping.read(
          DriftSqlType.bool, data['${effectivePrefix}show_battery_status'])!,
      showClock: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}show_clock'])!,
      tapToTurnPage: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}tap_to_turn_page'])!,
      keepScreenAwake: attachedDatabase.typeMapping.read(
          DriftSqlType.bool, data['${effectivePrefix}keep_screen_awake'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $ReaderPreferencesTable createAlias(String alias) {
    return $ReaderPreferencesTable(attachedDatabase, alias);
  }
}

class ReaderPreferencesData extends DataClass
    implements Insertable<ReaderPreferencesData> {
  final String id;
  final String themeMode;
  final double fontSize;
  final double lineHeight;
  final double horizontalMargin;
  final String fontFamily;
  final bool fullscreenEnabled;
  final bool autoHideControls;
  final bool justifiedText;
  final double? brightnessOverride;
  final double paragraphSpacing;
  final String textAlign;
  final bool showPageProgress;
  final bool showBatteryStatus;
  final bool showClock;
  final bool tapToTurnPage;
  final bool keepScreenAwake;
  final DateTime updatedAt;
  const ReaderPreferencesData(
      {required this.id,
      required this.themeMode,
      required this.fontSize,
      required this.lineHeight,
      required this.horizontalMargin,
      required this.fontFamily,
      required this.fullscreenEnabled,
      required this.autoHideControls,
      required this.justifiedText,
      this.brightnessOverride,
      required this.paragraphSpacing,
      required this.textAlign,
      required this.showPageProgress,
      required this.showBatteryStatus,
      required this.showClock,
      required this.tapToTurnPage,
      required this.keepScreenAwake,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['theme_mode'] = Variable<String>(themeMode);
    map['font_size'] = Variable<double>(fontSize);
    map['line_height'] = Variable<double>(lineHeight);
    map['horizontal_margin'] = Variable<double>(horizontalMargin);
    map['font_family'] = Variable<String>(fontFamily);
    map['fullscreen_enabled'] = Variable<bool>(fullscreenEnabled);
    map['auto_hide_controls'] = Variable<bool>(autoHideControls);
    map['justified_text'] = Variable<bool>(justifiedText);
    if (!nullToAbsent || brightnessOverride != null) {
      map['brightness_override'] = Variable<double>(brightnessOverride);
    }
    map['paragraph_spacing'] = Variable<double>(paragraphSpacing);
    map['text_align'] = Variable<String>(textAlign);
    map['show_page_progress'] = Variable<bool>(showPageProgress);
    map['show_battery_status'] = Variable<bool>(showBatteryStatus);
    map['show_clock'] = Variable<bool>(showClock);
    map['tap_to_turn_page'] = Variable<bool>(tapToTurnPage);
    map['keep_screen_awake'] = Variable<bool>(keepScreenAwake);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ReaderPreferencesCompanion toCompanion(bool nullToAbsent) {
    return ReaderPreferencesCompanion(
      id: Value(id),
      themeMode: Value(themeMode),
      fontSize: Value(fontSize),
      lineHeight: Value(lineHeight),
      horizontalMargin: Value(horizontalMargin),
      fontFamily: Value(fontFamily),
      fullscreenEnabled: Value(fullscreenEnabled),
      autoHideControls: Value(autoHideControls),
      justifiedText: Value(justifiedText),
      brightnessOverride: brightnessOverride == null && nullToAbsent
          ? const Value.absent()
          : Value(brightnessOverride),
      paragraphSpacing: Value(paragraphSpacing),
      textAlign: Value(textAlign),
      showPageProgress: Value(showPageProgress),
      showBatteryStatus: Value(showBatteryStatus),
      showClock: Value(showClock),
      tapToTurnPage: Value(tapToTurnPage),
      keepScreenAwake: Value(keepScreenAwake),
      updatedAt: Value(updatedAt),
    );
  }

  factory ReaderPreferencesData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ReaderPreferencesData(
      id: serializer.fromJson<String>(json['id']),
      themeMode: serializer.fromJson<String>(json['themeMode']),
      fontSize: serializer.fromJson<double>(json['fontSize']),
      lineHeight: serializer.fromJson<double>(json['lineHeight']),
      horizontalMargin: serializer.fromJson<double>(json['horizontalMargin']),
      fontFamily: serializer.fromJson<String>(json['fontFamily']),
      fullscreenEnabled: serializer.fromJson<bool>(json['fullscreenEnabled']),
      autoHideControls: serializer.fromJson<bool>(json['autoHideControls']),
      justifiedText: serializer.fromJson<bool>(json['justifiedText']),
      brightnessOverride:
          serializer.fromJson<double?>(json['brightnessOverride']),
      paragraphSpacing: serializer.fromJson<double>(json['paragraphSpacing']),
      textAlign: serializer.fromJson<String>(json['textAlign']),
      showPageProgress: serializer.fromJson<bool>(json['showPageProgress']),
      showBatteryStatus: serializer.fromJson<bool>(json['showBatteryStatus']),
      showClock: serializer.fromJson<bool>(json['showClock']),
      tapToTurnPage: serializer.fromJson<bool>(json['tapToTurnPage']),
      keepScreenAwake: serializer.fromJson<bool>(json['keepScreenAwake']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'themeMode': serializer.toJson<String>(themeMode),
      'fontSize': serializer.toJson<double>(fontSize),
      'lineHeight': serializer.toJson<double>(lineHeight),
      'horizontalMargin': serializer.toJson<double>(horizontalMargin),
      'fontFamily': serializer.toJson<String>(fontFamily),
      'fullscreenEnabled': serializer.toJson<bool>(fullscreenEnabled),
      'autoHideControls': serializer.toJson<bool>(autoHideControls),
      'justifiedText': serializer.toJson<bool>(justifiedText),
      'brightnessOverride': serializer.toJson<double?>(brightnessOverride),
      'paragraphSpacing': serializer.toJson<double>(paragraphSpacing),
      'textAlign': serializer.toJson<String>(textAlign),
      'showPageProgress': serializer.toJson<bool>(showPageProgress),
      'showBatteryStatus': serializer.toJson<bool>(showBatteryStatus),
      'showClock': serializer.toJson<bool>(showClock),
      'tapToTurnPage': serializer.toJson<bool>(tapToTurnPage),
      'keepScreenAwake': serializer.toJson<bool>(keepScreenAwake),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  ReaderPreferencesData copyWith(
          {String? id,
          String? themeMode,
          double? fontSize,
          double? lineHeight,
          double? horizontalMargin,
          String? fontFamily,
          bool? fullscreenEnabled,
          bool? autoHideControls,
          bool? justifiedText,
          Value<double?> brightnessOverride = const Value.absent(),
          double? paragraphSpacing,
          String? textAlign,
          bool? showPageProgress,
          bool? showBatteryStatus,
          bool? showClock,
          bool? tapToTurnPage,
          bool? keepScreenAwake,
          DateTime? updatedAt}) =>
      ReaderPreferencesData(
        id: id ?? this.id,
        themeMode: themeMode ?? this.themeMode,
        fontSize: fontSize ?? this.fontSize,
        lineHeight: lineHeight ?? this.lineHeight,
        horizontalMargin: horizontalMargin ?? this.horizontalMargin,
        fontFamily: fontFamily ?? this.fontFamily,
        fullscreenEnabled: fullscreenEnabled ?? this.fullscreenEnabled,
        autoHideControls: autoHideControls ?? this.autoHideControls,
        justifiedText: justifiedText ?? this.justifiedText,
        brightnessOverride: brightnessOverride.present
            ? brightnessOverride.value
            : this.brightnessOverride,
        paragraphSpacing: paragraphSpacing ?? this.paragraphSpacing,
        textAlign: textAlign ?? this.textAlign,
        showPageProgress: showPageProgress ?? this.showPageProgress,
        showBatteryStatus: showBatteryStatus ?? this.showBatteryStatus,
        showClock: showClock ?? this.showClock,
        tapToTurnPage: tapToTurnPage ?? this.tapToTurnPage,
        keepScreenAwake: keepScreenAwake ?? this.keepScreenAwake,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  ReaderPreferencesData copyWithCompanion(ReaderPreferencesCompanion data) {
    return ReaderPreferencesData(
      id: data.id.present ? data.id.value : this.id,
      themeMode: data.themeMode.present ? data.themeMode.value : this.themeMode,
      fontSize: data.fontSize.present ? data.fontSize.value : this.fontSize,
      lineHeight:
          data.lineHeight.present ? data.lineHeight.value : this.lineHeight,
      horizontalMargin: data.horizontalMargin.present
          ? data.horizontalMargin.value
          : this.horizontalMargin,
      fontFamily:
          data.fontFamily.present ? data.fontFamily.value : this.fontFamily,
      fullscreenEnabled: data.fullscreenEnabled.present
          ? data.fullscreenEnabled.value
          : this.fullscreenEnabled,
      autoHideControls: data.autoHideControls.present
          ? data.autoHideControls.value
          : this.autoHideControls,
      justifiedText: data.justifiedText.present
          ? data.justifiedText.value
          : this.justifiedText,
      brightnessOverride: data.brightnessOverride.present
          ? data.brightnessOverride.value
          : this.brightnessOverride,
      paragraphSpacing: data.paragraphSpacing.present
          ? data.paragraphSpacing.value
          : this.paragraphSpacing,
      textAlign: data.textAlign.present ? data.textAlign.value : this.textAlign,
      showPageProgress: data.showPageProgress.present
          ? data.showPageProgress.value
          : this.showPageProgress,
      showBatteryStatus: data.showBatteryStatus.present
          ? data.showBatteryStatus.value
          : this.showBatteryStatus,
      showClock: data.showClock.present ? data.showClock.value : this.showClock,
      tapToTurnPage: data.tapToTurnPage.present
          ? data.tapToTurnPage.value
          : this.tapToTurnPage,
      keepScreenAwake: data.keepScreenAwake.present
          ? data.keepScreenAwake.value
          : this.keepScreenAwake,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ReaderPreferencesData(')
          ..write('id: $id, ')
          ..write('themeMode: $themeMode, ')
          ..write('fontSize: $fontSize, ')
          ..write('lineHeight: $lineHeight, ')
          ..write('horizontalMargin: $horizontalMargin, ')
          ..write('fontFamily: $fontFamily, ')
          ..write('fullscreenEnabled: $fullscreenEnabled, ')
          ..write('autoHideControls: $autoHideControls, ')
          ..write('justifiedText: $justifiedText, ')
          ..write('brightnessOverride: $brightnessOverride, ')
          ..write('paragraphSpacing: $paragraphSpacing, ')
          ..write('textAlign: $textAlign, ')
          ..write('showPageProgress: $showPageProgress, ')
          ..write('showBatteryStatus: $showBatteryStatus, ')
          ..write('showClock: $showClock, ')
          ..write('tapToTurnPage: $tapToTurnPage, ')
          ..write('keepScreenAwake: $keepScreenAwake, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      themeMode,
      fontSize,
      lineHeight,
      horizontalMargin,
      fontFamily,
      fullscreenEnabled,
      autoHideControls,
      justifiedText,
      brightnessOverride,
      paragraphSpacing,
      textAlign,
      showPageProgress,
      showBatteryStatus,
      showClock,
      tapToTurnPage,
      keepScreenAwake,
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ReaderPreferencesData &&
          other.id == this.id &&
          other.themeMode == this.themeMode &&
          other.fontSize == this.fontSize &&
          other.lineHeight == this.lineHeight &&
          other.horizontalMargin == this.horizontalMargin &&
          other.fontFamily == this.fontFamily &&
          other.fullscreenEnabled == this.fullscreenEnabled &&
          other.autoHideControls == this.autoHideControls &&
          other.justifiedText == this.justifiedText &&
          other.brightnessOverride == this.brightnessOverride &&
          other.paragraphSpacing == this.paragraphSpacing &&
          other.textAlign == this.textAlign &&
          other.showPageProgress == this.showPageProgress &&
          other.showBatteryStatus == this.showBatteryStatus &&
          other.showClock == this.showClock &&
          other.tapToTurnPage == this.tapToTurnPage &&
          other.keepScreenAwake == this.keepScreenAwake &&
          other.updatedAt == this.updatedAt);
}

class ReaderPreferencesCompanion
    extends UpdateCompanion<ReaderPreferencesData> {
  final Value<String> id;
  final Value<String> themeMode;
  final Value<double> fontSize;
  final Value<double> lineHeight;
  final Value<double> horizontalMargin;
  final Value<String> fontFamily;
  final Value<bool> fullscreenEnabled;
  final Value<bool> autoHideControls;
  final Value<bool> justifiedText;
  final Value<double?> brightnessOverride;
  final Value<double> paragraphSpacing;
  final Value<String> textAlign;
  final Value<bool> showPageProgress;
  final Value<bool> showBatteryStatus;
  final Value<bool> showClock;
  final Value<bool> tapToTurnPage;
  final Value<bool> keepScreenAwake;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const ReaderPreferencesCompanion({
    this.id = const Value.absent(),
    this.themeMode = const Value.absent(),
    this.fontSize = const Value.absent(),
    this.lineHeight = const Value.absent(),
    this.horizontalMargin = const Value.absent(),
    this.fontFamily = const Value.absent(),
    this.fullscreenEnabled = const Value.absent(),
    this.autoHideControls = const Value.absent(),
    this.justifiedText = const Value.absent(),
    this.brightnessOverride = const Value.absent(),
    this.paragraphSpacing = const Value.absent(),
    this.textAlign = const Value.absent(),
    this.showPageProgress = const Value.absent(),
    this.showBatteryStatus = const Value.absent(),
    this.showClock = const Value.absent(),
    this.tapToTurnPage = const Value.absent(),
    this.keepScreenAwake = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ReaderPreferencesCompanion.insert({
    this.id = const Value.absent(),
    this.themeMode = const Value.absent(),
    this.fontSize = const Value.absent(),
    this.lineHeight = const Value.absent(),
    this.horizontalMargin = const Value.absent(),
    this.fontFamily = const Value.absent(),
    this.fullscreenEnabled = const Value.absent(),
    this.autoHideControls = const Value.absent(),
    this.justifiedText = const Value.absent(),
    this.brightnessOverride = const Value.absent(),
    this.paragraphSpacing = const Value.absent(),
    this.textAlign = const Value.absent(),
    this.showPageProgress = const Value.absent(),
    this.showBatteryStatus = const Value.absent(),
    this.showClock = const Value.absent(),
    this.tapToTurnPage = const Value.absent(),
    this.keepScreenAwake = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  static Insertable<ReaderPreferencesData> custom({
    Expression<String>? id,
    Expression<String>? themeMode,
    Expression<double>? fontSize,
    Expression<double>? lineHeight,
    Expression<double>? horizontalMargin,
    Expression<String>? fontFamily,
    Expression<bool>? fullscreenEnabled,
    Expression<bool>? autoHideControls,
    Expression<bool>? justifiedText,
    Expression<double>? brightnessOverride,
    Expression<double>? paragraphSpacing,
    Expression<String>? textAlign,
    Expression<bool>? showPageProgress,
    Expression<bool>? showBatteryStatus,
    Expression<bool>? showClock,
    Expression<bool>? tapToTurnPage,
    Expression<bool>? keepScreenAwake,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (themeMode != null) 'theme_mode': themeMode,
      if (fontSize != null) 'font_size': fontSize,
      if (lineHeight != null) 'line_height': lineHeight,
      if (horizontalMargin != null) 'horizontal_margin': horizontalMargin,
      if (fontFamily != null) 'font_family': fontFamily,
      if (fullscreenEnabled != null) 'fullscreen_enabled': fullscreenEnabled,
      if (autoHideControls != null) 'auto_hide_controls': autoHideControls,
      if (justifiedText != null) 'justified_text': justifiedText,
      if (brightnessOverride != null) 'brightness_override': brightnessOverride,
      if (paragraphSpacing != null) 'paragraph_spacing': paragraphSpacing,
      if (textAlign != null) 'text_align': textAlign,
      if (showPageProgress != null) 'show_page_progress': showPageProgress,
      if (showBatteryStatus != null) 'show_battery_status': showBatteryStatus,
      if (showClock != null) 'show_clock': showClock,
      if (tapToTurnPage != null) 'tap_to_turn_page': tapToTurnPage,
      if (keepScreenAwake != null) 'keep_screen_awake': keepScreenAwake,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ReaderPreferencesCompanion copyWith(
      {Value<String>? id,
      Value<String>? themeMode,
      Value<double>? fontSize,
      Value<double>? lineHeight,
      Value<double>? horizontalMargin,
      Value<String>? fontFamily,
      Value<bool>? fullscreenEnabled,
      Value<bool>? autoHideControls,
      Value<bool>? justifiedText,
      Value<double?>? brightnessOverride,
      Value<double>? paragraphSpacing,
      Value<String>? textAlign,
      Value<bool>? showPageProgress,
      Value<bool>? showBatteryStatus,
      Value<bool>? showClock,
      Value<bool>? tapToTurnPage,
      Value<bool>? keepScreenAwake,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return ReaderPreferencesCompanion(
      id: id ?? this.id,
      themeMode: themeMode ?? this.themeMode,
      fontSize: fontSize ?? this.fontSize,
      lineHeight: lineHeight ?? this.lineHeight,
      horizontalMargin: horizontalMargin ?? this.horizontalMargin,
      fontFamily: fontFamily ?? this.fontFamily,
      fullscreenEnabled: fullscreenEnabled ?? this.fullscreenEnabled,
      autoHideControls: autoHideControls ?? this.autoHideControls,
      justifiedText: justifiedText ?? this.justifiedText,
      brightnessOverride: brightnessOverride ?? this.brightnessOverride,
      paragraphSpacing: paragraphSpacing ?? this.paragraphSpacing,
      textAlign: textAlign ?? this.textAlign,
      showPageProgress: showPageProgress ?? this.showPageProgress,
      showBatteryStatus: showBatteryStatus ?? this.showBatteryStatus,
      showClock: showClock ?? this.showClock,
      tapToTurnPage: tapToTurnPage ?? this.tapToTurnPage,
      keepScreenAwake: keepScreenAwake ?? this.keepScreenAwake,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (themeMode.present) {
      map['theme_mode'] = Variable<String>(themeMode.value);
    }
    if (fontSize.present) {
      map['font_size'] = Variable<double>(fontSize.value);
    }
    if (lineHeight.present) {
      map['line_height'] = Variable<double>(lineHeight.value);
    }
    if (horizontalMargin.present) {
      map['horizontal_margin'] = Variable<double>(horizontalMargin.value);
    }
    if (fontFamily.present) {
      map['font_family'] = Variable<String>(fontFamily.value);
    }
    if (fullscreenEnabled.present) {
      map['fullscreen_enabled'] = Variable<bool>(fullscreenEnabled.value);
    }
    if (autoHideControls.present) {
      map['auto_hide_controls'] = Variable<bool>(autoHideControls.value);
    }
    if (justifiedText.present) {
      map['justified_text'] = Variable<bool>(justifiedText.value);
    }
    if (brightnessOverride.present) {
      map['brightness_override'] = Variable<double>(brightnessOverride.value);
    }
    if (paragraphSpacing.present) {
      map['paragraph_spacing'] = Variable<double>(paragraphSpacing.value);
    }
    if (textAlign.present) {
      map['text_align'] = Variable<String>(textAlign.value);
    }
    if (showPageProgress.present) {
      map['show_page_progress'] = Variable<bool>(showPageProgress.value);
    }
    if (showBatteryStatus.present) {
      map['show_battery_status'] = Variable<bool>(showBatteryStatus.value);
    }
    if (showClock.present) {
      map['show_clock'] = Variable<bool>(showClock.value);
    }
    if (tapToTurnPage.present) {
      map['tap_to_turn_page'] = Variable<bool>(tapToTurnPage.value);
    }
    if (keepScreenAwake.present) {
      map['keep_screen_awake'] = Variable<bool>(keepScreenAwake.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReaderPreferencesCompanion(')
          ..write('id: $id, ')
          ..write('themeMode: $themeMode, ')
          ..write('fontSize: $fontSize, ')
          ..write('lineHeight: $lineHeight, ')
          ..write('horizontalMargin: $horizontalMargin, ')
          ..write('fontFamily: $fontFamily, ')
          ..write('fullscreenEnabled: $fullscreenEnabled, ')
          ..write('autoHideControls: $autoHideControls, ')
          ..write('justifiedText: $justifiedText, ')
          ..write('brightnessOverride: $brightnessOverride, ')
          ..write('paragraphSpacing: $paragraphSpacing, ')
          ..write('textAlign: $textAlign, ')
          ..write('showPageProgress: $showPageProgress, ')
          ..write('showBatteryStatus: $showBatteryStatus, ')
          ..write('showClock: $showClock, ')
          ..write('tapToTurnPage: $tapToTurnPage, ')
          ..write('keepScreenAwake: $keepScreenAwake, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SearchIndexTable extends SearchIndex
    with TableInfo<$SearchIndexTable, SearchIndexData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SearchIndexTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _bookIdMeta = const VerificationMeta('bookId');
  @override
  late final GeneratedColumn<String> bookId = GeneratedColumn<String>(
      'book_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES books (id)'));
  static const VerificationMeta _chapterIndexMeta =
      const VerificationMeta('chapterIndex');
  @override
  late final GeneratedColumn<int> chapterIndex = GeneratedColumn<int>(
      'chapter_index', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _contentTextMeta =
      const VerificationMeta('contentText');
  @override
  late final GeneratedColumn<String> contentText = GeneratedColumn<String>(
      'content_text', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, bookId, chapterIndex, contentText];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'search_index';
  @override
  VerificationContext validateIntegrity(Insertable<SearchIndexData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('book_id')) {
      context.handle(_bookIdMeta,
          bookId.isAcceptableOrUnknown(data['book_id']!, _bookIdMeta));
    } else if (isInserting) {
      context.missing(_bookIdMeta);
    }
    if (data.containsKey('chapter_index')) {
      context.handle(
          _chapterIndexMeta,
          chapterIndex.isAcceptableOrUnknown(
              data['chapter_index']!, _chapterIndexMeta));
    } else if (isInserting) {
      context.missing(_chapterIndexMeta);
    }
    if (data.containsKey('content_text')) {
      context.handle(
          _contentTextMeta,
          contentText.isAcceptableOrUnknown(
              data['content_text']!, _contentTextMeta));
    } else if (isInserting) {
      context.missing(_contentTextMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SearchIndexData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SearchIndexData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      bookId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}book_id'])!,
      chapterIndex: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}chapter_index'])!,
      contentText: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}content_text'])!,
    );
  }

  @override
  $SearchIndexTable createAlias(String alias) {
    return $SearchIndexTable(attachedDatabase, alias);
  }
}

class SearchIndexData extends DataClass implements Insertable<SearchIndexData> {
  final int id;
  final String bookId;
  final int chapterIndex;
  final String contentText;
  const SearchIndexData(
      {required this.id,
      required this.bookId,
      required this.chapterIndex,
      required this.contentText});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['book_id'] = Variable<String>(bookId);
    map['chapter_index'] = Variable<int>(chapterIndex);
    map['content_text'] = Variable<String>(contentText);
    return map;
  }

  SearchIndexCompanion toCompanion(bool nullToAbsent) {
    return SearchIndexCompanion(
      id: Value(id),
      bookId: Value(bookId),
      chapterIndex: Value(chapterIndex),
      contentText: Value(contentText),
    );
  }

  factory SearchIndexData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SearchIndexData(
      id: serializer.fromJson<int>(json['id']),
      bookId: serializer.fromJson<String>(json['bookId']),
      chapterIndex: serializer.fromJson<int>(json['chapterIndex']),
      contentText: serializer.fromJson<String>(json['contentText']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'bookId': serializer.toJson<String>(bookId),
      'chapterIndex': serializer.toJson<int>(chapterIndex),
      'contentText': serializer.toJson<String>(contentText),
    };
  }

  SearchIndexData copyWith(
          {int? id, String? bookId, int? chapterIndex, String? contentText}) =>
      SearchIndexData(
        id: id ?? this.id,
        bookId: bookId ?? this.bookId,
        chapterIndex: chapterIndex ?? this.chapterIndex,
        contentText: contentText ?? this.contentText,
      );
  SearchIndexData copyWithCompanion(SearchIndexCompanion data) {
    return SearchIndexData(
      id: data.id.present ? data.id.value : this.id,
      bookId: data.bookId.present ? data.bookId.value : this.bookId,
      chapterIndex: data.chapterIndex.present
          ? data.chapterIndex.value
          : this.chapterIndex,
      contentText:
          data.contentText.present ? data.contentText.value : this.contentText,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SearchIndexData(')
          ..write('id: $id, ')
          ..write('bookId: $bookId, ')
          ..write('chapterIndex: $chapterIndex, ')
          ..write('contentText: $contentText')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, bookId, chapterIndex, contentText);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SearchIndexData &&
          other.id == this.id &&
          other.bookId == this.bookId &&
          other.chapterIndex == this.chapterIndex &&
          other.contentText == this.contentText);
}

class SearchIndexCompanion extends UpdateCompanion<SearchIndexData> {
  final Value<int> id;
  final Value<String> bookId;
  final Value<int> chapterIndex;
  final Value<String> contentText;
  const SearchIndexCompanion({
    this.id = const Value.absent(),
    this.bookId = const Value.absent(),
    this.chapterIndex = const Value.absent(),
    this.contentText = const Value.absent(),
  });
  SearchIndexCompanion.insert({
    this.id = const Value.absent(),
    required String bookId,
    required int chapterIndex,
    required String contentText,
  })  : bookId = Value(bookId),
        chapterIndex = Value(chapterIndex),
        contentText = Value(contentText);
  static Insertable<SearchIndexData> custom({
    Expression<int>? id,
    Expression<String>? bookId,
    Expression<int>? chapterIndex,
    Expression<String>? contentText,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (bookId != null) 'book_id': bookId,
      if (chapterIndex != null) 'chapter_index': chapterIndex,
      if (contentText != null) 'content_text': contentText,
    });
  }

  SearchIndexCompanion copyWith(
      {Value<int>? id,
      Value<String>? bookId,
      Value<int>? chapterIndex,
      Value<String>? contentText}) {
    return SearchIndexCompanion(
      id: id ?? this.id,
      bookId: bookId ?? this.bookId,
      chapterIndex: chapterIndex ?? this.chapterIndex,
      contentText: contentText ?? this.contentText,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (bookId.present) {
      map['book_id'] = Variable<String>(bookId.value);
    }
    if (chapterIndex.present) {
      map['chapter_index'] = Variable<int>(chapterIndex.value);
    }
    if (contentText.present) {
      map['content_text'] = Variable<String>(contentText.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SearchIndexCompanion(')
          ..write('id: $id, ')
          ..write('bookId: $bookId, ')
          ..write('chapterIndex: $chapterIndex, ')
          ..write('contentText: $contentText')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $BooksTable books = $BooksTable(this);
  late final $BookmarksTable bookmarks = $BookmarksTable(this);
  late final $NotesTable notes = $NotesTable(this);
  late final $ReadingProgressesTable readingProgresses =
      $ReadingProgressesTable(this);
  late final $ReaderPreferencesTable readerPreferences =
      $ReaderPreferencesTable(this);
  late final $SearchIndexTable searchIndex = $SearchIndexTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        books,
        bookmarks,
        notes,
        readingProgresses,
        readerPreferences,
        searchIndex
      ];
}

typedef $$BooksTableCreateCompanionBuilder = BooksCompanion Function({
  required String id,
  required String title,
  Value<String?> author,
  required String filePath,
  required String fileType,
  Value<int> fileSize,
  Value<String?> coverPath,
  Value<DateTime?> lastOpened,
  required DateTime addedAt,
  Value<bool> isFavorite,
  Value<int> totalPages,
  Value<int> currentPage,
  Value<double> readingProgress,
  Value<String?> fileHash,
  Value<int> rowid,
});
typedef $$BooksTableUpdateCompanionBuilder = BooksCompanion Function({
  Value<String> id,
  Value<String> title,
  Value<String?> author,
  Value<String> filePath,
  Value<String> fileType,
  Value<int> fileSize,
  Value<String?> coverPath,
  Value<DateTime?> lastOpened,
  Value<DateTime> addedAt,
  Value<bool> isFavorite,
  Value<int> totalPages,
  Value<int> currentPage,
  Value<double> readingProgress,
  Value<String?> fileHash,
  Value<int> rowid,
});

final class $$BooksTableReferences
    extends BaseReferences<_$AppDatabase, $BooksTable, BooksData> {
  $$BooksTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$BookmarksTable, List<BookmarksData>>
      _bookmarksRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
          db.bookmarks,
          aliasName: $_aliasNameGenerator(db.books.id, db.bookmarks.bookId));

  $$BookmarksTableProcessedTableManager get bookmarksRefs {
    final manager = $$BookmarksTableTableManager($_db, $_db.bookmarks)
        .filter((f) => f.bookId.id($_item.id));

    final cache = $_typedResult.readTableOrNull(_bookmarksRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$NotesTable, List<NotesData>> _notesRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.notes,
          aliasName: $_aliasNameGenerator(db.books.id, db.notes.bookId));

  $$NotesTableProcessedTableManager get notesRefs {
    final manager = $$NotesTableTableManager($_db, $_db.notes)
        .filter((f) => f.bookId.id($_item.id));

    final cache = $_typedResult.readTableOrNull(_notesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$ReadingProgressesTable,
      List<ReadingProgressesData>> _readingProgressesRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.readingProgresses,
          aliasName:
              $_aliasNameGenerator(db.books.id, db.readingProgresses.bookId));

  $$ReadingProgressesTableProcessedTableManager get readingProgressesRefs {
    final manager =
        $$ReadingProgressesTableTableManager($_db, $_db.readingProgresses)
            .filter((f) => f.bookId.id($_item.id));

    final cache =
        $_typedResult.readTableOrNull(_readingProgressesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$SearchIndexTable, List<SearchIndexData>>
      _searchIndexRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
          db.searchIndex,
          aliasName: $_aliasNameGenerator(db.books.id, db.searchIndex.bookId));

  $$SearchIndexTableProcessedTableManager get searchIndexRefs {
    final manager = $$SearchIndexTableTableManager($_db, $_db.searchIndex)
        .filter((f) => f.bookId.id($_item.id));

    final cache = $_typedResult.readTableOrNull(_searchIndexRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$BooksTableFilterComposer extends Composer<_$AppDatabase, $BooksTable> {
  $$BooksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get author => $composableBuilder(
      column: $table.author, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get filePath => $composableBuilder(
      column: $table.filePath, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get fileType => $composableBuilder(
      column: $table.fileType, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get fileSize => $composableBuilder(
      column: $table.fileSize, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get coverPath => $composableBuilder(
      column: $table.coverPath, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastOpened => $composableBuilder(
      column: $table.lastOpened, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get addedAt => $composableBuilder(
      column: $table.addedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isFavorite => $composableBuilder(
      column: $table.isFavorite, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get totalPages => $composableBuilder(
      column: $table.totalPages, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get currentPage => $composableBuilder(
      column: $table.currentPage, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get readingProgress => $composableBuilder(
      column: $table.readingProgress,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get fileHash => $composableBuilder(
      column: $table.fileHash, builder: (column) => ColumnFilters(column));

  Expression<bool> bookmarksRefs(
      Expression<bool> Function($$BookmarksTableFilterComposer f) f) {
    final $$BookmarksTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.bookmarks,
        getReferencedColumn: (t) => t.bookId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$BookmarksTableFilterComposer(
              $db: $db,
              $table: $db.bookmarks,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> notesRefs(
      Expression<bool> Function($$NotesTableFilterComposer f) f) {
    final $$NotesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.notes,
        getReferencedColumn: (t) => t.bookId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$NotesTableFilterComposer(
              $db: $db,
              $table: $db.notes,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> readingProgressesRefs(
      Expression<bool> Function($$ReadingProgressesTableFilterComposer f) f) {
    final $$ReadingProgressesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.readingProgresses,
        getReferencedColumn: (t) => t.bookId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ReadingProgressesTableFilterComposer(
              $db: $db,
              $table: $db.readingProgresses,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> searchIndexRefs(
      Expression<bool> Function($$SearchIndexTableFilterComposer f) f) {
    final $$SearchIndexTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.searchIndex,
        getReferencedColumn: (t) => t.bookId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SearchIndexTableFilterComposer(
              $db: $db,
              $table: $db.searchIndex,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$BooksTableOrderingComposer
    extends Composer<_$AppDatabase, $BooksTable> {
  $$BooksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get author => $composableBuilder(
      column: $table.author, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get filePath => $composableBuilder(
      column: $table.filePath, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get fileType => $composableBuilder(
      column: $table.fileType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get fileSize => $composableBuilder(
      column: $table.fileSize, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get coverPath => $composableBuilder(
      column: $table.coverPath, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastOpened => $composableBuilder(
      column: $table.lastOpened, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get addedAt => $composableBuilder(
      column: $table.addedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isFavorite => $composableBuilder(
      column: $table.isFavorite, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get totalPages => $composableBuilder(
      column: $table.totalPages, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get currentPage => $composableBuilder(
      column: $table.currentPage, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get readingProgress => $composableBuilder(
      column: $table.readingProgress,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get fileHash => $composableBuilder(
      column: $table.fileHash, builder: (column) => ColumnOrderings(column));
}

class $$BooksTableAnnotationComposer
    extends Composer<_$AppDatabase, $BooksTable> {
  $$BooksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get author =>
      $composableBuilder(column: $table.author, builder: (column) => column);

  GeneratedColumn<String> get filePath =>
      $composableBuilder(column: $table.filePath, builder: (column) => column);

  GeneratedColumn<String> get fileType =>
      $composableBuilder(column: $table.fileType, builder: (column) => column);

  GeneratedColumn<int> get fileSize =>
      $composableBuilder(column: $table.fileSize, builder: (column) => column);

  GeneratedColumn<String> get coverPath =>
      $composableBuilder(column: $table.coverPath, builder: (column) => column);

  GeneratedColumn<DateTime> get lastOpened => $composableBuilder(
      column: $table.lastOpened, builder: (column) => column);

  GeneratedColumn<DateTime> get addedAt =>
      $composableBuilder(column: $table.addedAt, builder: (column) => column);

  GeneratedColumn<bool> get isFavorite => $composableBuilder(
      column: $table.isFavorite, builder: (column) => column);

  GeneratedColumn<int> get totalPages => $composableBuilder(
      column: $table.totalPages, builder: (column) => column);

  GeneratedColumn<int> get currentPage => $composableBuilder(
      column: $table.currentPage, builder: (column) => column);

  GeneratedColumn<double> get readingProgress => $composableBuilder(
      column: $table.readingProgress, builder: (column) => column);

  GeneratedColumn<String> get fileHash =>
      $composableBuilder(column: $table.fileHash, builder: (column) => column);

  Expression<T> bookmarksRefs<T extends Object>(
      Expression<T> Function($$BookmarksTableAnnotationComposer a) f) {
    final $$BookmarksTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.bookmarks,
        getReferencedColumn: (t) => t.bookId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$BookmarksTableAnnotationComposer(
              $db: $db,
              $table: $db.bookmarks,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> notesRefs<T extends Object>(
      Expression<T> Function($$NotesTableAnnotationComposer a) f) {
    final $$NotesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.notes,
        getReferencedColumn: (t) => t.bookId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$NotesTableAnnotationComposer(
              $db: $db,
              $table: $db.notes,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> readingProgressesRefs<T extends Object>(
      Expression<T> Function($$ReadingProgressesTableAnnotationComposer a) f) {
    final $$ReadingProgressesTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.readingProgresses,
            getReferencedColumn: (t) => t.bookId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$ReadingProgressesTableAnnotationComposer(
                  $db: $db,
                  $table: $db.readingProgresses,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }

  Expression<T> searchIndexRefs<T extends Object>(
      Expression<T> Function($$SearchIndexTableAnnotationComposer a) f) {
    final $$SearchIndexTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.searchIndex,
        getReferencedColumn: (t) => t.bookId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SearchIndexTableAnnotationComposer(
              $db: $db,
              $table: $db.searchIndex,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$BooksTableTableManager extends RootTableManager<
    _$AppDatabase,
    $BooksTable,
    BooksData,
    $$BooksTableFilterComposer,
    $$BooksTableOrderingComposer,
    $$BooksTableAnnotationComposer,
    $$BooksTableCreateCompanionBuilder,
    $$BooksTableUpdateCompanionBuilder,
    (BooksData, $$BooksTableReferences),
    BooksData,
    PrefetchHooks Function(
        {bool bookmarksRefs,
        bool notesRefs,
        bool readingProgressesRefs,
        bool searchIndexRefs})> {
  $$BooksTableTableManager(_$AppDatabase db, $BooksTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BooksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BooksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BooksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String?> author = const Value.absent(),
            Value<String> filePath = const Value.absent(),
            Value<String> fileType = const Value.absent(),
            Value<int> fileSize = const Value.absent(),
            Value<String?> coverPath = const Value.absent(),
            Value<DateTime?> lastOpened = const Value.absent(),
            Value<DateTime> addedAt = const Value.absent(),
            Value<bool> isFavorite = const Value.absent(),
            Value<int> totalPages = const Value.absent(),
            Value<int> currentPage = const Value.absent(),
            Value<double> readingProgress = const Value.absent(),
            Value<String?> fileHash = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              BooksCompanion(
            id: id,
            title: title,
            author: author,
            filePath: filePath,
            fileType: fileType,
            fileSize: fileSize,
            coverPath: coverPath,
            lastOpened: lastOpened,
            addedAt: addedAt,
            isFavorite: isFavorite,
            totalPages: totalPages,
            currentPage: currentPage,
            readingProgress: readingProgress,
            fileHash: fileHash,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String title,
            Value<String?> author = const Value.absent(),
            required String filePath,
            required String fileType,
            Value<int> fileSize = const Value.absent(),
            Value<String?> coverPath = const Value.absent(),
            Value<DateTime?> lastOpened = const Value.absent(),
            required DateTime addedAt,
            Value<bool> isFavorite = const Value.absent(),
            Value<int> totalPages = const Value.absent(),
            Value<int> currentPage = const Value.absent(),
            Value<double> readingProgress = const Value.absent(),
            Value<String?> fileHash = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              BooksCompanion.insert(
            id: id,
            title: title,
            author: author,
            filePath: filePath,
            fileType: fileType,
            fileSize: fileSize,
            coverPath: coverPath,
            lastOpened: lastOpened,
            addedAt: addedAt,
            isFavorite: isFavorite,
            totalPages: totalPages,
            currentPage: currentPage,
            readingProgress: readingProgress,
            fileHash: fileHash,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$BooksTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: (
              {bookmarksRefs = false,
              notesRefs = false,
              readingProgressesRefs = false,
              searchIndexRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (bookmarksRefs) db.bookmarks,
                if (notesRefs) db.notes,
                if (readingProgressesRefs) db.readingProgresses,
                if (searchIndexRefs) db.searchIndex
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (bookmarksRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable:
                            $$BooksTableReferences._bookmarksRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$BooksTableReferences(db, table, p0).bookmarksRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.bookId == item.id),
                        typedResults: items),
                  if (notesRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable:
                            $$BooksTableReferences._notesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$BooksTableReferences(db, table, p0).notesRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.bookId == item.id),
                        typedResults: items),
                  if (readingProgressesRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable: $$BooksTableReferences
                            ._readingProgressesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$BooksTableReferences(db, table, p0)
                                .readingProgressesRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.bookId == item.id),
                        typedResults: items),
                  if (searchIndexRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable:
                            $$BooksTableReferences._searchIndexRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$BooksTableReferences(db, table, p0)
                                .searchIndexRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.bookId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$BooksTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $BooksTable,
    BooksData,
    $$BooksTableFilterComposer,
    $$BooksTableOrderingComposer,
    $$BooksTableAnnotationComposer,
    $$BooksTableCreateCompanionBuilder,
    $$BooksTableUpdateCompanionBuilder,
    (BooksData, $$BooksTableReferences),
    BooksData,
    PrefetchHooks Function(
        {bool bookmarksRefs,
        bool notesRefs,
        bool readingProgressesRefs,
        bool searchIndexRefs})>;
typedef $$BookmarksTableCreateCompanionBuilder = BookmarksCompanion Function({
  required String id,
  required String bookId,
  required int position,
  Value<int?> chapterIndex,
  required String title,
  Value<String?> excerpt,
  Value<String?> previewText,
  Value<int?> scrollOffset,
  required DateTime createdAt,
  Value<int> rowid,
});
typedef $$BookmarksTableUpdateCompanionBuilder = BookmarksCompanion Function({
  Value<String> id,
  Value<String> bookId,
  Value<int> position,
  Value<int?> chapterIndex,
  Value<String> title,
  Value<String?> excerpt,
  Value<String?> previewText,
  Value<int?> scrollOffset,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

final class $$BookmarksTableReferences
    extends BaseReferences<_$AppDatabase, $BookmarksTable, BookmarksData> {
  $$BookmarksTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $BooksTable _bookIdTable(_$AppDatabase db) => db.books
      .createAlias($_aliasNameGenerator(db.bookmarks.bookId, db.books.id));

  $$BooksTableProcessedTableManager? get bookId {
    if ($_item.bookId == null) return null;
    final manager = $$BooksTableTableManager($_db, $_db.books)
        .filter((f) => f.id($_item.bookId!));
    final item = $_typedResult.readTableOrNull(_bookIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$BookmarksTableFilterComposer
    extends Composer<_$AppDatabase, $BookmarksTable> {
  $$BookmarksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get position => $composableBuilder(
      column: $table.position, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get chapterIndex => $composableBuilder(
      column: $table.chapterIndex, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get excerpt => $composableBuilder(
      column: $table.excerpt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get previewText => $composableBuilder(
      column: $table.previewText, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get scrollOffset => $composableBuilder(
      column: $table.scrollOffset, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  $$BooksTableFilterComposer get bookId {
    final $$BooksTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.bookId,
        referencedTable: $db.books,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$BooksTableFilterComposer(
              $db: $db,
              $table: $db.books,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$BookmarksTableOrderingComposer
    extends Composer<_$AppDatabase, $BookmarksTable> {
  $$BookmarksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get position => $composableBuilder(
      column: $table.position, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get chapterIndex => $composableBuilder(
      column: $table.chapterIndex,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get excerpt => $composableBuilder(
      column: $table.excerpt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get previewText => $composableBuilder(
      column: $table.previewText, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get scrollOffset => $composableBuilder(
      column: $table.scrollOffset,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  $$BooksTableOrderingComposer get bookId {
    final $$BooksTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.bookId,
        referencedTable: $db.books,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$BooksTableOrderingComposer(
              $db: $db,
              $table: $db.books,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$BookmarksTableAnnotationComposer
    extends Composer<_$AppDatabase, $BookmarksTable> {
  $$BookmarksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  GeneratedColumn<int> get chapterIndex => $composableBuilder(
      column: $table.chapterIndex, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get excerpt =>
      $composableBuilder(column: $table.excerpt, builder: (column) => column);

  GeneratedColumn<String> get previewText => $composableBuilder(
      column: $table.previewText, builder: (column) => column);

  GeneratedColumn<int> get scrollOffset => $composableBuilder(
      column: $table.scrollOffset, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$BooksTableAnnotationComposer get bookId {
    final $$BooksTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.bookId,
        referencedTable: $db.books,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$BooksTableAnnotationComposer(
              $db: $db,
              $table: $db.books,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$BookmarksTableTableManager extends RootTableManager<
    _$AppDatabase,
    $BookmarksTable,
    BookmarksData,
    $$BookmarksTableFilterComposer,
    $$BookmarksTableOrderingComposer,
    $$BookmarksTableAnnotationComposer,
    $$BookmarksTableCreateCompanionBuilder,
    $$BookmarksTableUpdateCompanionBuilder,
    (BookmarksData, $$BookmarksTableReferences),
    BookmarksData,
    PrefetchHooks Function({bool bookId})> {
  $$BookmarksTableTableManager(_$AppDatabase db, $BookmarksTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BookmarksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BookmarksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BookmarksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> bookId = const Value.absent(),
            Value<int> position = const Value.absent(),
            Value<int?> chapterIndex = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String?> excerpt = const Value.absent(),
            Value<String?> previewText = const Value.absent(),
            Value<int?> scrollOffset = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              BookmarksCompanion(
            id: id,
            bookId: bookId,
            position: position,
            chapterIndex: chapterIndex,
            title: title,
            excerpt: excerpt,
            previewText: previewText,
            scrollOffset: scrollOffset,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String bookId,
            required int position,
            Value<int?> chapterIndex = const Value.absent(),
            required String title,
            Value<String?> excerpt = const Value.absent(),
            Value<String?> previewText = const Value.absent(),
            Value<int?> scrollOffset = const Value.absent(),
            required DateTime createdAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              BookmarksCompanion.insert(
            id: id,
            bookId: bookId,
            position: position,
            chapterIndex: chapterIndex,
            title: title,
            excerpt: excerpt,
            previewText: previewText,
            scrollOffset: scrollOffset,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$BookmarksTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({bookId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (bookId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.bookId,
                    referencedTable:
                        $$BookmarksTableReferences._bookIdTable(db),
                    referencedColumn:
                        $$BookmarksTableReferences._bookIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$BookmarksTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $BookmarksTable,
    BookmarksData,
    $$BookmarksTableFilterComposer,
    $$BookmarksTableOrderingComposer,
    $$BookmarksTableAnnotationComposer,
    $$BookmarksTableCreateCompanionBuilder,
    $$BookmarksTableUpdateCompanionBuilder,
    (BookmarksData, $$BookmarksTableReferences),
    BookmarksData,
    PrefetchHooks Function({bool bookId})>;
typedef $$NotesTableCreateCompanionBuilder = NotesCompanion Function({
  required String id,
  required String bookId,
  required String selectedText,
  required String noteContent,
  required int position,
  Value<int?> chapterIndex,
  required DateTime createdAt,
  Value<DateTime?> updatedAt,
  Value<int> rowid,
});
typedef $$NotesTableUpdateCompanionBuilder = NotesCompanion Function({
  Value<String> id,
  Value<String> bookId,
  Value<String> selectedText,
  Value<String> noteContent,
  Value<int> position,
  Value<int?> chapterIndex,
  Value<DateTime> createdAt,
  Value<DateTime?> updatedAt,
  Value<int> rowid,
});

final class $$NotesTableReferences
    extends BaseReferences<_$AppDatabase, $NotesTable, NotesData> {
  $$NotesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $BooksTable _bookIdTable(_$AppDatabase db) =>
      db.books.createAlias($_aliasNameGenerator(db.notes.bookId, db.books.id));

  $$BooksTableProcessedTableManager? get bookId {
    if ($_item.bookId == null) return null;
    final manager = $$BooksTableTableManager($_db, $_db.books)
        .filter((f) => f.id($_item.bookId!));
    final item = $_typedResult.readTableOrNull(_bookIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$NotesTableFilterComposer extends Composer<_$AppDatabase, $NotesTable> {
  $$NotesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get selectedText => $composableBuilder(
      column: $table.selectedText, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get noteContent => $composableBuilder(
      column: $table.noteContent, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get position => $composableBuilder(
      column: $table.position, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get chapterIndex => $composableBuilder(
      column: $table.chapterIndex, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  $$BooksTableFilterComposer get bookId {
    final $$BooksTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.bookId,
        referencedTable: $db.books,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$BooksTableFilterComposer(
              $db: $db,
              $table: $db.books,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$NotesTableOrderingComposer
    extends Composer<_$AppDatabase, $NotesTable> {
  $$NotesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get selectedText => $composableBuilder(
      column: $table.selectedText,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get noteContent => $composableBuilder(
      column: $table.noteContent, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get position => $composableBuilder(
      column: $table.position, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get chapterIndex => $composableBuilder(
      column: $table.chapterIndex,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  $$BooksTableOrderingComposer get bookId {
    final $$BooksTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.bookId,
        referencedTable: $db.books,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$BooksTableOrderingComposer(
              $db: $db,
              $table: $db.books,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$NotesTableAnnotationComposer
    extends Composer<_$AppDatabase, $NotesTable> {
  $$NotesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get selectedText => $composableBuilder(
      column: $table.selectedText, builder: (column) => column);

  GeneratedColumn<String> get noteContent => $composableBuilder(
      column: $table.noteContent, builder: (column) => column);

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  GeneratedColumn<int> get chapterIndex => $composableBuilder(
      column: $table.chapterIndex, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$BooksTableAnnotationComposer get bookId {
    final $$BooksTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.bookId,
        referencedTable: $db.books,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$BooksTableAnnotationComposer(
              $db: $db,
              $table: $db.books,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$NotesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $NotesTable,
    NotesData,
    $$NotesTableFilterComposer,
    $$NotesTableOrderingComposer,
    $$NotesTableAnnotationComposer,
    $$NotesTableCreateCompanionBuilder,
    $$NotesTableUpdateCompanionBuilder,
    (NotesData, $$NotesTableReferences),
    NotesData,
    PrefetchHooks Function({bool bookId})> {
  $$NotesTableTableManager(_$AppDatabase db, $NotesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$NotesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$NotesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$NotesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> bookId = const Value.absent(),
            Value<String> selectedText = const Value.absent(),
            Value<String> noteContent = const Value.absent(),
            Value<int> position = const Value.absent(),
            Value<int?> chapterIndex = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              NotesCompanion(
            id: id,
            bookId: bookId,
            selectedText: selectedText,
            noteContent: noteContent,
            position: position,
            chapterIndex: chapterIndex,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String bookId,
            required String selectedText,
            required String noteContent,
            required int position,
            Value<int?> chapterIndex = const Value.absent(),
            required DateTime createdAt,
            Value<DateTime?> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              NotesCompanion.insert(
            id: id,
            bookId: bookId,
            selectedText: selectedText,
            noteContent: noteContent,
            position: position,
            chapterIndex: chapterIndex,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$NotesTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({bookId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (bookId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.bookId,
                    referencedTable: $$NotesTableReferences._bookIdTable(db),
                    referencedColumn:
                        $$NotesTableReferences._bookIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$NotesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $NotesTable,
    NotesData,
    $$NotesTableFilterComposer,
    $$NotesTableOrderingComposer,
    $$NotesTableAnnotationComposer,
    $$NotesTableCreateCompanionBuilder,
    $$NotesTableUpdateCompanionBuilder,
    (NotesData, $$NotesTableReferences),
    NotesData,
    PrefetchHooks Function({bool bookId})>;
typedef $$ReadingProgressesTableCreateCompanionBuilder
    = ReadingProgressesCompanion Function({
  required String id,
  required String bookId,
  required int position,
  required double percentage,
  required DateTime lastRead,
  Value<int> chapterIndex,
  Value<int?> scrollOffset,
  Value<int> rowid,
});
typedef $$ReadingProgressesTableUpdateCompanionBuilder
    = ReadingProgressesCompanion Function({
  Value<String> id,
  Value<String> bookId,
  Value<int> position,
  Value<double> percentage,
  Value<DateTime> lastRead,
  Value<int> chapterIndex,
  Value<int?> scrollOffset,
  Value<int> rowid,
});

final class $$ReadingProgressesTableReferences extends BaseReferences<
    _$AppDatabase, $ReadingProgressesTable, ReadingProgressesData> {
  $$ReadingProgressesTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $BooksTable _bookIdTable(_$AppDatabase db) => db.books.createAlias(
      $_aliasNameGenerator(db.readingProgresses.bookId, db.books.id));

  $$BooksTableProcessedTableManager? get bookId {
    if ($_item.bookId == null) return null;
    final manager = $$BooksTableTableManager($_db, $_db.books)
        .filter((f) => f.id($_item.bookId!));
    final item = $_typedResult.readTableOrNull(_bookIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$ReadingProgressesTableFilterComposer
    extends Composer<_$AppDatabase, $ReadingProgressesTable> {
  $$ReadingProgressesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get position => $composableBuilder(
      column: $table.position, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get percentage => $composableBuilder(
      column: $table.percentage, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastRead => $composableBuilder(
      column: $table.lastRead, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get chapterIndex => $composableBuilder(
      column: $table.chapterIndex, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get scrollOffset => $composableBuilder(
      column: $table.scrollOffset, builder: (column) => ColumnFilters(column));

  $$BooksTableFilterComposer get bookId {
    final $$BooksTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.bookId,
        referencedTable: $db.books,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$BooksTableFilterComposer(
              $db: $db,
              $table: $db.books,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ReadingProgressesTableOrderingComposer
    extends Composer<_$AppDatabase, $ReadingProgressesTable> {
  $$ReadingProgressesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get position => $composableBuilder(
      column: $table.position, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get percentage => $composableBuilder(
      column: $table.percentage, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastRead => $composableBuilder(
      column: $table.lastRead, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get chapterIndex => $composableBuilder(
      column: $table.chapterIndex,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get scrollOffset => $composableBuilder(
      column: $table.scrollOffset,
      builder: (column) => ColumnOrderings(column));

  $$BooksTableOrderingComposer get bookId {
    final $$BooksTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.bookId,
        referencedTable: $db.books,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$BooksTableOrderingComposer(
              $db: $db,
              $table: $db.books,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ReadingProgressesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ReadingProgressesTable> {
  $$ReadingProgressesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  GeneratedColumn<double> get percentage => $composableBuilder(
      column: $table.percentage, builder: (column) => column);

  GeneratedColumn<DateTime> get lastRead =>
      $composableBuilder(column: $table.lastRead, builder: (column) => column);

  GeneratedColumn<int> get chapterIndex => $composableBuilder(
      column: $table.chapterIndex, builder: (column) => column);

  GeneratedColumn<int> get scrollOffset => $composableBuilder(
      column: $table.scrollOffset, builder: (column) => column);

  $$BooksTableAnnotationComposer get bookId {
    final $$BooksTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.bookId,
        referencedTable: $db.books,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$BooksTableAnnotationComposer(
              $db: $db,
              $table: $db.books,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ReadingProgressesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ReadingProgressesTable,
    ReadingProgressesData,
    $$ReadingProgressesTableFilterComposer,
    $$ReadingProgressesTableOrderingComposer,
    $$ReadingProgressesTableAnnotationComposer,
    $$ReadingProgressesTableCreateCompanionBuilder,
    $$ReadingProgressesTableUpdateCompanionBuilder,
    (ReadingProgressesData, $$ReadingProgressesTableReferences),
    ReadingProgressesData,
    PrefetchHooks Function({bool bookId})> {
  $$ReadingProgressesTableTableManager(
      _$AppDatabase db, $ReadingProgressesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ReadingProgressesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ReadingProgressesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ReadingProgressesTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> bookId = const Value.absent(),
            Value<int> position = const Value.absent(),
            Value<double> percentage = const Value.absent(),
            Value<DateTime> lastRead = const Value.absent(),
            Value<int> chapterIndex = const Value.absent(),
            Value<int?> scrollOffset = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ReadingProgressesCompanion(
            id: id,
            bookId: bookId,
            position: position,
            percentage: percentage,
            lastRead: lastRead,
            chapterIndex: chapterIndex,
            scrollOffset: scrollOffset,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String bookId,
            required int position,
            required double percentage,
            required DateTime lastRead,
            Value<int> chapterIndex = const Value.absent(),
            Value<int?> scrollOffset = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ReadingProgressesCompanion.insert(
            id: id,
            bookId: bookId,
            position: position,
            percentage: percentage,
            lastRead: lastRead,
            chapterIndex: chapterIndex,
            scrollOffset: scrollOffset,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$ReadingProgressesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({bookId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (bookId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.bookId,
                    referencedTable:
                        $$ReadingProgressesTableReferences._bookIdTable(db),
                    referencedColumn:
                        $$ReadingProgressesTableReferences._bookIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$ReadingProgressesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ReadingProgressesTable,
    ReadingProgressesData,
    $$ReadingProgressesTableFilterComposer,
    $$ReadingProgressesTableOrderingComposer,
    $$ReadingProgressesTableAnnotationComposer,
    $$ReadingProgressesTableCreateCompanionBuilder,
    $$ReadingProgressesTableUpdateCompanionBuilder,
    (ReadingProgressesData, $$ReadingProgressesTableReferences),
    ReadingProgressesData,
    PrefetchHooks Function({bool bookId})>;
typedef $$ReaderPreferencesTableCreateCompanionBuilder
    = ReaderPreferencesCompanion Function({
  Value<String> id,
  Value<String> themeMode,
  Value<double> fontSize,
  Value<double> lineHeight,
  Value<double> horizontalMargin,
  Value<String> fontFamily,
  Value<bool> fullscreenEnabled,
  Value<bool> autoHideControls,
  Value<bool> justifiedText,
  Value<double?> brightnessOverride,
  Value<double> paragraphSpacing,
  Value<String> textAlign,
  Value<bool> showPageProgress,
  Value<bool> showBatteryStatus,
  Value<bool> showClock,
  Value<bool> tapToTurnPage,
  Value<bool> keepScreenAwake,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});
typedef $$ReaderPreferencesTableUpdateCompanionBuilder
    = ReaderPreferencesCompanion Function({
  Value<String> id,
  Value<String> themeMode,
  Value<double> fontSize,
  Value<double> lineHeight,
  Value<double> horizontalMargin,
  Value<String> fontFamily,
  Value<bool> fullscreenEnabled,
  Value<bool> autoHideControls,
  Value<bool> justifiedText,
  Value<double?> brightnessOverride,
  Value<double> paragraphSpacing,
  Value<String> textAlign,
  Value<bool> showPageProgress,
  Value<bool> showBatteryStatus,
  Value<bool> showClock,
  Value<bool> tapToTurnPage,
  Value<bool> keepScreenAwake,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$ReaderPreferencesTableFilterComposer
    extends Composer<_$AppDatabase, $ReaderPreferencesTable> {
  $$ReaderPreferencesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get themeMode => $composableBuilder(
      column: $table.themeMode, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get fontSize => $composableBuilder(
      column: $table.fontSize, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get lineHeight => $composableBuilder(
      column: $table.lineHeight, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get horizontalMargin => $composableBuilder(
      column: $table.horizontalMargin,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get fontFamily => $composableBuilder(
      column: $table.fontFamily, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get fullscreenEnabled => $composableBuilder(
      column: $table.fullscreenEnabled,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get autoHideControls => $composableBuilder(
      column: $table.autoHideControls,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get justifiedText => $composableBuilder(
      column: $table.justifiedText, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get brightnessOverride => $composableBuilder(
      column: $table.brightnessOverride,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get paragraphSpacing => $composableBuilder(
      column: $table.paragraphSpacing,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get textAlign => $composableBuilder(
      column: $table.textAlign, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get showPageProgress => $composableBuilder(
      column: $table.showPageProgress,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get showBatteryStatus => $composableBuilder(
      column: $table.showBatteryStatus,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get showClock => $composableBuilder(
      column: $table.showClock, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get tapToTurnPage => $composableBuilder(
      column: $table.tapToTurnPage, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get keepScreenAwake => $composableBuilder(
      column: $table.keepScreenAwake,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$ReaderPreferencesTableOrderingComposer
    extends Composer<_$AppDatabase, $ReaderPreferencesTable> {
  $$ReaderPreferencesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get themeMode => $composableBuilder(
      column: $table.themeMode, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get fontSize => $composableBuilder(
      column: $table.fontSize, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get lineHeight => $composableBuilder(
      column: $table.lineHeight, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get horizontalMargin => $composableBuilder(
      column: $table.horizontalMargin,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get fontFamily => $composableBuilder(
      column: $table.fontFamily, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get fullscreenEnabled => $composableBuilder(
      column: $table.fullscreenEnabled,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get autoHideControls => $composableBuilder(
      column: $table.autoHideControls,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get justifiedText => $composableBuilder(
      column: $table.justifiedText,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get brightnessOverride => $composableBuilder(
      column: $table.brightnessOverride,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get paragraphSpacing => $composableBuilder(
      column: $table.paragraphSpacing,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get textAlign => $composableBuilder(
      column: $table.textAlign, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get showPageProgress => $composableBuilder(
      column: $table.showPageProgress,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get showBatteryStatus => $composableBuilder(
      column: $table.showBatteryStatus,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get showClock => $composableBuilder(
      column: $table.showClock, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get tapToTurnPage => $composableBuilder(
      column: $table.tapToTurnPage,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get keepScreenAwake => $composableBuilder(
      column: $table.keepScreenAwake,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$ReaderPreferencesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ReaderPreferencesTable> {
  $$ReaderPreferencesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get themeMode =>
      $composableBuilder(column: $table.themeMode, builder: (column) => column);

  GeneratedColumn<double> get fontSize =>
      $composableBuilder(column: $table.fontSize, builder: (column) => column);

  GeneratedColumn<double> get lineHeight => $composableBuilder(
      column: $table.lineHeight, builder: (column) => column);

  GeneratedColumn<double> get horizontalMargin => $composableBuilder(
      column: $table.horizontalMargin, builder: (column) => column);

  GeneratedColumn<String> get fontFamily => $composableBuilder(
      column: $table.fontFamily, builder: (column) => column);

  GeneratedColumn<bool> get fullscreenEnabled => $composableBuilder(
      column: $table.fullscreenEnabled, builder: (column) => column);

  GeneratedColumn<bool> get autoHideControls => $composableBuilder(
      column: $table.autoHideControls, builder: (column) => column);

  GeneratedColumn<bool> get justifiedText => $composableBuilder(
      column: $table.justifiedText, builder: (column) => column);

  GeneratedColumn<double> get brightnessOverride => $composableBuilder(
      column: $table.brightnessOverride, builder: (column) => column);

  GeneratedColumn<double> get paragraphSpacing => $composableBuilder(
      column: $table.paragraphSpacing, builder: (column) => column);

  GeneratedColumn<String> get textAlign =>
      $composableBuilder(column: $table.textAlign, builder: (column) => column);

  GeneratedColumn<bool> get showPageProgress => $composableBuilder(
      column: $table.showPageProgress, builder: (column) => column);

  GeneratedColumn<bool> get showBatteryStatus => $composableBuilder(
      column: $table.showBatteryStatus, builder: (column) => column);

  GeneratedColumn<bool> get showClock =>
      $composableBuilder(column: $table.showClock, builder: (column) => column);

  GeneratedColumn<bool> get tapToTurnPage => $composableBuilder(
      column: $table.tapToTurnPage, builder: (column) => column);

  GeneratedColumn<bool> get keepScreenAwake => $composableBuilder(
      column: $table.keepScreenAwake, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$ReaderPreferencesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ReaderPreferencesTable,
    ReaderPreferencesData,
    $$ReaderPreferencesTableFilterComposer,
    $$ReaderPreferencesTableOrderingComposer,
    $$ReaderPreferencesTableAnnotationComposer,
    $$ReaderPreferencesTableCreateCompanionBuilder,
    $$ReaderPreferencesTableUpdateCompanionBuilder,
    (
      ReaderPreferencesData,
      BaseReferences<_$AppDatabase, $ReaderPreferencesTable,
          ReaderPreferencesData>
    ),
    ReaderPreferencesData,
    PrefetchHooks Function()> {
  $$ReaderPreferencesTableTableManager(
      _$AppDatabase db, $ReaderPreferencesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ReaderPreferencesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ReaderPreferencesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ReaderPreferencesTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> themeMode = const Value.absent(),
            Value<double> fontSize = const Value.absent(),
            Value<double> lineHeight = const Value.absent(),
            Value<double> horizontalMargin = const Value.absent(),
            Value<String> fontFamily = const Value.absent(),
            Value<bool> fullscreenEnabled = const Value.absent(),
            Value<bool> autoHideControls = const Value.absent(),
            Value<bool> justifiedText = const Value.absent(),
            Value<double?> brightnessOverride = const Value.absent(),
            Value<double> paragraphSpacing = const Value.absent(),
            Value<String> textAlign = const Value.absent(),
            Value<bool> showPageProgress = const Value.absent(),
            Value<bool> showBatteryStatus = const Value.absent(),
            Value<bool> showClock = const Value.absent(),
            Value<bool> tapToTurnPage = const Value.absent(),
            Value<bool> keepScreenAwake = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ReaderPreferencesCompanion(
            id: id,
            themeMode: themeMode,
            fontSize: fontSize,
            lineHeight: lineHeight,
            horizontalMargin: horizontalMargin,
            fontFamily: fontFamily,
            fullscreenEnabled: fullscreenEnabled,
            autoHideControls: autoHideControls,
            justifiedText: justifiedText,
            brightnessOverride: brightnessOverride,
            paragraphSpacing: paragraphSpacing,
            textAlign: textAlign,
            showPageProgress: showPageProgress,
            showBatteryStatus: showBatteryStatus,
            showClock: showClock,
            tapToTurnPage: tapToTurnPage,
            keepScreenAwake: keepScreenAwake,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> themeMode = const Value.absent(),
            Value<double> fontSize = const Value.absent(),
            Value<double> lineHeight = const Value.absent(),
            Value<double> horizontalMargin = const Value.absent(),
            Value<String> fontFamily = const Value.absent(),
            Value<bool> fullscreenEnabled = const Value.absent(),
            Value<bool> autoHideControls = const Value.absent(),
            Value<bool> justifiedText = const Value.absent(),
            Value<double?> brightnessOverride = const Value.absent(),
            Value<double> paragraphSpacing = const Value.absent(),
            Value<String> textAlign = const Value.absent(),
            Value<bool> showPageProgress = const Value.absent(),
            Value<bool> showBatteryStatus = const Value.absent(),
            Value<bool> showClock = const Value.absent(),
            Value<bool> tapToTurnPage = const Value.absent(),
            Value<bool> keepScreenAwake = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ReaderPreferencesCompanion.insert(
            id: id,
            themeMode: themeMode,
            fontSize: fontSize,
            lineHeight: lineHeight,
            horizontalMargin: horizontalMargin,
            fontFamily: fontFamily,
            fullscreenEnabled: fullscreenEnabled,
            autoHideControls: autoHideControls,
            justifiedText: justifiedText,
            brightnessOverride: brightnessOverride,
            paragraphSpacing: paragraphSpacing,
            textAlign: textAlign,
            showPageProgress: showPageProgress,
            showBatteryStatus: showBatteryStatus,
            showClock: showClock,
            tapToTurnPage: tapToTurnPage,
            keepScreenAwake: keepScreenAwake,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ReaderPreferencesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ReaderPreferencesTable,
    ReaderPreferencesData,
    $$ReaderPreferencesTableFilterComposer,
    $$ReaderPreferencesTableOrderingComposer,
    $$ReaderPreferencesTableAnnotationComposer,
    $$ReaderPreferencesTableCreateCompanionBuilder,
    $$ReaderPreferencesTableUpdateCompanionBuilder,
    (
      ReaderPreferencesData,
      BaseReferences<_$AppDatabase, $ReaderPreferencesTable,
          ReaderPreferencesData>
    ),
    ReaderPreferencesData,
    PrefetchHooks Function()>;
typedef $$SearchIndexTableCreateCompanionBuilder = SearchIndexCompanion
    Function({
  Value<int> id,
  required String bookId,
  required int chapterIndex,
  required String contentText,
});
typedef $$SearchIndexTableUpdateCompanionBuilder = SearchIndexCompanion
    Function({
  Value<int> id,
  Value<String> bookId,
  Value<int> chapterIndex,
  Value<String> contentText,
});

final class $$SearchIndexTableReferences
    extends BaseReferences<_$AppDatabase, $SearchIndexTable, SearchIndexData> {
  $$SearchIndexTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $BooksTable _bookIdTable(_$AppDatabase db) => db.books
      .createAlias($_aliasNameGenerator(db.searchIndex.bookId, db.books.id));

  $$BooksTableProcessedTableManager? get bookId {
    if ($_item.bookId == null) return null;
    final manager = $$BooksTableTableManager($_db, $_db.books)
        .filter((f) => f.id($_item.bookId!));
    final item = $_typedResult.readTableOrNull(_bookIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$SearchIndexTableFilterComposer
    extends Composer<_$AppDatabase, $SearchIndexTable> {
  $$SearchIndexTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get chapterIndex => $composableBuilder(
      column: $table.chapterIndex, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get contentText => $composableBuilder(
      column: $table.contentText, builder: (column) => ColumnFilters(column));

  $$BooksTableFilterComposer get bookId {
    final $$BooksTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.bookId,
        referencedTable: $db.books,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$BooksTableFilterComposer(
              $db: $db,
              $table: $db.books,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$SearchIndexTableOrderingComposer
    extends Composer<_$AppDatabase, $SearchIndexTable> {
  $$SearchIndexTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get chapterIndex => $composableBuilder(
      column: $table.chapterIndex,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get contentText => $composableBuilder(
      column: $table.contentText, builder: (column) => ColumnOrderings(column));

  $$BooksTableOrderingComposer get bookId {
    final $$BooksTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.bookId,
        referencedTable: $db.books,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$BooksTableOrderingComposer(
              $db: $db,
              $table: $db.books,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$SearchIndexTableAnnotationComposer
    extends Composer<_$AppDatabase, $SearchIndexTable> {
  $$SearchIndexTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get chapterIndex => $composableBuilder(
      column: $table.chapterIndex, builder: (column) => column);

  GeneratedColumn<String> get contentText => $composableBuilder(
      column: $table.contentText, builder: (column) => column);

  $$BooksTableAnnotationComposer get bookId {
    final $$BooksTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.bookId,
        referencedTable: $db.books,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$BooksTableAnnotationComposer(
              $db: $db,
              $table: $db.books,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$SearchIndexTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SearchIndexTable,
    SearchIndexData,
    $$SearchIndexTableFilterComposer,
    $$SearchIndexTableOrderingComposer,
    $$SearchIndexTableAnnotationComposer,
    $$SearchIndexTableCreateCompanionBuilder,
    $$SearchIndexTableUpdateCompanionBuilder,
    (SearchIndexData, $$SearchIndexTableReferences),
    SearchIndexData,
    PrefetchHooks Function({bool bookId})> {
  $$SearchIndexTableTableManager(_$AppDatabase db, $SearchIndexTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SearchIndexTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SearchIndexTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SearchIndexTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> bookId = const Value.absent(),
            Value<int> chapterIndex = const Value.absent(),
            Value<String> contentText = const Value.absent(),
          }) =>
              SearchIndexCompanion(
            id: id,
            bookId: bookId,
            chapterIndex: chapterIndex,
            contentText: contentText,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String bookId,
            required int chapterIndex,
            required String contentText,
          }) =>
              SearchIndexCompanion.insert(
            id: id,
            bookId: bookId,
            chapterIndex: chapterIndex,
            contentText: contentText,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$SearchIndexTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({bookId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (bookId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.bookId,
                    referencedTable:
                        $$SearchIndexTableReferences._bookIdTable(db),
                    referencedColumn:
                        $$SearchIndexTableReferences._bookIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$SearchIndexTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SearchIndexTable,
    SearchIndexData,
    $$SearchIndexTableFilterComposer,
    $$SearchIndexTableOrderingComposer,
    $$SearchIndexTableAnnotationComposer,
    $$SearchIndexTableCreateCompanionBuilder,
    $$SearchIndexTableUpdateCompanionBuilder,
    (SearchIndexData, $$SearchIndexTableReferences),
    SearchIndexData,
    PrefetchHooks Function({bool bookId})>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$BooksTableTableManager get books =>
      $$BooksTableTableManager(_db, _db.books);
  $$BookmarksTableTableManager get bookmarks =>
      $$BookmarksTableTableManager(_db, _db.bookmarks);
  $$NotesTableTableManager get notes =>
      $$NotesTableTableManager(_db, _db.notes);
  $$ReadingProgressesTableTableManager get readingProgresses =>
      $$ReadingProgressesTableTableManager(_db, _db.readingProgresses);
  $$ReaderPreferencesTableTableManager get readerPreferences =>
      $$ReaderPreferencesTableTableManager(_db, _db.readerPreferences);
  $$SearchIndexTableTableManager get searchIndex =>
      $$SearchIndexTableTableManager(_db, _db.searchIndex);
}
