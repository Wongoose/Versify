import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:versify/providers/providers_home/theme_data_provider.dart';
import 'package:versify/screens/profile/settings/sub-settings/account_change_password.dart';

class AccWidgetPassword extends StatelessWidget {
  final String parsedSignInProvider;
  const AccWidgetPassword(this.parsedSignInProvider);

  @override
  Widget build(BuildContext context) {
    final ThemeProvider _themeProvider = Provider.of<ThemeProvider>(context);
    if (parsedSignInProvider == "password") {
      return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => Navigator.push(context,
            CupertinoPageRoute(builder: (context) => AccountChangePassword())),
        child: Padding(
          padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
          child: Row(
            children: [
              Icon(
                FontAwesomeIcons.key,
                size: 15,
                color: Theme.of(context).primaryColor.withOpacity(0.6),
              ),
              SizedBox(width: 10),
              //hide this widget if using Google/Facebook
              Text(
                "Password",
                style: TextStyle(
                  fontSize: 15,
                  color: _themeProvider.primaryTextColor.withOpacity(0.87),
                  fontWeight: FontWeight.w500,
                ),
              ),
              Expanded(child: Container()),
              Text(
                "Secured",
                style: TextStyle(
                  fontSize: 14,
                  color: _themeProvider.secondaryTextColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(width: 10),
              Icon(
                Icons.arrow_forward_ios_rounded,
                color: _themeProvider.secondaryTextColor,
                size: 15,
              ),
            ],
          ),
        ),
      );
    } else {
      return Container();
    }
  }
}
