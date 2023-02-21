part of '../../widgets.dart';

class EditTaskItem extends StatefulWidget {
  String taskId, boardId;
  EditTaskItem({required this.taskId, required this.boardId, super.key});

  @override
  State<EditTaskItem> createState() => _EditTaskItemState();
}

class _EditTaskItemState extends State<EditTaskItem> {
  TextEditingController taskController = TextEditingController();
  TextEditingController descController = TextEditingController();
  bool isTaskStart = false;
  String? errorMessage = '';
  var selectedValue;

  // firestore db
  FirebaseFirestore db = FirebaseFirestore.instance;

  Future<void> updateTask(String updateId) async {
    try {
      final User? user = Auth().currentUser;
      // get user id
      String userID = user!.uid;

      //Store Data
      final storeData = db.collection("tasks").doc(updateId);

      // creating section on db
      await storeData.update({
        "title": taskController.text,
        "description": descController.text,
        // "listId": selectedValue,
        "lastEdited": DateTime.now(),
      });
      print("update task successfully!");
    } on FirebaseAuthException catch (e) {
      print("Something is wrong: $e");
      errorMessage = e.message;
    }
  }

  Future<void> updateListTask(String updateId) async {
    try {
      final User? user = Auth().currentUser;
      // get user id
      String userID = user!.uid;

      //Store Data
      final storeData = db.collection("tasks").doc(updateId);

      // creating section on db
      await storeData.update({
        "listId": selectedValue,
      });
      print("update task successfully!");
    } on FirebaseAuthException catch (e) {
      print("Something is wrong: $e");
      errorMessage = e.message;
    }
  }

  Future<void> startTask(String updateId) async {
    try {
      final User? user = Auth().currentUser;
      // get user id
      String userID = user!.uid;

      //Store Data
      final storeData = db.collection("tasks").doc(updateId);

      // Get the Timestamp object from Firestore
      Timestamp timestamp = Timestamp.now();

      // Convert the Timestamp object to a DateTime object
      DateTime date = timestamp.toDate();

      // Format the DateTime object as a string
      String formattedDate = DateFormat('dd MMM yyyy HH:mm').format(date);

      // creating section on db
      await storeData.update({
        "taskStart": formattedDate,
        "lastEdited": DateTime.now(),
      });
      print("update task successfully!");
    } on FirebaseAuthException catch (e) {
      print("Something is wrong: $e");
      errorMessage = e.message;
    }
  }

  Future<void> endTask(String updateId) async {
    try {
      //Store Data
      final storeData = db.collection("tasks").doc(updateId);

      // Get the Timestamp object from Firestore
      Timestamp timestamp = Timestamp.now();

      // Convert the Timestamp object to a DateTime object
      DateTime date = timestamp.toDate();

      // Format the DateTime object as a string
      String formattedDate = DateFormat('dd MMM yyyy HH:mm').format(date);

      // creating section on db
      await storeData.update({
        "taskEnd": formattedDate,
        "lastEdited": DateTime.now(),
      });
      print("create new section successfully!");
    } on FirebaseAuthException catch (e) {
      print("Something is wrong: $e");
      errorMessage = e.message;
    }
  }

  Future<void> deleteTask(String updateId) async {
    try {
      //Store Data
      final storeData = db.collection("tasks").doc(updateId);

      // delete tasks on db
      await storeData.delete();
      print("delete successfully!");
    } on FirebaseAuthException catch (e) {
      print("Something is wrong: $e");
      errorMessage = e.message;
    }
  }

  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot> taskStream =
        FirebaseFirestore.instance.collection('tasks').snapshots();
    // Query the collection you want to populate in the dropdown menu
    CollectionReference collection =
        FirebaseFirestore.instance.collection('lists');

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColor().white,
      appBar: AppBar(
        backgroundColor: AppColor().primary,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.close,
            color: AppColor().white,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              await updateTask(widget.taskId);
            },
            child: Text(
              "Save",
              style: TextStyle(
                color: AppColor().white,
                fontSize: 16,
              ),
            ),
          )
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: taskStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Loading");
          }

          return Column(
            children: snapshot.data!.docs
                .where((element) => element['id'] == widget.taskId)
                .map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data()! as Map<String, dynamic>;
              final taskId = data['id'];
              final taskName = data['title'];
              final listId = data['listId'];
              final descName = data['description'];

              taskController.text = taskName;
              descController.text = descName;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 20,
                      horizontal: 16,
                    ),
                    // TASK NAME
                    child: TextFormField(
                      controller: taskController,
                      decoration:
                          InputDecoration.collapsed(hintText: 'Task Name'),
                      style: TextStyle(
                          color: AppColor().black,
                          fontSize: 20,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  // LIST & ASSIGN
                  FutureBuilder<QuerySnapshot>(
                    future: collection.get(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        List<DropdownMenuItem<String>> items = snapshot
                            .data!.docs
                            .where((element) =>
                                element['boardId'] == widget.boardId)
                            .map((doc) {
                          return DropdownMenuItem(
                            value: doc.id,
                            child: Text(
                              doc['name'],
                              style: TextStyle(
                                  color: AppColor().black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500),
                            ),
                          );
                        }).toList();

                        return Padding(
                          padding: EdgeInsets.only(
                            left: 16,
                            right: 16,
                            bottom: 10,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      width: 1,
                                      color: AppColor().grey,
                                    ),
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  child: items
                                      .firstWhere(
                                          (element) => element.value == listId)
                                      .child,
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      width: 1,
                                      color: AppColor().grey,
                                    ),
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  child: DropdownButton<String>(
                                    isDense: true,
                                    isExpanded: true,
                                    value: selectedValue,
                                    items: items,
                                    hint: Text('Move Task to'),
                                    onChanged: (value) {
                                      setState(() {
                                        selectedValue = value;
                                      });
                                      updateListTask(taskId);
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        return CircularProgressIndicator();
                      }
                    },
                  ),
                  // SECTION & ASSIGN END

                  // DESCRIPTION
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 16,
                      right: 16,
                      bottom: 30,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Description',
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColor().black,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          height: 200,
                          width: double.infinity,
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                              color: AppColor().grey,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: TextFormField(
                            controller: descController,
                            maxLines: null,
                            expands: true,
                            decoration: InputDecoration.collapsed(
                                hintText: 'Description'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // DESCRIPTION END
                  // BUTTON START & FINISHED TASK
                  Padding(
                    padding: const EdgeInsets.only(left: 16, right: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            data['taskStart'] != null
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Task Start at',
                                        style:
                                            TextStyle(color: AppColor().black),
                                      ),
                                      Text(
                                        data['taskStart'],
                                        style: TextStyle(
                                            color: AppColor().primary),
                                      )
                                    ],
                                  )
                                : SizedBox(),
                            data['taskEnd'] != null
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Task Finished at',
                                        style:
                                            TextStyle(color: AppColor().black),
                                      ),
                                      Text(
                                        data['taskEnd'],
                                        style:
                                            TextStyle(color: AppColor().green),
                                      )
                                    ],
                                  )
                                : SizedBox(),
                          ],
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        data['taskStart'] == null || data['taskEnd'] == null
                            ? ElevatedButton(
                                onPressed: () {
                                  if (data['taskStart'] == null &&
                                      data['taskEnd'] == null) {
                                    startTask(data['id']);
                                  }
                                  if (data['taskStart'] != null &&
                                      data['taskEnd'] == null) {
                                    endTask(data['id']);
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: data['taskStart'] == null
                                        ? AppColor().primary
                                        : AppColor().green),
                                child: Text(
                                  data['taskStart'] == null
                                      ? 'Task Start'
                                      : 'Finish Task',
                                  style: TextStyle(
                                      color: AppColor().white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                ))
                            : SizedBox(),
                      ],
                    ),
                  ),
                  // BUTTON START & FINISHED TASK END
                  SizedBox(
                    height: 50,
                  ),
                  Center(
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 20),
                      child: TextButton(
                          onPressed: () => _alertDeleteBoard(
                              taskId, data['title'], data['boardId']),
                          child: Text(
                            'Delete Task',
                            style: TextStyle(
                              color: AppColor().redHighlight,
                              fontSize: 16,
                            ),
                          )),
                    ),
                  )
                ],
              );
            }).toList(),
          );
        },
      ),
    );
  }

  Future<void> _alertDeleteBoard(
      String taskId, String taskName, String boardId) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(taskName),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Are you sure want to delete this task ?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text(
                'Delete',
                style: TextStyle(
                  color: AppColor().white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              onPressed: () async {
                await deleteTask(taskId);
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => BoardDetail(boardId: boardId)));

                showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: const Text('Task Has Been Delete'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.pop(context, 'OK'),
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor().redHighlight),
            ),
          ],
        );
      },
    );
  }
}
