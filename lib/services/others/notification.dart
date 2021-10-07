import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:versify/shared/widgets/widgets_dialog_image.dart';

class NotificationOverlay {
  void welcomePostNotification() {
    simpleNotification(
      duration: Duration(seconds: 5),
      delay: Duration(seconds: 4),
      title: "Are you excited?",
      body:
          "I can\'t believe you\'re reading your first blog! See you at the end.",
      imagePath: "assets/images/copywriting.png",
    );
  }

  void simpleNotification(
      {Duration duration,
      Duration delay,
      @required String title,
      @required String body,
      @required String imagePath}) {
    Future.delayed(delay ?? Duration(seconds: 0)).then((_) {
      showSimpleNotification(
        Material(
          color: Colors.transparent,
          child: Container(
            margin: EdgeInsets.fromLTRB(0, 15, 0, 0),
            padding: EdgeInsets.fromLTRB(25, 15, 20, 15),
            alignment: Alignment.center,
            height: 80,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                    offset: Offset(0, 0), blurRadius: 1, color: Colors.black45),
              ],
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(2),
                  child: AspectRatio(
                    aspectRatio: 1 / 1,
                    child: Image(
                      image: AssetImage(
                        imagePath ?? 'assets/images/love.png',
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 15),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title ?? 'Sign Up profile',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(
                      width: 260,
                      child: Text(
                        body ?? 'Login now to unlock more features!',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        elevation: 0,
        duration: duration ?? Duration(seconds: 4),
        background: Colors.transparent,
        foreground: Colors.transparent,
        slideDismissDirection: DismissDirection.horizontal,
      );
    });
  }

  void showNormalImageDialog(BuildContext context,
      {@required String body,
      @required String buttonText,
      @required Function clickFunc,
      @required String imagePath,
      @required String title,
      @required Duration delay}) {
    Future.delayed(delay).then((_) {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return NormalImageDialog(
              body: body,
              buttonText: buttonText,
              clickFunc: clickFunc,
              imagePath: imagePath,
              title: title,
            );
          });
    });
  }
}
