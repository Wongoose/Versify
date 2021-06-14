import 'package:versify/models/feed_model.dart';
import 'package:versify/providers/feeds/all_posts_provider.dart';
import 'package:versify/screens/feed_screen/for_you_page_view.dart';
import 'package:versify/screens/profile_screen/profile_page_view.dart';
import 'package:versify/screens/profile_screen/profile_pageview_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileFeedWidget extends StatelessWidget {
  final int index;
  final Feed feed;

  ProfileFeedWidget({this.index, this.feed});

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
      'primary': Color(0xFFFF696A),
      'secondary': Color(0xFFFF696A),
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

  String _content = '';

  void contentFromMap() {
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
    ProfilePageView pageView =
        Provider.of<ProfilePageView>(context, listen: false);
    ProfileAllPostsView _profileAllPostsView =
        Provider.of<ProfileAllPostsView>(context, listen: false);

    print('New feed widget built!');
    int _colorIndex = 2;
    // if (index > 4) {
    //   _colorIndex = index % 5;
    // } else {
    //   _colorIndex = index;
    // }

    contentFromMap();

    return Padding(
      padding: EdgeInsets.fromLTRB(5, 0, 8, 0),
      child: Column(
        children: [
          SizedBox(
            child: GestureDetector(
              onTap: () => {
                _profileAllPostsView.onClick(index),
                Navigator.push(
                  context,
                  CupertinoPageRoute(builder: (_) {
                    return pageView;
                  }),
                ),
              },
              child: Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.fromLTRB(3, 0, 0, 0),
                padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
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
                            onTap: () {},
                            child: FittedBox(
                              alignment: Alignment.center,
                              child: Container(
                                padding: EdgeInsets.fromLTRB(8, 5, 8, 5),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: _colorScheme[_colorIndex]['secondary'],
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
