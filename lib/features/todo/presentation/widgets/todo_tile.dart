import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:riverdrift/features/todo/data/database/database.dart';

class TodoListItem extends StatelessWidget {
  final TodoItem item;
  final void Function(BuildContext) onEditPressed;
  final void Function(BuildContext, int) onDeletePressed;

  const TodoListItem({
    Key? key,
    required this.item,
    required this.onEditPressed,
    required this.onDeletePressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 0), // changes position of shadow
            ),
          ],
        ),
        child: Slidable(
          child: ListTile(
            title: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                item.title,
                style: TextStyle(color: Colors.black),
              ),
            ),
          ),
          endActionPane: ActionPane(
            motion: StretchMotion(),
            children: [
              SlidableAction(
                label: 'Edit',
                backgroundColor: Colors.yellow,
                icon: Icons.edit,
                onPressed: (context) {
                  onEditPressed(context);
                },
              ),
              SlidableAction(
                label: 'Delete',
                backgroundColor: Colors.red,
                icon: Icons.delete,
                onPressed: (context) {
                  onDeletePressed(context, item.id);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
