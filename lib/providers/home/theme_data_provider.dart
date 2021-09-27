import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  Future<void> switchTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isDark = !isDark;
    if (isDark) {
      primaryTextColor = Colors.white.withOpacity(0.8);
      secondaryTextColor = Colors.white54;
    } else {
      primaryTextColor = Colors.black;
      secondaryTextColor = Colors.black54;
    }
    prefs.setBool("themeProvider_isDark", isDark);
    notifyListeners();
  }

  //sharedpreferences store isDark

  Future<void> initPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool _prefsIsDark = prefs.getBool("themeProvider_isDark") ?? true;
    isDark = _prefsIsDark;
  }
}
