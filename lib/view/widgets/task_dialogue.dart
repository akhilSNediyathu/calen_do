import 'package:calen_do/bloc/task_bloc.dart';
import 'package:calen_do/model/task_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TaskDialog extends StatefulWidget {
  final Task? task;
  final VoidCallback? onEditComplete; // Added callback

  const TaskDialog({this.task, this.onEditComplete}); // Modified constructor

  @override
  _TaskDialogState createState() => _TaskDialogState();
}

class _TaskDialogState extends State<TaskDialog> {
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
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _titleController,
            decoration: InputDecoration(labelText: 'Task Title'),
          ),
          TextField(
            controller: _descriptionController,
            decoration: InputDecoration(labelText: 'Description'),
          ),
          ListTile(
            title: Text('Select Date:'),
            subtitle: Text(_selectedDate.toString().split(' ')[0]),
            trailing: Icon(Icons.calendar_today),
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
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
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
              widget.onEditComplete?.call(); // Call the callback if editing
            }
            Navigator.pop(context);
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
