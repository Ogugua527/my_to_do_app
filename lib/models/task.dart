class Task {
  String todo;
  DateTime timeStamp;
  bool done;

  Task({required this.todo, required this.timeStamp, required this.done});

  Map<String, dynamic> toMap() {
    return {
      'todo': todo,
      'timeStamp': timeStamp.toIso8601String(),
      'done': done,
    };
  }

  factory Task.fromMap(Map map) {
    return Task(
      todo: map['todo'] ?? '',
      timeStamp: map['timeStamp'] is String
          ? DateTime.parse(map['timeStamp'])
          : (map['timeStamp'] ?? DateTime.now()),
      done: map['done'] ?? false,
    );
  }
}
