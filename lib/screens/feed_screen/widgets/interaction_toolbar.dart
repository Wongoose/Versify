import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:versify/models/feed_model.dart';
import 'package:versify/providers/view_post_gift_provider.dart';
import 'package:versify/providers/view_post_like_provider.dart';
import 'package:versify/screens/feed_screen/widgets/gift_widget.dart';
import 'package:versify/services/auth.dart';
import 'package:versify/services/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:versify/services/dynamic_links.dart';
import 'package:vibration/vibration.dart';

class InteractionBar extends StatelessWidget {
  final bool isLiked;
  final Feed feed;

  InteractionBar({this.isLiked, this.feed});

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

    // getSavePostLocal(feed.documentID).then((res) {
    //   _likeProvider.initialSave(res);
    // });

    final bool _isVisitProfile = _authService.myUser.userUID != feed.userID;

    return BottomAppBar(
      elevation: 5,
      child: Container(
        height: 55,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(10, 2, 10, 2),
        decoration: BoxDecoration(
          color: Colors.white,
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
                      backgroundColor: Colors.white,
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
                        print('state is in bottomSheet: ' +
                            state.giftLove.toString());
                        return ChangeNotifierProvider<GiftProvider>.value(
                          value: state,
                          child: GiftsBottomSheet(feed: feed),
                        );
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
                    color: Colors.black.withOpacity(0.8),
                    size: 24,
                  ),
                ),
              );
            }),
            Consumer<ViewPostLikeProvider>(
              builder: (context, likeProvider, _) {
                return GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () => {
                    likeProvider.likeTrigger(),
                    // setState(() {
                    //   _likedPost = !_likedPost;
                    // }),
                    Vibration.vibrate(duration: 5),
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
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Padding(
                    padding: EdgeInsets.all(8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                            height: 15,
                            width: 15,
                            child: CircularProgressIndicator(strokeWidth: 0.5)),
                        SizedBox(width: 15),
                        Text(
                          'Preparing shareable link...',
                          style: TextStyle(
                            fontFamily: 'Nunito',
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
                  Share.text(
                      'Versify Blogs',
                      _isVisitProfile
                          ? 'Check out this amazing blog on the Versify app!\n$res'
                          : 'Check out the blog that I wrote on the Versify app!\n$res',
                      'text/txt');
                });
              },
              child: SizedBox(
                height: 40,
                width: 80,
                child: Icon(
                  Icons.near_me_outlined,
                  color: Colors.black.withOpacity(0.8),
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
                        color: Color(0xffff548e),
                        image: 'assets/images/love.png',
                      ),
                      // GiftWidget(
                      //   giftType: GiftType.love,
                      //   text: 'Great love',
                      //   color: Color(0xffff548e),
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
                //         color: Color(0xffff548e),
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
                //         color: Color(0xffff548e),
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
                  color: _loading ? Colors.white : Color(0xffff548e),
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
//Save widget
// Consumer<ViewPostLikeProvider>(builder: (context, state, _) {
//               return GestureDetector(
//                 onTap: () async {
//                   Scaffold.of(context).showSnackBar(SnackBar(
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
