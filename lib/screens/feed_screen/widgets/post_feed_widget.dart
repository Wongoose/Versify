import 'package:cached_network_image/cached_network_image.dart';
import 'package:versify/models/feed_model.dart';
import 'package:versify/providers/all_posts_provider.dart';
import 'package:versify/providers/feed_type_provider.dart';
import 'package:versify/screens/feed_screen/feed_list_wrapper.dart';
import 'package:versify/screens/feed_screen/following_page_view.dart';
import 'package:versify/screens/feed_screen/for_you_page_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class PostFeedWidget extends StatelessWidget {
  final int index;
  final Feed feed;

  PostFeedWidget({this.index, this.feed});

  final List<Map<String, Color>> _colorScheme = [
    {
      //red
      'primary': Color(0xffff548e),
      'secondary': Color(0xffff548e),
    },
    {
      //orange
      'primary': Colors.amber[700],
      'secondary': Colors.amber[700],
    },
    {
      //green
      'primary': Colors.teal[300],
      'secondary': Colors.teal[300],
    },
    {
      //blue
      'primary': Colors.blueAccent,
      'secondary': Colors.blueAccent,
    },
    {
      //purple
      'primary': Colors.deepPurpleAccent,
      'secondary': Colors.deepPurpleAccent,
    },
  ];
  String _content = '';
  // final _colorScheme = [
  //   {
  //     //red
  //     'primary': Colors.pink,
  //     'secondary': Color(0xffff548e),
  //   },
  //   {
  //     //orange
  //     'primary': Colors.amber[800],
  //     'secondary': Colors.orange[400],
  //   },
  //   {
  //     //green
  //     'primary': Colors.teal[400],
  //     'secondary': Colors.teal[300],
  //   },
  //   {
  //     //blue
  //     'primary': Colors.blue,
  //     'secondary': Colors.blueAccent,
  //   },
  //   {
  //     //purple
  //     'primary': Colors.purple[700],
  //     'secondary': Colors.deepPurpleAccent,
  //   },
  // ];
  //

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
                  tag: 'featuredVerse$index',
                  child: Container(
                    height: 30,
                    child: FittedBox(
                      alignment: Alignment.center,
                      child: Container(
                        padding: EdgeInsets.fromLTRB(8, 5, 8, 5),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: _colorScheme[colorIndex]['secondary'],
                        ),
                        child: Text(
                          feed.featuredTopic ?? 'Featured',
                          style: TextStyle(
                            fontFamily: 'Nunito',
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Color(0xfffffcfe),
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
                        width: 2, color: _colorScheme[colorIndex]['primary']),
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
                              feed.featuredValue ?? '. . .',
                              overflow: TextOverflow.fade,
                              maxLines: null,
                              style: TextStyle(
                                fontFamily: 'Nunito',
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                                color: Colors.black87,
                                fontStyle: FontStyle.italic,
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
              //     'If you go back now, you will lose all your writing data.',
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
              //       'Discard',
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
              //       'Keep',
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
    print('content From Map Called');

    feed.listMapContent.forEach((mapContent) {
      // print(mapContent);
      switch (mapContent['type']) {
        case 'quote':
          break;
        case 'text':
          // print(mapContent['value'].toString());
          _content += mapContent['value'].toString() + '\n';
          break;
        case '':
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    FeedTypeProvider _feedTypeProvider =
        Provider.of<FeedTypeProvider>(context, listen: false);
    FollowingPageView followingPageView =
        Provider.of<FollowingPageView>(context, listen: false);
    ForYouPageView forYouPageView =
        Provider.of<ForYouPageView>(context, listen: false);
    AllPostsView allPostView =
        Provider.of<AllPostsView>(context, listen: false);

    contentFromMap();

    print('New feed widget built!');
    int _colorIndex = 1;
    if (index > 4) {
      _colorIndex = index % 5;
    } else {
      _colorIndex = index;
    }

    return Padding(
      padding: EdgeInsets.fromLTRB(5, 8, 8, 5),
      child: Column(
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
                          _colorScheme[_colorIndex]['primary'],
                          _colorScheme[_colorIndex]['secondary'],
                        ],
                        stops: [0, 0.6],
                      ),
                    ),
                    child: Container(
                      padding: EdgeInsets.all(1),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      height: 32,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: CachedNetworkImage(
                          height: 32,
                          fit: BoxFit.cover,
                          useOldImageOnUrlChange: false,
                          // cacheKey: userProfile.userUID,
                          imageUrl: feed.profileImageUrl ??
                              'https://firebasestorage.googleapis.com/v0/b/goconnect-745e7.appspot.com/o/images%2Ffashion.png?alt=media&token=f2e8484d-6874-420c-9401-615063e53b8d',
                          progressIndicatorBuilder:
                              (context, url, downloadProgress) {
                            return SizedBox(
                              height: 5,
                              width: 5,
                              child: CircularProgressIndicator(
                                strokeWidth: 0.5,
                                value: downloadProgress.progress,
                              ),
                            );
                          },
                          errorWidget: (context, url, error) =>
                              Icon(FontAwesomeIcons.userAltSlash, size: 10),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Container(
                    child: Text(
                      feed.username,
                      style: TextStyle(
                        color: _colorScheme[_colorIndex]['primary'],
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Nunito',
                        letterSpacing: 0,
                      ),
                    ),
                  )
                ],
              ),
              Container(
                child: Icon(
                  Icons.verified_user,
                  color: _colorScheme[_colorIndex]['primary'],
                  size: 15,
                ),
              )
            ],
          ),
          SizedBox(height: 5),
          SizedBox(
            child: GestureDetector(
              onTap: () {
                if (_feedTypeProvider.currentFeedType == FeedType.forYou) {
                  allPostView.forYouOnClick(index);
                } else {
                  allPostView.followingOnClick(index);
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
              },
              child: Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.fromLTRB(3, 2, 0, 0),
                decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(
                        width: 2, color: _colorScheme[_colorIndex]['primary']),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: 5),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          GestureDetector(
                            onTap: () {
                              if (feed.featuredTopic != null) {
                                showVerseDialog(
                                    context: context, colorIndex: _colorIndex);
                              }
                            },
                            child: Hero(
                              tag: 'featuredVerse$index',
                              child: FittedBox(
                                alignment: Alignment.center,
                                child: Container(
                                  padding: EdgeInsets.fromLTRB(8, 5, 8, 5),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: _colorScheme[_colorIndex]
                                        ['secondary'],
                                  ),
                                  child: Text(
                                    feed.featuredTopic ?? 'Blog singles',
                                    style: TextStyle(
                                      fontFamily: 'Nunito',
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xfffffcfe),
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
                                feed.featuredValue ?? '. . .',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontFamily: 'Nunito',
                                  fontSize: 12,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black26,
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
                          feed.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Nunito',
                            fontSize: 17.5,
                            letterSpacing: -0.3,
                          ),
                        ),
                      ),
                      SizedBox(height: 0),
                      Padding(
                        padding: EdgeInsets.all(2.0),
                        child: Text(
                          _content.replaceAll('\n', ' . '),
                          style: TextStyle(
                            fontFamily: 'Nunito',
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
                          'Read more...',
                          style: TextStyle(
                            fontWeight: FontWeight.w200,
                            fontSize: 12,
                            color: _colorScheme[_colorIndex]['secondary'],
                          ),
                        ),
                      ),
                      SizedBox(height: feed.tags.isEmpty ? 0 : 10),
                      Wrap(
                          runSpacing: 5,
                          children: feed.tags
                              .map(
                                (individualTag) => Padding(
                                  padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
                                  child: FittedBox(
                                    alignment: Alignment.center,
                                    child: Container(
                                      padding: EdgeInsets.fromLTRB(6, 3, 6, 3),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        border: Border.fromBorderSide(
                                            BorderSide(
                                                color: _colorScheme[_colorIndex]
                                                        ['secondary']
                                                    .withOpacity(0.7))),
                                        borderRadius: BorderRadius.circular(5),
                                        // color: _colorScheme[_colorIndex]['secondary']
                                        //     .withOpacity(0.3),
                                      ),
                                      child: Text(
                                        individualTag.toString().contains('#')
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
                                            fontFamily: 'Nunito',
                                            fontSize: 11,
                                            // color: Colors.white,
                                            color: _colorScheme[_colorIndex]
                                                    ['secondary']
                                                .withOpacity(0.7)),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                              .toList()),
                      SizedBox(height: 1),
                    ],
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
