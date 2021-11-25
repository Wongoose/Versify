import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:versify/providers/providers_home/theme_data_provider.dart';
import 'package:versify/screens/app_register/create_new_phone.dart';
import 'package:versify/providers/providers_home/profile_data_provider.dart';
import 'package:versify/services/firebase/auth.dart';
import 'package:versify/services/firebase/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:provider/provider.dart';
import 'package:versify/shared/widgets/widgets_all_loading.dart';
import 'package:versify/shared/widgets/widgets_username_validating_textfield.dart';
import 'package:vibration/vibration.dart';

class CreateNewUsername extends StatefulWidget {
  @override
  _CreateNewUsernameState createState() => _CreateNewUsernameState();
}

class _CreateNewUsernameState extends State<CreateNewUsername> {
  final TextEditingController _usernameController = TextEditingController();

  DatabaseService _databaseService;
  AuthService _authService;
  ProfileDataProvider _profileDataProvider;

  PhoneNumber _phoneNumber = PhoneNumber(isoCode: 'US', phoneNumber: '');

  bool _validUsername = false;
  // Timer _debounce;
  bool _nextLoading = false;

  void updateValidUsername(
      {@required bool validUsername, @required bool isSetState}) {
    _validUsername = validUsername;
    if (isSetState) {
      setState(() {});
    }
  }

  // Future<void> _checkForValidUsername(String username) async {
  //   _databaseService.checkIfValidUsername(username).then((isValid) {
  //     setState(() {
  //       _validUsername = isValid;
  //       _validLoading = false;
  //     });
  //   });
  // }

  // _onUsernameChanged(String username) {
  //   setState(() {
  //     _validUsername = false;
  //     _validLoading = true;
  //   });

  //   if (_debounce?.isActive ?? false) _debounce.cancel();
  //   _debounce = Timer(const Duration(seconds: 1), () {
  //     if (username != '') {
  //       _checkForValidUsername(username);
  //     }
  //   });
  // }

  Future<void> onWillPop() async {
    await FirebaseAuth.instance.currentUser.delete();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _profileDataProvider.phoneNumberNewAcc = PhoneNumber(
          phoneNumber: _authService.getCurrentUser.phoneNumber ?? '');
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeProvider _themeProvider =
        Provider.of<ThemeProvider>(context, listen: false);
    _authService = Provider.of<AuthService>(context);
    _databaseService = Provider.of<DatabaseService>(context);
    _profileDataProvider =
        Provider.of<ProfileDataProvider>(context, listen: false);

    return WillPopScope(
      onWillPop: () async {
        if (!Navigator.of(context).userGestureInProgress) {
          // await onWillPop();
          _authService.logout();
        }
        return null;
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          backgroundColor: Theme.of(context).backgroundColor,
          centerTitle: true,
          elevation: 0.5,
          title: Text(
            'Username',
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
            ),
            child: Text(
              'Cancel',
              style: TextStyle(
                fontSize: 14,
                color: _themeProvider.secondaryTextColor,
                fontWeight: FontWeight.w500,
              ),
            ),
            onPressed: () async {
              // _profileDataProvider.updateListeners();
              // await onWillPop();
              _authService.logout();

              // Navigator.pop(context);
            },
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                backgroundColor: Theme.of(context).backgroundColor,
              ),
              child: _nextLoading
                  ? CircleLoading()
                  : Text(
                      'Next',
                      style: TextStyle(
                        fontSize: 14,
                        color: _validUsername
                            ? Theme.of(context).primaryColor
                            : _themeProvider.primaryTextColor.withOpacity(0.26),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
              onPressed: () {
                if (!_nextLoading) {
                  if (_validUsername && _usernameController.text != '') {
                    setState(() => _nextLoading = true);

                    //check database second time
                    _databaseService
                        .checkIfValidUsername(_usernameController.text)
                        .then((isValid) {
                      if (isValid) {
                        // username is 100% valid
                        _databaseService.firestoreCreateAccount(
                          completeLogin: true,
                          email: _authService.getCurrentUser.email,
                          phone: _authService.getCurrentUser.phoneNumber,
                          username: _usernameController.text,
                          userUID: _authService.getCurrentUser.uid,
                        );

                        toast('New account created successfully!');

                        Navigator.pushReplacement(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => CreateNewPhone(
                                usernameController: _usernameController,
                              ),
                            ));
                      } else {
                        // second check is not valid
                        toast(
                            'This username has already been used. Please try another one.');
                        _validUsername = false;
                      }
                      setState(() => _nextLoading = false);
                    });
                  } else {
                    //not valid when typing (instant reject)
                  }
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
                  color: _themeProvider.secondaryTextColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 5),
              UsernameValidatingTextField(
                // onUsernameChanged: _onUsernameChanged,
                usernameController: _usernameController,
                updateValidUsername: updateValidUsername,
              ),
              // TextFormField(
              //   autofocus: true,
              //   controller: _usernameController,
              //   maxLength: 20,
              //   maxLines: 1,
              //   inputFormatters: [
              //     new FilteringTextInputFormatter.allow(
              //         RegExp("[a-z0-9|\\_|\\.]")),
              //   ],
              //   cursorColor: Theme.of(context).primaryColor,
              //   // onSaved: (newValue) => ,
              //   autovalidateMode: AutovalidateMode.always,
              //   onChanged: (newVal) {
              //     if (newVal.length <= 20) {
              //       _text = newVal;
              //     } else {
              //       Vibration.vibrate(duration: 200);
              //       _usernameController.value = new TextEditingValue(
              //           text: _text,
              //           selection: new TextSelection(
              //               baseOffset: 20,
              //               extentOffset: 20,
              //               affinity: TextAffinity.downstream,
              //               isDirectional: false),
              //           composing: new TextRange(start: 0, end: 20));

              //       _usernameController.text = _text;
              //     }
              //     _onUsernameChanged(newVal);
              //   },
              //   buildCounter: (_, {currentLength, maxLength, isFocused}) {
              //     return Visibility(
              //       visible: true,
              //       child: Container(
              //         padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
              //         alignment: Alignment.centerLeft,
              //         child: Text(
              //           '${currentLength.toString()}/${maxLength.toString()}',
              //           style: TextStyle(
              //             fontSize: 12,
              //             color: currentLength > maxLength
              //                 ? Colors.red
              //                 : _themeProvider.secondaryTextColor,
              //             fontWeight: FontWeight.w500,
              //           ),
              //         ),
              //       ),
              //     );
              //   },
              //   style: TextStyle(color: _themeProvider.primaryTextColor),
              //   decoration: InputDecoration(
              //     prefixText: '@ ',
              //     suffix: Visibility(
              //       visible: !_validLoading,
              //       child: _validUsername
              //           ? Icon(
              //               FontAwesomeIcons.checkCircle,
              //               size: 18,
              //               color: Colors.tealAccent[400],
              //             )
              //           : Icon(
              //               Icons.cancel_outlined,
              //               size: 20,
              //               color: Colors.redAccent,
              //             ),
              //       replacement: SizedBox(
              //         height: 15,
              //         width: 15,
              //         child: CircularProgressIndicator(
              //           valueColor: new AlwaysStoppedAnimation<Color>(
              //               Theme.of(context).primaryColor),
              //           strokeWidth: 0.5,
              //         ),
              //       ),
              //     ),
              //     prefixStyle: TextStyle(
              //         color: _themeProvider.secondaryTextColor, fontSize: 15),
              //     isDense: true,
              //     focusedBorder: UnderlineInputBorder(
              //       borderSide: BorderSide(
              //           color:
              //               _themeProvider.primaryTextColor.withOpacity(0.26),
              //           width: 0.5),
              //     ),
              //     enabledBorder: UnderlineInputBorder(
              //       borderSide: BorderSide(
              //           color:
              //               _themeProvider.primaryTextColor.withOpacity(0.26),
              //           width: 0.5),
              //     ),
              //   ),
              // ),
              SizedBox(height: 15),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
                child: SizedBox(
                  child: Text(
                    'Your username is just a nickname. You can always change it later.',
                    style: TextStyle(
                      height: 1.7,
                      fontSize: 12,
                      color: _themeProvider.secondaryTextColor,
                      fontWeight: FontWeight.w500,
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
