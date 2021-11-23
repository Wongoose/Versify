import 'package:flutter/material.dart';
import 'package:versify/screens/authentication/auth_create_account.dart';

import 'auth_sign_in.dart';
import 'auth_sign_up.dart';

enum InitialOption {
  SignIn,
  SignOut,
}

class AuthWrapper extends StatefulWidget {
  final bool initialOption;

  AuthWrapper({this.initialOption});
  @override
  _AuthWrapperState createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool signIn;
  void toggleSignIn() {
    setState(() {
      signIn = !signIn;
    });
  }

  void initState() {
    super.initState();
    signIn = widget.initialOption != null ? widget.initialOption : true;
  }

  @override
  Widget build(BuildContext context) {
    return signIn
        ? SignInAuth(toggleSignIn: toggleSignIn)
        : AuthCreateAccount(toggleSignIn: toggleSignIn);
    // : SignUpAuth(toggleSignIn: toggleSignIn);
  }
}
