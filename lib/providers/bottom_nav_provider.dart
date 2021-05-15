import 'package:flutter/cupertino.dart';

class BottomNavProvider extends ChangeNotifier {
  bool show = true;

  void hideBottomBar() {
    if (show == true) {
      show = false;
      notifyListeners();
      print('HIDE bottombar called Notifer');
    } else {
      // print('repeated called BottomNavBar');
    }
  }

  void showBottomBar() {
    if (show == false) {
      show = true;
      print('SHOW bottombar called Notifer');
    } else {
      // print('repeated called BottomNavBar');
    }
    notifyListeners();
  }
}

class PageViewProvider extends ChangeNotifier {
  int pageIndex = 1;

  void pageChanged(int index) {
    pageIndex = index;

    print('PageIndex: ' + index.toString());
    notifyListeners();
  }
}
