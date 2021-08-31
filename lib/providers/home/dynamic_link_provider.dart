import 'package:flutter/material.dart';

class DynamicLinkProvider extends ChangeNotifier {
  String updatedEmail;

  void updatedEmailSignin(String email) {
    print('DynamicLinkProvider | updateEmailSignin RAN');
    updatedEmail = email;
    // notifyListeners();
  }
}
