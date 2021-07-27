import 'package:overlay_support/overlay_support.dart';
import 'package:versify/providers/home/theme_data_provider.dart';
import 'package:versify/screens/profile_screen/settings/account_edit_row.dart';
import 'package:versify/services/auth.dart';
import 'package:versify/services/profile_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'account_provider.dart';

class AccountVerification extends StatefulWidget {
  final AccountEditType accEditType;
  final String parsedText;
  final Function verificationSuccessFunc;
  int resendingToken;

  AccountVerification({
    @required this.accEditType,
    @required this.parsedText,
    @required this.verificationSuccessFunc,
    this.resendingToken,
  });

  @override
  _AccountVerificationState createState() => _AccountVerificationState();
}

class _AccountVerificationState extends State<AccountVerification> {
  final TextEditingController _textController = TextEditingController();
  ProfileDBService _profileDBService;
  AuthService _authService;
  AccountSettingsProvider _accountSettingsProvider;
  FirebaseAuth _auth = FirebaseAuth.instance;

  ThemeProvider _themeProvider;
  String _verificationId;
  Duration timeout = Duration(seconds: 120);
  bool canResendToken = false;

  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      if (widget.accEditType == AccountEditType.phone) {
        //phone verification
        verifyPhoneNumber();
      } else {
        //email verification
        try {
          await _authService
              .signInWithGoogle(newUser: false)
              .then((value) async {
            await _auth.currentUser
                .verifyBeforeUpdateEmail(widget.parsedText)
                .then((_) {
              // _authService.myUser.email = widget.parsedText;
              // _profileDBService.updateEmailVerification(
              // email: _authService.myUser.email,
              // );
            });
          });
        } catch (err) {
          print('Error verify email: ' + err.toString());
        }
      }
    });
  }

  Future<void> verifyPhoneNumber({int forceResendingToken}) async {
    setState(() => canResendToken = false);
    if (forceResendingToken == null) {
      await _auth.verifyPhoneNumber(
        timeout: timeout,
        phoneNumber: widget.parsedText,

        //resendingToken
        verificationCompleted: (phoneAuthCredential) {
          phoneVerificationComplete(phoneAuthCredential);
        },
        verificationFailed: (authException) {
          print('Failed Verification with ${authException.toString()}');
          toast('Unable to verify with ${authException.phoneNumber}.',
              duration: Toast.LENGTH_LONG);
        },
        codeSent: (verificationId, resendingToken) {
          widget.resendingToken = resendingToken;
          print('Code was sent \n$verificationId and \n$resendingToken');
          toast('Verification code was sent to ${widget.parsedText}.',
              duration: Toast.LENGTH_LONG);

          setState(() => _verificationId = verificationId);
        },
        codeAutoRetrievalTimeout: (_) {
          // toast("Request time out. Please click 'resend code' and try again.",
          //     duration: Toast.LENGTH_LONG);

          print('Too late');
          setState(() => canResendToken = true);
        },
      );
    } else {
      print('verifyPhoneNumber | with resendingToken: $forceResendingToken');
      await _auth.verifyPhoneNumber(
        timeout: timeout,
        phoneNumber: widget.parsedText,
        forceResendingToken: forceResendingToken,
        verificationCompleted: (phoneAuthCredential) {
          phoneVerificationComplete(phoneAuthCredential);
        },
        verificationFailed: (authException) {
          print('Failed Verification with ${authException.toString()}');
          toast('Unable to verify with ${authException.phoneNumber}.',
              duration: Toast.LENGTH_LONG);
        },
        codeSent: (verificationId, resendingToken) {
          widget.resendingToken = resendingToken;
          print('Code was sent \n$verificationId and \n$resendingToken');
          toast('Verification code was sent to ${widget.parsedText}.',
              duration: Toast.LENGTH_LONG);

          setState(() => _verificationId = verificationId);
        },
        codeAutoRetrievalTimeout: (_) {
          // toast("Request time out. Please click 'resend code' and try again.",
          //     duration: Toast.LENGTH_LONG);
          setState(() => canResendToken = true);

          print('Too late');
        },
      );
    }
  }

  Future<void> phoneVerificationComplete(AuthCredential credential) async {
    try {
      // await _auth.currentUser.updatePhoneNumber(credential);
      await _auth.currentUser.updatePhoneNumber(credential).then((_) {
        if (_auth.currentUser != null) {
          print(
              'Success Code Verification! | phone: ${_authService.myUser.phoneNumber}');

          _profileDBService.updatePhoneVerification(
            phone: _authService.getCurrentUser.phoneNumber,
          );

          widget.verificationSuccessFunc();
          toast('Verification successful!', duration: Toast.LENGTH_LONG);
        } else {
          print('No User Code Verification!');
        }
      });
    } catch (err) {
      print(err.toString());
      if (err.code == "invalid-verification-code") {
        toast('Invalid verification code. Please check again.',
            duration: Toast.LENGTH_LONG);
      } else if (err.code == "invalid-verification-id") {
        toast("Failed to verify phone number. Please click 'resend code'.",
            duration: Toast.LENGTH_LONG);
      }
    }
  }

  Future<void> _onWillPopDialog() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return SimpleDialog(
            title: Align(
              alignment: Alignment.center,
              child: Text(
                'Warning',
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
                  'Verification is still in progress. Do you want to cancel the verification process?',
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
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Yes, cancel',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 16,
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
                    'No, go back',
                    style: TextStyle(
                      color: _themeProvider.primaryTextColor,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          );
        });
  }

  // void postFrameCheck() {
  //   WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
  //     if (_verificationId == null) {
  //       setState(() => canResendToken = true);
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    _themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    _authService = Provider.of<AuthService>(context);
    _profileDBService = Provider.of<ProfileDBService>(context);

    _accountSettingsProvider =
        Provider.of<AccountSettingsProvider>(context, listen: false);

    print('ResendingToken is: ' + widget.resendingToken.toString());

    return WillPopScope(
      onWillPop: () async {
        if (Navigator.of(context).userGestureInProgress) {
          return false;
        } else {
          await _onWillPopDialog();
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
            'Verification',
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
            child: Text(
              'Cancel',
              style: TextStyle(
                fontSize: 14,
                color: _themeProvider.secondaryTextColor,
                fontWeight: FontWeight.w500,
              ),
            ),
            onPressed: () {
              _onWillPopDialog();
            },
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                backgroundColor: Theme.of(context).backgroundColor,
                primary: Theme.of(context).backgroundColor,
              ),
              child: Text(
                widget.accEditType == AccountEditType.email
                    ? 'Close'
                    : 'Confirm',
                style: TextStyle(
                  fontSize: 14,
                  color: _verificationId != null ||
                          widget.accEditType == AccountEditType.email
                      ? Theme.of(context).primaryColor
                      : Theme.of(context).primaryColor.withOpacity(0.4),
                  fontWeight: FontWeight.w600,
                ),
              ),
              onPressed: () async {
                if (widget.accEditType == AccountEditType.phone) {
                  if (_verificationId != null) {
                    PhoneAuthCredential _credential =
                        PhoneAuthProvider.credential(
                      verificationId: _verificationId,
                      smsCode: _textController.text,
                    );

                    await phoneVerificationComplete(_credential);
                  }
                } else {
                  _accountSettingsProvider.updateProfileData();
                  //email
                  Navigator.pop(context);
                  Navigator.pop(context);
                }
              },
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
                  widget.accEditType == AccountEditType.phone
                      ? 'Enter 6-digit OTP'
                      : 'Verification email',
                  style: TextStyle(
                    fontSize: 14,
                    color: _themeProvider.secondaryTextColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              SizedBox(
                  height: widget.accEditType == AccountEditType.phone ? 15 : 0),
              widget.accEditType == AccountEditType.phone
                  ? TextFormField(
                      autofocus: true,
                      controller: _textController,
                      maxLines: 1,
                      keyboardType: TextInputType.phone,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      cursorColor: Theme.of(context).primaryColor,
                      // validator: (text) {
                      //   return text.contains(' ') ? '' : text;
                      // },
                      style: TextStyle(
                        color: _themeProvider.primaryTextColor,
                      ),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(8),
                        prefixStyle: TextStyle(
                            color: _themeProvider.secondaryTextColor,
                            fontSize: 15),
                        isDense: false,
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: _themeProvider.primaryTextColor
                                  .withOpacity(0.26),
                              width: 0.5),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: _themeProvider.primaryTextColor
                                  .withOpacity(0.26),
                              width: 0.5),
                        ),
                      ),
                    )
                  : Container(),
              SizedBox(height: 15),
              Padding(
                padding: EdgeInsets.fromLTRB(2, 0, 20, 0),
                child: SizedBox(
                  child: Text(
                    widget.accEditType == AccountEditType.phone
                        ? 'A verification code was sent to ${widget.parsedText}. If you have not received the code within 2 minutes, click resend.'
                        : 'A verification email was sent to ${widget.parsedText}. Please check your inbox. Your email will be updated after it is verified.',
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
                    if (canResendToken) {
                      verifyPhoneNumber(
                          forceResendingToken: widget.resendingToken);
                    } else {
                      toast(
                          "You can only resend verification once every 2 minutes. Please wait and try again later.");
                    }
                  },
                  child: SizedBox(
                    child: Text(
                      'Resend code',
                      style: TextStyle(
                        height: 1.7,
                        fontSize: 12,
                        color: canResendToken
                            ? Colors.blue[400]
                            : _themeProvider.primaryTextColor.withOpacity(0.26),
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
