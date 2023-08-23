import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'dart:async';
//import 'package:flutter_reorderable_list/flutter_reorderable_list.dart';

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final List<Task> tasks = [];
  //Timer? _midnTimer;
/*
  @override
  void initState()
  {

  }
*/

  late SharedPreferences prefs;
  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
    _loadTasks();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text("ToDo App"),
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            openDialog();
          },
          child: const Icon(Icons.add),
        ),
        body: /*Reorderable*/ ListView.builder(
          itemCount: tasks.length,
          /*onReorder: (oldIndex, newIndex) {
            setState(() {
              if (newIndex > oldIndex) {
                newIndex -= 1;
              }
              final Task task = tasks.removeAt(oldIndex);
              tasks.insert(newIndex, task);
            });
          },*/
          itemBuilder: (BuildContext context, int index) {
            return Column(
              children: [
                ListTile(
                  //key: Key('$index'),
                  onTap: () {
                    if (tasks[index].isComplete) {
                      _deleteTask(index);
                    } else {
                      _editTask(index);
                    }
                  },
                  title: Text(
                    tasks[index].title,
                    style: TextStyle(
                      decoration: tasks[index].isComplete
                          ? TextDecoration.lineThrough
                          : null,
                      decorationThickness: 3,
                      color: Colors.white,
                    ),
                  ),
                  trailing: Checkbox(
                    value: tasks[index].isComplete,
                    onChanged: (bool? value) {
                      setState(() {
                        tasks[index].isComplete = value ?? false;
                      });
                      _saveTasks();
                      /*
                      if (tasks[index].isComplete) {
                        tasks.removeAt(index);
                      }
                      */
                    },
                  ),
                ),
                const Divider(
                  color: Color.fromARGB(255, 93, 93, 93),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Future<void> _loadTasks() {
    final taskList = prefs.getStringList('tasks') ?? [];
    setState(() {
      tasks.clear();
      tasks.addAll(taskList.map((task) {
        final taskData = task.split(':');
        return Task(title: taskData[0], isComplete: taskData[1] == 'true');
      }).where((task) => !task.isComplete));
    });
    return Future.value();
  }

  Future<void> _saveTasks() {
    final taskList = tasks.map((task) {
      return '${task.title}:${task.isComplete}';
    }).toList();
    prefs.setStringList('tasks', taskList);
    return Future.value();
  }

  Future<void> _editTask(int index) async {
    final TextEditingController editController =
        TextEditingController(text: tasks[index].title);
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            "Edit Task",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: const Color.fromARGB(255, 50, 50, 50),
          content: TextField(
            controller: editController,
            style: const TextStyle(color: Colors.white),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  tasks[index].title = editController.text;
                });
                _saveTasks();
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteTask(index) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            "Delete Task",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: const Color.fromARGB(255, 50, 50, 50),
          content: const Text(
            "Delete task? Fosho?",
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  tasks.removeAt(index);
                });
                _saveTasks();
                Navigator.of(context).pop();
              },
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );
  }

  Future<void> openDialog() async {
    TextEditingController textFieldController = TextEditingController();

    String? task = await showDialog(
      // Added 'String?' before 'task'
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            "New task:",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: const Color.fromARGB(255, 50, 50, 50),
          content: TextField(
            controller: textFieldController,
            autofocus: true,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              hintText: "Add task...",
              hintStyle: TextStyle(color: Color.fromARGB(255, 142, 142, 142)),
            ),
            onSubmitted: (_) {
              Navigator.of(context).pop(textFieldController.text);
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(textFieldController.text);
              },
              child: const Text('SUBMIT'),
            ),
          ],
        );
      },
    );

    if (task != null && task.isNotEmpty) {
      // Added 'task.isNotEmpty' condition
      setState(() {
        tasks.add(Task(title: task));
      });
      _saveTasks();
    }
  }
}

class Task {
  String title;
  bool isComplete;
  Task({required this.title, this.isComplete = false});
  //Database
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'isComplete': isComplete,
    };
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      title: json['title'],
      isComplete: json['isComplete'],
    );
  }
}

void main() {
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyApp(),
    ),
  );
}
