import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_list_app/models/tasks.dart';

class TasksPage extends StatefulWidget {
  const TasksPage({super.key});

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  double? _deviceHeight, _deviceWidth;
  String? content;
  Box? _box;

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: _deviceHeight! * 0.1,
        title: const Text('Daily Planner'),
        leading: const Icon(Icons.arrow_back_ios, color: Colors.white),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      body: _tasksWidget(),
      floatingActionButton: FloatingActionButton(
        onPressed: displayTaskPop,
        child: const Icon(Icons.add),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
    );
  }

  // 🔹 Open Hive box
  // Future<Box> _openBox() async {
  //   return await Hive.openBox('tasks');
  // }


  Widget _todoList (){
    List tasks = _box!.values.toList();
    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (BuildContext context, int index) {
        var task = Tasks.fromMap(tasks[index]);
        return Card(
          color: Colors.white,
          elevation: 2,
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: ListTile(
            title: Text(
              task.todo,
              style: TextStyle(
                color: Colors.purple[900],
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              task.timeStamp.toString(),
              style: TextStyle(color: Colors.purple[300]),
            ),
            trailing: task.done
                ? Icon(Icons.check_box_outlined, color: Colors.purple)
                : Icon(Icons.check_box_outline_blank, color: Colors.purple[200]),
            onTap: () {
              task.done = !task.done;
              _box!.putAt(index, task.toMap());
              setState(() {});
            },
            onLongPress: () {
              _box!.deleteAt(index);
              setState(() {});
            },
          ),
        );
      },
    );
}

  /// 🔹 Display tasks
  Widget _tasksWidget() {
    return FutureBuilder(
      future: Hive.openBox('tasks'),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return const Center(child: Text('Error loading tasks'));
        }
        if (snapshot.hasData) {
          _box = snapshot.data;
          return _todoList();
        } else {
          return const Center(child: Text('No tasks found'));
        }
      },
    );
  }

  /// 🔹 Add task dialog
  void displayTaskPop() {
    String? newTaskContent;
    showDialog(
      context: context,
      builder: (BuildContext _context) {
        return AlertDialog(
          title: const Text('New Task'),
          content: TextField(
            autofocus: true,
            decoration: const InputDecoration(hintText: 'Enter your task'),
            onChanged: (value) {
              newTaskContent = value;
            },
            onSubmitted: (value) {
              if (value.trim().isNotEmpty) {
                var task = Tasks(
                  todo: value.trim(),
                  timeStamp: DateTime.now(),
                  done: false,
                );
                _box!.add(task.toMap());
                setState(() {});
                Navigator.pop(context);
              }
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (newTaskContent != null && newTaskContent!.trim().isNotEmpty) {
                  var task = Tasks(
                    todo: newTaskContent!.trim(),
                    timeStamp: DateTime.now(),
                    done: false,
                  );
                  _box!.add(task.toMap());
                  setState(() {});
                  Navigator.pop(context);
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }
}

