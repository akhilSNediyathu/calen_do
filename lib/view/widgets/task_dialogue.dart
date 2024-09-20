import 'package:calen_do/bloc/task_bloc.dart';
import 'package:calen_do/bloc/task_event.dart';
import 'package:calen_do/model/task_model.dart';
import 'package:calen_do/utils/validations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TaskDialog extends StatefulWidget {
  final Task? task;
  final VoidCallback? onEditComplete;

  const TaskDialog({super.key, this.task, this.onEditComplete});

  @override
  TaskDialogState createState() => TaskDialogState();
}

class TaskDialogState extends State<TaskDialog> {
  final _formKey =
      GlobalKey<FormState>(); 
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String _status = 'Pending';

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      _titleController.text = widget.task!.title;
      _descriptionController.text = widget.task!.description;
      _selectedDate = widget.task!.date;
      _status = widget.task!.status;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.task == null ? 'Add Task' : 'Edit Task'),
      content: Form(
        key: _formKey, 
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Task Title'),
              validator: validateTaskTitle,
            ),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            ListTile(
              title: const Text('Select Date:'),
              subtitle: Text(_selectedDate.toString().split(' ')[0]),
              trailing: const Icon(Icons.calendar_today),
              onTap: () {
                _selectDate(context);
              },
            ),
            DropdownButton<String>(
              value: _status,
              items: ['Pending', 'In Progress', 'Done']
                  .map((String value) => DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      ))
                  .toList(),
              onChanged: (newStatus) {
                setState(() {
                  _status = newStatus!;
                });
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final task = Task(
                id: widget.task?.id ?? '',
                title: _titleController.text,
                description: _descriptionController.text,
                date: _selectedDate,
                status: _status,
              );
              if (widget.task == null) {
                context.read<TaskBloc>().add(AddTask(task));
              } else {
                context.read<TaskBloc>().add(UpdateTask(task));
                widget.onEditComplete?.call();
              }
              Navigator.pop(context);
            }
          },
          child: Text(widget.task == null ? 'Add Task' : 'Save Changes'),
        ),
      ],
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2021, 1),
      lastDate: DateTime(2101, 12),
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }
}
