import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:versify/shared/helper/helper_widgets.dart';
import 'package:vibration/vibration.dart';

class Comment extends StatefulWidget {
  final Color primaryColor;
  final Color secondaryColor;
  final String user;
  final String comment;

  Comment({this.primaryColor, this.secondaryColor, this.user, this.comment});

  @override
  _CommentState createState() => _CommentState();
}

class _CommentState extends State<Comment> {
  bool _likedComment = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 8, 0, 8),
      decoration: BoxDecoration(
          // border: Border(
          //   left: BorderSide(
          //       width: 2,
          //       color: _colorScheme[widget.themeIndex]
          //           ['primary']),
          // ),
          ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(0, 0, 8, 0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ProfilePic(
                size: 1,
                primary: widget.primaryColor,
                secondary: widget.secondaryColor),
            SizedBox(width: 12),
            Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onDoubleTap: () {
                  setState(() => _likedComment = true);
                  Vibration.vibrate(duration: 5);
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Text(
                        widget.user ?? "Jacob",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Nunito',
                          letterSpacing: 0,
                        ),
                      ),
                    ),
                    Text(
                      widget.comment ??
                          "I'm so happy for you! Keep going love- 🥳",
                      style: TextStyle(
                          color: Colors.black87,
                          fontSize: 14,
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      height: 15,
                      width: 60,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            '2 d',
                            style:
                                TextStyle(fontSize: 10, color: Colors.black45),
                          ),
                          Text(
                            '3 likes',
                            style:
                                TextStyle(fontSize: 10, color: Colors.black45),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                setState(() => _likedComment = !_likedComment);
                Vibration.vibrate(duration: 5);
              },
              child: Container(
                height: 40,
                width: 40,
                alignment: Alignment.centerRight,
                child: Icon(
                  _likedComment
                      ? CupertinoIcons.heart_fill
                      : CupertinoIcons.heart,
                  color: Colors.red,
                  size: 15,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
