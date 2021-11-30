import 'package:flutter/material.dart';
import 'package:versify/shared/widgets/widgets_dialog_existing_login.dart';
import 'package:versify/shared/widgets/widgets_dialog_reset_password.dart';
import 'package:versify/source/wrapper.dart';

Future<void> refreshToWrapper(BuildContext context) async {
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (context) => Wrapper()),
    (route) => false,
  );
}

void resetPasswordDialog(BuildContext context) {
  showDialog(context: context, builder: (context) => DialogResetPassword());
}

void existingLoginDialog(BuildContext context, Function toggleSignIn) {
  showDialog(
      context: context,
      builder: (context) => DialogExistingLogin(toggleSignIn: toggleSignIn));
}
