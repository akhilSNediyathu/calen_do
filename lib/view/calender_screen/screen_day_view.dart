import 'package:flutter/material.dart';


class DayView extends StatelessWidget {
  final DateTime selectedDay;

  const DayView({super.key, required this.selectedDay});

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