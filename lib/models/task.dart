part of './models.dart';

class TaskModel {
  String? id;
  String? title;
  String? description;
  String? boardId;
  String? listId;
  String? taskStart;
  String? taskEnd;
  DateTime? timeCreated;
  DateTime? lastEdited;

  TaskModel({
    this.id,
    this.title,
    this.description,
    this.boardId,
    this.listId,
    this.taskStart,
    this.taskEnd,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'boardId': boardId,
      'listId': listId,
      'taskStart': taskStart,
      'taskEnd': taskEnd,
    };
  }

  TaskModel.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    boardId = json['boardId'];
    listId = json['listId'];
    taskStart = json['taskStart'];
    taskEnd == json['taskEnd'];
  }
}
