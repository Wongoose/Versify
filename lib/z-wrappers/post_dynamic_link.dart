import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:versify/models/feed_model.dart';
import 'package:versify/services/database.dart';
import 'package:versify/shared/loading.dart';

class DynamicLinkPost extends StatefulWidget {
  final String postId;
  DynamicLinkPost({this.postId});

  @override
  _DynamicLinkPostState createState() => _DynamicLinkPostState();
}

class _DynamicLinkPostState extends State<DynamicLinkPost> {
  Feed _feed;

  void initState() {
    super.initState();
    getFeedData();
  }

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
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData _theme = Theme.of(context);

    return Scaffold(
      backgroundColor: _theme.accentColor,
      appBar: AppBar(
        elevation: 0.5,
        backgroundColor: Colors.white,
        centerTitle: false,
        title: Text(
          'View Post',
          style: TextStyle(color: Colors.black),
        ),
        leading: Icon(
          Icons.arrow_back_rounded,
          color: Colors.black,
        ),
      ),
      body: _feed != null
          ? NestedScrollView(
              headerSliverBuilder: (context, s) {
                return [
                  // SliverToBoxAdapter(
                  //   child: Expanded(
                  //     child: Container(
                  //       height: MediaQuery.of(context).size.height,
                  //       width: MediaQuery.of(context).size.width,
                  //       color: _theme.accentColor,
                  //     ),
                  //   ),
                  // ),
                  SliverAppBar(
                    elevation: 0,
                    pinned: true,
                    floating: false,
                    expandedHeight: 200,
                    collapsedHeight: 100,
                    backgroundColor: Colors.transparent,
                    flexibleSpace: FlexibleSpaceBar(
                      titlePadding: EdgeInsets.fromLTRB(20, 0, 20, 10),
                      centerTitle: false,
                      collapseMode: CollapseMode.pin,
                      title: Align(
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          _feed.title,
                          textAlign: TextAlign.left,
                          maxLines: null,
                          style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontFamily: 'Libre',
                              fontStyle: FontStyle.normal,
                              color: Colors.black,
                              fontSize: 22,
                              height: 1.4,
                              letterSpacing: -0.3),
                        ),
                      ),
                    ),
                    // title: Text(
                    //   'Love endures through every circumstance.',
                    //   textAlign: TextAlign.left,
                    //   maxLines: null,
                    //   style: TextStyle(
                    //       fontWeight: FontWeight.normal,
                    //       fontFamily: 'Libre',
                    //       fontStyle: FontStyle.normal,
                    //       color: Colors.black,
                    //       fontSize: 27,
                    //       height: 1.4,
                    //       letterSpacing: -0.3),
                    // ),
                  ),
                  // SliverToBoxAdapter(
                  //   child: Container(
                  //     padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                  //     child: Column(
                  //       children: [
                  //         Padding(
                  //           padding: EdgeInsets.fromLTRB(2, 4, 26, 0),
                  //           child: Text(
                  //             'Love endures through every circumstance.',
                  //             textAlign: TextAlign.left,
                  //             style: TextStyle(
                  //                 fontWeight: FontWeight.normal,
                  //                 fontFamily: 'Libre',
                  //                 fontStyle: FontStyle.normal,
                  //                 color: Colors.black,
                  //                 fontSize: 27,
                  //                 height: 1.4,
                  //                 letterSpacing: -0.3),
                  //           ),
                  //         ),
                  //         SizedBox(height: 10),
                  //       ],
                  //     ),
                  //   ),
                  // ),
                ];
              },
              body: Container(
                padding: EdgeInsets.fromLTRB(20, 30, 8, 10),
                width: MediaQuery.of(context).size.width,
                // height: MediaQuery.of(context).size.height,
                constraints: BoxConstraints(
                  maxHeight: 500,
                  minHeight: 10,
                ),
                decoration: BoxDecoration(
                  boxShadow: [BoxShadow(color: Colors.black38)],
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50),
                  ),
                ),
                child: SingleChildScrollView(
                    child: Column(
                  children: [Text(_feed.username)],
                )),
              ),
            )
          : Loading(),
    );
  }
}

class _SliverPinContentDelegate extends SliverPersistentHeaderDelegate {
  _SliverPinContentDelegate(this._title);

  final Widget _title;
  @override
  double get minExtent => 55;
  @override
  double get maxExtent => 1000;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new Container(
      alignment: Alignment.topLeft,
      // decoration: BoxDecoration(
      //     border: Border(top: BorderSide(color: Colors.black38, width: 0.5))),
      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
      color: Colors.transparent,
      child: _title,
    );
  }

  @override
  bool shouldRebuild(_SliverPinContentDelegate oldDelegate) {
    return false;
  }
}
