
  import 'package:calen_do/model/task_model.dart';
import 'package:calen_do/utils/constants.dart';
import 'package:calen_do/utils/functions.dart';
import 'package:calen_do/view/widgets/task_dialogue.dart';
import 'package:flutter/material.dart';

Widget dismissBackground(Color color, IconData icon) {
    return Container(
      color: color,
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Icon(icon, color: white),
    );
  }

   Widget taskTile(Task task,BuildContext context) {
    Color tileColor = getStatusColor(task.status).withOpacity(0.3);

    return Dismissible(
      key: Key(task.id),
      direction: DismissDirection.horizontal,
      onDismissed: (direction) => handleDismiss(direction, task, context),
      background: dismissBackground(red, Icons.delete),
      secondaryBackground: dismissBackground(red, Icons.delete),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: tileColor,
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
        child: ListTile(
          contentPadding: EdgeInsets.zero,
          onTap: () => showDialog(
      context: context,
      builder: (context) => TaskDialog(
        task: task,
      ),
    ),
          title: Text(
            task.title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          subtitle: Text(
            task.description,
            style: TextStyle(color: Colors.grey[600], fontSize: 14),
          ),
          trailing: Icon(Icons.circle, color: getStatusColor(task.status)),
        ),
      ),
    );
  }

   void showTaskDialog(BuildContext context, [Task? task]) {
    showDialog(
      context: context,
      builder: (context) => TaskDialog(
        task: task,
      ),
    );
  }

  AppBar customAppBar({
  required String title,
  List<Widget>? actions,
}) {
  return AppBar(
    title: Text(title),
    actions: actions,
  );
}