import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todos/models/todos_model.dart';

import '../blocs/todos/todos_bloc.dart';

class AddToDoScreen extends StatelessWidget {
  const AddToDoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController controllerId = TextEditingController();
    TextEditingController controllerTask = TextEditingController();
    TextEditingController controllerDescription = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title:  Text('add_to_do'.tr),
      ),
      body: BlocListener<TodosBloc, TodosState>(
        listener: (context, state) {
          if (state is TodosLoaded) {
            ScaffoldMessenger.of(context).showSnackBar(
               SnackBar(
                content: Text('to_do_added'.tr),
              ),
            );
          }
        },
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                _inputField('id'.tr, controllerId),
                _inputField('task'.tr, controllerTask),
                _inputField('description'.tr, controllerDescription),
                ElevatedButton(
                  onPressed: () {
                    var todo = Todo(
                      id: controllerId.value.text,
                      task: controllerTask.value.text,
                      description: controllerDescription.value.text,
                    );
                    context.read<TodosBloc>().add(
                          AddTodo(todo: todo),
                        );
                    Navigator.pop(context);
                  },
                  child: Text('add'.tr),
                  style: ElevatedButton.styleFrom(
                    primary: Theme.of(context).primaryColor,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Column _inputField(String field, TextEditingController controller) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        '$field ',
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      Container(
        height: 50.0,
        margin: const EdgeInsets.only(bottom: 10.0),
        width: double.infinity,
        child: TextFormField(
          controller: controller,
        ),
      ),
    ],
  );
}
