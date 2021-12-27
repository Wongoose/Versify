import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:versify/providers/providers_home/theme_data_provider.dart';
import 'package:versify/screens/profile/settings/account_privacy.dart';
import 'package:versify/services/firebase/auth.dart';

class AccWidgetPrivacy extends StatelessWidget {
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
            builder: (context) => AccountPrivacy(authService: _authService),
          )),
      child: Padding(
        padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
        child: Row(
          children: [
            Icon(
              FontAwesomeIcons.lock,
              size: 15,
              color: Theme.of(context).primaryColor.withOpacity(0.6),
            ),
            SizedBox(width: 10),
            Text(
              "Privacy",
              style: TextStyle(
                fontSize: 15,
                color: _themeProvider.primaryTextColor.withOpacity(0.87),
                fontWeight: FontWeight.w500,
              ),
            ),
            Expanded(child: Container()),
            SizedBox(
              width: 180,
              child: Text(
                "More",
                textAlign: TextAlign.end,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 14,
                  color: _themeProvider.secondaryTextColor,
                  fontWeight: FontWeight.w500,
                ),
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
