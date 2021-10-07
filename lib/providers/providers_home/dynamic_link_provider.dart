import 'package:flutter/material.dart';

class DynamicLinkProvider extends ChangeNotifier {
  String updatedEmail;

  void resetUpdatedEmail() {
    if (updatedEmail != null) {
      updatedEmail = null;
    }
  }

  void updatedEmailSignin(String email) {
    print('DynamicLinkProvider | updateEmailSignin RAN');
    updatedEmail = email;
    // notifyListeners();
  }
}
