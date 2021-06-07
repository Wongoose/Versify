import 'package:flutter/material.dart';

enum TutorialProgress { pickTopics, viewedFirstPost, refreshFirst }

class TutorialProvider extends ChangeNotifier {
  bool allCompleted = false;
  bool pickedTopics = false;
  bool refreshFirst = false;
  bool viewedFirstPost = false;
  bool overlayScopeEnabled = true;

  void updateTutorialComplete(bool completed) {
    print('update TutorialComplete | completed: $completed');
    allCompleted = completed;
  }

  void updateOverlayScope(bool enabled) {
    overlayScopeEnabled = enabled;
    notifyListeners();
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
