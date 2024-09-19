import 'package:calen_do/bloc/task_bloc.dart';
import 'package:calen_do/view/calender_screen/screen_calender.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'repositories/task_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Initialize Firebase
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TaskBloc(taskRepository: TaskRepository(),
      ),
      child: MaterialApp(
        title: 'Flutter Calendar App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: RepositoryProvider(
          create: (context) => TaskRepository(),
          child: BlocProvider(
            create: (context) =>
                TaskBloc(taskRepository: context.read<TaskRepository>())
                  ..add(LoadTasks()),
            child: CalendarScreen(),
          ),
        ),
      ),
    );
  }
}