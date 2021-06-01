import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:versify/models/feed_model.dart';
import 'package:versify/services/auth.dart';
import 'package:versify/services/database.dart';
import 'package:versify/shared/loading.dart';

class DynamicLinkPost extends StatefulWidget {
  final String postId;
  final bool onPopExitApp;

  DynamicLinkPost({this.postId, this.onPopExitApp});

  @override
  _DynamicLinkPostState createState() => _DynamicLinkPostState();
}

class _DynamicLinkPostState extends State<DynamicLinkPost> {
  Feed _feed;
  AuthService _authService;

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
      setState(() {});
    });
  }

  Future<void> _onWillPop() async {
    if (widget.onPopExitApp) {
      await showDialog<bool>(
          context: context,
          builder: (c) => AlertDialog(
                title: Text(
                  'Exit app',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                content: Text('Do you really want to exit the app'),
                actions: [
                  TextButton(
                    child: Text('Yes'),
                    onPressed: () async {
                      print('onPopExit is true | yes clicked');
                      if (_authService.isUserAnonymous) {
                        print('onPopExit is true | user is anon!');
                        await FirebaseAuth.instance.currentUser.delete();
                      }
                      SystemNavigator.pop();
                    },
                  ),
                  TextButton(
                    child: Text('No'),
                    onPressed: () => Navigator.pop(c, false),
                  ),
                ],
              ));
    } else {
      print('onPopExit is false');
      if (_authService.isUserAnonymous) {
        print('onPopExit is false | user is anon!');
        await FirebaseAuth.instance.currentUser.delete().then((value) =>
            Navigator.popUntil(
                context, ModalRoute.withName(Navigator.defaultRouteName)));
      } else {
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData _theme = Theme.of(context);
    _authService = Provider.of<AuthService>(context);

    return WillPopScope(
      onWillPop: () {
        _onWillPop();
        return null;
      },
      child: Scaffold(
        backgroundColor: _theme.accentColor,
        appBar: AppBar(
          elevation: 0.5,
          backgroundColor: Colors.white,
          centerTitle: false,
          title: Text(
            'View Post',
            style: TextStyle(color: Colors.black),
          ),
          leading: GestureDetector(
            onTap: () async {
              await _onWillPop();
            },
            child: Icon(
              Icons.arrow_back_rounded,
              color: Colors.black,
            ),
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
      ),
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
