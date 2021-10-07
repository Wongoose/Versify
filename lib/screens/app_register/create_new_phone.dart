import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:versify/providers/providers_home/profile_data_provider.dart';
import 'package:versify/providers/providers_home/theme_data_provider.dart';
import 'package:versify/screens/profile/settings/account_edit_row.dart';
import 'package:versify/screens/profile/settings/account_verification.dart';
import 'package:versify/services/firebase/auth.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:versify/services/firebase/database.dart';
import 'package:versify/services/firebase/profile_database.dart';
import 'package:versify/shared/widgets/widgets_all_loading.dart';
import 'package:versify/shared/widgets/widgets_all_loading.dart';
import 'package:versify/wrapper.dart';

// ignore: must_be_immutable
class CreateNewPhone extends StatefulWidget {
  final TextEditingController usernameController;

  CreateNewPhone({
    this.usernameController,
  });

  @override
  _CreateNewPhoneState createState() => _CreateNewPhoneState();
}

class _CreateNewPhoneState extends State<CreateNewPhone> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  ProfileDataProvider _profileDataProvider;
  AuthService _authService;
  ProfileDBService _profileDBService;

  bool isValidPhone = false;
  bool _validLoading = false;

  int resendingToken;

  // PhoneNumber initNumber;

  // void initState() {
  //   super.initState();
  //   print('Phone initState RAN');
  //   initNumber =
  //       PhoneNumber(isoCode: 'MY', phoneNumber: widget.phoneController.text);
  // }

  Future<void> _fetchUrl() async {
    var url = Uri.parse(
        'http://apilayer.net/api/validate?access_key=45149a78db0ccc272062dd240ce4d350&number=${_profileDataProvider.phoneNumberNewAcc.phoneNumber}&country_code=&format=1');
    var response = await http.get(url);
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (json.decode(response.body)['valid'] == true) {
      print('Json Decode is Valid!');
      isValidPhone = true;
    } else {
      isValidPhone = false;
    }
  }

  Future<void> _phoneVerificationSuccess() async {
    print('Phone Verification Success | updatePhoneVerification');

    // Navigator.pushAndRemoveUntil(context,
    //     MaterialPageRoute(builder: (context) => Wrapper()), (route) => false);

    // print('Phone number: ' + _authService.getCurrentUser.phoneNumber);

    // DatabaseService().firestoreCreateAccount(
    //   completeLogin: true,
    //   email: _authService.getCurrentUser.email,
    //   phone: _authService.getCurrentUser.phoneNumber,
    //   username: widget.usernameController.text,
    //   userUID: _authService.getCurrentUser.uid,
    // );

    // Navigator.popUntil(
    //     context, ModalRoute.withName(Navigator.defaultRouteName));

    //then wrapper listens to auth and redirect to homeWrapper

    // DatabaseService()
    //     .updateNewAccUser(
    //   uid: _authService.authUser.uid,
    //   username: widget.usernameController.text,
    //   phone: phoneNumber,
    //   email: _authService.authUser.email,
    // )
    //     .then((_) async {
    //   _profileDataProvider.updateListeners();
    //   Navigator.push(
    //       context,
    //       MaterialPageRoute(
    //         builder: (context) => Wrapper(),
    //       ));
    // });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeProvider _themeProvider =
        Provider.of<ThemeProvider>(context, listen: false);
    _profileDBService = Provider.of<ProfileDBService>(context);
    _authService = Provider.of<AuthService>(context);
    _profileDataProvider =
        Provider.of<ProfileDataProvider>(context, listen: false);

    print('PHONE Build with authUser: ' +
        AuthService().getCurrentUser.toString());

    if (AuthService().getCurrentUser.phoneNumber != null) {
      //bug error getter 'phoneNumber' was called on null
      print('Already Got Phone Number!');
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => Wrapper()),
          (route) => false,
        );
      });
      return SplashLoading();
    } else {
      return WillPopScope(
        onWillPop: () async {
          if (Navigator.of(context).userGestureInProgress)
            return false;
          else
            return false;
        },
        child: Scaffold(
          backgroundColor: Theme.of(context).backgroundColor,
          appBar: AppBar(
            backgroundColor: Theme.of(context).backgroundColor,
            centerTitle: true,
            elevation: 0.5,
            title: Text(
              'Phone',
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
              //skip or back
              child: Text(
                'Skip',
                style: TextStyle(
                  fontSize: 14,
                  color: _themeProvider.secondaryTextColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => Wrapper()),
                  (route) => false,
                );
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //       builder: (context) => Wrapper(),
                //     ));
                // pop or reload()
                // Navigator.pop(context);
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
                  'Done',
                  style: TextStyle(
                    fontSize: 14,
                    color: this
                            ._profileDataProvider
                            .phoneNumberNewAcc
                            .phoneNumber
                            .isNotEmpty
                        ? Theme.of(context).primaryColor
                        : _themeProvider.primaryTextColor.withOpacity(0.26),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onPressed: () async {
                  if (isValidPhone &&
                      this
                          ._profileDataProvider
                          .phoneNumberNewAcc
                          .phoneNumber
                          .isNotEmpty) {
                    setState(() => _validLoading = true);

                    _fetchUrl().then((_) {
                      formKey.currentState.validate();
                      if (isValidPhone) {
                        //auth phone verification
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => new AccountVerification(
                                accEditType: AccountEditType.phone,
                                parsedText: _profileDataProvider
                                    .phoneNumberNewAcc.phoneNumber,
                                resendingToken: resendingToken,
                                verificationSuccessFunc:
                                    _phoneVerificationSuccess,

                                // DatabaseService()
                                //     .updateNewAccUser(
                                //   uid: _user.userUID,
                                //   username: widget.usernameController.text,
                                //   phone: _profileDataProvider
                                //       .phoneNumberNewAcc.phoneNumber,
                                //   email: _authService.authUser.email,
                                // )
                                //     .then((value) async {
                                //   _profileDataProvider.updateListeners();
                                //   Navigator.push(
                                //       context,
                                //       MaterialPageRoute(
                                //         builder: (context) => Wrapper(),
                                //       ));
                                // });
                              ),
                            ));
                      }
                      setState(() => _validLoading = false);
                    });
                  }
                  // formKey.currentState.validate();
                  // String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
                  // RegExp regExp = new RegExp(pattern);

                  // bool hasMatch = regExp.hasMatch(widget.initNumber.phoneNumber);
                  // print('REGEX Valid Phone: ' + hasMatch.toString());
                  // Navigator.pop(context);
                },
              ),
            ],
          ),
          body: Padding(
            padding: EdgeInsets.fromLTRB(0, 20, 0, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: Text(
                    'Phone number',
                    style: TextStyle(
                      fontSize: 14,
                      color: _themeProvider.secondaryTextColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                SizedBox(height: 5),
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: Form(
                      key: formKey,
                      child: Container(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              InternationalPhoneNumberInput(
                                // errorMessage: 'hello',
                                validator: (_) {
                                  return isValidPhone
                                      ? null
                                      : 'Invalid phone number';
                                },
                                onInputChanged: (PhoneNumber number) {
                                  // setState(() {
                                  isValidPhone = true;
                                  print('onINputCHnaged');
                                  formKey.currentState.validate();
                                  // });
                                  this._profileDataProvider.phoneNumberNewAcc =
                                      number;
                                  print(this
                                      ._profileDataProvider
                                      .phoneNumberNewAcc
                                      .phoneNumber);
                                },
                                onInputValidated: (bool value) {
                                  print(value);
                                },
                                selectorConfig: SelectorConfig(
                                  selectorType: PhoneInputSelectorType.DIALOG,
                                ),
                                ignoreBlank: false,
                                autoValidateMode: AutovalidateMode.disabled,
                                textStyle: TextStyle(
                                  color: _themeProvider.primaryTextColor,
                                ),
                                selectorTextStyle: TextStyle(
                                    color: _themeProvider.primaryTextColor),
                                initialValue:
                                    _profileDataProvider.phoneNumberNewAcc,

                                formatInput: false,
                                // keyboardType: TextInputType.numberWithOptions(
                                //     signed: true, decimal: true),
                                inputBorder: OutlineInputBorder(),

                                onSaved: (PhoneNumber number) {
                                  print('On Saved: $number');
                                },
                                spaceBetweenSelectorAndTextField: 2,
                                inputDecoration: InputDecoration(
                                  suffix: Visibility(
                                    visible: _validLoading,
                                    child: CircleLoading(),
                                  ),
                                  prefixStyle: TextStyle(
                                      color: _themeProvider.secondaryTextColor,
                                      fontSize: 15),
                                  isDense: true,
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: _themeProvider.primaryTextColor
                                            .withOpacity(0.26),
                                        width: 0.5),
                                  ),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: _themeProvider.primaryTextColor
                                            .withOpacity(0.26),
                                        width: 0.5),
                                  ),
                                ),
                              ),
                            ]),
                      )),
                ),
                SizedBox(height: 15),
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: SizedBox(
                    child: Text(
                      'Your privacy is guaranteed.\nYour phone number is used to enhance the security of your account.',
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
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => Wrapper()),
                          (route) => false);

                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //       builder: (context) => Wrapper(),
                      //     ));
                    },
                    child: SizedBox(
                      child: Text(
                        'I\'ll do it later.',
                        style: TextStyle(
                          height: 1.7,
                          fontSize: 12,
                          color: Colors.blue[400],
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

  // void getPhoneNumber(String phoneNumber) async {
  //   PhoneNumber number =
  //       await PhoneNumber.getRegionInfoFromPhoneNumber(phoneNumber, 'MYS');

  //   setState(() {
  //     this._profileDataProvider.phoneNumberNewAcc = number;
  //   });
  // }
}
