import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:versify/providers/providers_home/theme_data_provider.dart';
import 'package:versify/screens/authentication/auth_screen_reset_password.dart';
import 'package:versify/screens/profile/settings/account_edit_row.dart';
import 'package:versify/screens/profile/settings/account_verification.dart';

class DialogResetPassword extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    return SimpleDialog(
      title: Align(
        child: Text(
          'Reset Password',
          style: TextStyle(
            fontSize: 23,
            fontWeight: FontWeight.w600,
            color: themeProvider.primaryTextColor,
          ),
        ),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      children: [
        Container(
          padding: EdgeInsets.fromLTRB(30, 15, 30, 10),
          alignment: Alignment.center,
          width: 40,
          child: Text(
            "Don't worry. This action will only update your sign in details. Your account data will not be affected. Reset password now?",
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
              // Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //         builder: (context) => ScreenResetPassword()));
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AccountVerification(
                      accEditType: AccountEditType.password,
                      parsedText: '',
                      verificationSuccessFunc: null,
                    ),
                  ));
            },
            child: Text(
              'Yes, reset password.',
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
                color: themeProvider.secondaryTextColor,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
