import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../login_info.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key, required LoginInfo loginInfo});

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
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Spacer(),
        Padding(
          padding: pad,
          child: userField,
        ),
        Padding(
          padding: pad,
          child: passField,
        ),
        Padding(
          padding: pad,
          child: Row(
            children: [const Spacer(), submitButton],
          ),
        ),
        Text(loginErrText),
        const Spacer(),
        Padding(
          padding: pad,
          child: newUserButton,
        ),
      ],
    );
  }
}

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<StatefulWidget> createState() => _SignupScreen();
}

class _SignupScreen extends State<SignupScreen> {
  final TextEditingController userController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  final TextEditingController passConfirmController = TextEditingController();
  String loginErrText = "";

  void signup() async {
    String emailAddress = userController.value.text;
    String password = passController.value.text;
    String passwordConfirmation = passConfirmController.value.text;

    if (password != passwordConfirmation) {
      setState(() {
        loginErrText = "Passwords must match!";
      });
    }

    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        setState(() {
          loginErrText = "Password is too weak.";
        });
      } else if (e.code == 'email-already-in-use') {
        setState(() {
          loginErrText = "Account already exists.";
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
    passConfirmController.dispose();
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

    Widget passConfirmField = TextField(
      controller: passConfirmController,
      obscureText: true,
      decoration: const InputDecoration(
          border: OutlineInputBorder(), labelText: "Confirm Password"),
    );

    Widget submitButton =
        FilledButton(onPressed: () => signup(), child: const Text("Sign Up"));

    EdgeInsets pad = const EdgeInsets.all(10);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Spacer(),
        Padding(
          padding: pad,
          child: userField,
        ),
        Padding(
          padding: pad,
          child: passField,
        ),
        Padding(
          padding: pad,
          child: passConfirmField,
        ),
        Padding(
          padding: pad,
          child: Row(
            children: [const Spacer(), submitButton],
          ),
        ),
        Text(loginErrText),
        const Spacer(),
      ],
    );
  }
}
