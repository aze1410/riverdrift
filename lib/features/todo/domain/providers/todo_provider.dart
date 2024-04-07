import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverdrift/features/todo/data/database/database.dart';

class TodoProvider {
  static final todoItemsProvider = FutureProvider.autoDispose<List<TodoItem>>(
    (ref) async {
      final database = ref.watch(databaseProvider);
      return database.getAllTodoItems();
    },
  );

  static final addTodoItemProvider =
      Provider.autoDispose<void Function(String)>(
    (ref) {
      final database = ref.watch(databaseProvider);
      return (String title) async {
        try {
          await database.insertTodoItem(title);
          ref.refresh(todoItemsProvider);
        } catch (e) {
          print('Error adding todo item: $e');
        }
      };
    },
  );

  static final deleteTodoItemProvider =
      Provider.autoDispose<void Function(int)>(
    (ref) {
      final database = ref.watch(databaseProvider);
      return (int id) async {
        try {
          await database.deleteTodoItem(id);
          ref.refresh(todoItemsProvider);
        } catch (e) {
          print('Error deleting todo item: $e');
        }
      };
    },
  );

  static final updateTodoItemProvider =
      Provider.autoDispose<void Function(int, String)>(
    (ref) {
      final database = ref.watch(databaseProvider);
      return (int id, String title) async {
        try {
          await database.updateTodoItem(id, title);
          ref.refresh(todoItemsProvider);
        } catch (e) {
          print('Error updating todo item: $e');
        }
      };
    },
  );
}
