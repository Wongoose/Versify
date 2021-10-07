import 'package:versify/models/user_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:versify/providers/providers_feeds/all_posts_provider.dart';

import 'profile_data_provider.dart';

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
