

import 'package:first_app_v2/models/todo.dart';
import 'package:first_app_v2/services/database_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DatabaseService _databaseService = DatabaseService();

  @override
  widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: _appBar(),
      body: _buildUI(),

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
        builder: (context, snapchot) {
          List todos = snapshot.data?.docs ?? [];
          if (todo.isEmpty) {
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
              return Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 10,
                ), 
                child: ListTile(
                  tileColor: Theme.of(context).colorScheme.primaryContainer),
                  // TODO: Checkpoint
                ),
              );
            },
          );
        },
      ),
    );
  }
}