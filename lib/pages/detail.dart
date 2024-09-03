import 'package:flutter/material.dart';
import 'package:taskly/models/task_model.dart';

class Detail extends StatefulWidget {
  final Task task;
  const Detail({super.key, required this.task});

  @override
  State<Detail> createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  Widget buildText(String label, String title) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(
          color: Colors.grey.shade300,
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black54,
              ),
            ),
            const SizedBox(
              width: 40,
            ),
            Flexible(
              child: Text(
                title.isEmpty ? "No Details" : title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.normal,
                  color: Colors.black87,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
            child: Text(
          "Detail Page",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
        )),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildText("Event", widget.task.event),
              buildText("Note", widget.task.note),
              buildText("Category", widget.task.category),
              buildText("Time", widget.task.startTime),
              buildText("Date", widget.task.date),
            ],
          ),
        ),
      ),
    );
  }
}
