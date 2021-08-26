import 'package:share/share.dart';
import 'package:versify/models/feed_model.dart';
import 'package:versify/providers/feeds/all_posts_provider.dart';
import 'package:versify/providers/feeds/view_post_gift_provider.dart';
import 'package:versify/providers/feeds/view_post_like_provider.dart';
import 'package:versify/providers/home/theme_data_provider.dart';
import 'package:versify/screens/feed_screen/widget_view_post/gift_widget.dart';
import 'package:versify/services/auth.dart';
import 'package:versify/services/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:versify/services/dynamic_links.dart';
import 'package:versify/services/notification.dart';
import 'package:vibration/vibration.dart';

class InteractionBar extends StatelessWidget {
  final bool isLiked;
  final Feed feed;
  final bool fromDynamicLink;

  InteractionBar({this.isLiked, this.feed, this.fromDynamicLink});

  Future<void> updateSavePostLocal(String postID, {bool saved}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> _savedPostIDs = prefs.getStringList('savedPostIDs') ?? [];

    _savedPostIDs.insert(0, postID);

    prefs.setStringList('savedPostIDs', _savedPostIDs);
  }

  Future<bool> getSavePostLocal(String postID) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> _savedPostIDs = prefs.getStringList('savedPostIDs') ?? [];

    if (_savedPostIDs.contains(postID)) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    // final GiftProvider _giftProvider =
    //     Provider.of<GiftProvider>(context, listen: true);
    final AuthService _authService = Provider.of<AuthService>(context);

    final ViewPostLikeProvider _likeProvider =
        Provider.of<ViewPostLikeProvider>(context, listen: false);
    final ThemeProvider _themeProvider =
        Provider.of<ThemeProvider>(context, listen: false);

    final DatabaseService _databaseService =
        Provider.of<DatabaseService>(context);
    final AllPostsView _allPostsViewProvider =
        Provider.of<AllPostsView>(context, listen: false);

    // getSavePostLocal(feed.documentID).then((res) {
    //   _likeProvider.initialSave(res);
    // });

    final bool _isVisitProfile = _authService.myUser.userUID != feed.userID;

    return BottomAppBar(
      elevation: 5,
      color: Theme.of(context).backgroundColor,
      child: Container(
        height: 55,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(10, 2, 10, 2),
        decoration: BoxDecoration(
          color: Theme.of(context).backgroundColor,
          // boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 15)],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.min,
          children: [
            // GestureDetector(
            //   onTap: () => {
            //     showModalBottomSheet(
            //         backgroundColor: Colors.white,
            //         shape: RoundedRectangleBorder(
            //           borderRadius: BorderRadius.only(
            //             topLeft: Radius.circular(20),
            //             topRight: Radius.circular(20),
            //           ),
            //         ),
            //         isScrollControlled: true,
            //         context: context,
            //         builder: (context) {
            //           return bottomSheetComments(
            //             isViewOnly: true,
            //           );
            //         }),
            //     // Navigator.push(
            //     //     context,
            //     //     MaterialPageRoute(
            //     //       builder: (context) => AllComments(isViewOnly: true),
            //     //     ))
            //   },
            //   child: Container(
            //     height: 40,
            //     width: 80,
            //     child: Icon(
            //       CupertinoIcons.chat_bubble,
            //       color: Colors.black87,
            //       size: 30,
            //     ),
            //   ),
            // ),
            Consumer<GiftProvider>(builder: (context, state, _) {
              return GestureDetector(
                onTap: () => {
                  showModalBottomSheet(
                      backgroundColor: Theme.of(context).backgroundColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                      isScrollControlled: false,
                      enableDrag: false,
                      context: context,
                      builder: (context) {
                        return GiftComingSoon();

                        // return ChangeNotifierProvider<GiftProvider>.value(
                        //   value: state,
                        //   child: GiftsBottomSheet(feed: feed),
                        // );
                      }),
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //       builder: (context) => AllComments(isViewOnly: true),
                  //     ))
                },
                child: Container(
                  height: 40,
                  width: 80,
                  child: Icon(
                    AntDesign.gift,
                    color: _themeProvider.primaryTextColor.withOpacity(0.8),
                    size: 24,
                  ),
                ),
              );
            }),
            Consumer<ViewPostLikeProvider>(
              builder: (context, likeProvider, _) {
                return GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    if (_authService.isUserAnonymous) {
                      NotificationOverlay().showNormalImageDialog(context,
                          body:
                              'Did you enjoy reading this post? Sign up now to like this post!',
                          buttonText: 'Sign-up',
                          clickFunc: null,
                          imagePath: 'assets/images/user.png',
                          title: 'Create Account',
                          delay: Duration(milliseconds: 0));
                    } else {
                      likeProvider.likeTrigger();
                      Vibration.vibrate(duration: 5);
                      if (fromDynamicLink) {
                        _databaseService.updateFeedDynamicPost(feed: feed);
                      }
                    }
                  },
                  child: SizedBox(
                    height: 40,
                    width: 80,
                    child: Icon(
                      likeProvider.isLiked ? AntDesign.heart : AntDesign.hearto,
                      color: Colors.red,
                      size: 23,
                    ),
                  ),
                );
              },
            ),
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                if (feed.isDisableSharing == null) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    backgroundColor: Theme.of(context).dialogBackgroundColor,
                    content: Padding(
                      padding: EdgeInsets.all(8),
                      child: Text(
                        'Oops! Action too quick. Please try again.',
                        style: TextStyle(
                          fontFamily: 'Nunito',
                          color: _themeProvider.primaryTextColor,
                        ),
                      ),
                    ),
                  ));
                } else if (feed.isDisableSharing) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    backgroundColor: Theme.of(context).dialogBackgroundColor,
                    content: Padding(
                      padding: EdgeInsets.all(8),
                      child: Text(
                        'Sharing is disabled for this post',
                        style: TextStyle(
                          fontFamily: 'Nunito',
                          color: _themeProvider.primaryTextColor,
                        ),
                      ),
                    ),
                  ));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    backgroundColor: Theme.of(context).dialogBackgroundColor,
                    content: Padding(
                      padding: EdgeInsets.all(8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                              height: 15,
                              width: 15,
                              child: CircularProgressIndicator(
                                  valueColor: new AlwaysStoppedAnimation<Color>(
                                      Theme.of(context).primaryColor),
                                  strokeWidth: 0.5)),
                          SizedBox(width: 15),
                          Text(
                            'Preparing shareable link...',
                            style: TextStyle(
                              fontFamily: 'Nunito',
                              color: _themeProvider.primaryTextColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    behavior: SnackBarBehavior.fixed,
                  ));
                  DynamicLinkService()
                      .createPostDynamicLink(feed.documentID)
                      .then((res) async {
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    Share.share(
                      _isVisitProfile
                          ? 'I have been using Versify for awhile now. Come and check out this amazing blog post on the Versify app!\n\nBlog link:\n$res'
                          : 'I am a writer at Versify! Read one of my blogs on the Versify app!\n\nBlog link:\n$res',
                      subject: 'Check out this blogs on the Versify App!',
                    );
                  });
                }
              },
              child: SizedBox(
                height: 40,
                width: 80,
                child: Icon(
                  feed.isDisableSharing == null
                      ? Icons.near_me_outlined
                      : feed.isDisableSharing
                          ? Icons.near_me_disabled_outlined
                          : Icons.near_me_outlined,
                  color: _themeProvider.primaryTextColor.withOpacity(0.8),
                  size: 28,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GiftsBottomSheet extends StatefulWidget {
  // final GiftProvider giftProvider;

  const GiftsBottomSheet({
    Key key,
    @required this.feed,
    // this.giftProvider,
  }) : super(key: key);

  final Feed feed;

  @override
  _GiftsBottomSheetState createState() => _GiftsBottomSheetState();
}

class _GiftsBottomSheetState extends State<GiftsBottomSheet> {
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    final GiftProvider _giftProvider =
        Provider.of<GiftProvider>(context, listen: true);

    return Container(
      height: 420,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(0, 45, 0, 0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                Expanded(child: Container()),
                Padding(
                  padding: EdgeInsets.fromLTRB(10, 10, 0, 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GiftWidget(
                        giftType: GiftType.love,
                        text: 'Great love',
                        color: Theme.of(context).primaryColor,
                        image: 'assets/images/love.png',
                      ),
                      // GiftWidget(
                      //   giftType: GiftType.love,
                      //   text: 'Great love',
                      //   color: Theme.of(context).primaryColor,
                      //   image: 'assets/images/love.png',
                      // ),
                      GiftWidget(
                        giftType: GiftType.bird,
                        text: 'Soaring bird',
                        color: Colors.amber[700],
                        image: 'assets/images/bird.png',
                      ),
                    ],
                  ),
                ),
                // Padding(
                //   padding:
                //       EdgeInsets.fromLTRB(10, 10, 0, 10),
                //   child: Row(
                //     mainAxisAlignment:
                //         MainAxisAlignment.spaceAround,
                //     children: [
                //       GiftWidget(
                //         giftType: GiftType.love,
                //         text: 'Great love',
                //         color: Theme.of(context).primaryColor,
                //         image: 'assets/images/love.png',
                //       ),
                //       GiftWidget(
                //         giftType: GiftType.bird,
                //         text: 'Soaring bird',
                //         color: Colors.amber[700],
                //         image: 'assets/images/bird.png',
                //       ),
                //       GiftWidget(
                //         giftType: GiftType.love,
                //         text: 'Great love',
                //         color: Theme.of(context).primaryColor,
                //         image: 'assets/images/love.png',
                //       ),
                //     ],
                //   ),
                // ),
                Expanded(child: Container()),
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        FontAwesomeIcons.coins,
                        size: 13,
                        color: Colors.amber,
                      ),
                      SizedBox(width: 5),
                      Text(
                        'Total gift value: ',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        _giftProvider.totalGiftValue.toString(),
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Divider(thickness: 0.5, height: 0),
                Container(
                  margin: EdgeInsets.all(0),
                  width: MediaQuery.of(context).size.width,
                  height: 60,
                  color:
                      _loading ? Colors.white : Theme.of(context).primaryColor,
                  child: FlatButton(
                    materialTapTargetSize: MaterialTapTargetSize.padded,
                    onPressed: () {
                      setState(() => _loading = true);
                      DatabaseService()
                          .giftFeed(
                        postID: widget.feed.documentID,
                        giftLove: _giftProvider.giftLove,
                        giftBird: _giftProvider.giftBird,
                      )
                          .then((_) {
                        _giftProvider.confirmGifts(widget.feed);
                        Navigator.pop(context);
                        // setState(() => _loading = false);
                      });
                    },
                    child: Visibility(
                      visible: !_loading,
                      child: Text(
                        'Gift',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      replacement: SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          valueColor: new AlwaysStoppedAnimation<Color>(
                              Theme.of(context).primaryColor),
                          strokeWidth: 1,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 0,
            child: Container(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
              height: 50,
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(color: Colors.black12, offset: Offset(0, 0.5))
                ],
              ),
              child: Container(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Gifting',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),
                    GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Icon(Icons.keyboard_arrow_down_rounded)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class GiftComingSoon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ThemeProvider _themeProvider =
        Provider.of<ThemeProvider>(context, listen: false);

    return Column(children: [
      Expanded(child: Container()),
      Image.asset(
        'assets/images/copywriting.png',
        height: 120,
        width: 120,
      ),
      SizedBox(height: 40),
      SizedBox(
        width: 260,
        child: RichText(
          maxLines: 2,
          textAlign: TextAlign.center,
          text: TextSpan(children: [
            TextSpan(
              text: 'Gift',
              style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 35,
                  fontFamily: 'Nunito',
                  fontWeight: FontWeight.w600,
                  height: 1.1),
            ),
            TextSpan(
              text: ' feature',
              style: TextStyle(
                  color: _themeProvider.primaryTextColor,
                  fontSize: 35,
                  fontFamily: 'Nunito',
                  fontWeight: FontWeight.w600,
                  height: 1.1),
            )
          ]),
        ),
      ),
      SizedBox(height: 30),
      SizedBox(
        width: 280,
        child: Text(
          'New feature coming soon! Stay tuned.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: _themeProvider.secondaryTextColor,
          ),
        ),
      ),
      Expanded(flex: 1, child: Container()),
      Container(
        margin: EdgeInsets.all(0),
        width: MediaQuery.of(context).size.width,
        height: 60,
        color: Colors.transparent,
        child: FlatButton(
          materialTapTargetSize: MaterialTapTargetSize.padded,
          color: Theme.of(context).backgroundColor,
          splashColor: Theme.of(context).backgroundColor,
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            'Close',
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    ]);
  }
}
//Save widget
// Consumer<ViewPostLikeProvider>(builder: (context, state, _) {
//               return GestureDetector(
//                 onTap: () async {
//                   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                     duration: Duration(milliseconds: 1000),
//                     padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
//                     content: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(
//                           state.isSaved
//                               ? 'Unsaved post'
//                               : 'Saved to read later.',
//                           style: TextStyle(
//                             fontFamily: 'Nunito',
//                             fontWeight: FontWeight.w400,
//                           ),
//                         ),
//                         Text(
//                           state.isSaved ? 'undo' : 'change',
//                           style: TextStyle(
//                             fontFamily: 'Nunito',
//                             color: Colors.blue,
//                             fontWeight: FontWeight.w400,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ));
//                   state.updateSave(!state.isSaved);

//                   await updateSavePostLocal(feed.documentID,
//                       saved: state.isSaved);
//                 },
//                 child: Container(
//                   height: 40,
//                   width: 80,
//                   child: Icon(
//                     state.isSaved
//                         ? Icons.bookmark_rounded
//                         : Icons.bookmark_outline_rounded,
//                     // CupertinoIcons.bookmark,
//                     color: Colors.black87,
//                     size: 27,
//                   ),
//                   //  Image(
//                   //   image:

//                   //   AssetImage(
//                   //     'assets/socialIcons/png/010-star.png',
//                   //   ),
//                   //   color: Colors.black87,
//                   //   height: 20,
//                   //   width: 20,
//                   // ),
//                 ),
//               );
//             }),
