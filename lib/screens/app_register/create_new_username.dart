import "dart:async";
import "package:firebase_auth/firebase_auth.dart";
import "package:overlay_support/overlay_support.dart";
import "package:versify/providers/providers_home/theme_data_provider.dart";
import "package:versify/screens/app_register/create_new_phone.dart";
import "package:versify/providers/providers_home/profile_data_provider.dart";
import "package:versify/services/firebase/auth.dart";
import "package:versify/services/firebase/database.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:intl_phone_number_input/intl_phone_number_input.dart";
import "package:provider/provider.dart";
import 'package:versify/shared/helper/helper_classes.dart';
import "package:versify/shared/widgets/widgets_all_loading.dart";
import "package:versify/shared/widgets/widgets_username_validating_textfield.dart";
import "package:vibration/vibration.dart";

class CreateNewUsername extends StatefulWidget {
  @override
  _CreateNewUsernameState createState() => _CreateNewUsernameState();
}

class _CreateNewUsernameState extends State<CreateNewUsername> {
  final TextEditingController _usernameController = TextEditingController();

  DatabaseService _databaseService;
  AuthService _authService;
  ProfileDataProvider _profileDataProvider;

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
  //     if (username != "") {
  //       _checkForValidUsername(username);
  //     }
  //   });
  // }

  Future<void> onWillPop() async {
    // NOT USED
    await FirebaseAuth.instance.currentUser.delete();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _profileDataProvider.phoneNumberNewAcc = PhoneNumber(
          phoneNumber: _authService.getCurrentUser.phoneNumber ?? "");
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
            "Username",
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
            onPressed: () async {
              // _profileDataProvider.updateListeners();
              // await onWillPop();
              _authService.logout();
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
              ),
              onPressed: () async {
                if (!_nextLoading) {
                  if (_validUsername && _usernameController.text != "") {
                    setState(() => _nextLoading = true);

                    // check database second time - shift to Cloud Functions
                    final ReturnValue result = await _databaseService
                        .checkIfValidUsername(_usernameController.text);

                    if (result.success) {
                      // username is 100% valid
                      toast(result.value);

                      final ReturnValue createAccResult =
                          await _databaseService.createFirestoreAccount(
                        completeLogin: true,
                        email: _authService.getCurrentUser.email,
                        phone: _authService.getCurrentUser.phoneNumber,
                        username: _usernameController.text,
                        userUID: _authService.getCurrentUser.uid,
                      );

                      if (createAccResult.success) {
                        toast("Created username ${createAccResult.value}!");
                        Navigator.pushReplacement(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => CreateNewPhone(
                                usernameController: _usernameController,
                              ),
                            ));
                      } else {
                        toast(createAccResult.value);
                      }
                    } else {
                      // second check is not valid
                      toast(result.value);
                      _validUsername = false;
                    }
                    setState(() => _nextLoading = false);
                  } else {
                    //not valid when typing (instant reject)
                    toast("Invalid username. Please try again.");
                  }
                }
              },
              child: _nextLoading
                  ? CircleLoading()
                  : Text(
                      "Next",
                      style: TextStyle(
                        fontSize: 14,
                        color: _validUsername
                            ? Theme.of(context).primaryColor
                            : _themeProvider.primaryTextColor.withOpacity(0.26),
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
              Text(
                "Choose your username",
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
              SizedBox(height: 15),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
                child: SizedBox(
                  child: Text(
                    "Your username is your profile nickname. You can always change it later. (e.g. john_green04)",
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
