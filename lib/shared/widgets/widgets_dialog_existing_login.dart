import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import 'package:versify/providers/providers_home/theme_data_provider.dart';

class DialogExistingLogin extends StatelessWidget {
  final Function toggleSignIn;

  const DialogExistingLogin({Key key, this.toggleSignIn}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeProvider _themeProvider = Provider.of<ThemeProvider>(context);

    return SimpleDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
      title: Align(
        child: Text(
          "Existing Account",
          style: TextStyle(
              color: _themeProvider.primaryTextColor,
              fontSize: 23,
              fontWeight: FontWeight.w600),
        ),
      ),
      children: [
        Container(
          padding: EdgeInsets.fromLTRB(30, 15, 30, 10),
          alignment: Alignment.center,
          width: 40,
          child: Text(
            "It looks like you already have an account. Sign In instead?",
            textAlign: TextAlign.center,
            style: TextStyle(
                color: _themeProvider.primaryTextColor,
                fontSize: 14,
                fontWeight: FontWeight.w500),
          ),
        ),
        // Divider(thickness: 0.5, height: 0),
        Container(
          margin: EdgeInsets.all(0),
          height: 60,
          child: FlatButton(
            materialTapTargetSize: MaterialTapTargetSize.padded,
            onPressed: () {
              toggleSignIn();
              Navigator.pop(context);
            },
            child: Text(
              "Sign In",
              style: TextStyle(
                color: Colors.blue,
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
            onPressed: () => Navigator.pop(context),
            child: Text(
              "Cancel",
              style: TextStyle(
                color: _themeProvider.secondaryTextColor,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
