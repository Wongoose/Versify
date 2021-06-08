import 'dart:ui';
import 'package:versify/models/feed_model.dart';
import 'package:versify/providers/post_swipe_up_provider.dart';
import 'package:versify/providers/tutorial_provider.dart';
import 'package:versify/providers/view_post_gift_provider.dart';
import 'package:versify/providers/view_post_like_provider.dart';
import 'package:versify/providers/all_posts_provider.dart';
import 'package:versify/screens/feed_screen/widgets/comment_widget.dart';
import 'package:versify/screens/feed_screen/widgets/gift_widget.dart';
import 'package:versify/screens/feed_screen/widgets/interaction_toolbar.dart';
import 'package:versify/screens/feed_screen/widgets/read_more_overlay.dart';
import 'package:versify/screens/feed_screen/widgets/uneditable_comment.dart';
import 'package:versify/screens/feed_screen/widgets/view_content.dart';
import 'package:versify/screens/feed_screen/widgets/view_gift_widget.dart';
import 'package:versify/screens/feed_screen/widgets/view_post_title.dart';
import 'package:versify/screens/profile_screen/profile_pageview_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:versify/services/notification.dart';

//New ViePost

enum PageViewType { allPosts, profilePosts }

class ViewPostWidget extends StatefulWidget {
  // final List<Map<String, Color>> colorScheme;
  final int themeIndex;
  final String title;
  final String name;
  final String content;
  final List listMapContent;
  final List<dynamic> tags;
  final DateTime lastUpdated;
  final Feed feed;
  final PageViewType pageViewType;

  // final ThemeData _theme = ThemeData();

  ViewPostWidget(
      {this.themeIndex,
      this.title,
      this.name,
      this.content,
      this.listMapContent,
      this.tags,
      this.lastUpdated,
      // this.colorScheme,
      this.feed,
      this.pageViewType});

  @override
  _ViewPostWidgetState createState() => _ViewPostWidgetState();
}

class _ViewPostWidgetState extends State<ViewPostWidget> {
  final ScrollController _viewPostController =
      ScrollController(initialScrollOffset: 0);

  ViewPostLikeProvider _likeProvider;
  dynamic _postsProvider; //AllPostsView or ProfileAllPostsView
  PostSwipeUpProvider _swipeUpProvider;
  TutorialProvider _tutorialProvider;

  bool _firstInit = true;

  bool _nextPostVisibile = false;
  bool _prevPostVisibile = true;
  bool readMoreVisible = true;

  bool isEnd = false;
  bool isScroll = false;
  bool isStart = true;

  int _daysAgo;
  int readyForSwipeUp = 0;
  int readyForSwipeDown = 0;

  GiftProvider _giftProvider;

  void _readMoreTap() {
    setState(() {
      _viewPostController.position.jumpTo(80);
      _nextPostVisibile = false;
      readyForSwipeUp = 0;

      // _postsProvider.clickFromPostFeedWidget = false;

      // _postsProvider.readMoreVisible = false;
      _postsProvider.setReadMoreVisible(false);
      readMoreVisible = false;
    });
  }

  void initState() {
    print('ViewPost init state with name: ' + widget.name);
    super.initState();
    // readMoreVisible = widget.content.length > 1000 ? true : false;
    _giftProvider = GiftProvider(
      initialGiftBird: widget.feed.giftBird,
      initialGiftLove: widget.feed.giftLove,
    );

    //
    _likeProvider = ViewPostLikeProvider(feed: widget.feed);
    _likeProvider.initialLike();
  }

  void tutorialInit() {
    if (postFrameDone) {
      if (_tutorialProvider.viewSecondPost &&
          _postsProvider.forYouCurrentIndex != 0) {
        NotificationOverlay().simpleNotification(
          body: 'Hope you enjoy this new post. Keep going!',
          imagePath: 'assets/images/copywriting.png',
          title: 'A good start!',
          delay: Duration(seconds: 3),
        );
      }
    }
  }

  _ViewPostWidgetState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      tutorialInit();

      _firstInit = true;
      print('isClicked: ' + _postsProvider.clickFromPostFeedWidget.toString());
      _postsProvider.clickFromPostFeedWidget ? _readMoreTap() : null;
      //pass provider to allPostsView for bottomsheetActions
      // _postsProvider.setLikeProvider(_likeProvider);
      // if (_postsProvider.clickFromPostFeedWidget) {
      //   setState(
      //       () => readMoreVisible = !_postsProvider.clickFromPostFeedWidget);
      // }

      // _viewPostController.position.jumpTo(80);

      _viewPostController.addListener(() {
        isEnd = (_viewPostController.offset ==
            _viewPostController.position.maxScrollExtent);
        isStart = (_viewPostController.offset == 0);

        if (_viewPostController.position.pixels -
                _viewPostController.position.minScrollExtent >=
            500) {
          if (readyForSwipeUp == 1) {
            setState(() => isScroll = false);
          }
          if (isScroll == false && readyForSwipeUp != 1) {
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
        if (_viewPostController.position.userScrollDirection ==
            ScrollDirection.forward) {
          if (readyForSwipeUp == 1) {
            readyForSwipeUp = 0;
            setState(() => _nextPostVisibile = false);
          }

          // if (_viewPostController.offset == 0) {
          //   setState(() => readMoreVisible = true);
          //   // }
          //   // if (readMoreVisible) {
          //   //   print('Is START');
          //   //   readyForSwipeDown++;
          //   //   print('Ready for Swip Down: ' + readyForSwipeDown.toString());
          //   //   readyForSwipeDown == 2 ? setState(() => _prevPostVisibile = true): null;
          //   // }
          // }
        }

        if (isStart) {
          if (_firstInit) {
            readyForSwipeDown = 2;
            _firstInit = false;
          } else {
            print('Is Start');
            readyForSwipeDown++;

            if (readyForSwipeDown == 1) {
              print('Ready for Swipe Down to prev post ' +
                  readyForSwipeDown.toString());
              setState(() => _prevPostVisibile = true);
              _viewPostController.animateTo(20,
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeInOutQuint);
              // readySwipDownFunc();
            }
          }
        }

        if (isEnd) {
          print('Is ENd');
          if (_tutorialProvider.viewFirstPost) {
            _tutorialProvider
                .updateProgress(TutorialProgress.viewFirstPostDone);
          }

          if (readyForSwipeUp == 0) {
            _viewPostController.position.animateTo(
                _viewPostController.position.maxScrollExtent - 20,
                duration: Duration(milliseconds: 300),
                curve: Curves.easeInOutQuint);
            print('Has Jumped');

            _swipeUpProvider.setSwipeUpVisible(true);
          }

          readyForSwipeUp++;
          readyForSwipeUp == 1
              ? setState(() => _nextPostVisibile = true)
              : null;
          if (readyForSwipeUp == 1) {
            setState(() => isScroll = false);

            print('Ready For Swipe Up: ' + readyForSwipeUp.toString());
          }
        }

        if (_viewPostController.position.userScrollDirection ==
            ScrollDirection.reverse) {
          if (_firstInit == true) {
            setState(() {
              _prevPostVisibile = false;
              _firstInit = false;
            });
          }

          if (readyForSwipeDown == 1) {
            print('Scroll down hide prevPost');
            readyForSwipeDown = 0;
            setState(() => _prevPostVisibile = false);
          }
        }

        if (readyForSwipeUp == 2) {
          // _postsProvider.clickFromPostFeedWidget = false;
          _postsProvider.setClickFromPostFeedWidget(false);

          _postsProvider.setReadMoreVisible(true);

          _postsProvider.pageController.nextPage(
              duration: Duration(milliseconds: 400), curve: Curves.easeInOut);
        }

        if (readyForSwipeDown == 2 && _postsProvider.currentIndex != 0) {
          _postsProvider.setClickFromPostFeedWidget(false);

          _postsProvider.setReadMoreVisible(true);

          _postsProvider.pageController.previousPage(
              duration: Duration(milliseconds: 400), curve: Curves.easeInOut);

          print('Index is: ' + _postsProvider.currentIndex.toString());
        }
      });
    });
  }

  bool isProfileViewPost = false;
  bool postFrameDone;

  @override
  Widget build(BuildContext context) {
    final ThemeData _theme = Theme.of(context);
    _swipeUpProvider = Provider.of<PostSwipeUpProvider>(context, listen: false);
    _tutorialProvider = Provider.of<TutorialProvider>(context, listen: false);

    if (widget.pageViewType == PageViewType.allPosts) {
      print('Type of PageView is allpost');
      _postsProvider = Provider.of<AllPostsView>(context);
    } else if (widget.pageViewType == PageViewType.profilePosts) {
      print('Type of PageView is profilePost');
      _postsProvider = Provider.of<ProfileAllPostsView>(context);
      isProfileViewPost = true;
    }

    if (_postsProvider.clickFromPostFeedWidget) {
      if (_postsProvider.currentIndex == -1) {
        postFrameDone = false;
      } else {
        if (_postsProvider.currentIndex > 0) {
          postFrameDone = _postsProvider.pageViewPostFrameDone;
        } else {
          postFrameDone = true;
        }
      }
    } else {
      postFrameDone = true;
    }

    _daysAgo = (DateTime.now().difference(widget.lastUpdated)).inDays;

    return WillPopScope(
      onWillPop: () async {
        if (Navigator.of(context).userGestureInProgress)
          return false;
        else
          return true;
      },
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider<ViewPostLikeProvider>.value(
              value: _likeProvider),
          ChangeNotifierProvider<GiftProvider>.value(value: _giftProvider),
        ],
        child: Stack(children: [
          SafeArea(
            child: Scaffold(
              backgroundColor: Colors.white,
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
                            Container(
                              alignment: Alignment.bottomCenter,
                              height: readMoreVisible ? 0 : 80,
                              width: MediaQuery.of(context).size.width,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'swipe to previous post',
                                    style: TextStyle(
                                        color: Colors.black54, fontSize: 11),
                                  ),
                                  SizedBox(height: 5),
                                  Icon(
                                    Icons.arrow_downward_rounded,
                                    color: Colors.black54,
                                    size: 15,
                                  ),
                                  SizedBox(height: 10),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(2, 4, 26, 0),
                              child: Text(
                                widget.title,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontFamily: 'Libre',
                                    fontStyle: FontStyle.normal,
                                    color: Colors.black,
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
                          postFrameDone: postFrameDone,
                          pageViewType: widget.pageViewType,
                          daysAgo: _daysAgo,
                          viewPostWidget: widget,
                          isProfileViewPost: isProfileViewPost,
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 300,
                                  child: Wrap(
                                      runSpacing: 5,
                                      children: widget.tags.isEmpty
                                          ? [
                                              Padding(
                                                padding: EdgeInsets.fromLTRB(
                                                    0, 0, 5, 0),
                                                child: FittedBox(
                                                  alignment: Alignment.center,
                                                  child: Container(
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            6, 3, 6, 3),
                                                    alignment: Alignment.center,
                                                    decoration: BoxDecoration(
                                                      border: Border.fromBorderSide(
                                                          BorderSide(
                                                              color: _theme
                                                                  .primaryColor
                                                                  .withOpacity(
                                                                      0.8))),

                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),

                                                      // color: colorScheme[themeIndex]['secondary']

                                                      //     .withOpacity(0.3),
                                                    ),
                                                    child: Text(
                                                      'no tags',
                                                      style: TextStyle(
                                                          fontFamily: 'Nunito',
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
                                          : widget.tags
                                              .map(
                                                (individualTag) => Padding(
                                                  padding: EdgeInsets.fromLTRB(
                                                      0, 0, 5, 0),
                                                  child: FittedBox(
                                                    alignment: Alignment.center,
                                                    child: Container(
                                                      padding:
                                                          EdgeInsets.fromLTRB(
                                                              6, 3, 6, 3),
                                                      alignment:
                                                          Alignment.center,
                                                      decoration: BoxDecoration(
                                                        border: Border.fromBorderSide(
                                                            BorderSide(
                                                                color: _theme
                                                                    .primaryColor
                                                                    .withOpacity(
                                                                        0.8))),

                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),

                                                        // color: colorScheme[themeIndex]['secondary']

                                                        //     .withOpacity(0.3),
                                                      ),
                                                      child: Text(
                                                        individualTag
                                                                .toString()
                                                                .contains('#')
                                                            ? individualTag
                                                                .toString()
                                                                .replaceRange(
                                                                    individualTag
                                                                            .toString()
                                                                            .length -
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
                                  padding: EdgeInsets.fromLTRB(10, 0, 10, 4),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.timer,
                                        color:
                                            _theme.accentColor.withOpacity(1),
                                        size: 15,
                                      ),
                                      SizedBox(width: 2),
                                      Text(
                                        '${(widget.feed.contentLength / 5 / 1000 * 5.65 + 0.5).round()}min',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.black.withOpacity(0.5),
                                        ),
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
                    // SliverPersistentHeader(
                    //   floating: false,
                    //   pinned: true,
                    //   delegate: _SliverAppBarDelegate(
                    //     Text(
                    //       'Read',
                    //       softWrap: true,
                    //       style: TextStyle(
                    //         color: Color(0xffff548e),
                    //         letterSpacing: 0,
                    //         fontSize: 22,
                    //         fontWeight: FontWeight.w700,
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    SliverToBoxAdapter(
                      child: Container(
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 70),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Padding(
                              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                              child: ViewPostContent(
                                feed: widget.feed,
                                likeProvider: _likeProvider,
                                content: widget.content,
                                listMapContent: widget.listMapContent,
                                readMoreVisible: readMoreVisible,
                                readMoreTap: _readMoreTap,
                              ),
                            ),
                            SizedBox(height: 10),
                            Divider(thickness: 0.5),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(10, 0, 10, 0),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Gifts',
                                              style: TextStyle(
                                                letterSpacing: 0,
                                                fontSize: 22,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.black87,
                                              ),
                                            ),
                                            // TextButton(
                                            //   style: TextButton.styleFrom(
                                            //     primary: Colors.white,
                                            //     padding: EdgeInsets.fromLTRB(
                                            //         10, 0, 0, 0),
                                            //     backgroundColor: Colors.white,
                                            //   ),
                                            //   onPressed: () => {},
                                            //   child: Text(
                                            //     'View all...',
                                            //     style: TextStyle(
                                            //       fontSize: 12,
                                            //       color: Color(0xffff548e),
                                            //       fontWeight: FontWeight.w400,
                                            //     ),
                                            //   ),
                                            // ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      SingleChildScrollView(
                                        padding:
                                            EdgeInsets.fromLTRB(10, 8, 0, 10),
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            ViewGiftWidget(
                                              // value: widget.feed.giftLove,
                                              giftType: GiftType.love,
                                              text: 'Great love',
                                              color: Color(0xffff548e),
                                              image: 'assets/images/love.png',
                                            ),
                                            ViewGiftWidget(
                                              // value: widget.feed.giftBird,
                                              giftType: GiftType.bird,
                                              text: 'Soaring bird',
                                              color: Colors.amber[700],
                                              image: 'assets/images/bird.png',
                                            ),
                                            // GiftWidget(
                                            //   text: 'Magic unicorn',
                                            //   color: Color(0xffff548e),
                                            //   image: 'assets/images/shy.png',
                                            // ),
                                            // GiftWidget(
                                            //   text:
                                            //       'Growing sprout of the great',
                                            //   color: Colors.teal[300],
                                            //   image: 'assets/images/sprout.png',
                                            // ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            // ViewPostComments(
                            //   widget: widget,
                            //   bottomSheetComments: _bottomSheetComments,
                            // ),
                            AnimatedBuilder(
                              animation: _viewPostController,
                              builder: (context, child) => AnimatedContainer(
                                duration: Duration(milliseconds: 200),
                                alignment: Alignment.center,
                                height: _nextPostVisibile ? 60 : 0,
                                width: MediaQuery.of(context).size.width,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SizedBox(height: 0),
                                    Icon(
                                      Icons.arrow_upward_rounded,
                                      color: Colors.black54,
                                      size: 15,
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      'swipe to next post',
                                      style: TextStyle(
                                        color: Colors.black54,
                                        fontSize: 11,
                                      ),
                                    ),
                                    SizedBox(height: 15),
                                  ],
                                ),
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
                              color: Colors.black.withOpacity(0.7)),
                          backgroundColor: Colors.white,
                        )
                      : Container(
                          height: 10,
                        )),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerFloat,
              bottomNavigationBar: InteractionBar(
                feed: widget.feed,
                isLiked: widget.feed.isLiked,
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            child: ReadMoreOverlay(
              readMoreTap: _readMoreTap,
              postsProvider: _postsProvider,
            ),
          ),
          Positioned(
            child: Consumer<PostSwipeUpProvider>(builder: (context, state, _) {
              return Visibility(
                visible: state.swipeUpVisible,
                child: GestureDetector(
                  onVerticalDragDown: (_) {
                    state.setSwipeUpVisible(false);
                  },
                  onTapDown: (_) {
                    state.setSwipeUpVisible(false);
                  },
                  child: Container(
                    color: Colors.black.withOpacity(0.8),
                    alignment: Alignment.center,
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(child: Container()),
                        Icon(
                          Icons.swipe,
                          size: 70,
                          color: _theme.primaryColor,
                        ),
                        SizedBox(height: 30),
                        Text(
                          'Finish reading?\nSwipe up to next post!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 20,
                              color: Colors.white,
                              fontFamily: 'Nunito'),
                        ),
                        Expanded(child: Container()),
                        // Icon(
                        //   Icons.keyboard_arrow_up_rounded,
                        //   size: 70,
                        //   color: Color(0xffff548e),
                        // ),
                        // SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ]),
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
      child: new Container(
        alignment: Alignment.centerLeft,
        // decoration: BoxDecoration(
        //     border: Border(top: BorderSide(color: Colors.black38, width: 0.5))),
        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
        color: Colors.white,
        child: _title,
      ),
    );
  }

  @override
  bool shouldRebuild(_SliverTitleBarDelegate oldDelegate) {
    return false;
  }
}

//_____________________________________________________________
