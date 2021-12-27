import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:versify/providers/providers_home/theme_data_provider.dart';
import 'package:versify/services/firebase/auth.dart';
import 'package:versify/shared/helper/helper_functions.dart';

class AccWidgetLogout extends StatelessWidget {
  Future<void> deletePrefs() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // prefs.remove("seenDocs");
    // prefs.remove("sortedFollowingList");
    prefs.remove("lastUpdated");
  }

  @override
  Widget build(BuildContext context) {
    final ThemeProvider _themeProvider =
        Provider.of<ThemeProvider>(context, listen: false);
    final AuthService _authService = Provider.of<AuthService>(context);

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        _authService.logout().then((_) async {
          await deletePrefs();
          refreshToWrapper(context);
        });
      },
      child: Padding(
        padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
        child: Row(
          children: [
            Icon(
              Icons.logout,
              size: 16.5,
              color: Theme.of(context).primaryColor.withOpacity(0.6),
            ),
            SizedBox(width: 10),
            Text(
              "Log out",
              style: TextStyle(
                fontSize: 15,
                color: _themeProvider.primaryTextColor.withOpacity(0.87),
                fontWeight: FontWeight.w500,
              ),
            ),
            Expanded(child: Container()),
          ],
        ),
      ),
    );
  }
}
