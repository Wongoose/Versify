import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  bool isDark = true;
  Color primaryTextColor;
  Color secondaryTextColor;

  Color dialogColor;

  ThemeMode currentTheme() {
    primaryTextColor = isDark ? Colors.white.withOpacity(0.8) : Colors.black;
    secondaryTextColor = isDark ? Colors.white54 : Colors.black54;
    dialogColor = isDark ? Colors.grey[900] : Colors.white;
    
    return isDark ? ThemeMode.dark : ThemeMode.light;
  }

  void switchTheme() {
    isDark = !isDark;
    if (isDark) {
      primaryTextColor = Colors.white.withOpacity(0.8);
      secondaryTextColor = Colors.white54;
    } else {
      primaryTextColor = Colors.black;
      secondaryTextColor = Colors.black54;
    }
    notifyListeners();
  }

  //sharedpreferences store isDark
}
