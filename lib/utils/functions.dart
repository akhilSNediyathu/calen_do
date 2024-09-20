

import 'package:calen_do/bloc/task_bloc.dart';
import 'package:calen_do/bloc/task_event.dart';
import 'package:calen_do/model/task_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Color getStatusColor(String status) {
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
  
 void handleDismiss(DismissDirection direction, Task task, dynamic context) {
    if (direction == DismissDirection.startToEnd || direction == DismissDirection.endToStart) {
      BlocProvider.of<TaskBloc>(context).add(DeleteTask(task.id));
    }
  }



