import 'package:versify/models/user_model.dart';
import 'package:flutter/cupertino.dart';

class AccountSettingsProvider extends ChangeNotifier {
  MyUser _myUser;
  MyUser _initUser;
  String initialText;
  TextEditingController textController;

  MyUser get user => _myUser;
  bool get hasChanges {
    // print(initialText != textController.text);
    return initialText != textController.text;
  }

  void initProfileUser(MyUser user) {
    // Map _socialLinks = {};
    // user.socialLinks.forEach((key, value) {
    //   _socialLinks[key] = value;
    // });

    _initUser = MyUser(
      userUID: user.userUID,
      username: user.username,
      description: user.description,
      phoneNumber: user.phoneNumber,
      email: user.email,
      // socialLinks: _socialLinks,
      isFollowing: user.isFollowing ?? false,
    );

    // Map _socialLinks2 = {};
    // user.socialLinks.forEach((key, value) {
    //   _socialLinks2[key] = value;
    // });

    _myUser = MyUser(
      userUID: user.userUID,
      username: user.username,
      description: user.description,
      phoneNumber: user.phoneNumber,
      email: user.email,
      // socialLinks: _socialLinks2,
      isFollowing: user.isFollowing ?? false,
    );
    print('has initialize editing user');
  }

  void updateProfileData() {
    notifyListeners();
  }
}
