import 'package:versify/models/feed_model.dart';
import 'package:versify/models/user_model.dart';
import 'package:versify/screens/blogs_feed/widgets_feeds/feed_list_wrapper.dart';
import 'package:versify/screens/blogs_feed/widget_view_post/view_post.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'feed_type_provider.dart';

class AllPostsView extends ChangeNotifier {
  AllPostsView({
    this.forYouPageController,
    this.followingPageController,
    this.feedTypeProvider,
  });

  final FeedTypeProvider feedTypeProvider;
  MyUser _currentViewPostUser =
      MyUser(isFollowing: false, userUID: ''); //check again
  bool hasSetNewuser = false;
  // bool pageViewPostFrameDone = false;

  //-----------------------------------------

  // int currentIndex = 0;
  // PageController pageController;
  // bool clickFromPostFeedWidget = false;
  // bool readMoreVisible = true;

  // List<Feed> get listOfFeeds => _forYouFeedList;
  // Feed get currentFeed => _forYouFeedList[forYouCurrentIndex];
  String get currentUserUID => _currentViewPostUser.userUID;
  MyUser get currentViewPostUser => _currentViewPostUser;
  bool get currentUserIsFollowing => _currentViewPostUser.isFollowing;
  FeedType get allPostsViewCurrentFeedType => feedTypeProvider.currentFeedType;

  void newViewPostUser(MyUser user) {
    _currentViewPostUser = user;
    hasSetNewuser = true;
    print('NewUser AllPostsView with username: ' + user.username);
    notifyListeners();
  }

  void updateListeners() {
    notifyListeners();
  }

  bool get pageViewPostFrameDone {
    if (feedTypeProvider.currentFeedType == FeedType.following) {
      return _followingPostFrameDone;
    } else {
      return _forYouPostFrameDone;
    }
  }

  bool get readVisible {
    if (feedTypeProvider.currentFeedType == FeedType.following) {
      return followingReadMoreVisible == true
          ? followingClickFromPostFeedWidget == true
              ? false
              : true
          : false;
    } else {
      return forYouReadMoreVisible == true
          ? forYouClickFromPostFeedWidget == true
              ? false
              : true
          : false;
    }
  }

  //-----------------------------------------

  bool get readMoreVisible {
    if (feedTypeProvider.currentFeedType == FeedType.following) {
      return followingReadMoreVisible;
    } else {
      return forYouReadMoreVisible;
    }
  }

  bool get clickFromPostFeedWidget {
    if (feedTypeProvider.currentFeedType == FeedType.following) {
      return followingClickFromPostFeedWidget;
    } else {
      return forYouClickFromPostFeedWidget;
    }
  }

  int get currentIndex {
    if (feedTypeProvider.currentFeedType == FeedType.following) {
      return followingCurrentIndex;
    } else {
      return forYouCurrentIndex;
    }
  }

  PageController get pageController {
    if (feedTypeProvider.currentFeedType == FeedType.following) {
      return followingPageController;
    } else {
      return forYouPageController;
    }
  }

  void setReadMoreVisible(bool thisBool) {
    if (feedTypeProvider.currentFeedType == FeedType.following) {
      followingReadMoreVisible = thisBool;
    } else {
      forYouReadMoreVisible = thisBool;
    }
  }

  void setClickFromPostFeedWidget(bool thisBool) {
    if (feedTypeProvider.currentFeedType == FeedType.following) {
      followingClickFromPostFeedWidget = thisBool;
    } else {
      forYouClickFromPostFeedWidget = thisBool;
    }
  }

  void updatePageViewPostFrame(bool isDone) {
    if (feedTypeProvider.currentFeedType == FeedType.following) {
      _followingPostFrameDone = isDone;
    } else {
      _forYouPostFrameDone = isDone;
    }
  }

  //-----------------------------------------

  List<ViewPostWidget> _forYouViews = [];
  List<Feed> _forYouFeedList = [];
  int forYouCurrentIndex = -1;
  PageController forYouPageController;
  bool forYouClickFromPostFeedWidget = false;
  bool forYouReadMoreVisible = true;
  bool _forYouPostFrameDone = false;

  List<ViewPostWidget> get forYouViews => _forYouViews;

  List<Feed> get forYouListOfFeeds => _forYouFeedList;
  Feed get forYouCurrentFeed => _forYouFeedList[forYouCurrentIndex];
  bool get forYouReadVisible => forYouReadMoreVisible == true
      ? forYouClickFromPostFeedWidget == true
          ? false
          : true
      : false;

  void forYouOnSwipe(int index) {
    forYouCurrentIndex = index;
    // forYouClickFromPostFeedWidget = false;
    notifyListeners();
  }

  void forYouOnClick(int index) {
    print('For You onClicked');
    forYouCurrentIndex = index;
    forYouClickFromPostFeedWidget = true;
    notifyListeners();
  }

  // void refreshView() {
  //   _forYouViews.clear();
  // }

  void forYouAddView(Feed feed) {
    // print('ViewProvider count: ' + _forYouViews.length.toString());
    _forYouFeedList.add(feed);
    _forYouViews.add(
      ViewPostWidget(
        title: feed.title,
        // content: feed.content,
        listMapContent: feed.listMapContent,
        name: feed.username,
        tags: feed.tags,
        lastUpdated: feed.postedTimestamp,
        themeIndex: 0,
        feed: feed,
        pageViewType: PageViewType.allPosts,
      ),
    );
    notifyListeners();
  }

  void forYouInsertView(Feed feed, int index) {
    _forYouFeedList.insert(index, feed);
    _forYouViews.insert(
      index,
      ViewPostWidget(
        title: feed.title,
        // content: feed.content,
        listMapContent: feed.listMapContent,
        name: feed.username,
        tags: feed.tags,
        lastUpdated: feed.postedTimestamp,
        themeIndex: 0,
        feed: feed,
        pageViewType: PageViewType.allPosts,
      ),
    );
    // notifyListeners();
  }

  void forYouClearViews() {
    _forYouViews.clear();
  }

  //----------------------------------------

  List<ViewPostWidget> _followingViews = [];
  List<Feed> _followingFeedList = [];
  int followingCurrentIndex = -1;
  PageController followingPageController;
  bool followingClickFromPostFeedWidget = false;
  bool followingReadMoreVisible = true;
  bool _followingPostFrameDone = false;

  List<ViewPostWidget> get followingViews => _followingViews;

  List<Feed> get followingListOfFeeds => _followingFeedList;
  Feed get followingCurrentFeed => _followingFeedList[followingCurrentIndex];
  bool get followingReadVisible => followingReadMoreVisible == true
      ? followingClickFromPostFeedWidget == true
          ? false
          : true
      : false;

  void followingOnSwipe(int index) {
    followingCurrentIndex = index;
    notifyListeners();
  }

  void followingOnClick(int index) {
    print('Following onClicked');
    followingCurrentIndex = index;
    followingClickFromPostFeedWidget = true;
    notifyListeners();
  }

  // void refreshView() {
  //   _forYouViews.clear();
  // }

  void followingAddView(Feed feed) {
    // print('ViewProvider count: ' + _followingViews.length.toString());
    _followingFeedList.add(feed);
    _followingViews.add(
      ViewPostWidget(
        title: feed.title,
        // content: feed.content,
        listMapContent: feed.listMapContent,
        name: feed.username,
        tags: feed.tags,
        lastUpdated: feed.postedTimestamp,
        themeIndex: 0,
        feed: feed,
        pageViewType: PageViewType.allPosts,
      ),
    );
    notifyListeners();
  }

  void followingClearViews() {
    _followingViews.clear();
  }
}
