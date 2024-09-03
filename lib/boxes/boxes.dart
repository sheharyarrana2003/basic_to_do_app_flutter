import 'package:hive/hive.dart';
import 'package:taskly/models/task_model.dart';

class Boxes {
  static Box<Task> getData() => Hive.box<Task>('tasks');
}
