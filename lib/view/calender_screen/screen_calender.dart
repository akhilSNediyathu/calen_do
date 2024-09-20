import 'package:calen_do/bloc/task_bloc.dart';
import 'package:calen_do/bloc/task_state.dart';
import 'package:calen_do/model/task_model.dart';
import 'package:calen_do/utils/constants.dart';
import 'package:calen_do/view/calender_screen/screen_day_view.dart';
import 'package:calen_do/view/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  CalendarScreenState createState() => CalendarScreenState();
}

class CalendarScreenState extends State<CalendarScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(homeTitle),
        actions: calendarFormatButtons(),
      ),
      body: Column(
        children: [
          tableCalendarView(),
          Expanded(child: taskList()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showTaskDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  List<Widget> calendarFormatButtons() {
    return [
      IconButton(
        icon: const Icon(Icons.calendar_view_month),
        onPressed: () => setState(() => _calendarFormat = CalendarFormat.month),
      ),
      IconButton(
        icon: const Icon(Icons.calendar_today),
        onPressed: () => setState(() => _calendarFormat = CalendarFormat.week),
      ),
      IconButton(
          icon: const Icon(Icons.calendar_view_day),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    DayView(selectedDay: _selectedDay ?? DateTime.now()),
              ),
            );
          }),
    ];
  }

  Widget tableCalendarView() {
    return TableCalendar<Task>(
      firstDay: DateTime.utc(2000, 1, 1),
      lastDay: DateTime.utc(2100, 12, 31),
      focusedDay: _focusedDay,
      selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
      calendarFormat: _calendarFormat,
      eventLoader: (day) {
        final state = context.read<TaskBloc>().state;
        if (state is TaskLoaded) {
          return state.tasks
              .where((task) => isSameDay(task.date, day))
              .toList();
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
    );
  }

  Widget taskList() {
    return BlocBuilder<TaskBloc, TaskState>(
      builder: (context, state) {
        if (state is TaskLoaded) {
          final tasksForDay = state.tasks
              .where((task) => isSameDay(task.date, _selectedDay))
              .toList();
          return ListView.builder(
            itemCount: tasksForDay.length,
            itemBuilder: (context, index) {
              return taskTile(tasksForDay[index], context);
            },
          );
        } else if (state is TaskLoading) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return const Center(child: Text(errorLoading));
        }
      },
    );
  }
}
