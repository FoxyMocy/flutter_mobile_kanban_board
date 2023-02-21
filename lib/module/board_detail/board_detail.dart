part of '../pages.dart';

class BoardDetail extends StatefulWidget {
  String boardId;
  BoardDetail({required this.boardId, super.key});

  @override
  State<BoardDetail> createState() => _BoardDetailState();
}

class _BoardDetailState extends State<BoardDetail> {
  TextEditingController sectionController = TextEditingController();
  TextEditingController taskController = TextEditingController();
  String? errorMessage = '';
  String updateId = '';
  String listId = '';

  // firestore db
  FirebaseFirestore db = FirebaseFirestore.instance;
  final listCollection = FirebaseFirestore.instance.collection('lists');
  final boardCollection = FirebaseFirestore.instance.collection('boards');

  Future<void> createNewSection() async {
    try {
      //Store Data
      final storeData = db.collection("lists").doc();

      // creating section on db
      await storeData.set({
        "id": storeData.id,
        "boardId": widget.boardId,
        "name": sectionController.text,
        "timeCreated": DateTime.now(),
        "lastEdited": DateTime.now(),
      });
      print("create new section successfully!");
    } on FirebaseAuthException catch (e) {
      print("Something is wrong: $e");
      errorMessage = e.message;
    }
  }

  Future<void> deleteBoard(String boardId) {
    return boardCollection.doc(boardId).delete();
  }

  Future<void> updateSection(String updateId) async {
    try {
      final User? user = Auth().currentUser;
      // get user id
      String userID = user!.uid;

      //Store Data
      final storeData = db.collection("lists").doc(updateId);

      // creating section on db
      await storeData.update({
        "name": sectionController.text,
        "lastEdited": DateTime.now(),
      });
      print("create new section successfully!");
    } on FirebaseAuthException catch (e) {
      print("Something is wrong: $e");
      errorMessage = e.message;
    }
  }

  Future<void> createNewTask(String listId) async {
    try {
      final User? user = Auth().currentUser;
      // get user id
      String userId = user!.uid;

      //Store Data
      final storeData = db.collection("tasks").doc();

      // creating section on db
      await storeData.set({
        "id": storeData.id,
        "title": taskController.text,
        "description": '',
        "dueDate": null,
        "boardId": widget.boardId,
        "listId": listId,
        "createdBy": userId,
        "taskStart": null,
        "taskEnd": null,
        "timeCreated": DateTime.now(),
        "lastEdited": DateTime.now(),
      });
      print("create new task successfully!");
    } on FirebaseAuthException catch (e) {
      print("Something is wrong: $e");
      errorMessage = e.message;
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    taskController.text = '';
    sectionController.text = '';
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    DocumentReference docTask =
        FirebaseFirestore.instance.collection('Tasks').doc(widget.boardId);
  }

  @override
  Widget build(BuildContext context) {
    final DocumentReference docStream =
        FirebaseFirestore.instance.collection('boards').doc(widget.boardId);

    final Stream<QuerySnapshot> listStream =
        FirebaseFirestore.instance.collection('lists').snapshots();

    Stream<QuerySnapshot> taskStream =
        FirebaseFirestore.instance.collection('tasks').snapshots();

    Stream<QuerySnapshot> taskStream2 =
        FirebaseFirestore.instance.collection('tasks').snapshots();

    return Scaffold(
      backgroundColor: AppColor().background,
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppColor().white),
        backgroundColor: AppColor().primary,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.chevron_left_rounded,
            color: AppColor().white,
          ),
        ),
        title: FutureBuilder(
            future: docStream.get(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Text("Something went wrong");
              }

              if (snapshot.connectionState == ConnectionState.done) {
                Map<String, dynamic> data =
                    snapshot.data!.data() as Map<String, dynamic>;
                return Text(
                  data['name'],
                  style: TextStyle(color: AppColor().white),
                );
              }

              return Text(
                "Board Name",
                style: TextStyle(color: AppColor().white),
              );
            }),
        centerTitle: true,
      ),
      endDrawer: Drawer(
          child: ListView(
        children: [
          FutureBuilder(
              future: docStream.get(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Text("Something went wrong");
                }

                if (snapshot.connectionState == ConnectionState.done) {
                  Map<String, dynamic> data =
                      snapshot.data!.data() as Map<String, dynamic>;
                  return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Center(
                              child: Text(
                                data['name'],
                                style: TextStyle(
                                    fontSize: 20, color: AppColor().black),
                              ),
                            ),
                          ),
                          IconButton(
                              onPressed: () {
                                final boardName = data['name'];
                                setState(() {
                                  updateId = data['id'];
                                });
                                _alertDeleteBoard(
                                  updateId,
                                  boardName,
                                );
                              },
                              icon: Icon(
                                Icons.delete_forever_rounded,
                                color: AppColor().redHighlight,
                              ))
                        ],
                      ));
                }

                return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Center(
                            child: Text(
                              "Board Name",
                              style: TextStyle(
                                  fontSize: 20, color: AppColor().black),
                            ),
                          ),
                        ),
                        IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.delete_forever_rounded,
                              color: AppColor().redHighlight,
                            ))
                      ],
                    ));
              }),
          const Divider(),
          Container(
            margin: const EdgeInsets.only(
              left: 16,
              right: 16,
              bottom: 20,
            ),
            child: ElevatedButton(
              onPressed: () {},
              child: Text(
                "Export to CSV",
                style: TextStyle(color: AppColor().white, fontSize: 14),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor().primary,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 16,
              right: 16,
              bottom: 12,
            ),
            child: Text(
              "Completed Task",
              style: TextStyle(
                color: AppColor().black,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          StreamBuilder<QuerySnapshot>(
            stream: taskStream2,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                print('error');
                return const Text('Something went wrong');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                print('loading');
                return const Text("Loading");
              }

              if (snapshot.connectionState == ConnectionState.done) {
                return Column(
                  children: snapshot.data!.docs
                      .where((element) => element['boardId'] == widget.boardId)
                      .map((DocumentSnapshot tasks) {
                    Map<String, dynamic> data =
                        tasks.data()! as Map<String, dynamic>;
                    return Container(
                      padding: const EdgeInsets.only(
                        left: 16,
                        right: 16,
                        bottom: 10,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(right: 10),
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              color: AppColor().green,
                              shape: BoxShape.circle,
                              border:
                                  Border.all(width: 1, color: AppColor().grey),
                            ),
                          ),
                          Expanded(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RichText(
                                text: TextSpan(
                                  text: 'Task ',
                                  style: TextStyle(color: AppColor().black),
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: data['title'],
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    const TextSpan(
                                        text: ' has been completed at '),
                                    TextSpan(
                                        text: data['taskEnd'],
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                            ],
                          ))
                        ],
                      ),
                    );
                  }).toList(),
                );
              }
              return Column(
                children: snapshot.data!.docs
                    .where((element) =>
                        element['boardId'] == widget.boardId &&
                        element['taskEnd'] != null)
                    .map((DocumentSnapshot tasks) {
                  Map<String, dynamic> data =
                      tasks.data()! as Map<String, dynamic>;

                  return Container(
                    padding: const EdgeInsets.only(
                      left: 16,
                      right: 16,
                      bottom: 10,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(right: 10),
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: AppColor().green,
                            shape: BoxShape.circle,
                            border:
                                Border.all(width: 1, color: AppColor().grey),
                          ),
                        ),
                        Expanded(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              text: TextSpan(
                                text: 'Task ',
                                style: TextStyle(color: AppColor().black),
                                children: <TextSpan>[
                                  TextSpan(
                                      text: data['title'],
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  const TextSpan(
                                      text: ' has been completed at '),
                                  TextSpan(
                                      text: data['taskEnd'],
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                          ],
                        ))
                      ],
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ],
      )),
      endDrawerEnableOpenDragGesture: false,
      body: ListView(
        children: [
          StreamBuilder(
              stream: listStream,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return const Text('Something went wrong');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Text("Loading");
                }
                // SECTION
                return snapshot.data!.docs
                        .where(
                            (element) => element['boardId'] == widget.boardId)
                        .isNotEmpty
                    ? Column(
                        children: snapshot.data!.docs
                            .where((element) =>
                                element['boardId'] == widget.boardId)
                            .map((DocumentSnapshot document) {
                          Map<String, dynamic> data =
                              document.data()! as Map<String, dynamic>;
                          // CARD BOARDS ITEM
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(bottom: 10),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: GestureDetector(
                                        onLongPress: () {
                                          sectionController.text = data['name'];
                                          setState(() {
                                            updateId = data['id'];
                                          });
                                          _addSectionDialog(context, true);
                                        },
                                        child: Text(
                                          data['name'],
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              color: AppColor().black,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                        onPressed: () {
                                          setState(() {
                                            listId = data['id'];
                                          });
                                          print(
                                              "listID FROM add new TASK : $listId");
                                          _addTaskDialog(context, listId);
                                        },
                                        icon: Icon(
                                          Icons.add_rounded,
                                          color: AppColor().grey,
                                        ))
                                  ],
                                ),
                              ),
                              StreamBuilder(
                                  stream: taskStream,
                                  builder: (BuildContext context,
                                      AsyncSnapshot<QuerySnapshot> snapshot) {
                                    listId = data['id'];
                                    return snapshot.data != null
                                        ? Column(
                                            children: snapshot.data!.docs
                                                .where((element) =>
                                                    element['listId'] == listId)
                                                .map((DocumentSnapshot tasks) {
                                              Map<String, dynamic> data =
                                                  tasks.data()!
                                                      as Map<String, dynamic>;
                                              return GestureDetector(
                                                onTap: () => Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            EditTaskItem(
                                                              taskId:
                                                                  data['id'],
                                                              boardId: widget
                                                                  .boardId,
                                                            ))),
                                                child: Container(
                                                  width: double.infinity,
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 16,
                                                          right: 16,
                                                          bottom: 15),
                                                  decoration:
                                                      const BoxDecoration(),
                                                  child: Row(
                                                    children: [
                                                      Expanded(
                                                        child: Text(
                                                          data['title'],
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: TextStyle(
                                                              color: AppColor()
                                                                  .black,
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400),
                                                        ),
                                                      ),
                                                      Container(
                                                        width: 16,
                                                        height: 16,
                                                        decoration:
                                                            BoxDecoration(
                                                                color: data['taskStart'] !=
                                                                            null &&
                                                                        data['taskEnd'] ==
                                                                            null
                                                                    ? AppColor()
                                                                        .primary
                                                                    : data['taskStart'] !=
                                                                                null &&
                                                                            data['taskEnd'] !=
                                                                                null
                                                                        ? AppColor()
                                                                            .green
                                                                        : AppColor()
                                                                            .grey,
                                                                shape: BoxShape
                                                                    .circle),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              );
                                            }).toList(),
                                          )
                                        : const SizedBox();
                                  })
                              //TASK CARD
                            ],
                          );
                          // CARD BOARDS ITEM END
                        }).toList(),
                      )
                    : const SizedBox();
                // SECTION END
              }),

          // ADD SECTION BUTTON
          GestureDetector(
            onTap: () {
              sectionController.text = '';
              _addSectionDialog(context, false);
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add_rounded,
                    color: AppColor().primary,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    "Add List",
                    style: TextStyle(color: AppColor().primary, fontSize: 16),
                  )
                ],
              ),
            ),
          )
          // ADD SECTION BUTTON END
        ],
      ),
    );
  }

  Future<void> _addSectionDialog(BuildContext context, bool isUpdate) {
    return showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(color: AppColor().white),
            child: Row(
              children: <Widget>[
                Expanded(
                    child: Container(
                        margin:
                            const EdgeInsets.only(top: 12, bottom: 12, left: 8),
                        padding: const EdgeInsets.only(
                            left: 20, right: 20, top: 8, bottom: 8),
                        decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                              color: AppColor().grey,
                            ),
                            borderRadius: BorderRadius.circular(50)),
                        child: TextFormField(
                          controller: sectionController,
                          autofocus: true,
                          decoration: const InputDecoration.collapsed(
                              hintText: "Section Name"),
                        ))),
                IconButton(
                  onPressed: () async {
                    isUpdate == true
                        ? await updateSection(updateId)
                        : await createNewSection();
                    sectionController.text = '';
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.send_rounded,
                    color: AppColor().primary,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _alertDeleteBoard(String boardId, String boardName) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(boardName),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Are you sure want to delete this board ?'),
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
                await deleteBoard(boardId);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const MainPage()));

                showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: const Text('Board Has Been Delete'),
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

  Future<void> _addTaskDialog(BuildContext context, String listId) {
    return showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(color: AppColor().white),
            child: Row(
              children: <Widget>[
                Expanded(
                    child: Container(
                        margin:
                            const EdgeInsets.only(top: 12, bottom: 12, left: 8),
                        padding: const EdgeInsets.only(
                            left: 20, right: 20, top: 8, bottom: 8),
                        decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                              color: AppColor().grey,
                            ),
                            borderRadius: BorderRadius.circular(50)),
                        child: TextFormField(
                          controller: taskController,
                          autofocus: true,
                          decoration: const InputDecoration.collapsed(
                              hintText: "Task Name"),
                        ))),
                IconButton(
                  onPressed: () async {
                    print("listID FROM add new TASK : $listId");
                    await createNewTask(listId);
                    taskController.text = '';
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.send_rounded,
                    color: AppColor().primary,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
