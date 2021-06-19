import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:versify/providers/home/theme_data_provider.dart';

class AnonUserProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ThemeProvider _themeProvider =
        Provider.of<ThemeProvider>(context, listen: false);

    return Scaffold(
      appBar: null,
      body: Padding(
        padding: EdgeInsets.fromLTRB(30, 0, 20, 55),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(child: Container()),
            Image.asset(
              'assets/images/copywriting.png',
              height: 160,
              width: 160,
            ),
            SizedBox(height: 40),
            SizedBox(
              width: 260,
              child: RichText(
                maxLines: 2,
                textAlign: TextAlign.center,
                text: TextSpan(children: [
                  TextSpan(
                    text: 'Sign',
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 35,
                        fontFamily: 'Nunito',
                        fontWeight: FontWeight.w600,
                        height: 1.1),
                  ),
                  TextSpan(
                    text: ' up',
                    style: TextStyle(
                        color: _themeProvider.primaryTextColor,
                        fontSize: 35,
                        fontFamily: 'Nunito',
                        fontWeight: FontWeight.w600,
                        height: 1.1),
                  )
                ]),
              ),
            ),
            SizedBox(height: 30),
            SizedBox(
              width: 280,
              child: Text(
                'Sign up now to unlock more hidden features!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: _themeProvider.secondaryTextColor,
                ),
              ),
            ),
            SizedBox(height: 30),
            TextButton.icon(
              style: TextButton.styleFrom(
                padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                primary: Theme.of(context).primaryColor,
              ),
              onPressed: () {},
              label: Text(
                'Quick Sign-up',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontFamily: 'Nunito',
                ),
              ),
              icon: Icon(
                FontAwesomeIcons.user,
                size: 22,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 80),
            Expanded(flex: 1, child: Container()),
          ],
        ),
      ),
    );
  }
}
