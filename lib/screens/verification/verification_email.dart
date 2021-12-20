import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:versify/providers/providers_home/theme_data_provider.dart';
import 'package:versify/screens/authentication/auth_screen_open_inbox.dart';
import 'package:versify/services/firebase/auth.dart';
import 'package:versify/services/firebase/dynamic_links.dart';
import "package:versify/shared/helper/helper_functions.dart";
import 'package:versify/shared/helper/helper_methods.dart';

class VerificationEmail extends StatefulWidget {
  final String parsedEmail;

  const VerificationEmail({Key key, this.parsedEmail}) : super(key: key);

  @override
  _VerificationEmailState createState() => _VerificationEmailState();
}

class _VerificationEmailState extends State<VerificationEmail> {
  final TextEditingController textController = TextEditingController();
  final DynamicLinkService dynamicLinkService = DynamicLinkService();

  // VARIABLES
  bool canResendVerification = false;
  bool successSendVerification = false;
  String errorMessageVerification;
  AuthService _authService;

  // FUNCTIONS
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await sendNewEmailVerification();
      startTimer();
    });
  }

  Future<void> sendNewEmailVerification() async {
    try {
      print(purplePen("sendNewEmailVerification | STARTED"));
      final String dynamicLinkUrl = await dynamicLinkService
          .createResetEmailDynamicLink(widget.parsedEmail);

      await _authService.getCurrentUser.verifyBeforeUpdateEmail(
          widget.parsedEmail,
          ActionCodeSettings(
            url: dynamicLinkUrl,
            androidInstallApp: false,
            handleCodeInApp: false,
            androidPackageName: dynamicLinkService.androidPackageName,
            dynamicLinkDomain: dynamicLinkService.domain,
          ));
      print(greenPen("sendNewEmailVerification | SUCCESS"));
      setState(() => successSendVerification = true);
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ScreenOpenInbox(
              description:
                  "Follow the the instructions in the verification email that we have sent to ${widget.parsedEmail}. Your email will be updated after you complete this step.",
            ),
          ));
    } on FirebaseAuthException catch (err) {
      print(redPen(
          "sendNewEmailVerification | FAILED with FBAUTH catch error $err"));
      setState(() => successSendVerification = false);
      toast("Could not update email");
      setState(() => errorMessageVerification =
          "Could not update email. ${err.message}");
    } catch (err) {
      print(redPen("sendNewEmailVerification | FAILED with catch error $err"));
      setState(() => successSendVerification = false);
      if (err.message == "INVALID_NEW_EMAIL") {
        toast("Could not update email. This email is invalid.");
        setState(() => errorMessageVerification =
            "Could not update email. The new email address provided is invalid, please try again.");
      } else {
        toast("Could not update email");
        setState(() => errorMessageVerification =
            "Could not update email, please try again. Contact customer service if the problem persists.");
      }
    }
  }

  // VARIABLES
  Timer timer;
  int resendCountDown = 0;

  void startTimer() {
    resendCountDown = 120;
    canResendVerification = false;
    const Duration oneSec = Duration(seconds: 1);
    timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (resendCountDown == 0) {
          setState(() {
            canResendVerification = true;
            timer.cancel();
          });
        } else {
          setState(() {
            resendCountDown--;
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeProvider _themeProvider =
        Provider.of<ThemeProvider>(context, listen: false);
    _authService = Provider.of<AuthService>(context);

    return WillPopScope(
      onWillPop: () async {
        if (Navigator.of(context).userGestureInProgress) {
          return false;
        } else {
          cancelVerificationDialog(context);
          return false;
        }
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          backgroundColor: Theme.of(context).backgroundColor,
          centerTitle: true,
          elevation: 0.5,
          title: Text(
            "Verification",
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
              primary: Theme.of(context).backgroundColor,
            ),
            onPressed: () {
              cancelVerificationDialog(context);
            },
            child: Text(
              "Cancel",
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
              Padding(
                padding: EdgeInsets.fromLTRB(2, 0, 20, 0),
                child: Text(
                  "Email verification",
                  style: TextStyle(
                    fontSize: 14,
                    color: _themeProvider.secondaryTextColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              SizedBox(height: 15),
              Padding(
                padding: EdgeInsets.fromLTRB(2, 0, 20, 0),
                child: SizedBox(
                  child: Text(
                    successSendVerification
                        ? "Follow the the instructions in the verification email that we have sent to ${widget.parsedEmail}. Your email will be updated after you complete this step."
                        : errorMessageVerification ?? "Sending...",
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
                padding: EdgeInsets.fromLTRB(2, 0, 20, 0),
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () async {
                    if (canResendVerification) {
                      await sendNewEmailVerification();
                      startTimer();
                    } else {
                      toast(
                          "Please wait for 2 minutes before requesting another email.");
                    }
                  },
                  child: SizedBox(
                    child: Text(
                      resendCountDown == 0
                          ? "Resend email"
                          : "Resend email ($resendCountDown)",
                      style: TextStyle(
                        height: 1.7,
                        fontSize: 12,
                        color: canResendVerification
                            ? Colors.blue[400]
                            : _themeProvider.primaryTextColor.withOpacity(0.26),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
  }
}
