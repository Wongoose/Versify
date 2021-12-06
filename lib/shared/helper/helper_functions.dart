import 'package:flutter/material.dart';
import 'package:versify/shared/helper/helper_methods.dart';
import 'package:versify/shared/widgets/widgets_dialog_existing_login.dart';
import 'package:versify/shared/widgets/widgets_dialog_reset_password.dart';
import 'package:versify/source/wrapper.dart';
import 'package:profanity_filter/profanity_filter.dart';

import 'helper_classes.dart';

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

ReturnValue usernameFilterProfanity(String string) {
  print(purplePen("usernameFilterProfanity | STARTED"));
  final ProfanityFilter filter = ProfanityFilter();
  final String stringToFilter = string.replaceAll(".", " ").replaceAll("_", " ");

  final List<String> allProfanity = filter.getAllProfanity(stringToFilter);

  if (allProfanity.isEmpty) {
    // NO PROFANITY
    print(greenPen("usernameFilterProfanity | NO profanity found."));
    return ReturnValue(true, "Username good to go!");
  } else {
    print(greenPen(
        "usernameFilterProfanity | ${allProfanity.length} profanity found."));
    return ReturnValue(false,
        "These phrases are not allowed: ${allProfanity.toString().replaceAll("[", '"').replaceAll("]", '"')}.");
  }
}
