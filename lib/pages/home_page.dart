import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';
import 'package:taskly/boxes/boxes.dart';
import 'package:taskly/models/task_model.dart';
import 'package:taskly/pages/add_task.dart';
import 'package:taskly/pages/card_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Task> selectedTasks = [];

  @override
  void initState() {
    super.initState();
  }

  void toggleSelected(Task task) {
    setState(() {
      if (selectedTasks.contains(task)) {
        selectedTasks.remove(task);
      } else {
        selectedTasks.add(task);
      }
    });
  }

  void _deleteTasks() async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
              "Confirmation",
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
            content: const Text(
              "Are you sure to delete?",
              style: TextStyle(fontSize: 18),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    "Cancel",
                    style: TextStyle(fontSize: 16),
                  )),
              TextButton(
                  onPressed: () {
                    final box = Boxes.getData();
                    for (var task in selectedTasks) {
                      box.delete(task.key);
                    }
                    setState(() {
                      selectedTasks.clear();
                    });
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    "Delete",
                    style: TextStyle(fontSize: 16),
                  )),
            ],
          );
        });
  }

  void _deselectAll() {
    setState(() {
      selectedTasks.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (selectedTasks.isNotEmpty) {
          _deselectAll();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Center(
              child: Text(
            "My Tasks",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
          )),
          actions: [
            if (selectedTasks.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: IconButton(
                  onPressed: _deleteTasks,
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.red,
                    size: 25,
                  ),
                ),
              ),
          ],
        ),
        floatingActionButton: ClipOval(
          child: Material(
            color: Colors.black,
            child: InkWell(
              onTap: () {
                Navigator.of(context).push(_createRoute());
              },
              child: const SizedBox(
                width: 56,
                height: 56,
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 28,
                ),
              ),
            ),
          ),
        ),
        body: ValueListenableBuilder<Box<Task>>(
          valueListenable: Boxes.getData().listenable(),
          builder: (context, box, _) {
            var data = box.values.toList().cast<Task>();

            List<Task> todayTasks = [];
            List<Task> yesterdayTasks = [];
            Map<String, List<Task>> otherTasks = {};

            final today = DateTime.now();
            final yesterday = today.subtract(const Duration(days: 1));

            for (var task in data) {
              DateTime taskDate = DateFormat('M/d/yyyy').parse(task.date);

              if (isSameDate(taskDate, today)) {
                todayTasks.add(task);
              } else if (isSameDate(taskDate, yesterday)) {
                yesterdayTasks.add(task);
              } else {
                String formattedDate =
                    DateFormat('MMMM d, yyyy').format(taskDate);
                if (otherTasks[formattedDate] == null) {
                  otherTasks[formattedDate] = [];
                }
                otherTasks[formattedDate]?.add(task);
              }
            }
            return ListView(
              physics: const BouncingScrollPhysics(),
              children: [
                if (todayTasks.isNotEmpty) ...[
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Today's Tasks",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ...todayTasks
                      .map((task) => CardPage(
                            task: task,
                            onLongPress: () => toggleSelected(task),
                            isSelected: selectedTasks.contains(task),
                          ))
                      .toList(),
                ],
                if (yesterdayTasks.isNotEmpty) ...[
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Yesterday's Tasks",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ...yesterdayTasks
                      .map((task) => CardPage(
                            task: task,
                            onLongPress: () => toggleSelected(task),
                            isSelected: selectedTasks.contains(task),
                          ))
                      .toList(),
                ],
                if (otherTasks.isNotEmpty) ...[
                  for (var date in otherTasks.keys) ...[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        date,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    ...otherTasks[date]!
                        .map((task) => CardPage(
                              task: task,
                              onLongPress: () => toggleSelected(task),
                              isSelected: selectedTasks.contains(task),
                            ))
                        .toList(),
                  ]
                ],
              ],
            );
          },
        ),
      ),
    );
  }

  bool isSameDate(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  Route _createRoute() {
    return PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 900),
      pageBuilder: (context, animation, secondaryAnimation) => const AddTask(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    );
  }
}
