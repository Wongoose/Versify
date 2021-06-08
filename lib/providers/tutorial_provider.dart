import 'package:flutter/material.dart';

enum TutorialProgress { pickTopics, viewedFirstPost, refreshFirst }

class TutorialProvider extends ChangeNotifier {
  bool allCompleted = false;
  bool pickedTopics = true;
  bool refreshFirst = false;
  bool viewedFirstPost = false;
  bool viewedSecondPost = false;

  bool overlayScopeEnabled = true;

  bool get secondPostNotificationEnabled {
    return viewedFirstPost == true && viewedSecondPost == false;
  }

  void updateTutorialComplete(bool completed) {
    print('update TutorialComplete | completed: $completed');
    allCompleted = completed;
  }



  void updateProgress(TutorialProgress tutorialProgress, bool complete) {
    print('updateTutorialProgress RAN');
    switch (tutorialProgress) {
      case TutorialProgress.pickTopics:
        pickedTopics = complete;
        break;
      case TutorialProgress.viewedFirstPost:
        viewedFirstPost = complete;
        break;
      case TutorialProgress.refreshFirst:
        refreshFirst = complete;
        break;
    }
    notifyListeners();
  }
}
