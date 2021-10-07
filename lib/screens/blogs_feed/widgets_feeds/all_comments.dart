import 'package:versify/screens/blogs_feed/widget_view_post/comment_widget.dart';
import 'package:versify/screens/blogs_feed/widget_view_post/input_comment.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AllComments extends StatelessWidget {
  final FocusNode _inputFocus = FocusNode();
  final bool isViewOnly;

  AllComments({this.isViewOnly});
  @override
  Widget build(BuildContext context) {
    final ThemeData _theme = Theme.of(context);

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.black45,
      ),
    );
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: false,
        elevation: 1,
        backgroundColor: Colors.white,
        titleSpacing: -5,
        title: Text(
          'All comments',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        automaticallyImplyLeading: true,
        leading: TextButton.icon(
          style: TextButton.styleFrom(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
            backgroundColor: Colors.white,
            // focusColor: Colors.white,
            // highlightColor: Color(0xfffffcfe),
          ),
          clipBehavior: Clip.none,
          icon: Icon(Icons.arrow_back_ios_rounded, color: Colors.black),
          label: Text(''),
          onPressed: () => {Navigator.pop(context)},
        ),
      ),
      body: Stack(
        children: [
          GestureDetector(
            onTap: () => _inputFocus.unfocus(),
            child: ListView.builder(
              cacheExtent: 1000,
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.fromLTRB(8, 8, 8, 70),
              itemCount: 20,
              itemBuilder: (context, index) {
                return Comment(
                  primaryColor: _theme.primaryColor,
                  secondaryColor: _theme.accentColor,
                  comment: ([
                    'Hello, that\'s an amazing sharing mate! ❤️',
                    'Wow! Can\'t wait to try it out! 🥳',
                    'I\'m amazed. Hope you have a great day ahead as well! ❤️',
                  ]..shuffle())
                      .first,
                  user: ([
                    'wkayi_2000',
                    'elissa_ann04',
                    'justin_lau',
                    'edison_lime',
                    'zheng_yong_wzy',
                    'wong_zq',
                    'andrew_davilla_04'
                  ]..shuffle())
                      .first,
                );
              },
            ),
          ),
          Positioned(
            bottom: 0,
            child: InputComment(
              focusNode: _inputFocus,
              isViewOnly: isViewOnly,
            ),
          ),
        ],
      ),
    );
  }
}
