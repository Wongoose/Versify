import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:versify/providers/providers_home/theme_data_provider.dart';
import 'package:versify/screens/profile/settings/account_edit_row.dart';
import 'package:versify/screens/profile/settings/account_verify_new_email.dart';
import 'package:versify/screens/profile/settings/sub-settings/account_change_email.dart';
import 'package:versify/services/firebase/auth.dart';

class AccWidgetSignInProvider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ThemeProvider _themeProvider =
        Provider.of<ThemeProvider>(context, listen: false);
    final AuthService _authService = Provider.of<AuthService>(context);
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        if (_authService.currentSignInProvider == "google.com") {
          Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) => AccountEditRow(
                  editType: AccountEditType.google,
                ),
              ));
        } else if (_authService.currentSignInProvider == "password") {
          if (_authService.isEmailVerified) {
            Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => AccountChangeEmail(
                      parsedEmail: _authService.getCurrentUser.email),
                ));
          } else {
            //verify email address
            Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => AccountVerifyNewEmail(),
                ));
          }
        }
      },
      child: Padding(
        padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              _authService.currentSignInProvider == "google.com"
                  ? FontAwesomeIcons.google
                  : Icons.email_rounded,
              size: _authService.currentSignInProvider == "google.com"
                  ? 15
                  : 16.5,
              color: Theme.of(context).primaryColor.withOpacity(0.6),
            ),
            SizedBox(width: 10),
            Text(
              _authService.currentSignInProvider == "google.com"
                  ? "Google"
                  : "Email",
              style: TextStyle(
                fontSize: 15,
                color: _themeProvider.primaryTextColor.withOpacity(0.87),
                fontWeight: FontWeight.w500,
              ),
            ),
            Expanded(child: Container()),
            if (_authService.currentSignInProvider == "password" &&
                _authService.isEmailVerified == false)
              Icon(
                Icons.warning_rounded,
                color: Colors.redAccent,
                size: 15,
              )
            else
              Container(),
            SizedBox(width: 10),
            Text(
              _authService.getCurrentUser.email ?? "none",
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
  }
}
