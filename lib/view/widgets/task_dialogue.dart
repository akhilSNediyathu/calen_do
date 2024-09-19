import 'package:calen_do/bloc/task_bloc.dart';
import 'package:calen_do/model/task_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';


class TaskDialog extends StatefulWidget {
  final Task? task;
  const TaskDialog({this.task});

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
              DatePicker.showDatePicker(context,
                  showTitleActions: true,
                  minTime: DateTime(2021, 1, 1),
                  maxTime: DateTime(2101, 12, 31), onConfirm: (date) {
                setState(() {
                  _selectedDate = date;
                });
              }, currentTime: DateTime.now(), locale: LocaleType.en);
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
            }
            Navigator.pop(context);
          },
          child: Text(widget.task == null ? 'Add Task' : 'Save Changes'),
        ),
      ],
    );
  }
}
