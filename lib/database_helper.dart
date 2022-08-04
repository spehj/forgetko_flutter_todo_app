import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:what_todo/models/todo.dart';

import 'models/task.dart';

class DatabaseHelper {
  // All DB queries here

  Future<Database> database() async {
    return openDatabase(
      join(await getDatabasesPath(), 'todo.db'),
      onCreate: (db, version) async {
        // Run the CREATE TABLE statement on the database.
        await db.execute(
            'CREATE TABLE tasks(id INTEGER PRIMARY KEY, title TEXT, description TEXT)');
        await db.execute(
            'CREATE TABLE todo(id INTEGER PRIMARY KEY, taskId INTEGER, title TEXT, isDone INTEGER)');

        return Future.value();
      },
      version: 1,
    );
  }

  Future<int> insertTask(Task task) async {
    int taskId = 0;
    Database _db = await database();
    await _db
        .insert('tasks', task.toMap(),
            conflictAlgorithm: ConflictAlgorithm.replace)
        .then((value) {
      taskId = value;
    });
    return taskId;
  }

  Future<void> insertTodo(Todo todo) async {
    Database _db = await database();
    await _db.insert('todo', todo.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> updateTaskTitle(int id, String title) async {
    Database _db = await database();
    await _db.rawUpdate("UPDATE tasks SET title = '$title' WHERE id=$id");
  }

  Future<void> updateTaskDescription(int id, String description) async {
    Database _db = await database();
    await _db
        .rawUpdate("UPDATE tasks SET description='$description' WHERE id=$id");
  }

  Future<void> updateTodoDone(int taskId, int todoId, int isDone) async {
    Database _db = await database();
    await _db.rawUpdate(
        "UPDATE todo SET isDone=$isDone WHERE (taskId=$taskId AND id=$todoId)");
  }

  Future<void> updateTodoTitle(int taskId, int todoId, String title) async {
    Database _db = await database();
    await _db.rawUpdate(
        "UPDATE todo SET title='$title' WHERE (taskId=$taskId AND id=$todoId)");
  }
  
  Future<void> deleteTask(int taskId) async{
    Database _db = await database();
    await _db.rawDelete("DELETE FROM tasks WHERE id=$taskId");
    await _db.rawDelete("DELETE FROM todo WHERE taskId=$taskId");
  }

  Future<void> deleteTodo(int taskId, int todoId) async{
    Database _db = await database();
    await _db.rawDelete("DELETE FROM todo WHERE (taskId=$taskId AND id=$todoId)");
  }

  // Method to help retreive list of all cards
  Future<List<Task>> getTasks() async {
    Database _db = await database();
    List<Map<String, dynamic>> taskMap = await _db.query('tasks');
    return List.generate(taskMap.length, (index) {
      return Task(
          id: taskMap[index]['id'],
          title: taskMap[index]['title'],
          description: taskMap[index]['description']);
    });
  }

  Future<List<Todo>> getTodos(int taskId) async {
    Database _db = await database();
    //List<Map<String, dynamic>> todoMap = await _db.query('todo');
    List<Map<String, dynamic>> todoMap =
        await _db.rawQuery("SELECT * FROM todo WHERE taskId = $taskId");
    return List.generate(todoMap.length, (index) {
      return Todo(
          id: todoMap[index]['id'],
          taskId: todoMap[index]['taskId'],
          title: todoMap[index]['title'],
          isDone: todoMap[index]['isDone']);
    });
  }
}
