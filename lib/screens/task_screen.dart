import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/task.dart';

class TasksPage extends StatefulWidget {
  const TasksPage({super.key});

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  late final Box _box;
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _box = Hive.box('tasks');
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double deviceHeight = MediaQuery.sizeOf(context).height;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: deviceHeight * 0.1,
        title: const Text("Daily Planner"),
      ),
      body: _todoList(),
      floatingActionButton: FloatingActionButton(
        onPressed: _displayTaskPopup,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _todoList() {
    List tasks = _box.values.toList();
    if (tasks.isEmpty) {
      return const Center(
        child: Text(
          "No tasks yet. Tap '+' to add one!",
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }
    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (BuildContext context, int index) {
        var task = Task.fromMap(tasks[index] as Map);
        return ListTile(
          title: Text(
            task.todo,
            style: TextStyle(
              decoration: task.done ? TextDecoration.lineThrough : null,
            ),
          ),
          subtitle: Text(
            '${task.timeStamp.toLocal()}'.split('.')[0],
            style: const TextStyle(fontSize: 12),
          ),
          trailing: task.done
              ? const Icon(
                  Icons.check_box_outlined,
                  color: Colors.green,
                )
              : const Icon(Icons.check_box_outline_blank),
          onTap: () {
            task.done = !task.done;
            _box.putAt(index, task.toMap());
            setState(() {});
          },
          onLongPress: () {
            _box.deleteAt(index);
            setState(() {});
          },
        );
      },
    );
  }

  void _addTask(String value) {
    if (value.trim().isNotEmpty) {
      var task = Task(
        todo: value.trim(),
        timeStamp: DateTime.now(),
        done: false,
      );
      _box.add(task.toMap());
      Navigator.pop(context);
      setState(() {});
    }
  }

  void _displayTaskPopup() {
    _textController.clear();
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text("Add a ToDo"),
          content: TextField(
            controller: _textController,
            autofocus: true,
            decoration: const InputDecoration(hintText: 'Enter task description'),
            onSubmitted: (value) => _addTask(value),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => _addTask(_textController.text),
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }
}
