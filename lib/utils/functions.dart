

import 'package:calen_do/bloc/task_bloc.dart';
import 'package:calen_do/bloc/task_event.dart';
import 'package:calen_do/model/task_model.dart';
import 'package:calen_do/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Color getStatusColor(String status) {
    switch (status) {
      case 'Pending':
        return orange;
      case 'In Progress':
        return purple;
      case 'Done':
        return green;
      default:
        return Colors.grey;
    }
  }
  
 void handleDismiss(DismissDirection direction, Task task, dynamic context) {
    if (direction == DismissDirection.startToEnd || direction == DismissDirection.endToStart) {
      BlocProvider.of<TaskBloc>(context).add(DeleteTask(task.id));
    }
  }



