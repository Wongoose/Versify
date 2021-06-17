import 'dart:convert';
import 'package:versify/models/user_model.dart';
import 'package:versify/providers/home/profile_data_provider.dart';
import 'package:versify/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:versify/services/database.dart';
import 'package:versify/services/profile_database.dart';
import 'package:versify/home_wrapper.dart';
import 'package:versify/wrapper.dart';

// ignore: must_be_immutable
class SignUpPhone extends StatefulWidget {
  final TextEditingController usernameController;
  final TextEditingController phoneController;
  final String routeName;

  SignUpPhone({
    this.usernameController,
    this.routeName,
    this.phoneController,
  });

  @override
  _SignUpPhoneState createState() => _SignUpPhoneState();
}

class _SignUpPhoneState extends State<SignUpPhone> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  ProfileDataProvider _profileDataProvider;
  bool isValidPhone = false;
  bool _validLoading = false;

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

  @override
  Widget build(BuildContext context) {
    final AuthService _authService = Provider.of<AuthService>(context);
    final MyUser _user = Provider.of<MyUser>(context, listen: false);
    _profileDataProvider =
        Provider.of<ProfileDataProvider>(context, listen: false);

    print('PHONE Build');

    return WillPopScope(
      onWillPop: () async {
        if (Navigator.of(context).userGestureInProgress)
          return false;
        else
          return true;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          elevation: 0.5,
          title: Text(
            'Phone',
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
                'Done',
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              onPressed: () async {
                setState(() => _validLoading = true);

                _fetchUrl().then((_) {
                  formKey.currentState.validate();
                  if (isValidPhone) {
                    DatabaseService()
                        .updateNewAccUser(
                      uid: _user.userUID,
                      username: widget.usernameController.text,
                      phone: _profileDataProvider.phoneNumberNewAcc.phoneNumber,
                      email: _authService.authUser.email,
                    )
                        .then((value) async {
                      _profileDataProvider.updateListeners();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Wrapper(),
                          ));

                      // Navigator.popUntil(
                      //     context, ModalRoute.withName(widget.routeName));
                      // await ProfileDBService()
                      //     .whetherHasAccount(_user.userUID)
                      //     .then((user) {
                      //   _authService.myUser = user;
                      //   Navigator.popUntil(context, (route) => false);
                      //   return Navigator.push(
                      //       context,
                      //       MaterialPageRoute(
                      //         builder: (context) => HomeWrapper(),
                      //       ));
                      // });
                    });
                  }
                  setState(() => _validLoading = false);
                });

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
                    color: Colors.black45,
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
                              selectorTextStyle: TextStyle(color: Colors.black),
                              initialValue:
                                  _profileDataProvider.phoneNumberNewAcc,

                              textFieldController: widget.phoneController,
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
                                  child: SizedBox(
                                    height: 15,
                                    width: 15,
                                    child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
                                      strokeWidth: 0.5,
                                    ),
                                  ),
                                ),
                                prefixStyle: TextStyle(
                                    color: Colors.black45, fontSize: 15),
                                isDense: true,
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.black26, width: 0.5),
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.black26, width: 0.5),
                                ),
                              ),
                            ),
                          ]),
                    )),
              ),
              // TextFormField(
              //   autofocus: true,
              //   controller: _textController,
              //   keyboardType: TextInputType.phone,
              //   maxLength: 20,
              //   maxLines: 1,
              //   cursorColor: Theme.of(context).primaryColor,
              //   validator: (text) {
              //     return text.contains(' ') ? 'Cannot have spaces' : null;
              //   },
              //   buildCounter: (_, {currentLength, maxLength, isFocused}) {
              //     return Visibility(
              //       visible: false,
              //       child: Container(
              //         padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
              //         alignment: Alignment.centerLeft,
              //         child: Text(
              //           '${currentLength.toString()}/${maxLength.toString()}',
              //           style: TextStyle(
              //             fontSize: 12,
              //             color: currentLength > maxLength
              //                 ? Colors.red
              //                 : Colors.black54,
              //             fontWeight: FontWeight.w500,
              //           ),
              //         ),
              //       ),
              //     );
              //   },
              //   decoration: InputDecoration(
              //     prefixStyle: TextStyle(color: Colors.black45, fontSize: 15),
              //     isDense: true,
              //     focusedBorder: UnderlineInputBorder(
              //       borderSide: BorderSide(color: Colors.black26, width: 0.5),
              //     ),
              //     enabledBorder: UnderlineInputBorder(
              //       borderSide: BorderSide(color: Colors.black26, width: 0.5),
              //     ),
              //   ),
              // ),
              SizedBox(height: 15),
              Padding(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: SizedBox(
                  child: Text(
                    'Your privacy is guaranteed.\nYour phone number is used for verification purposes only.',
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
      ),
    );
  }

  void getPhoneNumber(String phoneNumber) async {
    PhoneNumber number =
        await PhoneNumber.getRegionInfoFromPhoneNumber(phoneNumber, 'MYS');

    setState(() {
      this._profileDataProvider.phoneNumberNewAcc = number;
    });
  }
}
