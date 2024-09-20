
import 'package:calen_do/model/task_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../repositories/task_repository.dart';
import 'task_event.dart';
import 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final TaskRepository taskRepository;

  TaskBloc({required this.taskRepository}) : super(TaskLoading()) {
    on<LoadTasks>(_onLoadTasks);
    on<AddTask>(_onAddTask);
    on<UpdateTask>(_onUpdateTask);
    on<DeleteTask>(_onDeleteTask);
  }

  
  void _onLoadTasks(LoadTasks event, Emitter<TaskState> emit) async {
    try {
      await emit.onEach<List<Task>>(
        taskRepository.getTasks(),
        onData: (tasks) => emit(TaskLoaded(tasks)),
      );
    } catch (_) {
      emit(TaskError());
    }
  }

  
  void _onAddTask(AddTask event, Emitter<TaskState> emit) async {
    try {
      await taskRepository.addTask(event.task);
      add(LoadTasks()); 
    } catch (_) {
      emit(TaskError());
    }
  }

  
  void _onUpdateTask(UpdateTask event, Emitter<TaskState> emit) async {
    try {
      await taskRepository.updateTask(event.task);
      add(LoadTasks()); 
    } catch (_) {
      emit(TaskError());
    }
  }

  
  void _onDeleteTask(DeleteTask event, Emitter<TaskState> emit) async {
    try {
      await taskRepository.deleteTask(event.id);
      add(LoadTasks()); 
    } catch (_) {
      emit(TaskError());
    }
  }
}
