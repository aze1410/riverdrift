import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverdrift/features/todo/data/database/database.dart';

class Todo {
  final int id;
  final String name;

  Todo({
    required this.id,
    required this.name,
  });
}

