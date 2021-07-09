import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:versify/models/feed_model.dart';
import 'package:versify/providers/feeds/view_post_gift_provider.dart';
import 'package:versify/providers/feeds/view_post_like_provider.dart';
import 'package:versify/providers/home/theme_data_provider.dart';
import 'package:versify/providers/home/tutorial_provider.dart';
import 'package:versify/screens/feed_screen/widget_view_post/interaction_toolbar.dart';
import 'package:versify/screens/feed_screen/widget_view_post/view_content.dart';
import 'package:versify/screens/feed_screen/widget_view_post/view_post.dart';
import 'package:versify/screens/feed_screen/widget_view_post/view_post_title.dart';
import 'package:versify/services/auth.dart';
import 'package:versify/services/database.dart';
import 'package:versify/services/notification.dart';
import 'package:versify/shared/splash_loading.dart';

class DynamicLinkPost extends StatefulWidget {
  final String postId;
  final String userUID;
  final bool onPopExitApp;

  DynamicLinkPost({this.postId, this.onPopExitApp, this.userUID});

  @override
  _DynamicLinkPostState createState() => _DynamicLinkPostState();
}

class _DynamicLinkPostState extends State<DynamicLinkPost> {
  final ScrollController _viewPostController =
      ScrollController(initialScrollOffset: 0);

  Feed feed;
  AuthService _authService;
  int _daysAgo;
  bool isScroll = false;

  ViewPostLikeProvider _likeProvider;
  GiftProvider _giftProvider;
  TutorialProvider _tutorialProvider;
  ThemeProvider _themeProvider;

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
      setState(() {
        feed = Feed(
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
          initLike: doc['isLiked'] != null
              ? doc['isLiked'].contains(widget.userUID)
              : false,
          numberOfLikes: doc['likes'],
          numberOfViews: doc['views'],
          listMapContent: doc['listMapContent'] ?? [],
          postedTimestamp: doc['postedTimeStamp'].toDate(),
        );
        _daysAgo = (DateTime.now().difference(feed.postedTimestamp)).inDays;
        _likeProvider = ViewPostLikeProvider(feed: feed);
        _likeProvider.initialLike();
      });
    });
  }

  Future<void> _onWillPop() async {
    if (widget.onPopExitApp) {
      await showDialog<bool>(
          context: context,
          builder: (c) => AlertDialog(
                title: Text(
                  'Exit app',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: _themeProvider.primaryTextColor,
                  ),
                ),
                content: Text(
                  'Do you really want to exit the app?',
                  style: TextStyle(
                    color: _themeProvider.primaryTextColor,
                  ),
                ),
                actions: [
                  TextButton(
                    child: Text('No'),
                    onPressed: () => Navigator.pop(c, false),
                  ),
                  TextButton(
                    child: Text('Yes'),
                    onPressed: () async {
                      print('onPopExit is true | yes clicked');
                      if (_authService.isUserAnonymous &&
                          !_authService.hasFirestoreDocuments) {
                        print('onPopExit is true | user is anon!');
                        await FirebaseAuth.instance.currentUser.delete();
                      }
                      SystemNavigator.pop();
                    },
                  ),
                ],
              ));
    } else {
      print('onPopExit is false');
      if (_authService.isUserAnonymous && !_authService.hasFirestoreDocuments) {
        print('onPopExit is false | user is anon!');
        await FirebaseAuth.instance.currentUser.delete().then((value) =>
            Navigator.popUntil(
                context, ModalRoute.withName(Navigator.defaultRouteName)));
      } else {
        if (_tutorialProvider.signUpProfileNotif) {
          //if tutorial profile not complete (still anonymous user)
          NotificationOverlay().simpleNotification(
              body: 'Sign-up now to unlock more features!',
              imagePath: 'assets/images/relatable.png',
              title: 'Sign Up Profile',
              delay: Duration(seconds: 1));
        }
        Navigator.pop(context);
      }
    }
  }

  _DynamicLinkPostState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _viewPostController.addListener(() {
        // isEnd = (_viewPostController.offset ==
        //     _viewPostController.position.maxScrollExtent);
        // isStart = (_viewPostController.offset == 0);

        if (_viewPostController.position.pixels -
                _viewPostController.position.minScrollExtent >=
            500) {
          if (isScroll == false) {
            setState(() => isScroll = true);
          }
        } else if (isScroll == true) {
          setState(() => isScroll = false);
        }

        if (_viewPostController.offset == 0) {
          if (isScroll == true) {
            setState(() => isScroll = false);
          }
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData _theme = Theme.of(context);
    _themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    _authService = Provider.of<AuthService>(context);
    _tutorialProvider = Provider.of<TutorialProvider>(context, listen: false);

    return WillPopScope(
      onWillPop: () {
        _onWillPop();
        return null;
      },
      child: feed == null
          ? SplashLoading()
          : MultiProvider(
              providers: [
                ChangeNotifierProvider<ViewPostLikeProvider>.value(
                    value: _likeProvider),
                ChangeNotifierProvider<GiftProvider>.value(
                    value: _giftProvider),
              ],
              child: Stack(
                children: [
                  Scaffold(
                    backgroundColor: _theme.backgroundColor,
                    appBar: AppBar(
                      elevation: 0.5,
                      backgroundColor: _theme.canvasColor,
                      centerTitle: false,
                      title: Text(
                        'Quick view',
                        style: TextStyle(
                          color: _themeProvider.primaryTextColor,
                        ),
                      ),
                      leading: GestureDetector(
                        onTap: () async {
                          await _onWillPop();
                        },
                        child: Icon(
                          Icons.arrow_back_rounded,
                          color: _themeProvider.primaryTextColor,
                        ),
                      ),
                    ),
                    body: Padding(
                      // padding: EdgeInsets.fromLTRB(15, 8, 15, 60),
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: CustomScrollView(
                        controller: _viewPostController,
                        cacheExtent: 1000,
                        physics: AlwaysScrollableScrollPhysics(),
                        slivers: [
                          SliverToBoxAdapter(
                            child: Container(
                              padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(2, 4, 26, 0),
                                    child: Text(
                                      feed.title,
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          fontFamily: 'Libre',
                                          fontStyle: FontStyle.normal,
                                          color:
                                              _themeProvider.primaryTextColor,
                                          fontSize: 27,
                                          height: 1.4,
                                          letterSpacing: -0.3),
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                ],
                              ),
                            ),
                          ),
                          SliverPersistentHeader(
                            floating: false,
                            pinned: true,
                            delegate: _SliverTitleBarDelegate(
                              ViewPostTitle(
                                postFrameDone: true,
                                pageViewType: PageViewType.allPosts,
                                daysAgo: _daysAgo,
                                feed: feed,
                                isProfileViewPost: false,
                              ),
                            ),
                          ),
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(height: 15),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: 300,
                                        child: Wrap(
                                            runSpacing: 5,
                                            children: feed.tags.isEmpty
                                                ? [
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.fromLTRB(
                                                              0, 0, 5, 0),
                                                      child: FittedBox(
                                                        alignment:
                                                            Alignment.center,
                                                        child: Container(
                                                          padding: EdgeInsets
                                                              .fromLTRB(
                                                                  6, 3, 6, 3),
                                                          alignment:
                                                              Alignment.center,
                                                          decoration:
                                                              BoxDecoration(
                                                            border: Border.fromBorderSide(BorderSide(
                                                                color: _theme
                                                                    .primaryColor
                                                                    .withOpacity(
                                                                        0.8))),

                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5),

                                                            // color: colorScheme[themeIndex]['secondary']

                                                            //     .withOpacity(0.3),
                                                          ),
                                                          child: Text(
                                                            'no tags',
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'Nunito',
                                                                fontSize: 11,

                                                                // color: Colors.white,

                                                                color: _theme
                                                                    .primaryColor
                                                                    .withOpacity(
                                                                        0.8)),
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                  ]
                                                : feed.tags
                                                    .map(
                                                      (individualTag) =>
                                                          Padding(
                                                        padding:
                                                            EdgeInsets.fromLTRB(
                                                                0, 0, 5, 0),
                                                        child: FittedBox(
                                                          alignment:
                                                              Alignment.center,
                                                          child: Container(
                                                            padding: EdgeInsets
                                                                .fromLTRB(
                                                                    6, 3, 6, 3),
                                                            alignment: Alignment
                                                                .center,
                                                            decoration:
                                                                BoxDecoration(
                                                              border: Border.fromBorderSide(BorderSide(
                                                                  color: _theme
                                                                      .primaryColor
                                                                      .withOpacity(
                                                                          0.8))),

                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5),

                                                              // color: colorScheme[themeIndex]['secondary']

                                                              //     .withOpacity(0.3),
                                                            ),
                                                            child: Text(
                                                              individualTag
                                                                      .toString()
                                                                      .contains(
                                                                          '#')
                                                                  ? individualTag
                                                                      .toString()
                                                                      .replaceRange(
                                                                          individualTag.toString().length -
                                                                              2,
                                                                          individualTag
                                                                              .toString()
                                                                              .length,
                                                                          '')
                                                                  : '#${individualTag.toString().replaceRange(individualTag.toString().length - 2, individualTag.toString().length, '')}',
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      'Nunito',
                                                                  fontSize: 11,

                                                                  // color: Colors.white,

                                                                  color: _theme
                                                                      .primaryColor
                                                                      .withOpacity(
                                                                          0.8)),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                    .toList()),
                                      ),
                                      Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(10, 0, 10, 4),
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.timer,
                                              color: _theme.accentColor
                                                  .withOpacity(1),
                                              size: 15,
                                            ),
                                            SizedBox(width: 2),
                                            Text(
                                              '${(feed.contentLength / 5 / 1000 * 5.65 + 0.5).round()}min',
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: _themeProvider
                                                      .secondaryTextColor),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 15),
                                ],
                              ),
                            ),
                          ),
                          SliverToBoxAdapter(
                            child: Container(
                              padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                    child: ViewPostContent(
                                      feed: feed,
                                      likeProvider: _likeProvider,
                                      content: feed.content,
                                      listMapContent: feed.listMapContent,
                                      readMoreVisible: false,
                                      fromDynamicLink: true,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    floatingActionButton: AnimatedContainer(
                        duration: Duration(milliseconds: 600),
                        curve: Curves.easeIn,
                        child: isScroll
                            ? FloatingActionButton(
                                onPressed: () {
                                  _viewPostController.animateTo(0,
                                      duration: Duration(milliseconds: 100),
                                      curve: Curves.linear);
                                },
                                elevation: 0.5,
                                mini: true,
                                child: Icon(Icons.upgrade_rounded,
                                    color: Theme.of(context)
                                        .backgroundColor
                                        .withOpacity(0.7)),
                                backgroundColor:
                                    _themeProvider.primaryTextColor)
                            : Container(
                                height: 10,
                              )),
                    floatingActionButtonLocation:
                        FloatingActionButtonLocation.centerFloat,
                    bottomNavigationBar: InteractionBar(
                      feed: feed,
                      isLiked: feed.isLiked,
                      fromDynamicLink: true,
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

class _SliverTitleBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverTitleBarDelegate(this._title);

  final Widget _title;
  @override
  double get minExtent => 55;
  @override
  double get maxExtent => 55;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return BottomAppBar(
      elevation: shrinkOffset == 0 ? 0 : 0.5,
      color: Theme.of(context).backgroundColor,
      child: new Container(
        alignment: Alignment.centerLeft,
        // decoration: BoxDecoration(
        //     border: Border(top: BorderSide(color: Colors.black38, width: 0.5))),
        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
        color: Theme.of(context).backgroundColor,
        child: _title,
      ),
    );
  }

  @override
  bool shouldRebuild(_SliverTitleBarDelegate oldDelegate) {
    return false;
  }
}

// class _SliverPinContentDelegate extends SliverPersistentHeaderDelegate {
//   _SliverPinContentDelegate(this._title);

//   final Widget _title;
//   @override
//   double get minExtent => 55;
//   @override
//   double get maxExtent => 1000;

//   @override
//   Widget build(
//       BuildContext context, double shrinkOffset, bool overlapsContent) {
//     return new Container(
//       alignment: Alignment.topLeft,
//       // decoration: BoxDecoration(
//       //     border: Border(top: BorderSide(color: Colors.black38, width: 0.5))),
//       padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
//       color: Colors.transparent,
//       child: _title,
//     );
//   }

//   @override
//   bool shouldRebuild(_SliverPinContentDelegate oldDelegate) {
//     return false;
//   }
// }
