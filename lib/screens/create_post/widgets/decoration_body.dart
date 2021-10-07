import 'package:versify/models/feed_model.dart';
import 'package:versify/providers/providers_create_post/content_body_provider.dart';
import 'package:versify/screens/create_post/widgets/review_feed_widget.dart';
import 'package:flutter/material.dart';

class DecorationBodyWidget extends StatelessWidget {
  final ContentBodyProvider contentBodyProvider;
  const DecorationBodyWidget({
    Key key,
    @required ScrollController scrollController,
    @required Feed reviewFeed,
    this.contentBodyProvider,
  })  : _scrollController = scrollController,
        _reviewFeed = reviewFeed,
        super(key: key);

  final ScrollController _scrollController;
  final Feed _reviewFeed;

  @override
  Widget build(BuildContext context) {
    final Feed _dummyFeed = Feed(
      username: 'versify_wongoose',
      title: 'Hello the world!',
      content:
          'Not everyone knwo what to do in a world like this la you are the words of all in the entire world of hunger games you can never imagine how much I hate you in this world. So please just go away and never come abck to my likfe I don;t want to see you ever again.',
      tags: ['#love', '#peace'],
    );

    return ListView(
      physics: NeverScrollableScrollPhysics(),
      controller: _scrollController,
      // crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Opacity(
          opacity: 0.3,
          child: Container(
            child: ReviewFeedWidget(
              index: 2,
              feed: _dummyFeed,
            ),
          ),
        ),
        Opacity(
          opacity: 0.3,
          child: Container(
            child: ReviewFeedWidget(
              index: 3,
              feed: _dummyFeed,
            ),
          ),
        ),
        Opacity(
          opacity: 0.3,
          child: Container(
            child: ReviewFeedWidget(
              index: 4,
              feed: _dummyFeed,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20))),
            child: Container(
              padding: EdgeInsets.fromLTRB(5, 5, 5, 15),
              child: ReviewFeedWidget(
                contentBodyProvider: contentBodyProvider,
                index: 0,
                feed: _reviewFeed,
              ),
            ),
          ),
        ),
        Opacity(
          opacity: 0.3,
          child: Container(
            child: ReviewFeedWidget(
              index: 1,
              feed: _dummyFeed,
            ),
          ),
        ),
        Opacity(
          opacity: 0.3,
          child: Container(
            child: ReviewFeedWidget(
              index: 1,
              feed: _dummyFeed,
            ),
          ),
        ),
        Opacity(
          opacity: 0.3,
          child: Container(
            child: ReviewFeedWidget(
              index: 1,
              feed: _dummyFeed,
            ),
          ),
        ),
        Opacity(
          opacity: 0.3,
          child: Container(
            child: ReviewFeedWidget(
              index: 1,
              feed: _dummyFeed,
            ),
          ),
        ),
        Opacity(
          opacity: 0.3,
          child: Container(
            child: ReviewFeedWidget(
              index: 1,
              feed: _dummyFeed,
            ),
          ),
        ),
        SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
