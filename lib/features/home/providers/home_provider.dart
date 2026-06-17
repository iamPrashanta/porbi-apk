import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:porbi/models/book.dart';
import 'package:porbi/providers/database_provider.dart';

final continueReadingProvider = StreamProvider<Book?>((ref) {
  final db = ref.watch(databaseProvider);
  return db
      .watchRecentBooks(limit: 1)
      .map((books) => books.isNotEmpty ? books.first : null);
});
