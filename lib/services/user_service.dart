part of './services.dart';

class UserService {
  final FirebaseFirestore db = FirebaseFirestore.instance;

  // User Services
  Future<void> addUser(UserModel userData, String userID) async {
    await db.collection("users").doc(userID).set(userData.toMap());
  }

  Future<void> editUser(UserModel userData, String userID) async {
    await db.collection("users").doc(userID).set(userData.toMap());
  }

  Future<UserModel> retrieveUser(String userID) async {
    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await db.collection("users").doc(userID).get();

    return UserModel.fromSnapshot(snapshot);
  }
}
