import 'package:versify/providers/feeds/feed_type_provider.dart';
import 'package:versify/providers/home/tutorial_provider.dart';
import 'package:versify/screens/feed_screen/following_feed_list.dart';
import 'package:versify/screens/feed_screen/for_you_feed_list.dart';
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
  Widget _followingFeed;
  Widget _forYouFeed;

  void initState() {
    super.initState();
    print('FEED WRAPPER INITSTATE');
    _followingFeed =
        FollowingFeedList(feedListController: widget.followingController);
    _forYouFeed = ForYouFeedList(feedListController: widget.forYouController);
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
        return _followingFeed;
      } else if (_feedTypeProvider.currentFeedType == FeedType.forYou) {
        return _forYouFeed;
      } else {
        return Loading();
      }
    }
  }
}
