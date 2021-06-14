import 'package:versify/models/user_model.dart';
import 'package:versify/providers/home/visit_profile_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class ProfileDataProvider extends ChangeNotifier {
  final String authUserUID;
  Function popFunc;
  bool myProfileInitialOpen = true;
  String currentProfileUID = '';
  VisitProfileProvider visitProfileProvider;

  MyUser _currentViewPostUser;

  PhoneNumber phoneNumberNewAcc;

  ProfileDataProvider({this.authUserUID});
  String get currentUserUID => _currentViewPostUser.userUID;
  MyUser get currentViewPostUser => _currentViewPostUser;
  bool get currentUserIsFollowing => _currentViewPostUser.isFollowing;

  void newViewPostUser(MyUser user) {
    _currentViewPostUser = user;
    print('NewUser ProfilePostsView with username: ' + user.username);
    notifyListeners();
  }

  void updateListeners() {
    notifyListeners();
  }

  void setVisitProfileProvider(VisitProfileProvider profileProvider) {
    visitProfileProvider = profileProvider;
  }
}
