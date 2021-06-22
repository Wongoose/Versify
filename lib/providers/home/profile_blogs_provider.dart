import 'package:versify/models/feed_model.dart';
import 'package:versify/providers/home/profile_pageview_provider.dart';
import 'package:flutter/cupertino.dart';

class ProfileBlogsProvider extends ChangeNotifier {
  List<Feed> data = [];
  int previousLength = 0;
  bool _noData = false;
  ProfileAllPostsView viewsProvider;

  // String currentProfileUID = '';

  bool initialOpen = true;
  bool doneLoading = false;

  //getters
  bool get noData => data.isEmpty;

  ProfileBlogsProvider({this.viewsProvider});

  void callFuture() {
    print('ProfileBlogsList CallFuture RAN!');
    notifyListeners();
  }

  Future<void> updateData(List<Feed> feedList) async {
    feedList.forEach((feed) {
      data.add(feed);
      viewsProvider.addView(feed, insertFirst: false);
    });
    if (data.length == previousLength) {
      _noData = true;
    } else {
      previousLength = data.length;
      _noData = false;
    }
    print('ChangeNotifier: ' + data.toString());
  }

  Future<void> insertNewData(List<Feed> feedList) async {
    feedList.forEach((feed) {
      data.insert(0, feed);
      viewsProvider.addView(feed, insertFirst: true);
    });
  }
}
