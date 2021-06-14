import 'package:versify/providers/feeds/view_post_like_provider.dart';
import 'package:versify/screens/feed_screen/widgets_feeds/all_comments.dart';
import 'package:versify/shared/profilePicture.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:vibration/vibration.dart';

class InteractionBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Colors.transparent,
      elevation: 0,
      child: Container(
        padding: EdgeInsets.fromLTRB(15, 2, 15, 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              child: ProfilePic(size: 1.2),
            ),
            SizedBox(height: 10),
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
                    height: 65,
                    width: 40,
                    child: Icon(
                      likeProvider.isLiked
                          ? CupertinoIcons.heart_solid
                          : CupertinoIcons.heart_solid,
                      color: likeProvider.isLiked
                          ? Colors.red
                          : Colors.black.withOpacity(0.8),
                      size: 40,
                    ),
                  ),
                );
              },
            ),
            GestureDetector(
              onTap: () => {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AllComments(isViewOnly: false),
                    )),
              },
              child: Container(
                height: 65,
                width: 40,
                child: Icon(
                  Icons.sms_rounded,
                  color: Colors.black.withOpacity(0.8),
                  size: 35,
                ),
              ),
            ),
            GestureDetector(
              onTap: () => {},
              child: Container(
                height: 60,
                width: 40,
                child: Icon(
                  FontAwesomeIcons.share,
                  color: Colors.black.withOpacity(0.8),
                  size: 35,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
