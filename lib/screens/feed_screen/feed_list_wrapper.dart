import 'package:versify/providers/feed_type_provider.dart';
import 'package:versify/screens/feed_screen/following_feed_list.dart';
import 'package:versify/screens/feed_screen/for_you_feed_list.dart';
import 'package:versify/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

    if (_feedTypeProvider.currentFeedType == FeedType.following) {
      return _followingFeed;
    } else if (_feedTypeProvider.currentFeedType == FeedType.forYou) {
      return _forYouFeed;
    } else {
      return Loading();
    }
  }
}
