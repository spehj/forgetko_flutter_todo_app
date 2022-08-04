import 'package:flutter/material.dart';
import 'package:what_todo/database_helper.dart';
import 'package:what_todo/screens/homepage.dart';
import 'package:what_todo/screens/widgets.dart';

import '../models/task.dart';
import '../models/todo.dart';

class Taskpage extends StatefulWidget {
  final Task? task;

  Taskpage({required this.task});

  @override
  State<Taskpage> createState() => _TaskpageState();
}

class _TaskpageState extends State<Taskpage> {
  DatabaseHelper _dbHelper = DatabaseHelper();
  String _taskTitle = "";
  String _todoDefaultTitle = "";
  int _taskId = 0;
  String _taskDescription = "";
  Color _taskDoneColor = Colors.red;
  Color _taskNotDoneColor = Colors.transparent;

  late FocusNode _titleFocus;
  late FocusNode _descriptionFocus;
  late FocusNode _todoFocus;
  bool _contentVisible = false;

  //String _todoTitle = "";

  @override
  void initState() {
    //print("ID:  ${widget.task?.id}");

    if (widget.task != null) {
      _taskTitle = widget.task!.title;
      _taskId = widget.task!.id!;

      _contentVisible = true;

      // Check if task description is null
      if (widget.task?.description != null) {
        _taskDescription = widget.task!.description!;
      }
    }

    _titleFocus = FocusNode();
    _descriptionFocus = FocusNode();
    _todoFocus = FocusNode();

    super.initState();
  }

  @override
  void dispose() {
    _titleFocus.dispose();
    _descriptionFocus.dispose();
    _todoFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 24.0, bottom: 12.0),
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () {
                            //print("Clicked the back button");
                            Navigator.pop(context);
                          },
                          child: Padding(
                            padding: EdgeInsets.all(24.0),
                            child: Image.asset(
                                'assets/images/back_arrow_icon.png'),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding:
                            const EdgeInsets.only(left: 2.0, right: 24.0),
                            child: TextField(
                              focusNode: _titleFocus,
                              controller: TextEditingController()
                                ..text = _taskTitle,
                              onSubmitted: (value) async {
                                //print("Value is: $value");
                                if (value != "") {
                                  if (widget.task == null) {
                                    Task _newTask = Task(
                                        title: value,
                                        id: null,
                                        description: null);
                                    _taskId =
                                    await _dbHelper.insertTask(_newTask);
                                    //print("New task_id: $_taskId");
                                    setState(() {
                                      _contentVisible = true;
                                      _taskTitle = value;
                                    });
                                  } else {
                                    //print("Task ${widget.task!.id!} updated to: $value");
                                    await _dbHelper.updateTaskTitle(
                                        _taskId, value);
                                    setState(() {
                                      _taskTitle = value;
                                    });
                                  }
                                  _contentVisible = true;
                                  _descriptionFocus.requestFocus();
                                }
                              },
                              decoration: InputDecoration(
                                hintText: "Enter Task Title Here",
                                border: InputBorder.none,
                              ),
                              style: TextStyle(
                                  fontSize: 26.0,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF211551)),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Visibility(
                    visible: _contentVisible,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 12.0),
                      child: TextField(
                        controller: TextEditingController()
                          ..text = _taskDescription,
                        focusNode: _descriptionFocus,
                        onSubmitted: (value) async {
                          if (value != "") {
                            await _dbHelper.updateTaskDescription(
                                _taskId, value);
                            setState(() {
                              _taskDescription = value;
                            });
                          }

                          _todoFocus.requestFocus();
                        },
                        decoration: InputDecoration(
                            hintText: "Enter description for your task here.",
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 24.0,
                            )),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: _contentVisible,
                    child: FutureBuilder(
                      initialData: [],
                      future: _dbHelper.getTodos(_taskId),
                      builder: (context, AsyncSnapshot snapshot) {
                        return Expanded(
                          child: ListView.builder(
                              itemCount: snapshot.data?.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () async {
                                    int doneState = snapshot.data[index].isDone;
                                    int todoId = snapshot.data[index].id;
                                    if (doneState == 0) {
                                      doneState = 1;
                                    } else if (doneState == 1) {
                                      doneState = 0;
                                    }
                                    await _dbHelper.updateTodoDone(
                                        _taskId, todoId, doneState);

                                    setState(() {});
                                  },
                                  child: Container(
                                    child: TodoWidget(
                                      text: snapshot.data[index].title,
                                      isDone: snapshot.data[index].isDone == 0
                                          ? false
                                          : true,
                                    ),
                                  ),
                                );
                              }),
                        );
                      },
                    ),
                  ),
                  Visibility(
                    visible: _contentVisible,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 24.0, right: 24.0, bottom: 30),
                      child: Row(
                        children: [
                          Container(
                            width: 20.0,
                            height: 20.0,
                            margin: EdgeInsets.only(right: 12.0),
                            decoration: BoxDecoration(
                                color: _taskNotDoneColor,
                                borderRadius: BorderRadius.circular(6.0),
                                border: Border.all(
                                  color: Color(0xFF86829D),
                                  width: 1.5,
                                )),
                            child: Image.asset('assets/images/check_icon.png'),
                          ),
                          Expanded(
                            child: TextField(
                              focusNode: _todoFocus,
                              controller: TextEditingController()
                                ..text = _todoDefaultTitle,
                              onSubmitted: (value) async {
                                if (value != "") {
                                  if (_taskId != null) {
                                    DatabaseHelper _dbHelper = DatabaseHelper();

                                    Todo _newTodo = Todo(
                                      title: value,
                                      isDone: 0,
                                      taskId: _taskId,
                                    );
                                    await _dbHelper.insertTodo(_newTodo);
                                    setState(() {});
                                    _todoFocus.requestFocus();
                                    //print("Creating new todo");
                                  } else {
                                    print("Task is null");
                                  }
                                }
                              },
                              decoration: InputDecoration(
                                hintText: "Enter Todo Item...",
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
              Visibility(
                visible: _contentVisible,
                child: Positioned(
                  bottom: 24.0,
                  right: 24.0,
                  child: GestureDetector(
                    onTap: () async{
                      if(_taskId != null){
                        await _dbHelper.deleteTask(_taskId);
                      }

                      Navigator.pop(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Homepage())); // CHANGE
                    },
                    child: Container(
                      padding: EdgeInsets.all(24.0),
                      decoration: BoxDecoration(
                        color: Color(0xFFFE2577),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Image.asset('assets/images/delete_icon.png'),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
