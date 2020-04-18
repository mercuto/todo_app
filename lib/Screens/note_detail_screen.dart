import 'package:flutter/material.dart';
import '../Models/todo.dart';
import '../Utils/database_helper.dart';
import 'package:intl/intl.dart';

class NoteDetailScreen extends StatefulWidget {
  final String appBarTilte;
  final Todo todo;
  NoteDetailScreen(this.todo, this.appBarTilte);

  @override
  _NoteDetailScreenState createState() =>
      _NoteDetailScreenState(todo, appBarTilte);
}

class _NoteDetailScreenState extends State<NoteDetailScreen> {
  Todo todo;
  String appBarTitle;
  static var _priorities = ['High', 'Medium', 'Low'];
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  DatabaseHelper databaseHelper = DatabaseHelper();

  _NoteDetailScreenState(this.todo, this.appBarTitle);

  @override
  Widget build(BuildContext context) {
    titleController.text = todo.title;
    descriptionController.text = todo.description;
    TextStyle textStyle = Theme.of(context).textTheme.title;

    return Scaffold(
      appBar: AppBar(title: Text(widget.appBarTilte)),
      body: getEditView(textStyle),
    );
  }

  Widget getEditView(TextStyle textStyle) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: <Widget>[
          ListTile(
            title: DropdownButton(
              items: _priorities.map((String ddItem) {
                return DropdownMenuItem<String>(
                  value: ddItem,
                  child: Text(
                    ddItem,
                    style: textStyle,
                  ),
                );
              }).toList(),
              value: priorityAsString(todo.priority),
              onChanged: (prioritySelected) {
                setState(() {
                  priorityAsInt(prioritySelected);
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: TextField(
              controller: titleController,
              style: textStyle,
              onChanged: (value) {
                updateTitle();
              },
              decoration: InputDecoration(
                labelText: 'Title',
                labelStyle: textStyle,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0)),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: TextField(
              controller: descriptionController,
              style: textStyle,
              onChanged: (value) {
                updateDescription();
              },
              decoration: InputDecoration(
                labelText: 'Description',
                labelStyle: textStyle,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0)),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                RaisedButton(
                  onPressed: () {
                    setState(() {
                      _save();
                    });
                  },
                  child: Text(
                    'Save',
                    textScaleFactor: 1.5,
                  ),
                  color: Colors.green,
                ),
                RaisedButton(
                  onPressed: () {
                    _delete();
                  },
                  child: Text(
                    'Delete',
                    textScaleFactor: 1.5,
                  ),
                  color: Colors.green,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  String priorityAsString(int val) {
    switch (val) {
      case 1:
        return _priorities[0];
        break;
      case 2:
        return _priorities[1];
        break;
      case 3:
        return _priorities[2];
        break;
      default:
        return _priorities[1];
    }
  }

  void priorityAsInt(String val) {
    switch (val) {
      case 'High':
        todo.priority = 1;
        break;
      case 'Medium':
        todo.priority = 2;
        break;
      case 'Low':
        todo.priority = 3;
        break;
      default:
        todo.priority = 2;
    }
  }

  void updateTitle() {
    todo.title = titleController.text;
  }

  void updateDescription() {
    todo.description = descriptionController.text;
  }

  void _save() async {
    Navigator.pop(context, true);
    todo.date = DateFormat.yMMMd().format(DateTime.now());
    int result;
    if (todo.id != null) {
      result = await databaseHelper.updateTodo(todo);
    } else {
      result = await databaseHelper.insertTodo(todo);
    }
    if (result != 0) {
      _showAlertDialog('Status', 'Todo Saved Successfully');
    } else {
      _showAlertDialog('Status', 'Error Occured!');
    }
  }

  void _showAlertDialog(String title, String msg) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(msg),
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }

  void _delete() async {
    Navigator.pop(context, true);

    if (todo.id == null) {
      _showAlertDialog('Status', 'Todo Discarded');
    } else {
      int result = await databaseHelper.deleteTodo(todo.id);
      if (result != 0) {
        _showAlertDialog('Status', 'Todo Deleted!');
      } else {
        _showAlertDialog('Status', 'Error Occured!');
      }
    }
  }
}
