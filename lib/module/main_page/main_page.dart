part of '../pages.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final User? user = Auth().currentUser;
  TextEditingController boardNameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? errorMessage = '';
  final Stream<QuerySnapshot> _boardsStream =
      FirebaseFirestore.instance.collection('boards').snapshots();
  // final userUid = user?.uid;
  String updateId = '';

  final userCollection = FirebaseFirestore.instance.collection('users');

  // firestore db
  FirebaseFirestore db = FirebaseFirestore.instance;

  Future<void> signOut() async {
    await Auth().signOut();
  }

  Widget _title() {
    return const Text("Firebase Auth");
  }

  Widget _userUid() {
    return Text(user?.uid ?? 'User email');
  }

  Widget _signoutButton() {
    return ElevatedButton(
      child: const Text("Signout"),
      onPressed: signOut,
    );
  }

  Future<void> createNewBoard() async {
    try {
      final User? user = Auth().currentUser;
      // get user id
      String userID = user!.uid;

      //Store Data
      final storeData = db.collection("boards").doc();

      // creating user profile on db
      await storeData.set({
        "userId": userID,
        "id": storeData.id,
        "name": boardNameController.text,
        "timeCreated": DateTime.now(),
        "lastEdited": DateTime.now(),
      });
      print("create new boards successfully!");
    } on FirebaseAuthException catch (e) {
      print("Something is wrong: $e");
      errorMessage = e.message;
    }
  }

  Future<void> editBoard(String updateId) async {
    try {
      //Store Data
      final storeData = db.collection("boards").doc(updateId);

      // creating user profile on db
      await storeData.update({
        "name": boardNameController.text,
        "lastEdited": DateTime.now(),
      });
      print("edit boards successfully!");
    } on FirebaseAuthException catch (e) {
      print("Something is wrong: $e");
      errorMessage = e.message;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(userCollection.snapshots());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          iconTheme: IconThemeData(color: AppColor().white),
          title: Text(
            "Boards",
            style: TextStyle(color: AppColor().white),
          ),
          backgroundColor: AppColor().primary,
        ),
        drawer: Drawer(
            child: Stack(
          children: [
            // DRAWER MENU
            ListView(
              // Important: Remove any padding from the ListView.
              padding: EdgeInsets.zero,
              children: [
                DrawerHeader(
                    decoration: BoxDecoration(
                      color: AppColor().background,
                    ),
                    child: FutureBuilder(
                        future: userCollection.doc(user?.uid).get(),
                        builder: (context,
                            AsyncSnapshot<DocumentSnapshot> snapshot) {
                          if (snapshot.hasError) {
                            return const Text("Something went wrong");
                          }

                          if (snapshot.hasData && !snapshot.data!.exists) {
                            return const Text("Document does not exist");
                          }

                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            Map<String, dynamic> data =
                                snapshot.data!.data() as Map<String, dynamic>;
                            return Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 80,
                                    width: 80,
                                    margin: const EdgeInsets.only(bottom: 10),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        width: 1,
                                        color: AppColor().primary,
                                      ),
                                      image: DecorationImage(
                                        image: NetworkImage(
                                          data['photo_url'],
                                        ),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    data['fullname'],
                                    style: TextStyle(
                                        color: AppColor().black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  Text(
                                    user?.email ?? 'User email',
                                    style: TextStyle(
                                        color: AppColor().black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ]);
                          }

                          return const Text("loading");
                        })),
                ListTile(
                  leading: Icon(
                    Icons.view_compact_alt_rounded,
                    color: AppColor().black,
                  ),
                  title: Text(
                    'Boards',
                    style: TextStyle(
                      color: AppColor().black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                const Divider(),
                const SizedBox(
                  height: 80,
                ),
              ],
            ),
            // DRAWER MENU END
            // BUTTON LOGOUT
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: const EdgeInsets.only(left: 16, right: 16, bottom: 30),
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => signOut(),
                  child: Text(
                    "Logout",
                    style: TextStyle(
                      color: AppColor().white,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor().redHighlight),
                ),
              ),
            ),
            // BUTTON LOGOUT END
          ],
        )),
        // FAB ADD BOARDS
        floatingActionButton: IconButton(
          onPressed: () => _addBoardDialog(context, false),
          icon: Icon(
            Icons.add,
            color: AppColor().white,
          ),
          style: IconButton.styleFrom(
            backgroundColor: AppColor().primary,
          ),
        ),
        // FAB ADD BOARDS END
        body: StreamBuilder<QuerySnapshot>(
          stream: _boardsStream,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return const Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: Text("Loading"));
            }

            return snapshot.data!.docs
                    .where((element) => element['userId'] == user!.uid)
                    .isNotEmpty
                ? GridView.count(
                    primary: false,
                    padding: const EdgeInsets.all(20),
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    crossAxisCount: 2,
                    childAspectRatio: 4 / 2,
                    children: snapshot.data!.docs
                        .where((element) => element['userId'] == user!.uid)
                        .map((DocumentSnapshot document) {
                      Map<String, dynamic> data =
                          document.data()! as Map<String, dynamic>;

                      print("dataBoards: ${data.length}");
                      // CARD BOARDS ITEM
                      return GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BoardDetail(
                              boardId: data['id'],
                            ),
                          ),
                        ),
                        onLongPress: () {
                          boardNameController.text = data['name'];
                          setState(() {
                            updateId = data['id'];
                          });
                          _addBoardDialog(context, true);
                        },
                        child: Card(
                          child: Center(
                            child: Text(
                              data['name'],
                              style: TextStyle(
                                color: AppColor().black,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      );
                      // CARD BOARDS ITEM END
                    }).toList(),
                  )
                : Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          AppImages().noBoards,
                          width: 140,
                          height: 140,
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        Text(
                          "Oops!\n You not have any Boards.",
                          style: TextStyle(
                            color: AppColor().primary,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        )
                      ],
                    ),
                  );
          },
        ));
  }

  // FUNCTION SHOW BOTTOM ADD BOARDS
  Future<void> _addBoardDialog(BuildContext context, bool isUpdate) {
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
                          controller: boardNameController,
                          autofocus: true,
                          decoration: const InputDecoration.collapsed(
                              hintText: "Board Name"),
                        ))),
                IconButton(
                  onPressed: () async {
                    isUpdate == true
                        ? await editBoard(updateId)
                        : await createNewBoard();
                    boardNameController.text = '';
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
  // FUNCTION SHOW BOTTOM ADD BOARDS
}
