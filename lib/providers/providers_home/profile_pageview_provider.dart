import 'package:versify/models/feed_model.dart';
import 'package:versify/models/user_model.dart';
import 'package:versify/screens/blogs_feed/widget_view_post/view_post.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfileAllPostsView extends ChangeNotifier {
  List<ViewPostWidget> _views = [];
  List<Feed> _feedList = [];
  int currentIndex = 0;
  PageController pageController;
  bool clickFromPostFeedWidget = false;
  bool readMoreVisible = true;

  MyUser _currentViewPostUser;
  bool pageViewPostFrameDone = false;

  // String currentProfileUID = '';

  List<ViewPostWidget> get allViews => _views;
  ProfileAllPostsView({this.pageController});

  List<Feed> get listOfFeeds => _feedList;
  Feed get currentFeed => _feedList[currentIndex];
  bool get readVisible => readMoreVisible == true
      ? clickFromPostFeedWidget == true
          ? false
          : true
      : false;

  // String get currentUserUID => _currentViewPostUser.userUID;
  // MyUser get currentViewPostUser => _currentViewPostUser;
  // bool get currentUserIsFollowing => _currentViewPostUser.isFollowing;
  //-------------------------------------------------------------------

  void setReadMoreVisible(bool thisBool) {
    readMoreVisible = thisBool;
  }

  void setClickFromPostFeedWidget(bool thisBool) {
    clickFromPostFeedWidget = thisBool;
  }

  //-------------------------------------------------------------------

  void onSwipe(int index) {
    currentIndex = index;
    notifyListeners();
  }

  void onClick(int index) {
    print('onClicked called');
    currentIndex = index;
    clickFromPostFeedWidget = true;
    notifyListeners();
  }

  void addView(Feed feed, {bool insertFirst}) {
    print('ViewProvider count: ' + _views.length.toString());

    if (insertFirst) {
      _feedList.insert(0, feed);
      _views.insert(
        0,
        ViewPostWidget(
          title: feed.title,
          // content: feed.content,
          listMapContent: feed.listMapContent,
          name: feed.username,
          tags: feed.tags,
          lastUpdated: feed.postedTimestamp,
          themeIndex: 0,
          feed: feed,
          pageViewType: PageViewType.profilePosts,
        ),
      );
    } else {
      _feedList.add(feed);
      _views.add(
        ViewPostWidget(
          title: feed.title,
          // content: feed.content,
          listMapContent: feed.listMapContent,
          name: feed.username,
          tags: feed.tags,
          lastUpdated: feed.postedTimestamp,
          themeIndex: 0,
          feed: feed,
          pageViewType: PageViewType.profilePosts,
        ),
      );
    }
    notifyListeners();
  }

  void clearViews() {
    _views.clear();
  }

  // void newViewPostUser(MyUser user) {
  //   _currentViewPostUser = user;
  //   print('NewUser ProfilePostsView with username: ' + user.username);
  // }

  void updatePageViewPostFrame(bool isDone) {
    pageViewPostFrameDone = isDone;
  }
}
