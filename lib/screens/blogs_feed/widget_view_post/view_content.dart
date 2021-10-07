import 'package:versify/models/feed_model.dart';
import 'package:versify/providers/providers_feeds/view_post_like_provider.dart';
import 'package:versify/providers/providers_home/theme_data_provider.dart';
import 'package:versify/screens/blogs_feed/widget_view_post/view_normal_text.dart';
import 'package:versify/screens/blogs_feed/widget_view_post/view_quote_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';
import 'package:versify/services/firebase/auth.dart';
import 'package:versify/services/firebase/database.dart';
import 'package:versify/services/others/notification.dart';
import 'package:vibration/vibration.dart';

class ViewPostContent extends StatelessWidget {
  final ViewPostLikeProvider likeProvider;
  final Feed feed;
  final String content;
  final List listMapContent;
  final bool readMoreVisible;
  final bool fromDynamicLink;

  const ViewPostContent(
      {@required this.likeProvider,
      @required this.content,
      @required this.listMapContent,
      @required this.readMoreVisible,
      this.feed,
      this.fromDynamicLink});

  @override
  Widget build(BuildContext context) {
    final ThemeData _theme = Theme.of(context);
    final ThemeProvider _themeProvider =
        Provider.of<ThemeProvider>(context, listen: false);
    final DatabaseService _databaseService =
        Provider.of<DatabaseService>(context);
    final AuthService _authService = Provider.of<AuthService>(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Read',
          softWrap: true,
          style: TextStyle(
            color: _theme.primaryColor,
            letterSpacing: 0,
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 2),
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          onDoubleTap: () {
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
              if (fromDynamicLink && !likeProvider.isLiked) {
                //call doubleTap() only after check not liked
                likeProvider.doubleTap();
                _databaseService.updateFeedDynamicPost(feed: feed);
              } else {
                likeProvider.doubleTap();
              }
              Vibration.vibrate(duration: 5);
            }
          },
          child: listMapContent.isNotEmpty
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: listMapContent
                      .map((mapContent) {
                        switch (mapContent['type']) {
                          case 'quote':
                            return ViewPostQuote(
                              topic: mapContent['topic'] ?? 'Quote',
                              value: mapContent['value'] ?? '',
                            );
                            break;
                          case 'text':
                            return ViewPostText(
                              isFirst: listMapContent.indexOf(mapContent) == 0,
                              value: mapContent['value'] ?? '',
                            );
                            break;
                          case '':
                            break;
                        }
                      })
                      .toList()
                      .cast<Widget>())
              : Container(
                  margin: EdgeInsets.fromLTRB(0, 2, 26, 2),
                  decoration: BoxDecoration(
                    border: Border(
                      left: BorderSide(
                          width: 2, color: Theme.of(context).primaryColor),
                    ),
                  ),
                  padding: EdgeInsets.fromLTRB(8, 0, 0, 2),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: 2),
                      Text(
                        content,
                        // maxLines: readMoreVisible ? 25 : null,
                        style: TextStyle(
                          fontSize: 15.5,
                          height: 1.5,
                          color: _themeProvider.primaryTextColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 10),
                      // Image(
                      //   height: 100,
                      //   image: AssetImage('assets/images/love.png'),
                      // ),
                      // SizedBox(height: 10),
                    ],
                  )),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(1, 10, 0, 10),
          child: feed.isHideInteraction == null
              ? Text(
                  'Likes, views, and shares are hidden in this post.',
                  style: TextStyle(
                    fontSize: 11,
                    color: _themeProvider.secondaryTextColor,
                  ),
                )
              : feed.isHideInteraction
                  ? Text(
                      'Likes, views, and shares are hidden in this post.',
                      style: TextStyle(
                        fontSize: 11,
                        color: _themeProvider.secondaryTextColor,
                      ),
                    )
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
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
                                height: 30,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      feed.numberOfLikes.toString(),
                                      style: TextStyle(
                                          fontSize: 11,
                                          color:
                                              _themeProvider.primaryTextColor),
                                    ),
                                    SizedBox(width: 3),
                                    Icon(
                                      likeProvider.isLiked
                                          ? AntDesign.heart
                                          : AntDesign.hearto,
                                      color: Colors.red,
                                      size: 16,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                        SizedBox(width: 20),
                        Container(
                          height: 30,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                feed.numberOfViews.toString(),
                                style: TextStyle(
                                    fontSize: 11,
                                    color: _themeProvider.primaryTextColor),
                              ),
                              SizedBox(width: 3),
                              Icon(
                                AntDesign.eyeo,
                                color: _themeProvider.primaryTextColor
                                    .withOpacity(0.8),
                                size: 20,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 20),
                        GestureDetector(
                          onTap: () => {},
                          child: Container(
                            height: 30,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  '3',
                                  style: TextStyle(
                                      fontSize: 11,
                                      color: _themeProvider.primaryTextColor),
                                ),
                                SizedBox(width: 3),
                                Icon(
                                  Icons.near_me_outlined,
                                  color: _themeProvider.primaryTextColor
                                      .withOpacity(0.8),
                                  size: 20,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
        )
      ],
    );
  }
}
