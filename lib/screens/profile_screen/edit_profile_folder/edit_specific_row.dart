import 'dart:async';

import 'package:overlay_support/overlay_support.dart';
import 'package:versify/models/user_model.dart';
import 'package:versify/providers/home/edit_profile_provider.dart';
import 'package:versify/providers/home/theme_data_provider.dart';
import 'package:versify/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:versify/services/database.dart';
import 'package:versify/shared/username_textfield.dart';

enum EditType { username, bio, phone, email, socialLinks }

class EditRowPage extends StatefulWidget {
  final EditType editType;
  // final Function updateFunc;
  final String socialLink;

  EditRowPage({this.editType, this.socialLink});

  @override
  _EditRowPageState createState() => _EditRowPageState();
}

class _EditRowPageState extends State<EditRowPage> {
  final TextEditingController _textController = TextEditingController();
  String _appBarTitle;
  String _textTitle;
  int _maxLength;
  bool _validToSave = true;

  String _text;

  // bool _validLoading = true;
  bool _validUsername = false;
  MyUser _editingUser;
  // Timer _debounce;

  void updateValidUsername(
      {@required bool validUsername, @required bool isSetState}) {
    _validUsername = validUsername;
    //does not consider isSetState
    
    // if (isSetState) {
    //   setState(() {});
    // }
  }

  // Future<void> _checkForValidUsername(String username) async {
  //   DatabaseService().checkIfValidUsername(username).then((isValid) {
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

  @override
  Widget build(BuildContext context) {
    final AuthService _authService = Provider.of<AuthService>(context);
    final ThemeProvider _themeProvider =
        Provider.of<ThemeProvider>(context, listen: false);

    final EditProfileProvider _editProfileProvider =
        Provider.of<EditProfileProvider>(context, listen: false);

    _editingUser = _editProfileProvider.user;

    switch (widget.editType) {
      case EditType.username:
        _appBarTitle = 'Username';
        _textTitle = 'Change username';
        _maxLength = 20;
        _textController.text = _editingUser.username;
        break;
      case EditType.bio:
        _appBarTitle = 'Bio';
        _textTitle = 'Change bio';
        _maxLength = 150;
        _textController.text = _editingUser.description;
        break;
      case EditType.phone:
        _appBarTitle = 'Phone';
        _textTitle = 'Change phone number';
        _maxLength = 20;
        _textController.text = _editingUser.phoneNumber;
        break;
      case EditType.email:
        _appBarTitle = 'Email';
        _textTitle = 'Change email address';
        _maxLength = 40;
        _textController.text = _editingUser.email;
        break;
      case EditType.socialLinks:
        _appBarTitle = widget.socialLink;
        _textTitle = 'Change link';
        _maxLength = 1000;
        _textController.text = _editingUser.socialLinks[widget.socialLink];
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
              Navigator.pop(context);
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
                'Save',
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              onPressed: () async {
                // _authService.myUser.username = _textController.text;
                // updateFunc();
                switch (widget.editType) {
                  case EditType.username:
                    _editingUser.username = _textController.text.trim();
                    print('Username changed to: ' + _editingUser.username);
                    if (_editingUser.username == _authService.myUser.username) {
                      _validToSave = true;
                    } else if (_validUsername &&
                        _editingUser.username.isNotEmpty) {
                      await DatabaseService()
                          .checkIfValidUsername(_editingUser.username)
                          .then((isValid) {
                        _validToSave = isValid;
                      });
                    } else {
                      print('Saved | validUsername: ' +
                          _validUsername.toString());
                      _validToSave = false;
                    }
                    break;
                  case EditType.bio:
                    _editingUser.description = _textController.text.trim();
                    _validToSave = true;

                    break;
                  case EditType.phone:
                    _editingUser.phoneNumber = _textController.text.trim();
                    _validToSave = true;

                    break;
                  case EditType.email:
                    _editingUser.email = _textController.text.trim();
                    _validToSave = true;

                    break;
                  case EditType.socialLinks:
                    _editingUser.socialLinks[widget.socialLink] =
                        _textController.text.trim() == ''
                            ? null
                            : _textController.text.trim();
                    break;
                }
                // MyUser _editedUser = _editingUser;
                print('ValidToSave: ' + _validToSave.toString());
                if (_validToSave) {
                  _editProfileProvider.updateProfileData(_editingUser);
                  Navigator.pop(context);
                } else {
                  _editingUser.username = _authService.myUser.username;
                  toast('Invalid $_appBarTitle, please try again.');
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
                _textTitle,
                style: TextStyle(
                  fontSize: 14,
                  color: _themeProvider.secondaryTextColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 5),
              widget.editType == EditType.username
                  ? UsernameTextField(
                      usernameController: _textController,
                      updateValidUsername: updateValidUsername,
                    )
                  : TextFormField(
                      autofocus: true,
                      controller: _textController,
                      maxLength: _maxLength,
                      maxLines: widget.editType == EditType.bio ? null : 1,
                      // keyboardType: TextInputType.multiline,
                      inputFormatters: [
                        FilteringTextInputFormatter.deny(RegExp('[\\\n]'))
                      ],
                      cursorColor: Theme.of(context).primaryColor,
                      validator: (text) {
                        return text.contains(' ') ? '' : text;
                      },
                      buildCounter: (_, {currentLength, maxLength, isFocused}) {
                        return Visibility(
                          visible: widget.editType != EditType.socialLinks,
                          child: Container(
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
                          ),
                        );
                      },
                      style: TextStyle(color: _themeProvider.primaryTextColor),
                      decoration: InputDecoration(
                        prefixText:
                            widget.editType == EditType.username ? '@ ' : '',
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
            ],
          ),
        ),
      ),
    );
  }
}
