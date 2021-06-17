// enum PageViewType { allPosts, profilePosts }

// class ViewPostWidget extends StatefulWidget {
//   // final List<Map<String, Color>> colorScheme;
//   final int themeIndex;
//   final String title;
//   final String name;
//   final String content;
//   final List listMapContent;
//   final List<dynamic> tags;
//   final DateTime lastUpdated;
//   final Feed feed;
//   final PageViewType pageViewType;

//   final ThemeData _theme = ThemeData();

//   ViewPostWidget(
//       {this.themeIndex,
//       this.title,
//       this.name,
//       this.content,
//       this.listMapContent,
//       this.tags,
//       this.lastUpdated,
//       // this.colorScheme,
//       this.feed,
//       this.pageViewType});

//   @override
//   _ViewPostWidgetState createState() => _ViewPostWidgetState();
// }

// class _ViewPostWidgetState extends State<ViewPostWidget> {
//   final ScrollController _viewPostController =
//       ScrollController(initialScrollOffset: 0);

//   ViewPostLikeProvider _likeProvider;
//   dynamic _postsProvider; //AllPostsView or ProfileAllPostsView

//   bool _firstInit = true;

//   bool _nextPostVisibile = false;
//   bool _prevPostVisibile = true;
//   bool readMoreVisible = true;

//   bool isEnd = false;
//   bool isScroll = false;
//   bool isStart = true;

//   int _daysAgo;
//   int readyForSwipeUp = 0;
//   int readyForSwipeDown = 0;

//   void _readMoreTap() {
//     setState(() {
//       _viewPostController.position.jumpTo(80);
//       _nextPostVisibile = false;
//       readyForSwipeUp = 0;

//       // _postsProvider.clickFromPostFeedWidget = false;
//       _postsProvider.readMoreVisible = false;
//       readMoreVisible = false;
//     });
//   }

//   void initState() {
//     print('ViewPost init state');
//     super.initState();
//     // readMoreVisible = widget.content.length > 1000 ? true : false;
//     _likeProvider = ViewPostLikeProvider(feed: widget.feed);
//     _likeProvider.initialLike();
//   }

//   // void readySwipDownFunc() {
//   //   setState(() {
//   //     _prevPostVisibile = true;
//   //   });
//   //   WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
//   //     _viewPostController.position.jumpTo(200);
//   //   });
//   // }

//   _ViewPostWidgetState() {
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _firstInit = true;
//       print('isClicked: ' + _postsProvider.clickFromPostFeedWidget.toString());
//       _postsProvider.clickFromPostFeedWidget ? _readMoreTap() : null;
//       // if (_postsProvider.clickFromPostFeedWidget) {
//       //   setState(
//       //       () => readMoreVisible = !_postsProvider.clickFromPostFeedWidget);
//       // }

//       // _viewPostController.position.jumpTo(80);

//       _viewPostController.addListener(() {
//         isEnd = (_viewPostController.offset ==
//             _viewPostController.position.maxScrollExtent);
//         isStart = (_viewPostController.offset == 0);

//         if (_viewPostController.position.pixels -
//                 _viewPostController.position.minScrollExtent >=
//             500) {
//           if (readyForSwipeUp == 1) {
//             setState(() => isScroll = false);
//           }
//           if (isScroll == false && readyForSwipeUp != 1) {
//             setState(() => isScroll = true);
//           }
//         } else if (isScroll == true) {
//           setState(() => isScroll = false);
//         }

//         if (_viewPostController.offset == 0) {
//           if (isScroll == true) {
//             setState(() => isScroll = false);
//           }
//         }
//         if (_viewPostController.position.userScrollDirection ==
//             ScrollDirection.forward) {
//           if (readyForSwipeUp == 1) {
//             readyForSwipeUp = 0;
//             setState(() => _nextPostVisibile = false);
//           }

//           // if (_viewPostController.offset == 0) {
//           //   setState(() => readMoreVisible = true);
//           //   // }
//           //   // if (readMoreVisible) {
//           //   //   print('Is START');
//           //   //   readyForSwipeDown++;
//           //   //   print('Ready for Swip Down: ' + readyForSwipeDown.toString());
//           //   //   readyForSwipeDown == 2 ? setState(() => _prevPostVisibile = true): null;
//           //   // }
//           // }
//         }

//         if (isStart) {
//           if (_firstInit) {
//             readyForSwipeDown = 2;
//             _firstInit = false;
//           } else {
//             print('Is Start');
//             readyForSwipeDown++;

//             if (readyForSwipeDown == 1) {
//               print('Ready for Swipe Down to prev post ' +
//                   readyForSwipeDown.toString());
//               setState(() => _prevPostVisibile = true);
//               _viewPostController.animateTo(20,
//                   duration: Duration(milliseconds: 300),
//                   curve: Curves.easeInOutQuint);
//               // readySwipDownFunc();
//             }
//           }
//         }

//         if (isEnd) {
//           print('Is ENd');

//           if (readyForSwipeUp == 0) {
//             _viewPostController.position.animateTo(
//                 _viewPostController.position.maxScrollExtent - 20,
//                 duration: Duration(milliseconds: 300),
//                 curve: Curves.easeInOutQuint);
//             print('Has Jumped');
//           }

//           readyForSwipeUp++;
//           readyForSwipeUp == 1
//               ? setState(() => _nextPostVisibile = true)
//               : null;
//           if (readyForSwipeUp == 1) {
//             setState(() => isScroll = false);

//             print('Ready For Swipe Up: ' + readyForSwipeUp.toString());
//           }
//         }

//         if (_viewPostController.position.userScrollDirection ==
//             ScrollDirection.reverse) {
//           if (_firstInit == true) {
//             setState(() {
//               _prevPostVisibile = false;
//               _firstInit = false;
//             });
//           }

//           if (readyForSwipeDown == 1) {
//             print('Scroll down hide prevPost');
//             readyForSwipeDown = 0;
//             setState(() => _prevPostVisibile = false);
//           }
//         }

//         if (readyForSwipeUp == 2) {
//           _postsProvider.clickFromPostFeedWidget = false;
//           _postsProvider.readMoreVisible = true;

//           _postsProvider.pageController.nextPage(
//               duration: Duration(milliseconds: 400), curve: Curves.easeInOut);
//         }

//         if (readyForSwipeDown == 2 && _postsProvider.currentIndex != 0) {
//           _postsProvider.clickFromPostFeedWidget = false;
//           _postsProvider.readMoreVisible = true;

//           _postsProvider.pageController.previousPage(
//               duration: Duration(milliseconds: 400), curve: Curves.easeInOut);
//           print('Index is: ' + _postsProvider.currentIndex.toString());
//         }
//       });
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final ThemeData _theme = Theme.of(context);

//     if (widget.pageViewType == PageViewType.allPosts) {
//       print('Type of PageView is allpost');
//       _postsProvider = Provider.of<AllPostsView>(context);
//     } else if (widget.pageViewType == PageViewType.profilePosts) {
//       print('Type of PageView is profilePost');
//       _postsProvider = Provider.of<ProfileAllPostsView>(context);
//     }

//     _daysAgo = (DateTime.now().difference(widget.lastUpdated)).inDays;

//     return WillPopScope(
//       onWillPop: () async {
//         if (Navigator.of(context).userGestureInProgress)
//           return false;
//         else
//           return true;
//       },
//       child: ChangeNotifierProvider<ViewPostLikeProvider>.value(
//         value: _likeProvider,
//         child: Stack(children: [
//           Scaffold(
//             backgroundColor: Colors.white,
//             body: DraggableScrollbar.arrows(
//               backgroundColor: Colors.black87,
//               padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
//               heightScrollThumb: widget.content.length > 1000 ? 50 : 0,
//               controller: _viewPostController,
//               child: ListView(
//                 controller: _viewPostController,
//                 padding: EdgeInsets.fromLTRB(10, 10, 10, 65),
//                 physics: AlwaysScrollableScrollPhysics(),
//                 scrollDirection: Axis.vertical,
//                 cacheExtent: 1000,
//                 children: [
//                   Container(
//                     alignment: Alignment.bottomCenter,
//                     height: readMoreVisible ? 0 : 80,
//                     width: MediaQuery.of(context).size.width,
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Text(
//                           'swipe to previous post',
//                           style: TextStyle(color: Colors.black54, fontSize: 11),
//                         ),
//                         SizedBox(height: 5),
//                         Icon(
//                           Icons.arrow_downward_rounded,
//                           color: Colors.black54,
//                           size: 15,
//                         ),
//                         SizedBox(height: 10),
//                       ],
//                     ),
//                   ),
//                   ViewPostTitle(daysAgo: _daysAgo, widget: widget),
//                   Wrap(
//                       runSpacing: 5,
//                       children: widget.tags
//                           .map(
//                             (individualTag) => Padding(
//                               padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
//                               child: FittedBox(
//                                 alignment: Alignment.center,
//                                 child: Container(
//                                   padding: EdgeInsets.fromLTRB(6, 3, 6, 3),
//                                   alignment: Alignment.center,
//                                   decoration: BoxDecoration(
//                                     border: Border.fromBorderSide(BorderSide(
//                                         color: _theme.primaryColor
//                                             .withOpacity(0.7))),

//                                     borderRadius: BorderRadius.circular(5),

//                                     // color: colorScheme[themeIndex]['secondary']

//                                     //     .withOpacity(0.3),
//                                   ),
//                                   child: Text(
//                                     individualTag.toString().contains('#')
//                                         ? individualTag.toString().replaceRange(
//                                             individualTag.toString().length - 2,
//                                             individualTag.toString().length,
//                                             '')
//                                         : '#${individualTag.toString().replaceRange(individualTag.toString().length - 2, individualTag.toString().length, '')}',
//                                     style: TextStyle(
//                                         fontFamily: 'Nunito',
//                                         fontSize: 11,

//                                         // color: Colors.white,

//                                         color: _theme.primaryColor
//                                             .withOpacity(0.7)),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           )
//                           .toList()),
//                   SizedBox(height: 15),
//                   ViewPostContent(
//                     likeProvider: _likeProvider,
//                     content: widget.content,
//                     listMapContent: widget.listMapContent,
//                     readMoreVisible: readMoreVisible,
//                     readMoreTap: _readMoreTap,
//                   ),
//                   ViewPostComments(
//                     widget: widget,
//                     bottomSheetComments: _bottomSheetComments,
//                   ),
//                   AnimatedBuilder(
//                     animation: _viewPostController,
//                     builder: (context, child) => AnimatedContainer(
//                       duration: Duration(milliseconds: 200),
//                       alignment: Alignment.center,
//                       height: _nextPostVisibile ? 60 : 0,
//                       width: MediaQuery.of(context).size.width,
//                       child: Column(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           SizedBox(height: 0),
//                           Icon(
//                             Icons.arrow_upward_rounded,
//                             color: Colors.black54,
//                             size: 15,
//                           ),
//                           SizedBox(height: 5),
//                           Text(
//                             'swipe to next post',
//                             style: TextStyle(
//                               color: Colors.black54,
//                               fontSize: 11,
//                             ),
//                           ),
//                           SizedBox(height: 15),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             floatingActionButton: AnimatedContainer(
//                 duration: Duration(milliseconds: 600),
//                 curve: Curves.easeIn,
//                 child: isScroll
//                     ? FloatingActionButton(
//                         onPressed: () {
//                           _viewPostController.animateTo(0,
//                               duration: Duration(milliseconds: 100),
//                               curve: Curves.linear);
//                         },
//                         elevation: 0.5,
//                         mini: true,
//                         child: Icon(Icons.upgrade_rounded,
//                             color: Colors.black.withOpacity(0.7)),
//                         backgroundColor: Colors.white,
//                       )
//                     : Container(
//                         height: 10,
//                       )),
//             floatingActionButtonLocation:
//                 FloatingActionButtonLocation.centerFloat,
//             bottomNavigationBar: InteractionBar(
//               isLiked: widget.feed.isLiked,
//               bottomSheetComments: _bottomSheetComments,
//             ),
//           ),
//           Positioned(
//               bottom: 0,
//               child: ReadMoreOverlay(
//                 readMoreTap: _readMoreTap,
//                 postsProvider: _postsProvider,
//               ))
//         ]),
//       ),
//     );
//   }

//   Widget _bottomSheetComments({
//     bool isViewOnly,
//   }) {
//     ScrollController _controller = ScrollController();
//     return Container(
//       height: 550,
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.only(
//           topLeft: Radius.circular(20),
//           topRight: Radius.circular(20),
//         ),
//       ),
//       child: Stack(
//         children: [
//           Container(
//             padding: EdgeInsets.fromLTRB(0, 45, 0, 0),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.only(
//                 topLeft: Radius.circular(20),
//                 topRight: Radius.circular(20),
//               ),
//             ),
//             child: ListView.builder(
//               controller: _controller,
//               cacheExtent: 1000,
//               padding: EdgeInsets.fromLTRB(15, 8, 15, 60),
//               itemCount: 20,
//               itemBuilder: (context, index) {
//                 return Comment(
//                   primaryColor: Theme.of(context).primaryColor,
//                   secondaryColor: Colors.pink[200],
//                   comment: ([
//                     'Hello, that\'s an amazing sharing mate! ❤️',
//                     'Wow! Can\'t wait to try it out! 🥳',
//                     'I\'m amazed. Hope you have a great day ahead as well! ❤️',
//                   ]..shuffle())
//                       .first,
//                   user: ([
//                     'wkayi_2000',
//                     'elissa_ann04',
//                     'justin_lau',
//                     'edison_lime',
//                     'zheng_yong_wzy',
//                     'wong_zq',
//                     'andrew_davilla_04'
//                   ]..shuffle())
//                       .first,
//                 );
//               },
//             ),
//           ),
//           Positioned(
//             top: 0,
//             child: Container(
//               padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
//               height: 50,
//               width: MediaQuery.of(context).size.width,
//               alignment: Alignment.center,
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.only(
//                   topLeft: Radius.circular(20),
//                   topRight: Radius.circular(20),
//                 ),
//                 boxShadow: [
//                   BoxShadow(color: Colors.black12, offset: Offset(0, 0.5))
//                 ],
//               ),
//               child: Container(
//                 padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       'All Comments',
//                       style: TextStyle(
//                         fontWeight: FontWeight.w700,
//                         fontSize: 15,
//                       ),
//                     ),
//                     GestureDetector(
//                         onTap: () => Navigator.pop(context),
//                         child: Icon(Icons.keyboard_arrow_down_rounded)),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//           Positioned(bottom: 0, child: UneditableInputComment()),
//         ],
//       ),
//     );
//   }
// }
//
// bottomsheetCOmments
//
//  // Widget _bottomSheetComments({
//   bool isViewOnly,
// }) {
//   ScrollController _controller = ScrollController();
//   return Container(
//     height: 550,
//     decoration: BoxDecoration(
//       color: Colors.white,
//       borderRadius: BorderRadius.only(
//         topLeft: Radius.circular(20),
//         topRight: Radius.circular(20),
//       ),
//     ),
//     child: Stack(
//       children: [
//         Container(
//           padding: EdgeInsets.fromLTRB(0, 45, 0, 0),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.only(
//               topLeft: Radius.circular(20),
//               topRight: Radius.circular(20),
//             ),
//           ),
//           child: ListView.builder(
//             controller: _controller,
//             cacheExtent: 1000,
//             padding: EdgeInsets.fromLTRB(15, 8, 15, 60),
//             itemCount: 20,
//             itemBuilder: (context, index) {
//               return Comment(
//                 primaryColor: Theme.of(context).primaryColor,
//                 secondaryColor: Colors.pink[200],
//                 comment: ([
//                   'Hello, that\'s an amazing sharing mate! ❤️',
//                   'Wow! Can\'t wait to try it out! 🥳',
//                   'I\'m amazed. Hope you have a great day ahead as well! ❤️',
//                 ]..shuffle())
//                     .first,
//                 user: ([
//                   'wkayi_2000',
//                   'elissa_ann04',
//                   'justin_lau',
//                   'edison_lime',
//                   'zheng_yong_wzy',
//                   'wong_zq',
//                   'andrew_davilla_04'
//                 ]..shuffle())
//                     .first,
//               );
//             },
//           ),
//         ),
//         Positioned(
//           top: 0,
//           child: Container(
//             padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
//             height: 50,
//             width: MediaQuery.of(context).size.width,
//             alignment: Alignment.center,
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.only(
//                 topLeft: Radius.circular(20),
//                 topRight: Radius.circular(20),
//               ),
//               boxShadow: [
//                 BoxShadow(color: Colors.black12, offset: Offset(0, 0.5))
//               ],
//             ),
//             child: Container(
//               padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     'All Comments',
//                     style: TextStyle(
//                       fontWeight: FontWeight.w700,
//                       fontSize: 15,
//                     ),
//                   ),
//                   GestureDetector(
//                       onTap: () => Navigator.pop(context),
//                       child: Icon(Icons.keyboard_arrow_down_rounded)),
//                 ],
//               ),
//             ),
//           ),
//         ),
//         Positioned(bottom: 0, child: UneditableInputComment()),
//       ],
//     ),
//   );
// }
