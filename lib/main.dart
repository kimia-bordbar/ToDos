import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:todos/blocs/todos/todos_bloc.dart';
import 'package:todos/blocs/todos_filter/todos_filter_bloc.dart';
import 'package:todos/lang/messages.dart';
import 'package:todos/screens/add_todo_screen.dart';
import 'package:todos/screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => TodosBloc()
            ..add(
              const LoadTodos(
                todos: [],
              ),
            ),
        ),
        BlocProvider(
          create: (context) => TodosFilterBloc(
            todosBloc: BlocProvider.of<TodosBloc>(context),
          ),
        ),
      ],
      child: GetMaterialApp(
        locale: Get.deviceLocale,
        translations: Messages(), // your translations
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          primaryColor: const Color(0xFF000A1F),
          appBarTheme: const AppBarTheme(color: Color(0xFF000A1F)),
        ),
        initialRoute: '/home',
        routes: {
          '/home': (_) => const HomeScreen(),
          '/add': (_) => const AddToDoScreen(),
        },
      ),
    );
  }
}
