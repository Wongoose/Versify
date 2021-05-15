import 'package:versify/models/content_widget.dart';
import 'package:versify/models/feed_model.dart';
import 'package:versify/providers/content_body_provider.dart';
import 'package:versify/providers/create_topics_provider.dart';
import 'package:versify/screens/feed_screen/create_post_sub/review_post_provider.dart';
import 'package:versify/screens/feed_screen/create_post_sub/widgets/decoration_body.dart';
import 'package:versify/screens/feed_screen/create_post_sub/widgets/quote_text.dart';
import 'package:versify/screens/feed_screen/create_post_sub/widgets/review_post_options.dart';
import 'package:versify/services/auth.dart';
import 'package:versify/services/database.dart';
import 'package:versify/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ReviewPost extends StatefulWidget {
  final TextEditingController titleController;
  final CreateTopicsProvider createTopicsProvider;
  final List listMapContent;
  final List<String> tags;

  ReviewPost({
    this.titleController,
    this.createTopicsProvider,
    this.listMapContent,
    this.tags,
  });

  @override
  _ReviewPostState createState() => _ReviewPostState();
}

class _ReviewPostState extends State<ReviewPost> {
  final ScrollController _scrollController =
      ScrollController(initialScrollOffset: 0);

  final ReviewPostProvider _reviewPostProvider = ReviewPostProvider();

  bool _loading = false;

  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _scrollController.animateTo(700,
          duration: Duration(milliseconds: 600), curve: Curves.easeInOut);
    });
  }

  @override
  Widget build(BuildContext context) {
    ContentBodyProvider _contentBodyProvider =
        Provider.of<ContentBodyProvider>(context, listen: false);

    final AuthService _authService = Provider.of<AuthService>(context);

    DatabaseService _databaseService = Provider.of<DatabaseService>(context);

    final Feed _reviewFeed = Feed(
      username: _authService.myUser.username,
      title: widget.titleController.text,
      listMapContent: widget.listMapContent,
      content: _contentBodyProvider.allText,
      tags: widget.tags,
    );

    // final Feed _reviewFeed = Feed(
    //   username: 'zheng_xiang-wzx',
    //   title: 'Hello the world',
    //   content:
    //       'Not everyone knwo what to do in a world like this la you are the words of all in the entire world of hunger games you can never imagine how much I hate you in this world. So please just go away and never come abck to my likfe I don;t want to see you ever again.',
    //   tags: ['#love20', '#peace20'],
    // );

    return Provider<ReviewPostProvider>.value(
      value: _reviewPostProvider,
      child: Stack(
        children: [
          Scaffold(
            appBar: AppBar(
              elevation: 1,
              backgroundColor: Colors.white,
              titleSpacing: 5,
              title: Text(
                'Create',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 22,
                    fontWeight: FontWeight.w600),
              ),
              leading: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Icon(
                    Icons.arrow_back_ios_rounded,
                    color: Colors.black,
                    size: 25,
                  )),
              actions: [
                new Builder(
                  builder: (context) {
                    return TextButton.icon(
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                        backgroundColor: Colors.white,
                      ),
                      label: Text(''),
                      icon: Icon(
                        Icons.check_rounded,
                        size: 28,
                        color: Color(0xffff548e),
                      ),
                      onPressed: () async {
                        setState(() => _loading = true);

                        List<Map<String, String>> _tempListMapContent = [];

                        _contentBodyProvider.listOfContentWidgets
                            .forEach((contentWidget) {
                          switch (contentWidget.widgetType) {
                            case WidgetType.quote:
                              bool _quoteHasTitle =
                                  ((contentWidget.widget) as QuoteText)
                                      .titleController
                                      .text
                                      .isNotEmpty;
                              _tempListMapContent.add({
                                'type': 'quote',
                                'topic': _quoteHasTitle
                                    ? ((contentWidget.widget) as QuoteText)
                                        .titleController
                                        .text
                                    : null,
                                'value': contentWidget.controller.text
                              });

                              break;

                            case WidgetType.text:
                              _tempListMapContent.add({
                                'type': 'text',
                                'value': contentWidget.controller.text,
                              });

                              break;

                            case WidgetType.image:
                              break;

                            case WidgetType.delete:
                              break;
                          }
                        });

                        await _databaseService
                            .createPostWithMap(
                          myUser: _authService.myUser,
                          featuredTopic: _reviewPostProvider.featuredTopic,
                          featuredValue: _reviewPostProvider.featuredValue,
                          title: widget.titleController.text,
                          listMapContent: _tempListMapContent,
                          content: _contentBodyProvider.allText,
                          tags: widget.createTopicsProvider.chipSnaps
                              .map((chipData) =>
                                  chipData.checked ? chipData.topic : null)
                              .toList(),
                        )
                            .then((_) {
                          Navigator.popUntil(context,
                              ModalRoute.withName(Navigator.defaultRouteName));

                          setState(() => _loading = false);
                        });
                      },
                    );
                  },
                ),
              ],
            ),
            body: DecorationBodyWidget(
                scrollController: _scrollController,
                reviewFeed: _reviewFeed,
                contentBodyProvider: _contentBodyProvider),
            bottomSheet: ReviewPostOptions(reviewFeed: _reviewFeed),
          ),
          Visibility(
            visible: _loading,
            child: Loading(),
          ),
        ],
      ),
    );
  }
}
