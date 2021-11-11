import "package:cached_network_image/cached_network_image.dart";
import "package:google_fonts/google_fonts.dart";
import "package:shimmer_animation/shimmer_animation.dart";
import "package:versify/models/feed_model.dart";
import "package:versify/providers/providers_feeds/all_posts_provider.dart";
import "package:versify/providers/providers_feeds/feed_type_provider.dart";
import "package:versify/providers/providers_home/theme_data_provider.dart";
import "package:versify/screens/blogs_feed/widgets_feeds/feed_list_wrapper.dart";
import "package:versify/screens/blogs_feed/widgets_feeds/following_page_view.dart";
import "package:versify/screens/blogs_feed/widgets_feeds/for_you_page_view.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:font_awesome_flutter/font_awesome_flutter.dart";
import "package:provider/provider.dart";
import "package:versify/services/others/notification.dart";

class PostFeedWidget extends StatefulWidget {
  final int index;
  final Feed feed;
  final bool isWelcome;
  final bool isGrey;

  const PostFeedWidget({this.index, this.feed, this.isWelcome, this.isGrey});

  @override
  _PostFeedWidgetState createState() => _PostFeedWidgetState();
}

class _PostFeedWidgetState extends State<PostFeedWidget> {
  final List<Map<String, Color>> _colorScheme = [
    {
      //purple
      "primary": Color(0xFFcc99ff),
      "secondary": Color(0xFFefdaff),
    },
    {
      //biege
      "primary": Color(0xFFffcc99),
      "secondary": Color(0xFFffefda),
    },
    {
      //blue
      "primary": Color(0xFF99ccff),
      "secondary": Color(0xFFdaeaff),
    },
  ];

  String _content = "";

  void showVerseDialog({BuildContext context, int colorIndex}) {
    showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Hero(
                  tag: "featuredVerse${widget.index}",
                  child: Container(
                    height: 30,
                    child: FittedBox(
                      child: Container(
                        padding: EdgeInsets.fromLTRB(8, 5, 8, 5),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: _colorScheme[colorIndex]["secondary"],
                        ),
                        child: Text(
                          widget.feed.featuredTopic ?? "Featured",
                          style: TextStyle(
                            fontFamily:
                                GoogleFonts.getFont("Nunito Sans").fontFamily,
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 8),
              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.fromLTRB(3, 2, 0, 0),
                decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(
                        width: 2, color: _colorScheme[colorIndex]["primary"]),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(10, 8, 10, 8),
                  child: Column(
                    children: [
                      Container(
                        constraints:
                            BoxConstraints(maxHeight: 200, minHeight: 0),
                        child: SizedBox(
                          child: SingleChildScrollView(
                            child: Text(
                              widget.feed.featuredValue ?? ". . .",
                              overflow: TextOverflow.fade,
                              style: TextStyle(
                                fontFamily: GoogleFonts.getFont("Philosopher")
                                    .fontFamily,
                                fontSize: 14,
                                height: 1.5,
                                fontWeight: FontWeight.w400,
                                color: Colors.black87,
                                // fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Container(
              //   padding: EdgeInsets.fromLTRB(30, 15, 30, 10),
              //   alignment: Alignment.center,
              //   width: 40,
              //   child: Text(
              //     "If you go back now, you will lose all your writing data.",
              //     textAlign: TextAlign.center,
              //     style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              //   ),
              // ),
              // // Divider(thickness: 0.5, height: 0),
              // Container(
              //   margin: EdgeInsets.all(0),
              //   height: 60,
              //   child: FlatButton(
              //     materialTapTargetSize: MaterialTapTargetSize.padded,
              //     onPressed: () {},
              //     child: Text(
              //       "Discard",
              //       style: TextStyle(
              //         color: Colors.red,
              //         fontSize: 16,
              //         fontWeight: FontWeight.w600,
              //       ),
              //     ),
              //   ),
              // ),
              // Divider(thickness: 0.5, height: 0),
              // Container(
              //   margin: EdgeInsets.all(0),
              //   height: 60,
              //   child: FlatButton(
              //     onPressed: () {
              //       Navigator.pop(context);
              //     },
              //     child: Text(
              //       "Keep",
              //       style: TextStyle(
              //         color: Colors.blue,
              //         fontSize: 16,
              //       ),
              //     ),
              //   ),
              // ),
            ],
          );
        });
  }

  void contentFromMap() {
    //should shift up to listViewBuilder
    print("content From Map Called");

    widget.feed.listMapContent.forEach((mapContent) {
      if (mapContent["type"] == "text") {
        _content += "${mapContent["value"]}\n";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeProvider _themeProvider =
        Provider.of<ThemeProvider>(context, listen: false);
    final FeedTypeProvider _feedTypeProvider =
        Provider.of<FeedTypeProvider>(context, listen: false);
    final FollowingPageView followingPageView =
        Provider.of<FollowingPageView>(context, listen: false);
    final ForYouPageView forYouPageView =
        Provider.of<ForYouPageView>(context, listen: false);
    final AllPostsView allPostView =
        Provider.of<AllPostsView>(context, listen: false);

    contentFromMap();

    final Color newGrey =
        _themeProvider.isDark ? Colors.white12 : Colors.grey[400];

    int _colorIndex = 0;
    if (widget.index > 2) {
      _colorIndex = widget.index % 3;
    } else {
      _colorIndex = widget.index;
    }

    return Padding(
      padding: EdgeInsets.fromLTRB(5, 0, 10, 0),
      child: Column(
        children: [
          SizedBox(
            child: GestureDetector(
              onTap: () {
                if (_feedTypeProvider.currentFeedType == FeedType.forYou) {
                  allPostView.forYouOnClick(widget.index);
                } else {
                  allPostView.followingOnClick(widget.index);
                }
                Navigator.push(
                  context,
                  CupertinoPageRoute(builder: (_) {
                    if (_feedTypeProvider.currentFeedType == FeedType.forYou) {
                      return forYouPageView;
                    } else {
                      return followingPageView;
                    }
                  }),
                );
                if (widget.isWelcome ?? false) {
                  NotificationOverlay().welcomePostNotification();
                }
              },
              child: Shimmer(
                duration: Duration(milliseconds: 1000),
                interval: Duration(milliseconds: 1000),
                color: _themeProvider.isDark ? Colors.white : Colors.pink,
                direction: ShimmerDirection.fromLTRB(),
                enabled: widget.isWelcome,
                child: Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.fromLTRB(3, 0, 0, 0),
                  decoration: BoxDecoration(
                    border: Border(
                      left: BorderSide(
                          width: 2,
                          color: widget.isGrey
                              ? newGrey
                              : _colorScheme[_colorIndex]["primary"]),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(8, 10, 8, 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(1.5),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: LinearGradient(
                                      colors: [
                                        widget.isGrey
                                            ? newGrey
                                            : _colorScheme[_colorIndex]
                                                ["primary"],
                                        widget.isGrey
                                            ? newGrey
                                            : _colorScheme[_colorIndex][
                                                _themeProvider.isDark
                                                    ? "secondary"
                                                    : "primary"],
                                      ],
                                      stops: [0, 0.9],
                                    ),
                                  ),
                                  child: Container(
                                    padding: EdgeInsets.all(1),
                                    height: 32,
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).backgroundColor,
                                      shape: BoxShape.circle,
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(100),
                                      child: CachedNetworkImage(
                                        color: widget.isGrey
                                            ? Theme.of(context).backgroundColor
                                            : null,
                                        colorBlendMode: BlendMode.color,
                                        height: 32,
                                        fit: BoxFit.cover,
                                        useOldImageOnUrlChange: false,
                                        // cacheKey: userProfile.userUID,
                                        imageUrl: widget.feed.profileImageUrl ??
                                            "https://firebasestorage.googleapis.com/v0/b/goconnect-745e7.appspot.com/o/images%2Ffashion.png?alt=media&token=f2e8484d-6874-420c-9401-615063e53b8d",
                                        // progressIndicatorBuilder:
                                        //     (context, url, downloadProgress) {
                                        //   return SizedBox(
                                        //     height: 5,
                                        //     width: 5,
                                        //     child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
                                        //       strokeWidth: 0.5,
                                        //       value: downloadProgress.progress,
                                        //     ),
                                        //   );
                                        // },
                                        errorWidget: (context, url, error) =>
                                            Icon(FontAwesomeIcons.userAltSlash,
                                                size: 5,
                                                color: _themeProvider
                                                    .secondaryTextColor),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10),
                                Container(
                                  child: Text(
                                    widget.feed.username,
                                    style: TextStyle(
                                      color: widget.isGrey
                                          ? newGrey
                                          : _themeProvider.primaryTextColor
                                              .withOpacity(0.87),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: "Nunito",
                                      // letterSpacing: 0.5,
                                    ),
                                  ),
                                )
                              ],
                            ),
                            Container(
                              child: Icon(
                                Icons.verified_user,
                                color: widget.isGrey
                                    ? newGrey
                                    : _colorScheme[_colorIndex]["primary"],
                                size: 15,
                              ),
                            )
                          ],
                        ),
                        // SizedBox(height: 5),
                        SizedBox(height: 15),
                        Padding(
                          padding: EdgeInsets.fromLTRB(2, 0, 0, 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      if (widget.feed.featuredTopic != null) {
                                        showVerseDialog(
                                            context: context,
                                            colorIndex: _colorIndex);
                                      }
                                    },
                                    child: Hero(
                                      tag: "featuredVerse${widget.index}",
                                      child: Shimmer(
                                        duration: Duration(milliseconds: 500),
                                        interval: Duration(milliseconds: 500),
                                        color: _themeProvider.isDark
                                            ? Colors.white
                                            : Colors.pink,
                                        enabled: widget.isWelcome,
                                        direction: ShimmerDirection.fromLTRB(),
                                        child: FittedBox(
                                          alignment: Alignment.center,
                                          child: Container(
                                            padding:
                                                EdgeInsets.fromLTRB(8, 5, 8, 5),
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              color: widget.isGrey || widget.isWelcome
                                                  ? Colors.transparent
                                                  : _colorScheme[_colorIndex]
                                                      ["secondary"],
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              border: Border.all(
                                                // color: _theme.primaryColor,
                                                color: widget.isGrey
                                                    ? newGrey
                                                    : _colorScheme[_colorIndex][
                                                        widget.isWelcome
                                                            ? "primary"
                                                            : "secondary"],
                                              ),
                                            ),
                                            child: Text(
                                              widget.feed.featuredTopic ??
                                                  "Blog singles",
                                              style: TextStyle(
                                                fontFamily: GoogleFonts.getFont(
                                                        "Nunito Sans")
                                                    .fontFamily,
                                                fontSize: 13,
                                                fontWeight: FontWeight.w400,
                                                color: widget.isGrey
                                                    ? newGrey
                                                    : widget.isWelcome
                                                        ? _colorScheme[
                                                                _colorIndex]
                                                            ["primary"]
                                                        : Colors.black
                                                            .withOpacity(0.8),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: SizedBox(
                                      child: Text(
                                        widget.feed.featuredValue ?? ". . .",
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontFamily:
                                              GoogleFonts.getFont("Nunito Sans")
                                                  .fontFamily,
                                          fontSize: 12,
                                          fontWeight: FontWeight.normal,
                                          color: _themeProvider.primaryTextColor
                                              .withOpacity(0.26),
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(height: 10),
                              Padding(
                                padding: EdgeInsets.all(2.0),
                                child: Text(
                                  widget.feed.title,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: widget.isGrey
                                        ? newGrey
                                        : _themeProvider.primaryTextColor,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: "Nunito",
                                    fontSize: 18,
                                    letterSpacing: -0.3,
                                  ),
                                ),
                              ),
                              SizedBox(height: 3),
                              Padding(
                                padding: EdgeInsets.all(2.0),
                                child: Text(
                                  _content.replaceAll("\n", " . "),
                                  style: TextStyle(
                                    fontFamily:
                                        GoogleFonts.getFont("Nunito Sans")
                                            .fontFamily,
                                    color: widget.isGrey
                                        ? newGrey
                                        : _themeProvider.primaryTextColor,
                                    fontSize: 13,
                                    height: 1.4,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  maxLines: 3,
                                  overflow: TextOverflow.fade,
                                ),
                              ),
                              SizedBox(height: 2),
                              Padding(
                                padding: EdgeInsets.all(2.0),
                                child: Text(
                                  "Read more...",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w200,
                                    fontSize: 12,
                                    color: widget.isGrey
                                        ? newGrey
                                        : _colorScheme[_colorIndex][
                                            _themeProvider.isDark
                                                ? "secondary"
                                                : "primary"],
                                  ),
                                ),
                              ),
                              // SizedBox(height: feed.tags.isEmpty ? 0 : 10),
                              // Wrap(
                              //     runSpacing: 5,
                              //     children: feed.tags
                              //         .map(
                              //           (individualTag) => Padding(
                              //             padding:
                              //                 EdgeInsets.fromLTRB(0, 0, 5, 0),
                              //             child: FittedBox(
                              //               alignment: Alignment.center,
                              //               child: Container(
                              //                 padding:
                              //                     EdgeInsets.fromLTRB(6, 3, 6, 3),
                              //                 alignment: Alignment.center,
                              //                 decoration: BoxDecoration(
                              //                   border: Border.fromBorderSide(
                              //                       BorderSide(
                              //                           color: _colorScheme[
                              //                                       _colorIndex]
                              //                                   ["secondary"]
                              //                               .withOpacity(0.7))),
                              //                   borderRadius:
                              //                       BorderRadius.circular(5),
                              //                   // color: _colorScheme[_colorIndex]["secondary"]
                              //                   //     .withOpacity(0.3),
                              //                 ),
                              //                 child: Text(
                              //                   individualTag
                              //                           .toString()
                              //                           .contains("#")
                              //                       ? individualTag
                              //                           .toString()
                              //                           .replaceRange(
                              //                               individualTag
                              //                                       .toString()
                              //                                       .length -
                              //                                   2,
                              //                               individualTag
                              //                                   .toString()
                              //                                   .length,
                              //                               "")
                              //                       : "#${individualTag.toString().replaceRange(individualTag.toString().length - 2, individualTag.toString().length, "")}",
                              //                   style: TextStyle(
                              //                       fontFamily: GoogleFonts.getFont("Nunito Sans").fontFamily,
                              //                       fontSize: 11,
                              //                       // color: Colors.white,
                              //                       color:
                              //                           _colorScheme[_colorIndex]
                              //                                   ["secondary"]
                              //                               .withOpacity(0.7)),
                              //                 ),
                              //               ),
                              //             ),
                              //           ),
                              //         )
                              //         .toList()),
                            ],
                          ),
                        ),

                        SizedBox(height: 1),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
