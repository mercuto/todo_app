import 'package:flutter/material.dart';
import 'package:todo_app/Screens/note_detail_screen.dart';
import '../Models/todo.dart';
import '../Utils/database_helper.dart';

class NoteListScreen extends StatefulWidget {
  @override
  _NoteListScreenState createState() => _NoteListScreenState();
}

class _NoteListScreenState extends State<NoteListScreen> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Todo> todoList;
  int count = 0;

  @override
  Widget build(BuildContext context) {
    if (todoList == null) {
      todoList = List<Todo>();
      updateListView();
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo'),
      ),
      body: getListView(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return NoteDetailScreen(Todo('', '', 2), 'Add TODO');
          })).then((val) {
            if (val == true) updateListView();
          });
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.yellow,
        tooltip: 'Add Todo',
      ),
    );
  }

  ListView getListView() {
    TextStyle titleStyle = Theme.of(context).textTheme.subhead;

    return ListView.builder(
        itemBuilder: (context, ind) => Card(
              color: Colors.white,
              elevation: 5,
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor:
                      getPriorityColor(this.todoList[ind].priority),
                  child: getPriorityIcon(this.todoList[ind].priority),
                ),
                title: Text(
                  this.todoList[ind].title,
                  style: titleStyle,
                ),
                subtitle: Text(this.todoList[ind].description),
                trailing: GestureDetector(
                  child: Icon(Icons.delete, color: Colors.grey),
                  onTap: () => _delete(context, todoList[ind]),
                ),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return NoteDetailScreen(this.todoList[ind], 'Edit TODO');
                  })).then((val) {
                    if (val == true) updateListView();
                  });
                },
              ),
            ),
        itemCount: count);
  }

  Color getPriorityColor(int priority) {
    switch (priority) {
      case 1:
        return Colors.red.withOpacity(0.7);
        break;
      case 2:
        return Colors.yellow.withOpacity(0.9);
        break;
      case 3:
        return Colors.lightGreenAccent;
        break;
      default:
        return Colors.yellow.withOpacity(0.9);
    }
  }

  Icon getPriorityIcon(int priority) {
    switch (priority) {
      case 1:
        return Icon(Icons.star);
        break;
      case 2:
        return Icon(Icons.star_half);
        break;
      case 3:
        return Icon(Icons.star_border);
        break;
      default:
        return Icon(Icons.star_half);
    }
  }

  void _delete(BuildContext context, Todo todo) async {
    int result = await databaseHelper.deleteTodo(todo.id);
    if (result != 0) {
      _showSnackBar(context, 'Todo Deleted Successfully');
      updateListView();
    }
  }

  void _showSnackBar(BuildContext context, String string) {
    final snackBar = SnackBar(content: Text(string),duration: Duration(seconds: 1),);
    Scaffold.of(context).removeCurrentSnackBar();
    Scaffold.of(context).showSnackBar(snackBar);
  }

  void updateListView() async {
    await databaseHelper.intializeDatabase();
    final todoList = await databaseHelper.getTodoList();
    setState(() {
      this.todoList = todoList;
      this.count = todoList.length;
    });
  }
}
