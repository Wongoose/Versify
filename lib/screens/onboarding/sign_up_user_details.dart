import 'dart:async';

import 'package:versify/screens/onboarding/new_user_options.dart';
import 'package:versify/screens/onboarding/sign_up_phone.dart';
import 'package:versify/screens/profile_screen/profile_data_provider.dart';
import 'package:versify/services/auth.dart';
import 'package:versify/services/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:provider/provider.dart';
import 'package:vibration/vibration.dart';

class SignUpDetails extends StatefulWidget {
  @override
  _SignUpDetailsState createState() => _SignUpDetailsState();
}

class _SignUpDetailsState extends State<SignUpDetails> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  ProfileDataProvider _profileDataProvider;
  PhoneNumber _phoneNumber = PhoneNumber(isoCode: 'US', phoneNumber: '');

  bool _validUsername = false;
  Timer _debounce;
  bool _validLoading = true;
  String _text = '';

  Future<void> _checkForValidUsername(String username) async {
    DatabaseService().checkValidUsername(username).then((isValid) {
      setState(() {
        _validUsername = isValid;
        _validLoading = false;
      });
    });
  }

  _onUsernameChanged(String username) {
    if (!_validLoading) {
      setState(() {
        _validUsername = false;
        _validLoading = true;
      });
    }

    if (_debounce?.isActive ?? false) _debounce.cancel();
    _debounce = Timer(const Duration(seconds: 1), () {
      if (username != '') {
        _checkForValidUsername(username);
      }
    });
  }

  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _profileDataProvider.phoneNumberNewAcc = _phoneNumber;
    });
  }

  @override
  Widget build(BuildContext context) {
    final AuthService _authService = Provider.of<AuthService>(context);
    _profileDataProvider =
        Provider.of<ProfileDataProvider>(context, listen: false);

    return WillPopScope(
      onWillPop: () {
        _authService.logout();
        return null;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          elevation: 0.5,
          title: Text(
            'Username',
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
              // _profileDataProvider.updateListeners();
              _authService.logout();
              // Navigator.pop(context);
            },
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                backgroundColor: Colors.white,
              ),
              child: Text(
                'Next',
                style: TextStyle(
                  fontSize: 14,
                  color: _validUsername ? Color(0xffff548e) : Colors.black26,
                  fontWeight: FontWeight.w600,
                ),
              ),
              onPressed: () {
                if (_validUsername && _usernameController.text != '') {
                  Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => SignUpPhone(
                          usernameController: _usernameController,
                          phoneController: _phoneController,
                          routeName: Navigator.defaultRouteName,
                        ),
                      ));
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
              Text(
                'Choose your username',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black45,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 5),
              TextFormField(
                autofocus: true,
                controller: _usernameController,
                maxLengthEnforced: true,
                maxLength: 20,
                maxLines: 1,
                inputFormatters: [
                  new FilteringTextInputFormatter.allow(
                      RegExp("[a-z0-9|\\_|\\.]")),
                ],
                cursorColor: Color(0xffff548e),
                // onSaved: (newValue) => ,
                autovalidateMode: AutovalidateMode.always,
                onChanged: (newVal) {
                  if (newVal.length <= 20) {
                    _text = newVal;
                  } else {
                    Vibration.vibrate(duration: 200);
                    _usernameController.value = new TextEditingValue(
                        text: _text,
                        selection: new TextSelection(
                            baseOffset: 20,
                            extentOffset: 20,
                            affinity: TextAffinity.downstream,
                            isDirectional: false),
                        composing: new TextRange(start: 0, end: 20));

                    _usernameController.text = _text;
                  }
                  _onUsernameChanged(newVal);
                },
                buildCounter: (_, {currentLength, maxLength, isFocused}) {
                  return Visibility(
                    visible: true,
                    child: Container(
                      padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '${currentLength.toString()}/${maxLength.toString()}',
                        style: TextStyle(
                          fontSize: 12,
                          color: currentLength > maxLength
                              ? Colors.red
                              : Colors.black54,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  );
                },
                decoration: InputDecoration(
                  prefixText: '@ ',
                  suffix: Visibility(
                    visible: !_validLoading,
                    child: _validUsername
                        ? Icon(
                            FontAwesomeIcons.checkCircle,
                            size: 18,
                            color: Colors.tealAccent[400],
                          )
                        : Icon(
                            Icons.cancel_outlined,
                            size: 20,
                            color: Colors.redAccent,
                          ),
                    replacement: SizedBox(
                      height: 15,
                      width: 15,
                      child: CircularProgressIndicator(
                        strokeWidth: 0.5,
                      ),
                    ),
                  ),
                  prefixStyle: TextStyle(color: Colors.black45, fontSize: 15),
                  isDense: true,
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black26, width: 0.5),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black26, width: 0.5),
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
