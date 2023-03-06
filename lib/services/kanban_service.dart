part of './services.dart';

class KanbanService {
  final FirebaseFirestore db = FirebaseFirestore.instance;

  // Board Services
  Future<void> createNewBoard(BoardModel boardModel) async {
    await db.collection("boards").doc().set(boardModel.toMap());
  }
  Future<void> updateBoard(BoardModel boardModel, String boardId) async {
    await db.collection("boards").doc(boardId).set(boardModel.toMap());
  }
  Future<void> deleteBoard(BoardModel boardModel, String boardId) async {
    await db.collection("boards").doc(boardId).delete();
  }
  Future<BoardModel> retrieveBoard() async {
    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await db.collection("boards").doc().get();

    return BoardModel.fromDocumentSnapshot(snapshot);
  }

  // List Services
  Future<void> createNewList(ListModel listModel) async {
    await db.collection("lists").doc().set(listModel.toMap());
  }
  Future<void> updateList(ListModel listModel) async {
    await db.collection("lists").doc().set(listModel.toMap());
  }
  Future<void> deleteList(ListModel listModel, String listId) async {
    await db.collection("lists").doc(listId).delete();
  }
  Future<ListModel> retrieveList() async {
    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await db.collection("lists").doc().get();

    return ListModel.fromDocumentSnapshot(snapshot);
  }

  // Task Services
  Future<void> createNewTask(TaskModel taskModel) async {
    await db.collection("tasks").doc().set(taskModel.toMap());
  }
  Future<void> updateTask(TaskModel taskModel) async {
    await db.collection("tasks").doc().set(taskModel.toMap());
  }
  Future<void> deleteTask(TaskModel taskModel, String taskId) async {
    await db.collection("tasks").doc(taskId).delete();
  }
  Future<TaskModel> retrieveTask() async {
    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await db.collection("tasks").doc().get();

    return TaskModel.fromDocumentSnapshot(snapshot);
  }
}
