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

  AccountVerification({this.accEditType, this.parsedText});

  @override
  _AccountVerificationState createState() => _AccountVerificationState();
}

class _AccountVerificationState extends State<AccountVerification> {
  final TextEditingController _textController = TextEditingController();
  ProfileDBService _profileDBService;
  AuthService _authService;
  AccountSettingsProvider _accountSettingsProvider;
  FirebaseAuth _auth = FirebaseAuth.instance;

  String _verificationId;

  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      if (widget.accEditType == AccountEditType.phone) {
        await _auth.verifyPhoneNumber(
          timeout: Duration(seconds: 120),
          phoneNumber: widget.parsedText,
          verificationCompleted: (phoneAuthCredential) {
            phoneVerificationComplete(phoneAuthCredential);
          },
          verificationFailed: (authException) {
            print('Failed Verificatin with ${authException.toString()}');
          },
          codeSent: (verificationId, resendingToken) {
            print('Code was sent \n$verificationId and \n$resendingToken');
            setState(() => _verificationId = verificationId);
          },
          codeAutoRetrievalTimeout: (_) {
            print('Too late');
          },
        );
      } else {
        try {
          await _authService
              .signInWithGoogle(newUser: false)
              .then((value) async {
            await _auth.currentUser
                .verifyBeforeUpdateEmail(widget.parsedText)
                .then((_) {
              _authService.myUser.email = widget.parsedText;
              _profileDBService.updateEmailVerification(
                email: _authService.myUser.email,
              );
            });
          });
        } catch (err) {
          print('Error verify email: ' + err.toString());
        }
      }
    });
  }

  Future<void> phoneVerificationComplete(AuthCredential credential) async {
    try {
      // await _auth.currentUser.updatePhoneNumber(credential);
      await _auth.currentUser.updatePhoneNumber(credential).then((_) {
        if (_auth.currentUser != null) {
          print('Success Code Verification!');
          _authService.myUser.phoneNumber = widget.parsedText;

          if (widget.accEditType == AccountEditType.phone) {
            _profileDBService.updatePhoneVerification(
              phone: _authService.myUser.phoneNumber,
            );
          }
          _accountSettingsProvider.updateProfileData();

          Navigator.pop(context);
          Navigator.pop(context);
        } else {
          print('No User Code Verification!');
        }
      });
    } catch (err) {
      print(err.toString());
      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //   content: Text('Failed to update phone number. An error has occured.'),
      // ));
      Navigator.pop(context);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    _authService = Provider.of<AuthService>(context);
    _profileDBService = Provider.of<ProfileDBService>(context);

    _accountSettingsProvider =
        Provider.of<AccountSettingsProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0.5,
        title: Text(
          'Verification',
          style: TextStyle(
            fontSize: 17.5,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        leadingWidth: 60,
        leading: TextButton(
          style: TextButton.styleFrom(
            padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
            backgroundColor: Colors.white,
          ),
          child: Text(
            'Cancel',
            style: TextStyle(
              fontSize: 14,
              color: Colors.black54,
              fontWeight: FontWeight.w500,
            ),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
              backgroundColor: Colors.white,
            ),
            child: Text(
              'Confirm',
              style: TextStyle(
                fontSize: 14,
                color: _verificationId != null ||
                        widget.accEditType == AccountEditType.email
                    ? Color(0xffff548e)
                    : Color(0xffff548e).withOpacity(0.4),
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
                    ? 'Verification code'
                    : 'Verification email',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black45,
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
                    maxLines:
                        widget.accEditType == AccountEditType.bio ? null : 1,
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    cursorColor: Color(0xffff548e),
                    // validator: (text) {
                    //   return text.contains(' ') ? '' : text;
                    // },

                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(8),
                      prefixText: widget.accEditType == AccountEditType.username
                          ? '@ '
                          : '',
                      prefixStyle:
                          TextStyle(color: Colors.black45, fontSize: 15),
                      isDense: false,
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.black26, width: 0.5),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.black26, width: 0.5),
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
                      ? 'A verification code was sent to your device. If you have not received the code after 1 minute, click resend.'
                      : 'A verification email was sent to ${widget.parsedText}. Please check your inbox to verify your new email.',
                  style: TextStyle(
                    height: 1.7,
                    fontSize: 12,
                    color: Colors.black54,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
