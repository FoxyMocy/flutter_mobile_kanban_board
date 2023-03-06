part of './models.dart';

class ListModel {
  String? id;
  String? name;
  String? boardId;
  DateTime? timeCreated;
  DateTime? lastEdited;
  
  ListModel({
    this.id,
    this.name,
    this.boardId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'boardId': boardId,
    };
  }

  ListModel.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> json) {
    id = json['id'];
    name = json['name'];
    boardId = json['boardId'];
  }
}
