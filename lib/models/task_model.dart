import 'package:hive/hive.dart';
part 'task_model.g.dart';

@HiveType(typeId: 0)
class Task extends HiveObject {
  @HiveField(0)
  String event;

  @HiveField(1)
  String note;

  @HiveField(2)
  String category;

  @HiveField(3)
  String date;

  @HiveField(4)
  String startTime;

  @HiveField(5)
  bool isCompleted;

  Task({
    required this.event,
    required this.note,
    required this.category,
    required this.date,
    required this.startTime,
    this.isCompleted = false,
  });
}
