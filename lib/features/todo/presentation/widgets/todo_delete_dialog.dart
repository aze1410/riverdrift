import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverdrift/features/todo/domain/providers/todo_provider.dart';

Future<void> DeleteTodoItem(BuildContext context, WidgetRef ref, int id) async {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Confirm Delete'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('Are you sure you want to delete this item?'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              ref.read(TodoProvider.deleteTodoItemProvider)(id);
            },
            child: Text('Delete'),
          ),
        ],
      );
    },
  );
}
