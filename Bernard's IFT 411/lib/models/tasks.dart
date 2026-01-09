
class Tasks {
  String todo;
  DateTime timeStamp;
  bool done;

  Tasks({
    required this.todo,
    required this.timeStamp,
    required this.done
});

  Map toMap() {
    return {
      'todo': todo,
      'timeStamp': timeStamp,
      'done': done,
    };
  }

  // factory returns an instance of the Tasks class
  factory Tasks.fromMap(Map task){
    return Tasks(
        todo: task['todo'],
        timeStamp: task['timeStamp'],
        done: task['done']
    );
  }
}

