import 'package:cached_network_image/cached_network_image.dart';
import 'package:versify/models/content_widget.dart';
import 'package:versify/models/feed_model.dart';
import 'package:versify/providers/content_body_provider.dart';
import 'package:versify/screens/feed_screen/create_post_sub/review_post_provider.dart';
import 'package:versify/screens/feed_screen/create_post_sub/widgets/feature_quote.dart';
import 'package:versify/screens/feed_screen/create_post_sub/widgets/quote_text.dart';
import 'package:versify/services/auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class ReviewFeedWidget extends StatefulWidget {
  final int index;
  final Feed feed;
  final String content;
  final ContentBodyProvider contentBodyProvider;

  ReviewFeedWidget(
      {this.index, this.feed, this.content, this.contentBodyProvider});

  @override
  _ReviewFeedWidgetState createState() => _ReviewFeedWidgetState();
}

class _ReviewFeedWidgetState extends State<ReviewFeedWidget> {
  String _featuredTopic;
  String _featuredValue;

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
  ReviewPostProvider _reviewPostProvider;
  void setNewFeatured({String topic, String value}) {
    setState(() {
      _featuredTopic = topic;
      _featuredValue = value;
      _reviewPostProvider.featuredTopic = topic;
      _reviewPostProvider.featuredValue = value;
    });
  }

  // void initState() {
  //   super.initState();
  //   WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
  //     _showBottomSheet();
  //   });
  // }

  void _showBottomSheet({BuildContext context}) {
    showModalBottomSheet(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        isScrollControlled: true,

        // isDismissible: true,
        context: context,
        builder: (context) => _bottomSheetFeatureQuote(
              context: context,
              feed: widget.feed,
              contentBodyProvider: widget.contentBodyProvider,
              setNewFeatured: setNewFeatured,
            ));
  }

  @override
  Widget build(BuildContext context) {
    _reviewPostProvider = Provider.of<ReviewPostProvider>(context);
    AuthService _authService = Provider.of<AuthService>(context);

    print('New feed widget built!');
    int _colorIndex = 1;
    if (widget.index > 4) {
      _colorIndex = widget.index % 5;
    } else {
      _colorIndex = widget.index;
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
                          imageUrl: _authService.myUser.profileImageUrl ??
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
                      widget.feed.username,
                      // ([
                      //   'wkayi_2000',
                      //   'elissa_ann04',
                      //   'justin_lau',
                      //   'edison_lime',
                      //   'zheng_yong_wzy',
                      //   'wong_zq',
                      //   'andrew_davilla_04'
                      // ]..shuffle())
                      //     .first,
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
                _showBottomSheet(context: context);
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
                              _showBottomSheet(context: context);
                            },
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
                                  _featuredTopic ?? 'Quote',
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
                              width: 240,
                              child: Text(
                                _featuredValue ?? '. . .',
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
                          widget.feed.title,
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
                          widget.feed.content.replaceAll('\n', ' . '),
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
                      SizedBox(height: 10),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                            children: widget.feed.tags
                                .map(
                                  (individualTag) => Padding(
                                    padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
                                    child: FittedBox(
                                      alignment: Alignment.center,
                                      child: Container(
                                        padding:
                                            EdgeInsets.fromLTRB(6, 3, 6, 3),
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          border: Border.fromBorderSide(
                                              BorderSide(
                                                  color:
                                                      _colorScheme[_colorIndex]
                                                              ['secondary']
                                                          .withOpacity(0.7))),
                                          borderRadius:
                                              BorderRadius.circular(5),
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
                      ),
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

  Widget _bottomSheetFeatureQuote({
    BuildContext context,
    Feed feed,
    ContentBodyProvider contentBodyProvider,
    Function setNewFeatured,
  }) {
    ScrollController _controller = ScrollController();

    List<Map<String, String>> _tempFeatureQuotes = [];

    contentBodyProvider.listOfContentWidgets.forEach((contentWidget) {
      if (contentWidget.widgetType == WidgetType.quote) {
        bool _quoteHasTitle = ((contentWidget.widget) as QuoteText)
            .titleController
            .text
            .isNotEmpty;
        _tempFeatureQuotes.add({
          // 'type': 'quote',
          'topic': _quoteHasTitle
              ? ((contentWidget.widget) as QuoteText).titleController.text
              : null,
          'value': contentWidget.controller.text.isNotEmpty
              ? contentWidget.controller.text
              : null,
        });
      }
    });

    return Container(
      height: MediaQuery.of(context).size.height * 0.55,
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
            child: ListView.builder(
              controller: _controller,
              cacheExtent: 1000,
              padding: EdgeInsets.fromLTRB(8, 0, 0, 0),
              itemCount: _tempFeatureQuotes.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    setNewFeatured(
                        topic: _tempFeatureQuotes[index]['topic'],
                        value: _tempFeatureQuotes[index]['value']);
                    Navigator.pop(context);
                  },
                  child: FeatureQuote(
                      topic: _tempFeatureQuotes[index]['topic'] ?? 'Quote',
                      value: _tempFeatureQuotes[index]['value'] ?? '. . .'),
                );
              },
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
                      'Pick Featured Verse',
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
          // Positioned(bottom: 0, child: UneditableInputComment()),
        ],
      ),
    );
  }
}
