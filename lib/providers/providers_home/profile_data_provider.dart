import 'package:versify/models/user_model.dart';
import 'package:flutter/cupertino.dart';
import 'visit_profile_provider.dart';

class ProfileDataProvider extends ChangeNotifier {
  final String authUserUID;
  Function popFunc;
  bool myProfileInitialOpen = true;
  String currentProfileUID = '';
  VisitProfileProvider visitProfileProvider;

  MyUser _currentViewPostUser;

  ProfileDataProvider({this.authUserUID});
  String get currentUserUID => _currentViewPostUser.userUID;
  MyUser get currentViewPostUser => _currentViewPostUser;
  bool get currentUserIsFollowing => _currentViewPostUser.isFollowing;

  void newViewPostUser(MyUser user) {
    _currentViewPostUser = user;
    print("NewUser ProfilePostsView with username: ${user.username}");
    notifyListeners();
  }

  void updateListeners() {
    notifyListeners();
  }

  void setVisitProfileProvider(VisitProfileProvider profileProvider) {
    visitProfileProvider = profileProvider;
  }
}
