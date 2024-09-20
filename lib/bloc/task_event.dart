// task_event.dart
import '../model/task_model.dart';

// Abstract class representing a TaskEvent
abstract class TaskEvent {}

// Event to load tasks from the repository
class LoadTasks extends TaskEvent {}

// Event to add a new task
class AddTask extends TaskEvent {
  final Task task;

  AddTask(this.task);
}

// Event to update an existing task
class UpdateTask extends TaskEvent {
  final Task task;

  UpdateTask(this.task);
}

// Event to delete a task by its ID
class DeleteTask extends TaskEvent {
  final String id;

  DeleteTask(this.id);
}
