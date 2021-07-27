import 'package:versify/models/user_model.dart';
import 'package:flutter/cupertino.dart';

class AccountSettingsProvider extends ChangeNotifier {
  // MyUser _myUser;
  MyUser _initUser;
  String initialText;
  TextEditingController textController;

  MyUser get user => _initUser;
  bool get hasChanges {
    // print(initialText != textController.text);
    return initialText != textController.text;
  }

  void initSettingsUser(MyUser user) {
    _initUser = MyUser(
      userUID: user.userUID,
      phoneNumber: user.phoneNumber,
      email: user.email,
    );

    // _myUser = MyUser(
    //   userUID: user.userUID,
    //   phoneNumber: user.phoneNumber,
    //   email: user.email,
    // );
    print('initSettingsUser | with credentials...\n' +
        'phoneNumber is: ${user.phoneNumber}\n' +
        'email is: ${user.email}\n');
  }

  void updateProfileData() {
    notifyListeners();
  }
}
