import 'package:biscuitt_ai/screens/signup_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<StatefulWidget> createState() => _AuthScreen();
}

class _AuthScreen extends State<AuthScreen> {
  final TextEditingController userController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  String loginErrText = "";

  void verifyLogin() async {
    String emailAddress = userController.value.text;
    String password = passController.value.text;

    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: emailAddress, password: password);
      setState(() {
        loginErrText = "Logged in as ${credential.user}!";
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'INVALID_LOGIN_CREDENTIALS') {
        setState(() {
          loginErrText = "Invalid Login.";
        });
      } else if (e.code == 'wrong-password') {
        setState(() {
          loginErrText = "Incorrect password.";
        });
      } else if (e.code == 'invalid-email') {
        setState(() {
          loginErrText = "Invalid email.";
        });
      } else {
        setState(() {
          loginErrText = "An unknown error occurred: ${e.code}";
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    userController.dispose();
    passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget userField = TextField(
      controller: userController,
      decoration: const InputDecoration(
          border: OutlineInputBorder(), labelText: "Email"),
    );

    Widget passField = TextField(
      controller: passController,
      obscureText: true,
      decoration: const InputDecoration(
          border: OutlineInputBorder(), labelText: "Password"),
    );

    Widget submitButton = FilledButton(
        onPressed: () => verifyLogin(), child: const Text("Login"));
    Widget newUserButton = TextButton(
        onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const Scaffold(body: SignupScreen()))),
        child: const Text("New User?"));

    EdgeInsets pad = const EdgeInsets.all(10);
    return Padding(
      padding: pad,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Spacer(),
          userField,
          const SizedBox(height: 10),
          passField,
          const SizedBox(height: 10),
          submitButton,
          Text(loginErrText),
          const Spacer(),
          newUserButton,
        ],
      ),
    );
  }
}
