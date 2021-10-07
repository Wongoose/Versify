import 'package:versify/screens/blogs_feed/widgets_feeds/feed_list_wrapper.dart';
import 'package:flutter/cupertino.dart';

class FeedTypeProvider extends ChangeNotifier {
  // final FeedListProvider feedListProvider;
  // final DatabaseService databaseService;
  Widget forYouPageView;
  Widget followingPageView;

  // FeedTypeProvider({this.feedListProvider, this.databaseService});

  FeedType currentFeedType = FeedType.forYou;

  Future<void> typeClicked({FeedType selection}) async {
    if (selection != currentFeedType) {
      currentFeedType = selection;
      if (currentFeedType == FeedType.following) {
        print('Following FeedType selected');
      } else {
        print('For You FeedType selected');
      }
      notifyListeners();
    }
  }

  void initAddPageViews(Widget forYou, Widget following) {
    forYouPageView = forYou;
    followingPageView = following;
  }
}
