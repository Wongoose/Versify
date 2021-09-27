import 'package:versify/providers/feeds/feed_type_provider.dart';
import 'package:versify/providers/home/tutorial_provider.dart';
import 'package:versify/screens/feed_screen/widgets_feeds/following_feed_list.dart';
import 'package:versify/screens/feed_screen/widgets_feeds/for_you_feed_list.dart';
import 'package:versify/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:versify/tutorial/feed_list_tutorial.dart';

enum FeedType { following, forYou }

class FeedListWrapper extends StatefulWidget {
  final ScrollController followingController;
  final ScrollController forYouController;
  FeedListWrapper({this.followingController, this.forYouController});

  @override
  _FeedListWrapperState createState() => _FeedListWrapperState();
}

class _FeedListWrapperState extends State<FeedListWrapper> {
  Map<int, double> forYouDynamicItemExtentList = {};
  Map<int, double> followingDynamicItemExtentList = {};

  void dispose() {
    super.dispose();
    print("FEED WRAPPER is disposed!");
  }

  @override
  Widget build(BuildContext context) {
    print('feed list wrapper built');
    FeedTypeProvider _feedTypeProvider =
        Provider.of<FeedTypeProvider>(context, listen: true);

    final TutorialProvider _tutorialProvider =
        Provider.of<TutorialProvider>(context, listen: true);

    if (_tutorialProvider.refreshFeedList) {
      return TutorialFeedList();
    } else {
      if (_feedTypeProvider.currentFeedType == FeedType.following) {
        return FollowingFeedList(
          feedListController: widget.followingController,
          dynamicItemExtentList: followingDynamicItemExtentList,
        );
        // return _followingFeed;
      } else if (_feedTypeProvider.currentFeedType == FeedType.forYou) {
        return ForYouFeedList(
          feedListController: widget.forYouController,
          dynamicItemExtentList: forYouDynamicItemExtentList,
        );
        // return _forYouFeed;
      } else {
        return Loading();
      }
    }
  }
}
