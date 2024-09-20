
import '../model/task_model.dart';


abstract class TaskState {}


class TaskLoading extends TaskState {}

// State when tasks have been successfully loaded
class TaskLoaded extends TaskState {
  final List<Task> tasks;

  TaskLoaded(this.tasks);
}

// State when there is an error loading tasks
class TaskError extends TaskState {}
