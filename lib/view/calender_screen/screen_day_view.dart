import 'package:calen_do/bloc/task_bloc.dart';
import 'package:calen_do/bloc/task_event.dart';
import 'package:calen_do/bloc/task_state.dart';
import 'package:calen_do/view/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_calendar/table_calendar.dart';

class DayView extends StatefulWidget {
  final DateTime selectedDay;

  const DayView({super.key, required this.selectedDay});

  @override
  State<DayView> createState() => _DayViewState();
}

class _DayViewState extends State<DayView> {
  @override
  void initState() {
    context.read<TaskBloc>().add(LoadTasks());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            'Day View: ${widget.selectedDay.toLocal().toString().split(' ')[0]}'),
      ),
      body: BlocBuilder<TaskBloc, TaskState>(
        builder: (context, state) {
          if (state is TaskLoaded) {
            final tasksForDay = state.tasks
                .where((task) => isSameDay(task.date, widget.selectedDay))
                .toList();

            if (tasksForDay.isEmpty) {
              return const Center(child: Text('No tasks for this day.'));
            }

            return ListView.builder(
              itemCount: tasksForDay.length,
              itemBuilder: (context, index) {
                return taskTile(tasksForDay[index], context);
              },
            );
          } else if (state is TaskLoading) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return const Center(child: Text('Error loading tasks.'));
          }
        },
      ),
    );
  }
}
