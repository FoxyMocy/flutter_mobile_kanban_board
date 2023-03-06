part of './models.dart';

class UserModel {
  String? id;
  String? email;
  String? fullname;
  String? photoUrl;
  DateTime? timeCreated;
  DateTime? lastEdited;

  UserModel( {
    this.id,
    this.email,
    this.fullname,
    this.photoUrl,
    this.timeCreated,
    this.lastEdited,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'fullname': fullname,
      'photoUrl': photoUrl,
      'timeCreated': timeCreated,
      'lastEdited': lastEdited
    };
  }

  UserModel.fromSnapshot(DocumentSnapshot snapshot) {
    id = snapshot['id'];
    email = snapshot['email'];
    fullname = snapshot['fullname'];
    photoUrl = snapshot['photoUrl'];
    timeCreated = snapshot['timeCreated'];
  }
}
