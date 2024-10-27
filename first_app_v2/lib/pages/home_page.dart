

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:first_app_v2/models/todo.dart';
import 'package:first_app_v2/services/database_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _textEditingController = TextEditingController();
  final DatabaseService _databaseService = DatabaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: _appBar(),
      body: _buildUI(),
      floatingActionButton: FloatingActionButton(
        onPressed: _displayTextInputDialog, 
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(Icons.add),
      ),
    );
  }

  PreferredSizeWidget _appBar() {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.primary,
      title: const Text(
        "Todo", 
        style: TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildUI() {
    return SafeArea(
      child: Column(
        children: [
          _messagesListView(),
        ],
      )
    );
  }

  Widget _messagesListView() {
    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.80,
      width: MediaQuery.sizeOf(context).width,
      child: StreamBuilder(
        stream: _databaseService.getTodos(),
        builder: (context, snapshot) {
          List todos = snapshot.data?.docs ?? [];
          if (todos.isEmpty) {
            return const Center (
              child: Text ("Add a todo!"),
              );
          }
          print(todos);
          return ListView.builder(
            itemCount: todos.length,
            itemBuilder: (context, index) {
              Todo todo = todos[index].data(); 
              // access todo data in here
              String todoId = todos[index].id;
              print(todoId); 
              return Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 10,
                ), 
                child: ListTile(
                  tileColor: Theme.of(context).colorScheme.primaryContainer,
                  title: Text(todo.task),
                  subtitle: Text(
                    DateFormat("dd-MM-yyy h:mm a").format(
                      todo.updatedOn.toDate(),
                    )
                  ),
                  trailing: Checkbox(
                    value: todo.isDone, 
                    onChanged: (value) {
                      Todo updatedTodo = todo.copyWith(
                        isDone: !todo.isDone, 
                        updatedOn: Timestamp.now()
                      );
                      _databaseService.updatedTodo(todoId, updatedTodo);
                    }
                  ),
                  onLongPress: () {
                    _databaseService.deleteTodo(todoId);
                  } ,

                ),
              );
            },
          );
        },
      ),
    );
  }

  void _displayTextInputDialog() async {
    return showDialog(
        context: context, 
        builder: (context){
          return AlertDialog(
            title: const Text('Add a Todo'),
            content: TextField(
                controller: _textEditingController,
                decoration: const InputDecoration(hintText: "Todo..."),
              ),
            actions: <Widget>[
              MaterialButton(
                color: Theme.of(context).colorScheme.primary,
                textColor: Colors.white,
                child: const Text('Ok'),
                onPressed: () {
                  Todo todo = Todo(
                      task: _textEditingController.text, 
                      isDone: false, 
                      createdOn: Timestamp.now(), 
                      updatedOn: Timestamp.now(),
                    );
                  _databaseService.addTodo(todo);
                  Navigator.pop(context);
                  _textEditingController.clear();
                },
              )
            ]
          );
        }
      );
  }
}