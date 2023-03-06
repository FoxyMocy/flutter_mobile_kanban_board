part of './models.dart';

class BoardModel {
  String? id;
  String? name;
  String? userId;
  DateTime? timeCreated;
  DateTime? lastEdited;

  BoardModel(
      {this.id, this.name, this.userId, this.timeCreated, this.lastEdited});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'userId': userId,
      'timeCreated': timeCreated,
      'lastEdited': lastEdited,
    };
  }

  BoardModel.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc) {
    id = doc['id'];
    name = doc['name'];
    userId = doc['userId'];
    timeCreated = doc['timeCreated'];
    lastEdited = doc['lastEdited'];
  }
}
