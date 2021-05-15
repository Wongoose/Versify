import 'package:versify/models/user_model.dart';
import 'package:versify/providers/all_posts_provider.dart';
import 'package:versify/screens/profile_screen/profile_data_provider.dart';
import 'package:flutter/cupertino.dart';

class VisitProfileProvider extends ChangeNotifier {
  MyUser _userProfile;
  AllPostsView allPostsView;
  ProfileDataProvider profileDataProvider;
  VisitProfileProvider({this.allPostsView, this.profileDataProvider});

  MyUser get userProfile => _userProfile;

  void setUserProfile(MyUser user) {
    _userProfile = user;
    notifyListeners();
  }

  void updateFollowing(bool isFollowing) {
    _userProfile.isFollowing = isFollowing;
    allPostsView.updateListeners();
    profileDataProvider.updateListeners();
    print('updateFollowing NOTIFY in VisitProfile');
    notifyListeners();
  }
}
