import 'package:flutter/material.dart';

class TaskCardWidget extends StatelessWidget {
  final String? title;
  final String? description;
  TaskCardWidget({this.title, this.description});


  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 16.0),
      padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title ?? "No task title!",
            style: TextStyle(
                color: Color(0xFF211551),
                fontWeight: FontWeight.bold,
                fontSize: 22.0),
          ),
          Padding(
            padding: EdgeInsets.only(top: 16.0),
            child: Text(
              description ?? "No task description has been added!" ,
              style: TextStyle(
                fontWeight: FontWeight.w400,
                color: Color(0XFF86829D),
                fontSize: 16.0,
                height: 1.5,
              ),
            ),
          ),

        ],
      ),
    );
  }
}


class TodoWidget extends StatelessWidget {
  //const TodoWidget({Key? key}) : super(key: key);

  final String text;
  final bool isDone;

  TodoWidget({Key? key, required this.text, required this.isDone}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 8.0,
      ),
      margin: EdgeInsets.only(left: 24.0, right: 24.0),
      child: Row(
        children: [
          Container(

            width: 20.0,
            height: 20.0,
            margin: EdgeInsets.only(right: 12.0),
            decoration: BoxDecoration(
              color: isDone ? Color(0xFF7349FE) : Colors.transparent,
              borderRadius: BorderRadius.circular(6.0),
              border: isDone ? null : Border.all(
                color: Color(0xFF86829D),
                width: 1.5,
              )
            ),

            child: Image.asset('assets/images/check_icon.png'),
            ),
          Expanded(
            child: Text(text,
            style: TextStyle(
              color: isDone ? Color(0xFF86829D) : Color(0xFF211551) ,
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
            ),
          ),

          Container(

            width: 30.0,
            height: 30.0,
            margin: EdgeInsets.only(right: 0),
            decoration: BoxDecoration(
                color: Color(0xFFFE2577),
                borderRadius: BorderRadius.circular(6.0),

            ),

            child: Image.asset('assets/images/delete_icon.png'),
          ),



        ],
      ),
    );
  }
}
