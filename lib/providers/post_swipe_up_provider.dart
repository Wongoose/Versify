import 'package:flutter/cupertino.dart';

class PostSwipeUpProvider extends ChangeNotifier {
  bool _swipeUpVisible = false;
  int numberOfTimesShown = 0;

  bool get swipeUpVisible => _swipeUpVisible;

  void setSwipeUpVisible(bool visible) {
    if (numberOfTimesShown < 2) {
      if (!visible) {
        numberOfTimesShown++;
      }
      _swipeUpVisible = visible;
      notifyListeners();
    }
  }
}
