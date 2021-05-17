import 'package:flutter/material.dart';
import 'package:versify/models/feed_model.dart';
import 'package:versify/services/database.dart';

class DynamicLinksWrapper extends StatefulWidget {
  final String postId;

  DynamicLinksWrapper({this.postId});

  @override
  _DynamicLinksWrapperState createState() => _DynamicLinksWrapperState();
}

class _DynamicLinksWrapperState extends State<DynamicLinksWrapper> {
  Feed _feed;

  Future<void> getFeedData() async {
    await DatabaseService()
        .allPostsCollection
        .doc(widget.postId)
        .get()
        .then((doc) {
      _feed = Feed(
        documentID: doc.id,
        userID: doc.data()['userID'],
        username: doc.data()['username'],
        profileImageUrl: doc.data()['profileImageUrl'] ?? null,
        hasViewed: false,

        // content: doc.data()['content'] ?? 'No Content',
        contentLength: doc.data()['contentLength'] ?? 0,

        featuredTopic: doc.data()['featuredTopic'] ?? null,
        featuredValue: doc.data()['featuredValue'] ?? ". . .",

        giftLove: doc.data()['giftLove'] ?? 0,
        giftBird: doc.data()['giftBird'] ?? 0,

        title: doc.data()['title'] ?? 'Just Me',
        tags: doc.data()['tags'] ?? [],
        initLike: false,
        numberOfLikes: doc.data()['likes'],
        numberOfViews: doc.data()['views'],
        listMapContent: doc.data()['listMapContent'] ?? [],
        postedTimestamp: doc.data()['postedTimeStamp'].toDate(),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getFeedData(),
        builder: (context, snap) {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              title: Text(widget.postId),
            ),
            body: Container(
              alignment: Alignment.center,
              child: Column(
                children: [
                  Text('postId is: ${widget.postId}'),
                  SizedBox(height: 20),
                  Container(child: Text(_feed.username)),
                ],
              ),
            ),
          );
        });
  }
}
