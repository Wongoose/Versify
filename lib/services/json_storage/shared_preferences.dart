import 'package:shared_preferences/shared_preferences.dart';

class MySharedPreferences {
  SharedPreferences appPreferences;

  // getters
  bool get isCompletedBoarding {
    return appPreferences.getBool("completedBoarding") ?? true;
  }

  bool get isCompletedTutorial {
    return appPreferences.getBool("completedTutorial") ?? false;
  }

  // setters
  void deleteStorage() {
    appPreferences.remove('lastUpdated');
    appPreferences.remove('deviceLatestBadgeTs');
  }

  // initialize
  Future<void> initMySharedPreferences() async {
    appPreferences = await SharedPreferences.getInstance();
  }
}
