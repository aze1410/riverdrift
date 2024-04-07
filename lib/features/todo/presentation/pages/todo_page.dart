import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverdrift/features/todo/domain/providers/todo_provider.dart';
import 'package:riverdrift/features/todo/presentation/widgets/todo_add_dialog.dart';
import 'package:riverdrift/features/todo/presentation/widgets/todo_delete_dialog.dart';
import 'package:riverdrift/features/todo/presentation/widgets/todo_edit_dialog.dart';
import 'package:riverdrift/features/todo/presentation/widgets/todo_tile.dart';

class TodoPage extends ConsumerWidget {
  const TodoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todoItemsAsync = ref.watch(TodoProvider.todoItemsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Todo List'),
      ),
      body: todoItemsAsync.when(
        loading: () => Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Text('Error: $error'),
        data: (items) {
          if (items.isEmpty) {
            return Center(
              child: Text(
                'Add a Todo item by tapping + icon.',
              ),
            );
          } else {
            return ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return TodoListItem(
                  item: item,
                  onEditPressed: (context) {
                    EditTodoItem(context, ref, item);
                  },
                  onDeletePressed: (context, id) {
                    DeleteTodoItem(context, ref, id);
                  },
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => AddTodoItem(context, ref),
        child: Icon(Icons.add),
      ),
    );
  }
}
