part of '../pages.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColor().background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("New Account"),
        backgroundColor: AppColor().background,
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 20),
        child: Column(
          children: [
            // FORM LOGIN
            Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  // FULLNAME INPUT
                  TextFormField(
                    decoration: const InputDecoration(
                      hintText: "Type your fullname",
                      label: Text("Fullname"),
                      border: OutlineInputBorder(),
                    ),
                    // The validator receives the text that the user has entered.
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  // EMAIL INPUT
                  TextFormField(
                    decoration: const InputDecoration(
                      hintText: "Type your email",
                      label: Text("Email"),
                      border: OutlineInputBorder(),
                    ),
                    // The validator receives the text that the user has entered.
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  // PASSWORD INPUT
                  TextFormField(
                    decoration: InputDecoration(
                        hintText: "Type your Password",
                        label: Text("Password"),
                        border: OutlineInputBorder()),
                    obscureText: true,
                    // The validator receives the text that the user has entered.
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  // CONF PASSWORD INPUT
                  TextFormField(
                    decoration: InputDecoration(
                        hintText: "Type your Password",
                        label: Text("Confirm Password"),
                        border: OutlineInputBorder()),
                    obscureText: true,
                    // The validator receives the text that the user has entered.
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(
                    height: 32,
                  ),
                  // BUTTON LOGIN
                  ElevatedButton(
                    onPressed: () {},
                    child: Center(
                      child: Text(
                        'Sign Up',
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
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(left: 10),
                    width: 100,
                    height: 1,
                    decoration: BoxDecoration(
                      color: AppColor().grey,
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 8, right: 8),
                  child: Text('Or'),
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(right: 10),
                    width: 100,
                    height: 1,
                    decoration: BoxDecoration(
                      color: AppColor().grey,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),

            // LOGIN WITH GOOGLE
            ElevatedButton(
              onPressed: () {},
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      AppIcons().ic_google,
                      height: 20,
                      width: 20,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Text(
                      'Sign Up with Google',
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: AppColor().primary,
                          fontSize: 16),
                    ),
                  ],
                ),
              ),
              style:
                  ElevatedButton.styleFrom(backgroundColor: AppColor().white),
            ),
            Spacer(),
            Container(
              margin: EdgeInsets.only(bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Already have an account ?"),
                  SizedBox(
                    width: 5,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SignInPage(),
                        ),
                      );
                    },
                    child: Text(
                      'Login',
                      style: TextStyle(color: AppColor().primary),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      )),
    );
  }
}
