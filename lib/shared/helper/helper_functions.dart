import 'dart:convert';
import "package:http/http.dart" as http;
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:versify/shared/helper/helper_methods.dart';
import 'package:versify/shared/widgets/widgets_dialog_cancel_verification.dart';
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

void cancelVerificationDialog(BuildContext context) {
  showDialog(
      context: context, builder: (context) => DialogCancelVerification());
}

ReturnValue usernameFilterProfanity(String string) {
  print(purplePen("usernameFilterProfanity | STARTED"));
  final ProfanityFilter filter = ProfanityFilter();
  final String stringToFilter =
      string.replaceAll(".", " ").replaceAll("_", " ");

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

Future<ReturnValue> validatePhoneNumber(PhoneNumber number) async {
  try {
    print(purplePen("validatePhoneNumber | STARTED"));
    final Uri url = Uri.parse(
        "http://apilayer.net/api/validate?access_key=45149a78db0ccc272062dd240ce4d350&number=$number&country_code=&format=1");
    final http.Response response = await http.get(url);

    print(greenPen("validatePhoneNumber | RAN with response:"));
    print(grayPen("Status: ${response.statusCode}"));
    print(grayPen("Body: ${response.body}"));

    if (json.decode(response.body)["valid"] == true) {
      print(greenPen("validatePhoneNumber | phone number is VALID!"));
      // SHOULD RETURN PHONE NUMBER FROM RESPONSE BODY
      return ReturnValue(true, number.phoneNumber);
    } else {
      print(redPen("validatePhoneNumber | phone number is INVALID!"));
      // SHOULD RETURN PHONE NUMBER FROM RESPONSE BODY
      return ReturnValue(false, number.phoneNumber, "INVALID-PHONE-NUMBER");
    }
  } catch (err) {
    print(redPen("validatePhoneNumber | FAILED with catch error: $err"));
    return ReturnValue(
        false, "Could not update phone number. Please try again later.");
  }
}
