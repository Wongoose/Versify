import 'package:flutter/material.dart';
import 'package:versify/models/feed_model.dart';
import 'package:versify/services/firebase/database.dart';

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
        userID: doc['userID'],
        username: doc['username'],
        profileImageUrl: doc['profileImageUrl'] ?? null,
        hasViewed: false,

        // content: doc['content'] ?? 'No Content',
        contentLength: doc['contentLength'] ?? 0,

        featuredTopic: doc['featuredTopic'] ?? null,
        featuredValue: doc['featuredValue'] ?? ". . .",

        giftLove: doc['giftLove'] ?? 0,
        giftBird: doc['giftBird'] ?? 0,

        title: doc['title'] ?? 'Just Me',
        tags: doc['tags'] ?? [],
        initLike: false,
        numberOfLikes: doc['likes'],
        numberOfViews: doc['views'],
        listMapContent: doc['listMapContent'] ?? [],
        postedTimestamp: doc['postedTimeStamp'].toDate(),
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
