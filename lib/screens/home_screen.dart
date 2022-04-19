import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todos/blocs/todos/todos_bloc.dart';
import 'package:todos/models/todos_filter_model.dart';

import '../blocs/todos_filter/todos_filter_bloc.dart';
import '../models/todos_model.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('app_bar_title'.tr),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.pushNamed(context, '/add');
              },
              icon: const Icon(Icons.add),
            ),
          ],
          bottom: TabBar(
            onTap: (tabIndex) {
              switch (tabIndex) {
                case 0:
                  BlocProvider.of<TodosFilterBloc>(context).add(
                    const UpdateTodos(
                      todosFilter: TodosFilter.pending,
                    ),
                  );
                  break;
                case 1:
                  BlocProvider.of<TodosFilterBloc>(context).add(
                    const UpdateTodos(
                      todosFilter: TodosFilter.completed,
                    ),
                  );
                  break;
              }
            },
            tabs: const [
              Tab(
                icon: Icon(Icons.pending),
              ),
              Tab(
                icon: Icon(Icons.add_task),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _todos('pending'.tr),
            _todos('completed'.tr),
          ],
        ),
      ),
    );
  }

  BlocConsumer<TodosFilterBloc, TodosFilterState> _todos(String title) {
    return BlocConsumer<TodosFilterBloc, TodosFilterState>(
      listener: ((context, state) {
        if (state is TodosFilterLoaded) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'There are ${state.filteredTodos.length} To Dos in your ${state.todosFilter.toString().split('.').last} list.',
              ),
            ),
          );
        }
      }),
      builder: (context, state) {
        if (state is TodosFilterLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is TodosFilterLoaded) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: state.filteredTodos.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return _todoDetail(
                                  context, state.filteredTodos[index]);
                            });
                      },
                      child: _todoCard(context, state.filteredTodos[index]),
                    );
                  },
                ),
              ],
            ),
          );
        } else {
          return const Text('Somthing went wrong!');
        }
      },
    );
  }
}

Container _todoDetail(BuildContext context, Todo todo) {
  return Container(
    height: MediaQuery.of(context).size.height * 0.3,
    width: double.infinity,
    decoration: const BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(30),
        topRight: Radius.circular(30),
      ),
    ),
    padding: const EdgeInsets.symmetric(
      horizontal: 20,
    ),
    child: CustomScrollView(
      slivers: [
        SliverList(
          delegate: SliverChildListDelegate(
            [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40.0),
                  // id & task ------------------------------
                  Text(
                    '#${todo.id}: ${todo.task}',
                    style: const TextStyle(
                      fontSize: 40.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  // description ------------------------------
                   Text(
                    'description'.tr,
                    style:const TextStyle(
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0, top: 15.0),
                    child: Text(
                      todo.description,
                      style: const TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  const SizedBox(height: 35.0),

                  // back button ------------------------------
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Theme.of(context).primaryColor),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child:  Text(
                        'go_back'.tr,
                        style:const TextStyle(fontSize: 18.0),
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ],
    ),
  );
}

Card _todoCard(BuildContext context, Todo todo) {
  return Card(
    margin: const EdgeInsets.only(bottom: 8.0),
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Text(
            '#${todo.id}: ${todo.task}',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          Row(
            children: [
              todo.isCompleted==false ?
              IconButton(
                onPressed: () {
                  context.read<TodosBloc>().add(
                        UpdateTodo(
                          todo: todo.copyWith(isCompleted: true),
                        ),
                      );
                    
                },
                icon: const Icon(Icons.add_task),
              ) : Container(),
              IconButton(
                onPressed: () {
                  context.read<TodosBloc>().add(DeleteTodo(todo: todo));
                },
                icon: const Icon(Icons.cancel),
              ),
            ],
          )
        ],
      ),
    ),
  );
}
