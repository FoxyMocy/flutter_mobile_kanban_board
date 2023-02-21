part of '../pages.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  bool isLogin = true;
  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    TextEditingController fullnameController = TextEditingController();
    final _formKey = GlobalKey<FormState>();
    String? errorMessage = '';

    // firestore db
    FirebaseFirestore db = FirebaseFirestore.instance;

    Future<void> signInWithEmailAndPassword() async {
      try {
        await Auth().signInWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );

        final User? user = Auth().currentUser;
        // get user id
        String userID = user!.uid;

        // creating user profile on db
        await db.collection("users").doc(userID).update({
          "lastLogin": DateTime.now(),
        });
      } on FirebaseAuthException catch (e) {
        setState(() {
          errorMessage = e.message;
        });
      }
    }

    List avatar = [
      'https://firebasestorage.googleapis.com/v0/b/kanban-project-b1de6.appspot.com/o/avatar%2Fava_male_2.png?alt=media&token=7459c33f-a70b-4b33-b8ba-1054927d2ebe',
      'https://firebasestorage.googleapis.com/v0/b/kanban-project-b1de6.appspot.com/o/avatar%2Fava_female_1.png?alt=media&token=5eabd084-5b6c-4bee-b7b1-f348e4663959',
      'https://firebasestorage.googleapis.com/v0/b/kanban-project-b1de6.appspot.com/o/avatar%2Fava_female_3.png?alt=media&token=50572ac7-86a8-4a8c-a708-675af615a336',
      'https://firebasestorage.googleapis.com/v0/b/kanban-project-b1de6.appspot.com/o/avatar%2Fava_male_1.png?alt=media&token=eda4d170-b35f-405c-8033-871f462b84e4',
    ];

    Future<void> createUserWithEmailAndPassword() async {
      try {
        final credential = await Auth().createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );

        final User? user = Auth().currentUser;
        // get user id
        String userID = user!.uid;
        // print(userID);
        final _random = new Random();

        // creating user profile on db
        await db.collection("users").doc(userID).set({
          "id": userID,
          "fullname": fullnameController.text,
          "email": emailController.text,
          "photo_url": avatar[_random.nextInt(avatar.length)],
          "timeCreated": DateTime.now(),
          "lastLogin": DateTime.now(),
          // ... other params
        });
        print("Signed up successfully!");
      } on FirebaseAuthException catch (e) {
        print("Something is wrong: $e");
        errorMessage = e.message;
      }
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColor().white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // LOGO APP
              Container(
                margin: const EdgeInsets.only(top: 50),
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(AppImages().logoApp),
                        fit: BoxFit.cover)),
              ),

              const SizedBox(
                height: 50,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  isLogin ? "Login into your account" : "Create new account",
                  style: TextStyle(
                    color: AppColor().black,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              // FORM LOGIN
              Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    // EMAIL INPUT
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(width: 1, color: AppColor().grey),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: TextFormField(
                        controller: emailController,
                        decoration: const InputDecoration.collapsed(
                          hintText: "Email",
                          // label: Text("Email"),
                          // border: OutlineInputBorder(),
                        ),
                        // The validator receives the text that the user has entered.
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(
                      height: !isLogin ? 12 : 0,
                    ),
                    // FULLNAME INPUT
                    !isLogin
                        ? Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              border:
                                  Border.all(width: 1, color: AppColor().grey),
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: TextFormField(
                              controller: fullnameController,
                              decoration: const InputDecoration.collapsed(
                                hintText: "Type your fullname",
                              ),
                              // The validator receives the text that the user has entered.
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter some text';
                                }
                                return null;
                              },
                            ),
                          )
                        : SizedBox(),
                    const SizedBox(
                      height: 12,
                    ),
                    // PASSWORD INPUT
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(width: 1, color: AppColor().grey),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: TextFormField(
                        controller: passwordController,
                        decoration: InputDecoration.collapsed(
                          hintText: "Type your Password",
                        ),
                        obscureText: true,
                        // The validator receives the text that the user has entered.
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    // CONF PASSWORD INPUT
                    !isLogin
                        ? Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              border:
                                  Border.all(width: 1, color: AppColor().grey),
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: TextFormField(
                              decoration: InputDecoration.collapsed(
                                hintText: "Confirm your Password",
                              ),
                              obscureText: true,
                              // The validator receives the text that the user has entered.
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter some text';
                                } else if (value != passwordController.text) {
                                  return 'Your Password not same';
                                }
                                return null;
                              },
                            ),
                          )
                        : const SizedBox(),

                    const SizedBox(
                      height: 32,
                    ),
                    // BUTTON LOGIN
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState?.validate() ?? false) {
                          isLogin
                              ? signInWithEmailAndPassword()
                              : createUserWithEmailAndPassword();
                        }
                      },
                      child: Center(
                        child: Text(
                          isLogin ? 'Login' : 'Sign Up',
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: AppColor().white,
                              fontSize: 16),
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: AppColor().primary),
                    ),
                  ],
                ),
              ),
              Spacer(),
              Container(
                margin: EdgeInsets.only(bottom: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(isLogin
                        ? "Don't have an account?"
                        : "Already have an account ?"),
                    SizedBox(
                      width: 5,
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isLogin = !isLogin;
                        });
                      },
                      child: Text(
                        isLogin ? "Sign Up" : "Login",
                        style: TextStyle(color: AppColor().primary),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
