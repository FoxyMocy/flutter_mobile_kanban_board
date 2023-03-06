part of './services.dart';

class AuthService {
  UserModel userData = UserModel();
  UserService service = UserService();
  // firestore db
  FirebaseFirestore db = FirebaseFirestore.instance;
  String? errorMessage = '';

  List avatar = [
    'https://firebasestorage.googleapis.com/v0/b/kanban-project-b1de6.appspot.com/o/avatar%2Fava_male_2.png?alt=media&token=7459c33f-a70b-4b33-b8ba-1054927d2ebe',
    'https://firebasestorage.googleapis.com/v0/b/kanban-project-b1de6.appspot.com/o/avatar%2Fava_female_1.png?alt=media&token=5eabd084-5b6c-4bee-b7b1-f348e4663959',
    'https://firebasestorage.googleapis.com/v0/b/kanban-project-b1de6.appspot.com/o/avatar%2Fava_female_3.png?alt=media&token=50572ac7-86a8-4a8c-a708-675af615a336',
    'https://firebasestorage.googleapis.com/v0/b/kanban-project-b1de6.appspot.com/o/avatar%2Fava_male_1.png?alt=media&token=eda4d170-b35f-405c-8033-871f462b84e4',
  ];

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    try {
      await Auth().signInWithEmailAndPassword(
        email:email,
        password:password,
      );

      final User? user = Auth().currentUser;
      // get user id
      String userID = user!.uid;

      // creating user profile on db
      await db.collection("users").doc(userID).update({
        "lastLogin": DateTime.now(),
      });
    } on FirebaseAuthException catch (e) {
      errorMessage = e.message;
    }
  }

  Future<void> createUserWithEmailAndPassword(String email, String password, String fullname) async {
    try {
      await Auth().createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final User? user = Auth().currentUser;
      // get user id
      String userID = user!.uid;

      final _random = new Random();
      final userData = UserModel(
        id: userID,
        fullname: fullname,
        email: email,
        photoUrl: avatar[_random.nextInt(avatar.length)],
      );
      // Add user on DB
      await service.addUser(userData, userID);
    } on FirebaseAuthException catch (e) {
      errorMessage = e.message;
    }
  }
}
