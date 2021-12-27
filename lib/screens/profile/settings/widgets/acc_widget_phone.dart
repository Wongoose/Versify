import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:versify/providers/providers_home/theme_data_provider.dart';
import 'package:versify/screens/profile/settings/sub-settings/account_change_phone.dart';
import 'package:versify/services/firebase/auth.dart';

class AccWidgetPhone extends StatelessWidget {
  final bool parsedHasPhoneNumber;
  const AccWidgetPhone({this.parsedHasPhoneNumber});

  @override
  Widget build(BuildContext context) {
    final ThemeProvider _themeProvider =
        Provider.of<ThemeProvider>(context, listen: false);
    final AuthService _authService = Provider.of<AuthService>(context);
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => AccountChangePhone(parsedHasPhoneNumber
                ? _authService.getCurrentUser.phoneNumber
                : ""),
          )),
      child: Padding(
        padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
        child: Row(
          children: [
            Icon(
              Icons.phone,
              size: 16.5,
              color: Theme.of(context).primaryColor.withOpacity(0.6),
            ),
            SizedBox(width: 10),
            Text(
              "Phone number",
              style: TextStyle(
                fontSize: 15,
                color: _themeProvider.primaryTextColor.withOpacity(0.87),
                fontWeight: FontWeight.w500,
              ),
            ),
            Expanded(child: Container()),
            Text(
              parsedHasPhoneNumber
                  ? _authService.getCurrentUser.phoneNumber
                  : "none",
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
