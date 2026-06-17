import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:porbi/models/book.dart';

part 'database.g.dart';

// ─── Tables ─────────────────────────────────────────────────

@DataClassName('BooksData')
class Books extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get author => text().nullable()();
  TextColumn get filePath => text()();
  TextColumn get fileType => text()();
  IntColumn get fileSize => integer().withDefault(const Constant(0))();
  TextColumn get coverPath => text().nullable()();
  DateTimeColumn get lastOpened => dateTime().nullable()();
  DateTimeColumn get addedAt => dateTime()();
  BoolColumn get isFavorite => boolean().withDefault(const Constant(false))();
  IntColumn get totalPages => integer().withDefault(const Constant(0))();
  IntColumn get currentPage => integer().withDefault(const Constant(0))();
  RealColumn get readingProgress => real().withDefault(const Constant(0.0))();
  TextColumn get fileHash => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('BookmarksData')
class Bookmarks extends Table {
  TextColumn get id => text()();
  TextColumn get bookId => text().references(Books, #id)();
  IntColumn get position => integer()();
  IntColumn get chapterIndex => integer().nullable()();
  TextColumn get title => text()();
  TextColumn get excerpt => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('NotesData')
class Notes extends Table {
  TextColumn get id => text()();
  TextColumn get bookId => text().references(Books, #id)();
  TextColumn get selectedText => text()();
  TextColumn get noteContent => text()();
  IntColumn get position => integer()();
  IntColumn get chapterIndex => integer().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('ReadingProgressesData')
class ReadingProgresses extends Table {
  TextColumn get id => text()();
  TextColumn get bookId => text().references(Books, #id)();
  IntColumn get position => integer()();
  RealColumn get percentage => real()();
  DateTimeColumn get lastRead => dateTime()();
  IntColumn get chapterIndex => integer().withDefault(const Constant(0))();
  IntColumn get scrollOffset => integer().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

// ─── Reader Settings & Search ───────────────────────────────

@DataClassName('ReaderSettingsData')
class ReaderSettings extends Table {
  TextColumn get id => text()();
  RealColumn get fontSize => real().withDefault(const Constant(16.0))();
  TextColumn get fontFamily => text().withDefault(const Constant('System'))();
  RealColumn get lineHeight => real().withDefault(const Constant(1.5))();
  TextColumn get themeMode => text().withDefault(const Constant('light'))();
  RealColumn get margin => real().withDefault(const Constant(16.0))();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('SearchIndexData')
class SearchIndex extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get bookId => text().references(Books, #id)();
  IntColumn get chapterIndex => integer()();
  TextColumn get contentText => text()();
}

// ─── Database ───────────────────────────────────────────────

@DriftDatabase(tables: [Books, Bookmarks, Notes, ReadingProgresses, ReaderSettings, SearchIndex])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  AppDatabase.forTesting(super.e);

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) async {
          await m.createAll();
        },
        onUpgrade: (Migrator m, int from, int to) async {
          if (from < 2) {
            await m.addColumn(books, books.fileHash);
            await m.addColumn(books, books.author);
            await m.addColumn(books, books.fileSize);
            await m.createTable(readerSettings);
            await m.createTable(searchIndex);
          }
        },
      );

  // ─── Book Operations ──────────────────────────────────────

  Future<List<Book>> getAllBooks() async {
    final rows = await select(books).get();
    return rows.map(_bookFromRow).toList();
  }

  Future<Book?> getBookById(String id) async {
    final row = await (select(
      books,
    )..where((b) => b.id.equals(id))).getSingleOrNull();
    return row != null ? _bookFromRow(row) : null;
  }

  Future<Book?> getBookByHash(String hash) async {
    final row = await (select(
      books,
    )..where((b) => b.fileHash.equals(hash))).getSingleOrNull();
    return row != null ? _bookFromRow(row) : null;
  }

  Stream<List<Book>> watchAllBooks() {
    return select(books).watch().map((rows) => rows.map(_bookFromRow).toList());
  }

  Stream<List<Book>> watchRecentBooks({int limit = 10}) {
    return (select(books)
          ..where((b) => b.lastOpened.isNotNull())
          ..orderBy([(b) => OrderingTerm.desc(b.lastOpened)])
          ..limit(limit))
        .watch()
        .map((rows) => rows.map(_bookFromRow).toList());
  }

  Stream<List<Book>> watchFavoriteBooks() {
    return (select(books)..where((b) => b.isFavorite.equals(true))).watch().map(
      (rows) => rows.map(_bookFromRow).toList(),
    );
  }

  Future<void> insertBook(Book book) async {
    await into(books).insert(_bookToCompanion(book));
  }

  Future<void> updateBook(Book book) async {
    await (update(
      books,
    )..where((b) => b.id.equals(book.id))).write(_bookToCompanion(book));
  }

  Future<void> deleteBook(String id) async {
    await (delete(bookmarks)..where((b) => b.bookId.equals(id))).go();
    await (delete(notes)..where((n) => n.bookId.equals(id))).go();
    await (delete(readingProgresses)..where((r) => r.bookId.equals(id))).go();
    await (delete(books)..where((b) => b.id.equals(id))).go();
  }

  Future<void> toggleFavorite(String id) async {
    final book = await getBookById(id);
    if (book != null) {
      await updateBook(book.copyWith(isFavorite: !book.isFavorite));
    }
  }

  // ─── Bookmark Operations ──────────────────────────────────

  Future<List<BookmarksData>> getBookmarksForBook(String bookId) async {
    return (select(bookmarks)
          ..where((b) => b.bookId.equals(bookId))
          ..orderBy([(b) => OrderingTerm.asc(b.position)]))
        .get();
  }

  Stream<List<BookmarksData>> watchBookmarksForBook(String bookId) {
    return (select(bookmarks)
          ..where((b) => b.bookId.equals(bookId))
          ..orderBy([(b) => OrderingTerm.asc(b.position)]))
        .watch();
  }

  Future<void> insertBookmark(BookmarksCompanion bookmark) async {
    await into(bookmarks).insert(bookmark);
  }

  Future<void> updateBookmark(BookmarksCompanion bookmark) async {
    await (update(
      bookmarks,
    )..where((b) => b.id.equals(bookmark.id.value))).write(bookmark);
  }

  Future<void> deleteBookmark(String id) async {
    await (delete(bookmarks)..where((b) => b.id.equals(id))).go();
  }

  // ─── Note Operations ──────────────────────────────────────

  Future<List<NotesData>> getNotesForBook(String bookId) async {
    return (select(notes)
          ..where((n) => n.bookId.equals(bookId))
          ..orderBy([(n) => OrderingTerm.asc(n.position)]))
        .get();
  }

  Stream<List<NotesData>> watchNotesForBook(String bookId) {
    return (select(notes)
          ..where((n) => n.bookId.equals(bookId))
          ..orderBy([(n) => OrderingTerm.asc(n.position)]))
        .watch();
  }

  Future<List<NotesData>> getAllNotes() async {
    return select(notes).get();
  }

  Future<void> insertNote(NotesCompanion note) async {
    await into(notes).insert(note);
  }

  Future<void> updateNote(NotesCompanion note) async {
    await (update(notes)..where((n) => n.id.equals(note.id.value))).write(note);
  }

  Future<void> deleteNote(String id) async {
    await (delete(notes)..where((n) => n.id.equals(id))).go();
  }

  // ─── Reading Progress Operations ──────────────────────────

  Future<ReadingProgressesData?> getProgressForBook(String bookId) async {
    return (select(
      readingProgresses,
    )..where((r) => r.bookId.equals(bookId))).getSingleOrNull();
  }

  Stream<ReadingProgressesData?> watchProgressForBook(String bookId) {
    return (select(
      readingProgresses,
    )..where((r) => r.bookId.equals(bookId))).watchSingleOrNull();
  }

  Future<void> upsertProgress(ReadingProgressesCompanion progress) async {
    await into(readingProgresses).insertOnConflictUpdate(progress);
  }

  // ─── Backup / Export ──────────────────────────────────────

  Future<Map<String, dynamic>> exportAll() async {
    final allBooks = await select(books).get();
    final allBookmarks = await select(bookmarks).get();
    final allNotes = await select(notes).get();
    final allProgress = await select(readingProgresses).get();
    final allSettings = await select(readerSettings).get();
    final allSearchIndex = await select(searchIndex).get();

    return {
      'version': 1,
      'exportedAt': DateTime.now().toIso8601String(),
      'books': allBooks
          .map(
            (b) => {
              'id': b.id,
              'title': b.title,
              'author': b.author,
              'filePath': b.filePath,
              'fileType': b.fileType,
              'fileSize': b.fileSize,
              'coverPath': b.coverPath,
              'lastOpened': b.lastOpened?.toIso8601String(),
              'addedAt': b.addedAt.toIso8601String(),
              'isFavorite': b.isFavorite,
              'totalPages': b.totalPages,
              'currentPage': b.currentPage,
              'readingProgress': b.readingProgress,
              'fileHash': b.fileHash,
            },
          )
          .toList(),
      'bookmarks': allBookmarks
          .map(
            (b) => {
              'id': b.id,
              'bookId': b.bookId,
              'position': b.position,
              'chapterIndex': b.chapterIndex,
              'title': b.title,
              'excerpt': b.excerpt,
              'createdAt': b.createdAt.toIso8601String(),
            },
          )
          .toList(),
      'notes': allNotes
          .map(
            (n) => {
              'id': n.id,
              'bookId': n.bookId,
              'selectedText': n.selectedText,
              'noteContent': n.noteContent,
              'position': n.position,
              'chapterIndex': n.chapterIndex,
              'createdAt': n.createdAt.toIso8601String(),
              'updatedAt': n.updatedAt?.toIso8601String(),
            },
          )
          .toList(),
      'readingProgress': allProgress
          .map(
            (r) => {
              'id': r.id,
              'bookId': r.bookId,
              'position': r.position,
              'percentage': r.percentage,
              'lastRead': r.lastRead.toIso8601String(),
              'chapterIndex': r.chapterIndex,
              'scrollOffset': r.scrollOffset,
            },
          )
          .toList(),
      'readerSettings': allSettings
          .map(
            (s) => {
              'id': s.id,
              'fontSize': s.fontSize,
              'fontFamily': s.fontFamily,
              'lineHeight': s.lineHeight,
              'themeMode': s.themeMode,
              'margin': s.margin,
            },
          )
          .toList(),
      'searchIndex': allSearchIndex
          .map(
            (s) => {
              'bookId': s.bookId,
              'chapterIndex': s.chapterIndex,
              'contentText': s.contentText,
            },
          )
          .toList(),
    };
  }

  Future<void> importAll(Map<String, dynamic> data) async {
    await transaction(() async {
      // Clear existing data
      await delete(searchIndex).go();
      await delete(readerSettings).go();
      await delete(readingProgresses).go();
      await delete(notes).go();
      await delete(bookmarks).go();
      await delete(books).go();

      // Import books
      final booksList = data['books'] as List? ?? [];
      for (final b in booksList) {
        await into(books).insert(
          BooksCompanion.insert(
            id: b['id'] as String,
            title: b['title'] as String,
            author: Value(b['author'] as String?),
            filePath: b['filePath'] as String,
            fileType: b['fileType'] as String,
            fileSize: Value(b['fileSize'] as int? ?? 0),
            coverPath: Value(b['coverPath'] as String?),
            lastOpened: Value(
              b['lastOpened'] != null
                  ? DateTime.parse(b['lastOpened'] as String)
                  : null,
            ),
            addedAt: DateTime.parse(b['addedAt'] as String),
            isFavorite: Value(b['isFavorite'] as bool? ?? false),
            totalPages: Value(b['totalPages'] as int? ?? 0),
            currentPage: Value(b['currentPage'] as int? ?? 0),
            readingProgress: Value((b['readingProgress'] as num?)?.toDouble() ?? 0.0),
            fileHash: Value(b['fileHash'] as String?),
          ),
        );
      }

      // Import bookmarks
      final bookmarksList = data['bookmarks'] as List? ?? [];
      for (final b in bookmarksList) {
        await into(bookmarks).insert(
          BookmarksCompanion.insert(
            id: b['id'] as String,
            bookId: b['bookId'] as String,
            position: b['position'] as int,
            chapterIndex: Value(b['chapterIndex'] as int?),
            title: b['title'] as String,
            excerpt: Value(b['excerpt'] as String?),
            createdAt: DateTime.parse(b['createdAt'] as String),
          ),
        );
      }

      // Import notes
      final notesList = data['notes'] as List? ?? [];
      for (final n in notesList) {
        await into(notes).insert(
          NotesCompanion.insert(
            id: n['id'] as String,
            bookId: n['bookId'] as String,
            selectedText: n['selectedText'] as String,
            noteContent: n['noteContent'] as String,
            position: n['position'] as int,
            chapterIndex: Value(n['chapterIndex'] as int?),
            createdAt: DateTime.parse(n['createdAt'] as String),
            updatedAt: Value(
              n['updatedAt'] != null
                  ? DateTime.parse(n['updatedAt'] as String)
                  : null,
            ),
          ),
        );
      }

      // Import reading progress
      final progressList = data['readingProgress'] as List? ?? [];
      for (final r in progressList) {
        await into(readingProgresses).insert(
          ReadingProgressesCompanion.insert(
            id: r['id'] as String,
            bookId: r['bookId'] as String,
            position: r['position'] as int,
            percentage: (r['percentage'] as num).toDouble(),
            lastRead: DateTime.parse(r['lastRead'] as String),
            chapterIndex: Value(r['chapterIndex'] as int? ?? 0),
            scrollOffset: Value(r['scrollOffset'] as int?),
          ),
        );
      }

      // Import settings
      final settingsList = data['readerSettings'] as List? ?? [];
      for (final s in settingsList) {
        await into(readerSettings).insert(
          ReaderSettingsCompanion.insert(
            id: s['id'] as String,
            fontSize: Value((s['fontSize'] as num?)?.toDouble() ?? 16.0),
            fontFamily: Value(s['fontFamily'] as String? ?? 'System'),
            lineHeight: Value((s['lineHeight'] as num?)?.toDouble() ?? 1.5),
            themeMode: Value(s['themeMode'] as String? ?? 'light'),
            margin: Value((s['margin'] as num?)?.toDouble() ?? 16.0),
          ),
        );
      }

      // Import search index
      final searchList = data['searchIndex'] as List? ?? [];
      for (final s in searchList) {
        await into(searchIndex).insert(
          SearchIndexCompanion.insert(
            bookId: s['bookId'] as String,
            chapterIndex: s['chapterIndex'] as int,
            contentText: s['contentText'] as String,
          ),
        );
      }
    });
  }

  // ─── Helpers ──────────────────────────────────────────────

  Book _bookFromRow(BooksData row) {
    return Book(
      id: row.id,
      title: row.title,
      filePath: row.filePath,
      fileType:
          FileTypeExtension.fromExtension('.${row.fileType}') ?? FileType.txt,
      coverPath: row.coverPath,
      lastOpened: row.lastOpened,
      addedAt: row.addedAt,
      isFavorite: row.isFavorite,
      totalPages: row.totalPages,
      currentPage: row.currentPage,
      readingProgress: row.readingProgress,
    );
  }

  BooksCompanion _bookToCompanion(Book book) {
    return BooksCompanion(
      id: Value(book.id),
      title: Value(book.title),
      filePath: Value(book.filePath),
      fileType: Value(book.fileType.name),
      coverPath: Value(book.coverPath),
      lastOpened: Value(book.lastOpened),
      addedAt: Value(book.addedAt),
      isFavorite: Value(book.isFavorite),
      totalPages: Value(book.totalPages),
      currentPage: Value(book.currentPage),
      readingProgress: Value(book.readingProgress),
    );
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'porbi.db'));
    return NativeDatabase.createInBackground(file);
  });
}
