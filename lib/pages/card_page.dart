import 'package:flutter/material.dart';
import 'package:taskly/models/task_model.dart';
import 'package:taskly/pages/detail.dart';

class CardPage extends StatefulWidget {
  final Task task;
  final Function onLongPress;
  final bool isSelected;

  const CardPage(
      {super.key,
      required this.task,
      required this.onLongPress,
      required this.isSelected});

  @override
  State<CardPage> createState() => _CardPageState();
}

class _CardPageState extends State<CardPage> {
  bool isSelected = false;

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Work':
        return Colors.blue;
      case 'Personal':
        return Colors.yellow;
      case 'Health':
        return const Color.fromARGB(255, 255, 185, 119);
      case 'Family':
        return const Color.fromARGB(255, 234, 117, 165);
      case 'Finance':
        return const Color.fromARGB(255, 162, 118, 232);
      case 'Shopping':
        return const Color.fromARGB(255, 103, 203, 216);
      case 'Education':
        return const Color.fromARGB(255, 146, 222, 180);
      case 'Travel':
        return Colors.green;
      case 'Goals':
        return const Color.fromARGB(255, 76, 112, 175);
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => Detail(
                    task: widget.task,
                  ))),
      onLongPress: () => widget.onLongPress(),
      child: Card(
        color: widget.isSelected ? Colors.blue.shade300 : Colors.white,
        elevation: 4,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Checkbox(
                value: widget.task.isCompleted,
                onChanged: (bool? value) {
                  setState(() {
                    widget.task.isCompleted = !widget.task.isCompleted;
                    widget.task.save();
                  });
                },
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            widget.task.event,
                            maxLines: null,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              decoration: widget.task.isCompleted
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(
                          width: 80,
                          child: Text(
                            widget.task.startTime,
                            style: TextStyle(
                              fontSize: 12,
                              color: const Color.fromARGB(255, 0, 0, 0),
                              decoration: widget.task.isCompleted
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                            ),
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: _getCategoryColor(widget.task.category),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(
                              vertical: 6, horizontal: 12),
                          child: Text(
                            widget.task.category,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color.fromARGB(255, 3, 3, 3),
                            ),
                          ),
                        ),
                        const SizedBox(width: 20), // Adjusted space
                        Expanded(
                          child: Text(
                            widget.task.date,
                            style: const TextStyle(
                                fontSize: 14, color: Colors.black),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: widget.task.isCompleted
                    ? const Icon(
                        Icons.check_circle,
                        color: Colors.green,
                      )
                    : const Icon(Icons.check_circle_outline),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
