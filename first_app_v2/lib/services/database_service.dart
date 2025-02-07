import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:first_app_v2/models/todo.dart';
const String TODO_COLLECTION_REF = "todos";

class DatabaseService {

  final _firestore = FirebaseFirestore.instance;
  late final CollectionReference _todosRef;

  DatabaseService() {
    _todosRef = _firestore.collection(TODO_COLLECTION_REF).withConverter<Todo>(
      fromFirestore: (snapshots, _) => Todo.fromJson(
          snapshots.data()!.map((key, value) =>
          MapEntry(key, value as Object)),
        ),
      toFirestore: (todo, _) => todo.toJson()
    );
  }

  Stream <QuerySnapshot> getTodos() {
    return _todosRef.snapshots();
  }

  void addTodo(Todo todo) async {
    _todosRef.add(todo);
  }

  void updatedTodo(String todoId, Todo todo) {
    _todosRef.doc(todoId).update(todo.toJson());
  }

  void deleteTodo(String todoId) {
    _todosRef.doc(todoId).delete();
  }
}