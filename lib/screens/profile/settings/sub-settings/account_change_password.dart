import 'package:overlay_support/overlay_support.dart';
import "package:versify/providers/providers_home/theme_data_provider.dart";
import 'package:versify/screens/authentication/auth_screen_reset_password.dart';
import "package:versify/services/firebase/auth.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";

class AccountChangePassword extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ThemeProvider _themeProvider =
        Provider.of<ThemeProvider>(context, listen: false);
    final AuthService _authService = Provider.of<AuthService>(context);

    return WillPopScope(
      onWillPop: () async {
        if (Navigator.of(context).userGestureInProgress) {
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          backgroundColor: Theme.of(context).backgroundColor,
          centerTitle: true,
          elevation: 0.5,
          title: Text(
            "Password",
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
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              "Back",
              style: TextStyle(
                fontSize: 14,
                color: _themeProvider.secondaryTextColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
         
        ),
        body: Padding(
          padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Manage account password",
                style: TextStyle(
                  fontSize: 14,
                  color: _themeProvider.secondaryTextColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 10),
            
              Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
                child: SizedBox(
                  child: Text(
                    "The password for ${_authService.getCurrentUser.email} is secured.",
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
                      // resetPasswordDialog(context);
                      if (_authService.getCurrentUser.email?.isEmpty ?? false) {
                        // NO EMAIL
                        toast("Could not change password");
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ScreenResetPassword(
                              initialEmail: _authService.getCurrentUser.email,
                              editAccess: false,
                            ),
                          ),
                        );
                      }
                    },
                    child: SizedBox(
                      child: Text(
                        "Change password?",
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
