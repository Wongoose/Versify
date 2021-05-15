import 'package:versify/models/feed_model.dart';
import 'package:versify/providers/all_posts_provider.dart';
import 'package:flutter/cupertino.dart';

class FeedListProvider extends ChangeNotifier {
  List<Feed> forYouData = [];
  int forYouPreviousLength = 0;
  bool noforYouData = false;
  bool forYouFirstInit = true;
  double forYouScrollPosition = 0;

  List<Feed> followingData = [];
  int followingPreviousLength = 0;
  bool nofollowingData = false;
  bool followingFirstInit = true;
  double followingScrollPosition = 0;

  AllPostsView viewsProvider;

  FeedListProvider({this.viewsProvider});

  void callFuture() {
    print('FeedList CallFuture RAN!');
    notifyListeners();
  }

  // void refreshViewPosts() {
  //   viewsProvider.refreshView();
  // }

  Future<void> updateFollowingData(List<Feed> feedList) async {
    feedList.forEach((feed) {
      followingData.add(feed);
      viewsProvider.followingAddView(feed);
    });
    if (followingData.length == followingPreviousLength) {
      nofollowingData = true;
    } else {
      followingPreviousLength = followingData.length;
      nofollowingData = false;
    }
  }

  Future<void> updateForYouData(List<Feed> feedList) async {
    feedList.forEach((feed) {
      forYouData.add(feed);
      viewsProvider.forYouAddView(feed);
    });
    if (forYouData.length == forYouPreviousLength) {
      noforYouData = true;
    } else {
      forYouPreviousLength = forYouData.length;
      noforYouData = false;
    }
    print('ChangeNotifier: ' + forYouData.toString());
  }

  void followingDataClear() {
    followingData.clear();
  }

  void forYouDataClear() {
    forYouData.clear();
  }
}
