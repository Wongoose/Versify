import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:versify/services/notification.dart';

enum TutorialProgress {
  none,
  pickTopicsDone,
  refreshTutorialFeedDone,
  viewFirstPostDone,
  viewSecondPostDone,
  signUpProfileNotifDone,
}

class TutorialProvider extends ChangeNotifier {
  TutorialProgress currentTutorialCompleted = TutorialProgress.none;

  bool pickTopics = true;
  bool refreshFeedList = false;
  bool viewFirstPost = false;
  bool viewSecondPost = false;
  bool signUpProfileNotif = false;

  //----

  bool allCompleted = false;
  // bool pickedTopics = true;
  // bool refreshFirst = false;
  // bool viewedFirstPost = false;
  // bool viewedSecondPost = false;

  // bool overlayScopeEnabled = true;

  // bool get secondPostNotificationEnabled {
  //   return viewedFirstPost == true && viewedSecondPost == false;
  // }

  void updateTutorialComplete(bool completed) {
    print('update TutorialComplete | completed: $completed');
    allCompleted = completed;
  }

  void updateProgress(TutorialProgress tutorialProgress) {
    print('updateTutorialProgress RAN');
    currentTutorialCompleted = tutorialProgress;

    switch (tutorialProgress) {
      case TutorialProgress.none:
        // TODO: Handle this case.
        break;
      case TutorialProgress.pickTopicsDone:
        refreshFeedList = true;
        pickTopics = false;
        break;
      case TutorialProgress.refreshTutorialFeedDone:
        viewFirstPost = true;
        refreshFeedList = false;
        break;
      case TutorialProgress.viewFirstPostDone:
        viewSecondPost = true;
        viewFirstPost = false;
        break;
      case TutorialProgress.viewSecondPostDone:
        viewSecondPost = false;
        signUpProfileNotif = true;
        NotificationOverlay().simpleNotification(
            body: 'Sign-up now to unlock more features!',
            imagePath: 'assets/images/relatable.png',
            title: 'Sign Up Profile',
            delay: Duration(seconds: 3));
        break;
      case TutorialProgress.signUpProfileNotifDone:
        signUpProfileNotif = false;
        break;
    }
    notifyListeners();
  }
}
