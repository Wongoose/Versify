import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:versify/providers/home/theme_data_provider.dart';
import 'package:versify/services/auth.dart';
import 'package:versify/services/dynamic_links.dart';

class AccountVerifyNewEmail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ThemeProvider _themeProvider =
        Provider.of<ThemeProvider>(context, listen: false);
    AuthService _authService = Provider.of<AuthService>(context);

    void verifyEmailDialog() {
      showDialog(
          context: context,
          builder: (context) {
            return SimpleDialog(
              title: Align(
                alignment: Alignment.center,
                child: Text(
                  'Verify Email',
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.w600,
                    color: _themeProvider.primaryTextColor,
                  ),
                ),
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(30, 15, 30, 10),
                  alignment: Alignment.center,
                  width: 40,
                  child: Text(
                    'A Verification Email will be sent to your inbox.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                ),
                // Divider(thickness: 0.5, height: 0),
                Container(
                  margin: EdgeInsets.all(0),
                  height: 60,
                  child: FlatButton(
                    materialTapTargetSize: MaterialTapTargetSize.padded,
                    onPressed: () {
                      _authService.verifyEmailAddress();
                    },
                    child: Text(
                      'Yes, verify email.',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                Divider(thickness: 0.5, height: 0),
                Container(
                  margin: EdgeInsets.all(0),
                  height: 60,
                  child: FlatButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        color: _themeProvider.secondaryTextColor,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            );
          });
    }

    return WillPopScope(
      onWillPop: () async {
        if (Navigator.of(context).userGestureInProgress)
          return false;
        else
          return true;
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          backgroundColor: Theme.of(context).backgroundColor,
          centerTitle: true,
          elevation: 0.5,
          title: Text(
            'Email',
            style: TextStyle(
              fontSize: 17.5,
              fontWeight: FontWeight.w600,
              color: _themeProvider.primaryTextColor.withOpacity(0.87),
            ),
          ),
          leadingWidth: 60,
          leading: TextButton(
            style: TextButton.styleFrom(
                padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                backgroundColor: Theme.of(context).backgroundColor,
                primary: Theme.of(context).backgroundColor),
            child: Text(
              'Back',
              style: TextStyle(
                fontSize: 14,
                color: _themeProvider.secondaryTextColor,
                fontWeight: FontWeight.w500,
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: [],
        ),
        body: Padding(
          padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Email not verified',
                style: TextStyle(
                  fontSize: 14,
                  color: _themeProvider.secondaryTextColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 5),
              SizedBox(height: 5),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
                child: SizedBox(
                  child: Text(
                    'Please verify your email address to keep your account secured and to keep the community safe.',
                    style: TextStyle(
                      height: 1.7,
                      fontSize: 12,
                      color: _themeProvider.secondaryTextColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 15),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    verifyEmailDialog();
                  },
                  child: SizedBox(
                    child: Text(
                      'Click to verify email',
                      style: TextStyle(
                        height: 1.7,
                        fontSize: 12,
                        color: Colors.blue[400],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
