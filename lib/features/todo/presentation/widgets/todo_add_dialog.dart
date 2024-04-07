import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverdrift/features/todo/domain/providers/todo_provider.dart';

Future<void> AddTodoItem(BuildContext context, WidgetRef ref) async {
  final TextEditingController textController = TextEditingController();
  String? errorText;

  await showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text('Add Todo'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: textController,
                  onChanged: (value) {
                    setState(() {
                      if (value.isNotEmpty) {
                        errorText = null;
                      } else {
                        errorText = 'Todo title cannot be empty';
                      }
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Enter Todo',
                    errorText: errorText,
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  final title = textController.text.trim();
                  if (title.isNotEmpty) {
                    ref.read(TodoProvider.addTodoItemProvider)(title);
                    Navigator.of(context).pop();
                  } else {
                    setState(() {
                      errorText = 'Todo title cannot be empty';
                    });
                  }
                },
                child: Text('Save'),
              ),
            ],
          );
        },
      );
    },
  );
}
