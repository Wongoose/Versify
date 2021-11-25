import 'package:flutter/material.dart';
import 'package:versify/screens/authentication/auth_create_account.dart';
import 'auth_create_password.dart';
import 'auth_sign_in.dart';

class AuthWrapper extends StatefulWidget {
  final bool initialOption;

  const AuthWrapper({this.initialOption});

  @override
  _AuthWrapperState createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool signIn;

  @override
  void initState() {
    super.initState();
    signIn = widget.initialOption ?? true;
  }

  void toggleSignIn() {
    setState(() {
      signIn = !signIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    return signIn
        ? SignInAuth(toggleSignIn: toggleSignIn)
        : AuthCreateAccount(toggleSignIn: toggleSignIn);
        // :AuthCreatePassword(email: "ppp@gmail.com");
    // : SignUpAuth(toggleSignIn: toggleSignIn);
  }
}
