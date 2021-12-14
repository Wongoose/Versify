import 'package:overlay_support/overlay_support.dart';
import "package:versify/providers/providers_home/theme_data_provider.dart";
import "package:versify/screens/profile/settings/account_edit_row.dart";
import "package:versify/screens/profile/settings/account_verification.dart";
import "package:versify/services/firebase/auth.dart";
import "package:flutter/material.dart";
import "package:intl_phone_number_input/intl_phone_number_input.dart";
import "package:provider/provider.dart";
import 'package:versify/shared/helper/helper_classes.dart';
import 'package:versify/shared/helper/helper_functions.dart';
import "package:versify/shared/helper/helper_methods.dart";
import "package:versify/shared/widgets/widgets_all_loading.dart";

// ignore: must_be_immutable
class CreateNewPhone extends StatefulWidget {
  @override
  _CreateNewPhoneState createState() => _CreateNewPhoneState();
}

class _CreateNewPhoneState extends State<CreateNewPhone> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  AuthService _authService;

  String validateError = "";
  bool _validLoading = false;

  int resendingToken;
  PhoneNumber phoneNumber;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print(purplePen("SCREEN create new phone | initState RAN"));
      phoneNumber = PhoneNumber(
          phoneNumber: _authService.getCurrentUser?.phoneNumber ?? "");
    });
  }

  Future<void> _phoneVerificationSuccess() async {
    print("Phone Verification Success | updatePhoneVerification");

    // Navigator.pushAndRemoveUntil(context,
    //     MaterialPageRoute(builder: (context) => Wrapper()), (route) => false);

    // print("Phone number: " + _authService.getCurrentUser.phoneNumber);

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
    _authService = Provider.of<AuthService>(context);

    // if (_authService.getCurrentUser.phoneNumber != null) {
    //   //bug error getter "phoneNumber" was called on null
    //   print("Already Got Phone Number!");
    //   WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //     Navigator.pushAndRemoveUntil(
    //       context,
    //       MaterialPageRoute(builder: (context) => Wrapper()),
    //       (route) => false,
    //     );
    //   });
    //   return SplashLoading();
    // } else {
    return WillPopScope(
      onWillPop: () async {
        if (Navigator.of(context).userGestureInProgress) {
          return false;
        } else {
          // back button pressed
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
            "Phone",
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
            onPressed: () => refreshToWrapper(context),
            child: Text(
              "Skip",
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
                if (phoneNumber.phoneNumber.isNotEmpty) {
                  setState(() => _validLoading = true);

                  final ReturnValue result =
                      await validatePhoneNumber(phoneNumber);

                  setState(() => _validLoading = false);
                  if (result.success) {
                    // PHONE IS VALID
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AccountVerification(
                            accEditType: AccountEditType.phone,
                            parsedText: result.value,
                            resendingToken: resendingToken,
                            verificationSuccessFunc: _phoneVerificationSuccess,
                          ),
                        ));
                  } else {
                    if (result.errorCode == "INVALID-PHONE-NUMBER") {
                      toast("This phone number is invalid.");
                      validateError = "This phone number is invalid.";
                    } else {
                      toast(
                          "Something went wrong. Could not update phone number.");
                    }
                  }
                }
              },
              child: Text(
                "Done",
                style: TextStyle(
                  fontSize: 14,
                  color: phoneNumber.phoneNumber.isNotEmpty
                      ? Theme.of(context).primaryColor
                      : _themeProvider.primaryTextColor.withOpacity(0.26),
                  fontWeight: FontWeight.w600,
                ),
              ),
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
                  "Phone number",
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
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          InternationalPhoneNumberInput(
                            // errorMessage: "hello",
                            validator: (_) {
                              return validateError.isNotEmpty
                                  ? validateError
                                  : null;
                            },
                            autoValidateMode: AutovalidateMode.always,
                            onInputChanged: (PhoneNumber newNumber) {
                              validateError = "";
                              phoneNumber = newNumber;
                              print(grayPen(
                                  "Phone number is: ${phoneNumber.phoneNumber}"));
                            },
                            selectorConfig: SelectorConfig(
                              selectorType: PhoneInputSelectorType.DIALOG,
                            ),
                            textStyle: TextStyle(
                              color: _themeProvider.primaryTextColor,
                            ),
                            selectorTextStyle: TextStyle(
                                color: _themeProvider.primaryTextColor),
                            initialValue: phoneNumber,

                            formatInput: false,

                            inputBorder: OutlineInputBorder(),

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
                        ])),
              ),
              SizedBox(height: 15),
              Padding(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: SizedBox(
                  child: Text(
                    "Your privacy is guaranteed.\nYour phone number is used to enhance the security of your account.",
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
                  onTap: () => refreshToWrapper(context),
                  child: SizedBox(
                    child: Text(
                      "I'll do it later.",
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
  // }

  // void getPhoneNumber(String phoneNumber) async {
  //   PhoneNumber number =
  //       await PhoneNumber.getRegionInfoFromPhoneNumber(phoneNumber, "MYS");

  //   setState(() {
  //     this._profileDataProvider.phoneNumberNewAcc = number;
  //   });
  // }
}
