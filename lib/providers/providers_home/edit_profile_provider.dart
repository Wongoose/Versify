import 'package:versify/models/user_model.dart';
import 'package:versify/services/firebase/profile_database.dart';
import 'package:flutter/cupertino.dart';

class EditProfileProvider extends ChangeNotifier {
  MyUser _myUser;
  MyUser _initUser;
  ProfileDBService profileDB;
  bool _socialLinkHasChanges = false;

  EditProfileProvider({this.profileDB});

  MyUser get user => _myUser;

  bool get hasChanges {
    _socialLinkHasChanges = false;
    _initUser.socialLinks.forEach((key, value) {
      print('Compare: ' + value.toString());
      print('With: ' + _myUser.socialLinks[key.toString()].toString());

      if (value.toString() != _myUser.socialLinks[key.toString()].toString()) {
        _socialLinkHasChanges = true;
        // return true;
      }
    });

    if (_initUser.username != _myUser.username) {
      return true;
    } else if (_initUser.description != _myUser.description) {
      return true;
    } else if (_initUser.phoneNumber != _myUser.phoneNumber) {
      return true;
    } else if (_initUser.email != _myUser.email) {
      return true;
    } else if (_socialLinkHasChanges) {
      return true;
    } else {
      return false;
    }
  }

  void initProfileUser(MyUser user) {
    Map _socialLinks = {};
    user.socialLinks.forEach((key, value) {
      _socialLinks[key] = value;
    });

    _initUser = MyUser(
      userUID: user.userUID,
      username: user.username,
      description: user.description,
      phoneNumber: user.phoneNumber,
      email: user.email,
      socialLinks: _socialLinks,
      isFollowing: user.isFollowing ?? false,
      profileImageUrl: user.profileImageUrl,
    );

    Map _socialLinks2 = {};
    user.socialLinks.forEach((key, value) {
      _socialLinks2[key] = value;
    });

    _myUser = MyUser(
      userUID: user.userUID,
      username: user.username,
      description: user.description,
      phoneNumber: user.phoneNumber,
      email: user.email,
      socialLinks: _socialLinks2,
      isFollowing: user.isFollowing ?? false,
      profileImageUrl: user.profileImageUrl,
    );
    print('has initialize editing user');
  }

  void updateProfileData(MyUser user) {
    _myUser = user;
    notifyListeners();
  }

  Future<bool> confirmUpdate() async {
    try {
      return profileDB.updateEditedProfile(_myUser).then((_) {
        notifyListeners();
        return true;
      });
    } catch (err) {
      return false;
    }
  }
}
