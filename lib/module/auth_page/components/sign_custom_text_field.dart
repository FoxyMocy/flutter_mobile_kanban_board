part of '../../widgets.dart';

class SignCustomTextField extends StatelessWidget {
  const SignCustomTextField({super.key});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: const InputDecoration(
        hintText: "Type your email",
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
    );
  }
}
