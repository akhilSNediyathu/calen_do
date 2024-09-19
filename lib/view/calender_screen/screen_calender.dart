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
        actions: _buildCalendarFormatButtons(),
      ),
      body: Column(
        children: [
          _buildTableCalendar(),
          Expanded(child: _buildTaskList()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showTaskDialog(),
        child: Icon(Icons.add),
      ),
    );
  }

  // Build the calendar format toggle buttons
  List<Widget> _buildCalendarFormatButtons() {
    return [
      IconButton(
        icon: Icon(Icons.calendar_view_month),
        onPressed: () => setState(() => _calendarFormat = CalendarFormat.month),
      ),
      IconButton(
        icon: Icon(Icons.calendar_today),
        onPressed: () => setState(() => _calendarFormat = CalendarFormat.week),
      ),
      IconButton(
        icon: Icon(Icons.calendar_view_day),
        onPressed: _showDayView,
      ),
    ];
  }

  // Build the TableCalendar
  Widget _buildTableCalendar() {
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

  // Build the list of tasks for the selected day
  Widget _buildTaskList() {
    return BlocBuilder<TaskBloc, TaskState>(
      builder: (context, state) {
        if (state is TaskLoaded) {
          final tasksForDay = state.tasks
              .where((task) => isSameDay(task.date, _selectedDay))
              .toList();
          return ListView.builder(
            itemCount: tasksForDay.length,
            itemBuilder: (context, index) {
              return _buildTaskTile(tasksForDay[index]);
            },
          );
        } else if (state is TaskLoading) {
          return Center(child: CircularProgressIndicator());
        } else {
          return Center(child: Text('Error loading tasks.'));
        }
      },
    );
  }

  // Build a single task tile
  Widget _buildTaskTile(Task task) {
    Color tileColor = _getStatusColor(task.status).withOpacity(0.3);

    return Dismissible(
      key: Key(task.id),
      direction: DismissDirection
          .horizontal, // Allow swipe to delete in both directions
      onDismissed: (direction) => _handleDismiss(direction, task),
      background: _buildDismissBackground(Colors.red, Icons.delete),
      secondaryBackground: _buildDismissBackground(
          Colors.red, Icons.delete), // Background for opposite direction
      child: Container(
        margin:
            EdgeInsets.symmetric(vertical: 4, horizontal: 8), // Reduced margins
        padding: EdgeInsets.all(8), // Padding for the entire tile
        decoration: BoxDecoration(
          color: tileColor,
          border: Border.all(color: Colors.grey), // Border for the tile
          borderRadius: BorderRadius.circular(8), // Rounded corners
        ),
        child: ListTile(
          contentPadding: EdgeInsets.zero, // Remove default padding
          onTap: () => _showTaskDialog(task), // Edit on tap
          title: Text(
            task.title,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16), // Slightly smaller font
          ),
          subtitle: Text(
            task.description,
            style: TextStyle(
                color: Colors.grey[600], fontSize: 14), // Slightly smaller font
          ),
          trailing: Icon(Icons.circle, color: _getStatusColor(task.status)),
        ),
      ),
    );
  }

  // Handle dismiss action for task tiles
  void _handleDismiss(DismissDirection direction, Task task) {
    if (direction == DismissDirection.startToEnd ||
        direction == DismissDirection.endToStart) {
      context.read<TaskBloc>().add(DeleteTask(task.id));
    }
  }

  // Build dismiss background for swipe actions
  Widget _buildDismissBackground(Color color, IconData icon) {
    return Container(
      color: color,
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Icon(icon, color: Colors.white),
    );
  }

  // Show the task dialog for adding/editing tasks
  void _showTaskDialog([Task? task]) {
    showDialog(
      context: context,
      builder: (context) => TaskDialog(
        task: task,
      ),
    );
  }

  // Show the day view
  void _showDayView() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            DayView(selectedDay: _selectedDay ?? DateTime.now()),
      ),
    );
  }

  // Get color based on task status
  Color _getStatusColor(String status) {
    switch (status) {
      case 'Pending':
        return Colors.red;
      case 'In Progress':
        return Colors.orange;
      case 'Done':
        return Colors.green;
      default:
        return Colors.grey;
    }
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
