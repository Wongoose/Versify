import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:versify/providers/providers_home/theme_data_provider.dart';
import 'package:versify/services/firebase/auth.dart';
import "package:versify/shared/helper/helper_functions.dart";

class VerificationPhone extends StatefulWidget {
  final String parsedPhoneNumber;

  const VerificationPhone({Key key, this.parsedPhoneNumber}) : super(key: key);

  @override
  _VerificationPhoneState createState() => _VerificationPhoneState();
}

class _VerificationPhoneState extends State<VerificationPhone> {
  final TextEditingController textController = TextEditingController();

  bool canResendVerification = false;
  String verificationID;
  int resendingToken;

  AuthService _authService;

  //FUNCTIONS
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _authService.verifyPhoneNumber(
        context,
        widget.parsedPhoneNumber,
        onCodeSent,
      );
      startTimer();
    });
  }

  void onCodeSent(String verificationID, int resendingToken) {
    setState(() {
      this.resendingToken = resendingToken;
      this.verificationID = verificationID;
    });
  }

  Timer timer;
  int resendCountDown;

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
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                backgroundColor: Theme.of(context).backgroundColor,
                primary: Theme.of(context).backgroundColor,
              ),
              onPressed: () async {
                if (verificationID != null) {
                  final PhoneAuthCredential newCredential =
                      PhoneAuthProvider.credential(
                          verificationId: verificationID,
                          smsCode: textController.text.trim());

                  await _authService.updateUserPhoneNumber(
                      context, newCredential);
                }
              },
              child: Text(
                "Confirm",
                style: TextStyle(
                  fontSize: 14,
                  color: verificationID != null
                      ? Theme.of(context).primaryColor
                      : Theme.of(context).primaryColor.withOpacity(0.4),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        body: Padding(
          padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(2, 0, 20, 0),
                child: Text(
                  "Enter 6-digit OTP",
                  style: TextStyle(
                    fontSize: 14,
                    color: _themeProvider.secondaryTextColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              SizedBox(height: 15),
              TextFormField(
                autofocus: true,
                controller: textController,
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                cursorColor: Theme.of(context).primaryColor,
                // validator: (text) {
                //   return text.contains(" ") ? "" : text;
                // },
                style: TextStyle(
                  color: _themeProvider.primaryTextColor,
                ),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(8),
                  prefixStyle: TextStyle(
                      color: _themeProvider.secondaryTextColor, fontSize: 15),
                  isDense: false,
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color:
                            _themeProvider.primaryTextColor.withOpacity(0.26),
                        width: 0.5),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color:
                            _themeProvider.primaryTextColor.withOpacity(0.26),
                        width: 0.5),
                  ),
                ),
              ),
              SizedBox(height: 15),
              Padding(
                padding: EdgeInsets.fromLTRB(2, 0, 20, 0),
                child: SizedBox(
                  child: Text(
                    verificationID != null
                        ? "Enter the verification code that we have sent to ${widget.parsedPhoneNumber}. If you have not received the code within 2 minutes, click resend."
                        : "Sending...",
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
                      await _authService.verifyPhoneNumber(
                        context,
                        widget.parsedPhoneNumber,
                        onCodeSent,
                        resendingToken,
                      );
                      startTimer();
                    } else {
                      toast(
                          "Please wait for 2 minutes before sending another code.");
                    }
                  },
                  child: SizedBox(
                    child: Text(
                      resendCountDown == 0
                          ? "Resend code"
                          : "Resend code ($resendCountDown)",
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
