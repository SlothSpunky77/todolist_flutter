import 'package:flutter/material.dart';
//import 'dart:async';
import 'package:flutter_reorderable_list/flutter_reorderable_list.dart';

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
        body: ReorderableListView.builder(
          itemCount: tasks.length,
          onReorder: (oldIndex, newIndex) {
            setState(() {
              if (newIndex > oldIndex) {
                newIndex -= 1;
              }
              final Task task = tasks.removeAt(oldIndex);
              tasks.insert(newIndex, task);
            });
          },
          itemBuilder: (BuildContext context, int index) {
            return //Column(
                //children: [
                ListTile(
              key: Key('$index'),
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
                  //if (tasks[index].isComplete) {
                  //tasks.removeAt(index);
                  //}
                },
              ),
            );
            /*
            const Divider(
              color: Color.fromARGB(255, 93, 93, 93),
            );
            */
            //],
            //);
          },
        ),
      ),
    );
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
    }
  }
}

class Task {
  String title;
  bool isComplete;
  Task({required this.title, this.isComplete = false});
}

void main() {
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyApp(),
    ),
  );
}
