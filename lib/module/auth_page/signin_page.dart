part of '../pages.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
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
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    width: 1,
                    color: AppColor().black,
                  ),
                ),
                child: const Center(
                  child: Text('Logo App'),
                ),
              ),

              const SizedBox(
                height: 50,
              ),
              // FORM LOGIN
              Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
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
                      height: 32,
                    ),
                    // BUTTON LOGIN
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MainPage(),
                          ),
                        );
                      },
                      child: Center(
                        child: Text(
                          'Login',
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
                        'Login with Google',
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
                    Text("Don't have an account?"),
                    SizedBox(
                      width: 5,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SignUpPage(),
                          ),
                        );
                      },
                      child: Text(
                        'Sign Up',
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
