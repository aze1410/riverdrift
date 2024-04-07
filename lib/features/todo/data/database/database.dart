import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverdrift/features/news/data/models/news_model.dart';
import 'package:riverdrift/features/todo/data/model/todo_model.dart';
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';
part 'database.g.dart';

final databaseProvider = Provider<AppDatabase>((ref) => AppDatabase());

class TodoItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text().withLength(min: 1, max: 32)();
}

// Define News table in Drift database
class NewsTable extends Table {
  TextColumn get title => text()();
  TextColumn get description => text()();
  TextColumn get url => text()();
  TextColumn get urlToImage => text()();

  @override
  Set<Column> get primaryKey => {url};
}

@DriftDatabase(tables: [TodoItems, NewsTable])
@DriftDatabase(tables: [TodoItems, NewsTable])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 2; // Increment schema version

  // Define migrations to handle schema changes
  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) {
          return m.createAll();
        },
        onUpgrade: (Migrator m, int from, int to) async {
          if (from == 1) {
            await m.createTable(newsTable);
          }
        },
      );

  Future<List<TodoItem>> getAllTodoItems() => select(todoItems).get();

  Future<int> insertTodoItem(String title) {
    return into(todoItems).insert(TodoItemsCompanion.insert(title: title));
  }

  Future<int> deleteTodoItem(int id) {
    return (delete(todoItems)..where((item) => item.id.equals(id))).go();
  }

  Future<int> updateTodoItem(int id, String newTitle) {
    return (update(todoItems)..where((item) => item.id.equals(id)))
        .write(TodoItemsCompanion(title: Value(newTitle)));
  }

  //
  Future<List<NewsTableData>> getallNews() => select(newsTable).get();

  // Define a method to insert news into the database
  Future<void> insertNews(News news) async {
    final existingNews = await (select(newsTable)
          ..where((tbl) => tbl.url.equals(news.url)))
        .get();

    if (existingNews.isNotEmpty) {
      // News with the same URL already exists, you can choose to update it or ignore
      // For now, let's just ignore and return
      return;
    }

    await into(newsTable).insert(NewsTableCompanion.insert(
      title: news.title,
      description: news.description,
      url: news.url,
      urlToImage: news.urlToImage,
    ));
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
