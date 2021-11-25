import 'package:flutter/material.dart';
import 'package:open_mail_app/open_mail_app.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:versify/providers/providers_home/theme_data_provider.dart';
import 'package:versify/shared/helper/helper_functions.dart';

class ScreenOpenInbox extends StatelessWidget {
  final String description;

  const ScreenOpenInbox({Key key, this.description}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeProvider _themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 35.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 30),
            Expanded(
              child: Container(),
            ),
            Text(
              "Check your inbox!",
              style: TextStyle(
                  color: _themeProvider.primaryTextColor,
                  fontSize: 39,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Nunito Sans",
                  height: 1.1),
            ),
            Expanded(
              child: Container(),
            ),
            Image(
              height: 250,
              width: 250,
              image: AssetImage("assets/images/email_success.png"),
            ),
            SizedBox(height: 35),
            SizedBox(
              width: 320,
              child: Text(
                description,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: _themeProvider.primaryTextColor,
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  fontFamily: "Nunito Sans",
                ),
              ),
            ),
            SizedBox(height: 35),
            SizedBox(
              height: 65,
              width: MediaQuery.of(context).size.width,
              // margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                ),
                onPressed: () async {
                  final OpenMailAppResult result =
                      await OpenMailApp.openMailApp();
                  if (!result.didOpen && !result.canOpen) {
                    // If no mail apps found, show error
                    toast("Oops! No mail apps installed.");
                  } else if (!result.didOpen && result.canOpen) {
                    showDialog(
                      context: context,
                      builder: (_) {
                        return MailAppPickerDialog(
                          mailApps: result.options,
                        );
                      },
                    );
                  }
                },
                child: Text(
                  "Open email app",
                  style: TextStyle(
                    // shadows: [
                    //   Shadow(
                    //       color: _themeProvider.primaryTextColor26,
                    //       blurRadius: 10,
                    //       offset: Offset(0.5, 0.5))
                    // ],
                    fontFamily: "Nunito Sans",
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            SizedBox(height: 15),
            GestureDetector(
              onTap: () => refreshToWrapper(context),
              child: Padding(
                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                child: Text(
                  "Click to go back to home",
                  style: TextStyle(
                      fontFamily: "Nunito Sans",
                      decoration: TextDecoration.underline,
                      color: _themeProvider.secondaryTextColor,
                      fontWeight: FontWeight.w400,
                      fontSize: 14),
                ),
              ),
            ),
            Expanded(
              child: Container(),
            ),
          ],
        ),
      ),
    );
  }
}
