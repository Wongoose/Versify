import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';

class NotificationOverlay {
  void welcomePostNotification() {
    simpleNotification(
        duration: Duration(seconds: 8), delay: Duration(seconds: 4));
  }

  Future<void> simpleNotification({Duration duration, Duration delay}) async {
    Future.delayed(delay).then((_) {
      showSimpleNotification(
        Material(
          color: Colors.transparent,
          child: Container(
            margin: EdgeInsets.fromLTRB(0, 15, 0, 0),
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
            child: Text(
              'Hello world',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ),
        elevation: 0,
        duration: duration,
        background: Colors.transparent,
        foreground: Colors.transparent,
        slideDismissDirection: DismissDirection.horizontal,
      );
    });
  }
}
