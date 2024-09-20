
import '../model/task_model.dart';


abstract class TaskState {}


class TaskLoading extends TaskState {}


class TaskLoaded extends TaskState {
  final List<Task> tasks;

  TaskLoaded(this.tasks);
}


class TaskError extends TaskState {}
