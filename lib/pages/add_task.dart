import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:taskly/boxes/boxes.dart';
import 'package:taskly/models/task_model.dart';

Widget buildTextField(String label, TextEditingController controller,
    IconData icon, String? Function(String?)? validator) {
  return TextFormField(
    controller: controller,
    validator: validator,
    maxLines: null,
    decoration: InputDecoration(
      labelText: "Enter " + label,
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(11),
        borderSide: const BorderSide(color: Colors.blue, width: 2),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(11),
        borderSide: const BorderSide(color: Colors.black, width: 2),
      ),
      prefixIcon: Icon(icon),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
    ),
  );
}

Widget buildDateTimeSelector({
  required BuildContext context,
  required String label,
  required DateTime selectedDate,
  required TimeOfDay selectedTime,
  required ValueChanged<DateTime> onDateChanged,
  required ValueChanged<TimeOfDay> onTimeChanged,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Row(
      children: [
        Expanded(child: Text(label)),
        TextButton(
          onPressed: () async {
            if (label == "Select Date") {
              DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: selectedDate,
                firstDate: DateTime.now(),
                lastDate: DateTime(2050),
              );
              if (pickedDate != null && pickedDate != selectedDate) {
                onDateChanged(pickedDate);
                FocusScope.of(context).unfocus();
              }
            } else if (label == "Select Time") {
              TimeOfDay? pickedTime = await showTimePicker(
                context: context,
                initialTime: selectedTime,
              );
              if (pickedTime != null && pickedTime != selectedTime) {
                onTimeChanged(pickedTime);
                FocusScope.of(context).unfocus();
              }
            }
          },
          child: Text(
            label == "Select Date"
                ? DateFormat('M/d/yyyy').format(selectedDate)
                : selectedTime.format(context),
          ),
        ),
      ],
    ),
  );
}

class AddTask extends StatefulWidget {
  const AddTask({super.key});

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  String? _selectedCategory;

  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();

  List<String> categories = [
    'Work',
    'Personal',
    'Health',
    'Family',
    'Finance',
    'Shopping',
    'Education',
    'Travel',
    'Goals',
  ];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Add Task"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                const SizedBox(
                  height: 30,
                ),
                Lottie.asset('assets/animations/add_event.json',
                    height: 150,
                    width: 150,
                    reverse: true,
                    repeat: true,
                    fit: BoxFit.fitHeight),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: buildTextField(
                    "Name",
                    _nameController,
                    Icons.event,
                    (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter name";
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: buildTextField(
                    "Event Note",
                    _descriptionController,
                    Icons.note,
                    null,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: DropdownButtonFormField<String>(
                    borderRadius: BorderRadius.circular(11),
                    value: _selectedCategory,
                    items: categories.map((String category) {
                      return DropdownMenuItem<String>(
                        value: category,
                        child: Text(category),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedCategory = newValue;
                      });
                    },
                    decoration: const InputDecoration(
                      labelText: "Category",
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please select a category";
                      }
                      return null;
                    },
                  ),
                ),
                buildDateTimeSelector(
                  context: context,
                  label: "Select Date",
                  selectedDate: _selectedDate,
                  selectedTime: _selectedTime,
                  onDateChanged: (DateTime date) {
                    setState(() {
                      _selectedDate = date;
                    });
                  },
                  onTimeChanged: (_) {},
                ),
                buildDateTimeSelector(
                  context: context,
                  label: "Select Time",
                  selectedDate: _selectedDate,
                  selectedTime: _selectedTime,
                  onDateChanged: (_) {},
                  onTimeChanged: (TimeOfDay time) {
                    setState(() {
                      _selectedTime = time;
                    });
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Center(
                    child: Container(
                      height: 50,
                      width: 160,
                      decoration: BoxDecoration(
                        color: Colors.purple,
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.purple.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 7,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: InkWell(
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            // Format date and time as required
                            final formattedDate =
                                DateFormat('M/d/yyyy').format(_selectedDate);
                            final formattedTime = DateFormat.jm().format(
                              DateTime(
                                _selectedDate.year,
                                _selectedDate.month,
                                _selectedDate.day,
                                _selectedTime.hour,
                                _selectedTime.minute,
                              ),
                            );

                            final data = Task(
                              event: _nameController.text,
                              note: _descriptionController.text,
                              category: _selectedCategory!,
                              date: formattedDate,
                              startTime: formattedTime,
                            );

                            final box = Boxes.getData();
                            box.add(data);
                            data.save();
                            _nameController.clear();
                            _descriptionController.clear();
                            setState(() {
                              _selectedCategory = null;
                              _selectedDate = DateTime.now();
                              _selectedTime = TimeOfDay.now();
                            });
                            Navigator.of(context).pop();
                          }
                        },
                        child: const Center(
                          child: Text(
                            "Add Task",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
