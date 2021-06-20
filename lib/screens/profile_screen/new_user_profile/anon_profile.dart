import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:versify/providers/home/theme_data_provider.dart';
import 'package:versify/providers/home/tutorial_provider.dart';

class AnonUserProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ThemeProvider _themeProvider =
        Provider.of<ThemeProvider>(context, listen: false);
    final TutorialProvider _tutorialProvider =
        Provider.of<TutorialProvider>(context);

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: null,
      body: Padding(
        padding: EdgeInsets.fromLTRB(20, 0, 20, 55),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(flex: 1, child: Container()),
            SizedBox(height: 30),

            Image.asset(
              'assets/images/user.png',
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
                    text: 'Create',
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 35,
                        fontFamily: 'Nunito',
                        fontWeight: FontWeight.w600,
                        height: 1.1),
                  ),
                  TextSpan(
                    text: ' account',
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
              width: 250,
              child: Text(
                'Sign up now to unlock more hidden features!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: _themeProvider.secondaryTextColor,
                ),
              ),
            ),
            // SizedBox(height: 30),
            Expanded(flex: 1, child: Container()),
            TextButton.icon(
              style: TextButton.styleFrom(
                padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                primary: Theme.of(context).primaryColor,
                backgroundColor: Theme.of(context).primaryColor,
              ),
              onPressed: () {},
              label: Text(
                'Sign up',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontFamily: 'Nunito',
                ),
              ),
              icon: Icon(
                FontAwesomeIcons.user,
                size: 20,
                color: Colors.white,
              ),
            ),
            // _tutorialProvider.signUpProfileNotif
            //     ? BouncingSignUp()
            //     : TextButton.icon(
            //         style: TextButton.styleFrom(
            //           padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
            //           shape: RoundedRectangleBorder(
            //             borderRadius: BorderRadius.circular(15),
            //           ),
            //           primary: Theme.of(context).primaryColor,
            //           backgroundColor: Theme.of(context).primaryColor,
            //         ),
            //         onPressed: () {},
            //         label: Text(
            //           'Sign up',
            //           style: TextStyle(
            //             color: Colors.white,
            //             fontSize: 16,
            //             fontFamily: 'Nunito',
            //           ),
            //         ),
            //         icon: Icon(
            //           FontAwesomeIcons.user,
            //           size: 20,
            //           color: Colors.white,
            //         ),
            //       ),
            SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}

class BouncingSignUp extends StatefulWidget {
  const BouncingSignUp({
    Key key,
  }) : super(key: key);

  @override
  _BouncingSignUpState createState() => _BouncingSignUpState();
}

class _BouncingSignUpState extends State<BouncingSignUp> {
  double marginTop = 1;
  double start;
  double end;
  double increment;

  Timer timer;

  bool isGoingDown = true;

  void bounce(Timer t) async {
    timer = t;
    if (marginTop <= start) {
      setState(() {
        marginTop += increment;
        isGoingDown = true;
      });
    } else if (marginTop >= end) {
      setState(() {
        marginTop -= increment;
        isGoingDown = false;
      });
    }

    if (marginTop < end && marginTop > start) {
      if (isGoingDown) {
        setState(() {
          marginTop += increment;
        });
      } else {
        setState(() {
          marginTop -= increment;
        });
      }
    }
  }

  void interpolate(double start, double end) {
    setState(() {
      increment = (end - start) / 50;
    });
  }

  @override
  void initState() {
    super.initState();
    marginTop = 1;
    start = 1;
    end = 6;
    interpolate(start, end);
    Timer.periodic(const Duration(milliseconds: 4), bounce);
  }

  void dispose() {
    super.dispose();
    timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeProvider _themeProvider =
        Provider.of<ThemeProvider>(context, listen: false);
    return Container(
      margin: EdgeInsets.only(top: marginTop),
      child: TextButton.icon(
        style: TextButton.styleFrom(
          padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          primary: Theme.of(context).primaryColor,
          backgroundColor: Theme.of(context).primaryColor,
        ),
        onPressed: () {},
        label: Text(
          'Sign up',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontFamily: 'Nunito',
          ),
        ),
        icon: Icon(
          FontAwesomeIcons.user,
          size: 20,
          color: Colors.white,
        ),
      ),
    );
  }
}
