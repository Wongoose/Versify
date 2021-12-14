import 'package:overlay_support/overlay_support.dart';
import 'package:versify/models/user_model.dart';
import 'package:versify/providers/providers_home/edit_profile_provider.dart';
import 'package:versify/providers/providers_home/theme_data_provider.dart';
import 'package:versify/screens/authentication/auth_screen_reset_password.dart';
import 'package:versify/screens/profile/settings/account_provider.dart';
import 'package:versify/screens/profile/settings/account_verification.dart';
import 'package:versify/screens/verification/verification_phone.dart';
import 'package:versify/services/firebase/auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:versify/shared/helper/helper_functions.dart';

enum AccountEditType { phone, google, email, password }

class AccountEditRow extends StatefulWidget {
  final AccountEditType editType;
  // final Function updateFunc;

  AccountEditRow({this.editType});

  @override
  _AccountEditRowState createState() => _AccountEditRowState();
}

class _AccountEditRowState extends State<AccountEditRow> {
  final TextEditingController _textController = TextEditingController();

  //providers
  ThemeProvider _themeProvider;
  AuthService _authService;
  AccountSettingsProvider _accountSettingsProvider;

  String _appBarTitle;
  String _textTitle;
  int _maxLength;
  int _resendingToken;

  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // setState(() => _accountSettingsProvider.textController = _textController);
    });
  }

  @override
  Widget build(BuildContext context) {
    _themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    _authService = Provider.of<AuthService>(context);

    _accountSettingsProvider =
        Provider.of<AccountSettingsProvider>(context, listen: false);
    final MyUser _editingUser = _accountSettingsProvider.user;
    _accountSettingsProvider.textController = _textController;

    switch (widget.editType) {
      case AccountEditType.phone:
        _appBarTitle = 'Phone';
        _textTitle = 'Change phone number';
        _maxLength = 20;
        _textController.text = _editingUser.phoneNumber;
        _accountSettingsProvider.initialText = _editingUser.phoneNumber;
        break;
      case AccountEditType.email:
        _appBarTitle = 'Email';
        _textTitle = 'Change email address';
        _maxLength = 40;
        _textController.text = _editingUser.email;
        _accountSettingsProvider.initialText = _editingUser.email;
        break;
      case AccountEditType.password:
        _appBarTitle = 'Password';
        _textTitle = 'Manage password';
        _maxLength = 40;
        // _textController.text = _editingUser.email;
        // _accountSettingsProvider.initialText = _editingUser.email;
        break;
      case AccountEditType.google:
        _appBarTitle = 'Account';
        _textTitle = 'Google account';
        _maxLength = 40;
        break;
    }

    return WillPopScope(
      onWillPop: () async {
        if (Navigator.of(context).userGestureInProgress)
          return false;
        else
          return true;
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          backgroundColor: Theme.of(context).backgroundColor,
          centerTitle: true,
          elevation: 0.5,
          title: Text(
            _appBarTitle,
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
                primary: Theme.of(context).backgroundColor),
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              'Back',
              style: TextStyle(
                fontSize: 14,
                color: _themeProvider.secondaryTextColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          actions: [
            if (widget.editType == AccountEditType.password ||
                widget.editType == AccountEditType.google)
              Container()
            else
              TextButton(
                style: TextButton.styleFrom(
                  padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                  backgroundColor: Theme.of(context).backgroundColor,
                  primary: Theme.of(context).backgroundColor,
                ),
                onPressed: () {
                  // _authService.myUser.username = _textController.text;
                  // updateFunc();
                  if (_accountSettingsProvider.hasChanges) {
                    bool _needVerification;

                    switch (widget.editType) {
                      case AccountEditType.phone:
                        _needVerification = true;
                        // _editingUser.phoneNumber = _textController.text.trim();
                        break;
                      case AccountEditType.email:
                        _needVerification = true;
                        // _editingUser.email = _textController.text.trim();
                        break;
                      case AccountEditType.password:
                        // TODO: Handle this case.
                        break;
                      case AccountEditType.google:
                        // TODO: Handle this case.
                        break;
                    }
                    // _accountSettingsProvider.updateProfileData();
                    if (_needVerification) {
                      if (widget.editType == AccountEditType.phone) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => VerificationPhone(
                                parsedPhoneNumber: _textController.text.trim(),
                              ),
                            ));
                      } else {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AccountVerification(
                                accEditType: widget.editType,
                                resendingToken: _resendingToken,
                                parsedText: _textController.text,
                                verificationSuccessFunc: () {
                                  _accountSettingsProvider.updateProfileData();

                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                },
                              ),
                            ));
                      }
                    } else {
                      Navigator.pop(context);
                    }
                  }
                },
                child: Consumer<AccountSettingsProvider>(
                  builder: (context, state, _) => Text(
                    'Next',
                    style: TextStyle(
                      fontSize: 14,
                      color: state.hasChanges
                          ? Theme.of(context).primaryColor
                          : Theme.of(context).primaryColor.withOpacity(0.4),
                      fontWeight: FontWeight.w600,
                    ),
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
                _textTitle,
                style: TextStyle(
                  fontSize: 14,
                  color: _themeProvider.secondaryTextColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 5),
              if (widget.editType == AccountEditType.password ||
                  widget.editType == AccountEditType.google)
                Container()
              else
                TextFormField(
                  autofocus: true,
                  controller: _textController,
                  maxLength: _maxLength,
                  maxLines: 1,
                  keyboardType: widget.editType == AccountEditType.phone
                      ? TextInputType.phone
                      : TextInputType.emailAddress,
                  // inputFormatters: [
                  //   FilteringTextInputFormatter.deny(RegExp('[\\\n]'))
                  // ],
                  cursorColor: Theme.of(context).primaryColor,
                  validator: (text) {
                    return text.contains(' ') ? '' : text;
                  },

                  onChanged: (_) {
                    //trigger has change text
                    _accountSettingsProvider.updateProfileData();
                  },

                  buildCounter: (_, {currentLength, maxLength, isFocused}) {
                    return Container(
                      padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '${currentLength.toString()}/${maxLength.toString()}',
                        style: TextStyle(
                          fontSize: 12,
                          color: currentLength > maxLength
                              ? Colors.red
                              : _themeProvider.secondaryTextColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  },
                  style: TextStyle(
                    color: _themeProvider.primaryTextColor,
                  ),
                  decoration: InputDecoration(
                    // prefixText:
                    //     widget.editType == AccountEditType.username ? '@ ' : '',
                    prefixStyle: TextStyle(
                        color: _themeProvider.secondaryTextColor, fontSize: 15),
                    isDense: true,
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color:
                              _themeProvider.primaryTextColor.withOpacity(0.26),
                          width: 0.5),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color:
                              _themeProvider.primaryTextColor.withOpacity(0.26),
                          width: 0.5),
                    ),
                  ),
                ),
              SizedBox(height: 5),
              if (widget.editType == AccountEditType.password ||
                  widget.editType == AccountEditType.google)
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
                  child: SizedBox(
                    child: Text(
                      widget.editType == AccountEditType.password
                          ? 'The password for ${_authService.getCurrentUser.email} is secured.'
                          : 'Your Versify account is created with ${_authService.getCurrentUser.email} Google account.',
                      style: TextStyle(
                        height: 1.7,
                        fontSize: 12,
                        color: _themeProvider.secondaryTextColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                )
              else
                Container(),
              SizedBox(height: 15),
              if (widget.editType == AccountEditType.password)
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      // resetPasswordDialog(context);
                      if (_authService.getCurrentUser.email?.isEmpty ?? false) {
                        // NO EMAIL
                        toast("Could not reset password");
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ScreenResetPassword(
                              initialEmail: _authService.getCurrentUser.email,
                              editAccess: false,
                            ),
                          ),
                        );
                      }
                    },
                    child: SizedBox(
                      child: Text(
                        'Reset password?',
                        style: TextStyle(
                          height: 1.7,
                          fontSize: 12,
                          color: Colors.blue[400],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                )
              else
                Container(),
            ],
          ),
        ),
      ),
    );
  }
}
