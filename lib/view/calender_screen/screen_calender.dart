import 'package:calen_do/bloc/task_bloc.dart';
import 'package:calen_do/model/task_model.dart';
import 'package:calen_do/view/widgets/task_dialogue.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarScreen extends StatefulWidget {
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calendar View'),
        actions: [
          IconButton(
            icon: Icon(Icons.calendar_view_month),
            onPressed: () {
              setState(() {
                _calendarFormat = CalendarFormat.month;
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.calendar_today),
            onPressed: () {
              setState(() {
                _calendarFormat = CalendarFormat.week;
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.calendar_view_day),
            onPressed: () {
              _showDayView(); // Implement a custom day view
            },
          ),
        ],
      ),
      body: Column(
        children: [
          TableCalendar<Task>(
            firstDay: DateTime.utc(2000, 1, 1),
            lastDay: DateTime.utc(2100, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            calendarFormat: _calendarFormat,
            eventLoader: (day) {
              final state = context.read<TaskBloc>().state;
              if (state is TaskLoaded) {
                return state.tasks.where((task) => isSameDay(task.date, day)).toList();
              }
              return [];
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
          ),
          // Display tasks for the selected day
          Expanded(
            child: BlocBuilder<TaskBloc, TaskState>(
              builder: (context, state) {
                if (state is TaskLoaded) {
                  final tasksForDay = state.tasks.where((task) => isSameDay(task.date, _selectedDay)).toList();
                  return ListView.builder(
                    itemCount: tasksForDay.length,
                    itemBuilder: (context, index) {
                      final task = tasksForDay[index];
                      return Card(
                        child: ListTile(
                          title: Text(task.title),
                          subtitle: Text(task.description),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.circle,
                                color: task.status == 'Pending'
                                    ? Colors.red
                                    : task.status == 'In Progress'
                                        ? Colors.orange
                                        : Colors.green,
                                size: 12,
                              ),
                              IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => TaskDialog(task: task),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                } else if (state is TaskLoading) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  return Center(child: Text('Error loading tasks.'));
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => TaskDialog(),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }

  // Custom function to show a day view
  void _showDayView() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DayView(selectedDay: _selectedDay ?? DateTime.now()),
      ),
    );
  }
}

// Custom Day View screen
class DayView extends StatelessWidget {
  final DateTime selectedDay;

  const DayView({Key? key, required this.selectedDay}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Day View: ${selectedDay.toLocal()}'),
      ),
      body: Center(
        child: Text('Tasks for ${selectedDay.toLocal()}'),
      ),
    );
  }
}
