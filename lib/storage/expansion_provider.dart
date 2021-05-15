import 'package:flutter/cupertino.dart';

class ExpansionProvider extends ChangeNotifier {
  bool expanded = false;

  bool get isExpanded => expanded;

  void toggle(bool expanded) {
    this.expanded = expanded;
    notifyListeners();
  }

  void collapse() {
    expanded = false;
    print('EXPANDED NOTIFY IS: ' + expanded.toString());
    notifyListeners();
  }
}
