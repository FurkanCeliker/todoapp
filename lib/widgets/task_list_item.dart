import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todoapp/data/local_storage.dart';
import 'package:todoapp/main.dart';
import 'package:todoapp/models/task_model.dart';

class TaskItem extends StatefulWidget {
  final Task task;
  TaskItem({Key? key, required this.task}) : super(key: key);

  @override
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  TextEditingController _taskNameContoller = TextEditingController();
  late LocalStorage _localStorage;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _localStorage = locator<LocalStorage>();
    _taskNameContoller.text = widget.task.name;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
            ),
          ]),
      child: ListTile(
        leading: GestureDetector(
          onTap: () {
            widget.task.isCompleted = !widget.task.isCompleted;
            _localStorage.updateTask(task: widget.task);
            setState(() {});
          },
          child: Container(
              decoration: BoxDecoration(
                  color: widget.task.isCompleted ? Colors.green : Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey, width: 0.8)),
              child: Icon(
                Icons.check,
                color: Colors.white,
              )),
        ),
        title: widget.task.isCompleted
            ? Text(
                widget.task.name,
                style: TextStyle(
                    decoration: TextDecoration.lineThrough, color: Colors.grey),
              )
            : TextField(
                controller: _taskNameContoller,
                maxLines:null,
                textInputAction: TextInputAction.done, //
                minLines: 1,
                decoration: InputDecoration(border: InputBorder.none),
                onSubmitted: (yeniDeger){
                  
                  if(yeniDeger.length>3){
                    widget.task.name=yeniDeger;
                    _localStorage.updateTask(task: widget.task);
                  }
                  
                },
                
              ),
              trailing: Text(
                DateFormat('hh:mm a').format(widget.task.createdAt), style: TextStyle(fontSize: 14,color: Colors.grey),
              ),
      ),
    );
  }
}
