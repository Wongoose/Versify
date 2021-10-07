import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:versify/services/others/notification.dart';
import 'package:versify/shared/helper/helper_methods.dart';

enum TutorialProgress {
  none,
  pickTopicsDone,
  refreshTutorialFeedDone,
  viewFirstPostDone,
  viewSecondPostDone,
  checkInDialogDone,
  signUpProfileNotifDone,
}

class TutorialProvider extends ChangeNotifier {
  TutorialProgress currentTutorialCompleted = TutorialProgress.none;

  bool pickTopics = false;
  bool refreshFeedList = false;
  bool viewFirstPost = false;
  bool viewSecondPost = false;
  bool checkInDialog = false;
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

  // ignore: avoid_positional_boolean_parameters
  void setTutorialComplete(bool completed) {
    print(greenPen("setTutorialComplete | completed: $completed"));
    if (completed) {
      allCompleted = completed;

      pickTopics = false;
      refreshFeedList = false;
      viewFirstPost = false;
      viewSecondPost = false;
      checkInDialog = false;
      signUpProfileNotif = false;
    }
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
        checkInDialog = true;
        viewSecondPost = false;

        break;
      case TutorialProgress.checkInDialogDone:
        signUpProfileNotif = true;
        checkInDialog = false;
        NotificationOverlay().simpleNotification(
            body: 'Sign-up now to unlock more features!',
            imagePath: 'assets/images/relatable.png',
            title: 'Sign Up Profile',
            delay: Duration(seconds: 3));
        break;
      case TutorialProgress.signUpProfileNotifDone:
        signUpProfileNotif = false;
        //next
        break;
    }
    notifyListeners();
  }

  // --------- PICK TOPICS
  final List<String> listOfTopics = [
    'Love',
    'Hope',
    'Peace',
    'Joy',
    'Healing',
    'Kindness',
    'Loss',
    'Patience',
    'Faith',
    'Prayer'
  ];

  List<String> listOfSelectedTopics = [];

  bool topicIsSelected(String topic) {
    return listOfSelectedTopics.contains(topic);
  }

  void topicClicked(String topic) {
    final bool isSelected = topicIsSelected(topic);

    if (isSelected) {
      listOfSelectedTopics.remove(topic);
      notifyListeners();
    } else if (listOfSelectedTopics.length != 3) {
      listOfSelectedTopics.add(topic);
      notifyListeners();
    } else {
      toast("Pick 3 topics only", duration: Toast.LENGTH_SHORT);
    }
  }
}
