import 'package:versify/models/user_model.dart';
import 'package:versify/providers/home/edit_profile_provider.dart';
import 'package:versify/screens/profile_screen/settings/account_provider.dart';
import 'package:versify/screens/profile_screen/settings/account_verification.dart';
import 'package:versify/services/auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

enum AccountEditType { username, bio, phone, email, socialLinks }

class AccountEditRow extends StatefulWidget {
  final AccountEditType editType;
  final String socialLink;
  // final Function updateFunc;

  AccountEditRow({this.editType, this.socialLink});

  @override
  _AccountEditRowState createState() => _AccountEditRowState();
}

class _AccountEditRowState extends State<AccountEditRow> {
  final TextEditingController _textController = TextEditingController();
  String _appBarTitle;
  String _textTitle;
  int _maxLength;

  @override
  Widget build(BuildContext context) {
    final AccountSettingsProvider _accountSettingsProvider =
        Provider.of<AccountSettingsProvider>(context, listen: false);

    final MyUser _editingUser = _accountSettingsProvider.user;

    switch (widget.editType) {
      case AccountEditType.username:
        _appBarTitle = 'Username';
        _textTitle = 'Change username';
        _maxLength = 20;
        _textController.text = _editingUser.username;
        break;
      case AccountEditType.bio:
        _appBarTitle = 'Bio';
        _textTitle = 'Change bio';
        _maxLength = 150;
        _textController.text = _editingUser.description;
        break;
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
      case AccountEditType.socialLinks:
        _appBarTitle = widget.socialLink;
        _textTitle = 'Change link';
        _maxLength = 1000;
        _textController.text = _editingUser.socialLinks[widget.socialLink];
        break;
    }
    _accountSettingsProvider.textController = _textController;

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
            _appBarTitle,
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
              child: Consumer<AccountSettingsProvider>(
                builder: (context, state, _) => Text(
                  'Next',
                  style: TextStyle(
                    fontSize: 14,
                    color: state.hasChanges
                        ? Color(0xffff548e)
                        : Color(0xffff548e).withOpacity(0.4),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              onPressed: () {
                // _authService.myUser.username = _textController.text;
                // updateFunc();
                if (_accountSettingsProvider.hasChanges) {
                  bool _needVerification;

                  switch (widget.editType) {
                    case AccountEditType.username:
                      // _editingUser.username = _textController.text.trim();
                      break;
                    case AccountEditType.bio:
                      // _editingUser.description = _textController.text.trim();
                      break;
                    case AccountEditType.phone:
                      _needVerification = true;
                      // _editingUser.phoneNumber = _textController.text.trim();
                      break;
                    case AccountEditType.email:
                      _needVerification = true;
                      // _editingUser.email = _textController.text.trim();
                      break;
                    case AccountEditType.socialLinks:
                      // _editingUser.socialLinks[widget.socialLink] =
                      //     _textController.text.trim() == ''
                      //         ? null
                      //         : _textController.text.trim();
                      break;
                  }
                  // _accountSettingsProvider.updateProfileData();
                  if (_needVerification) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AccountVerification(
                            accEditType: widget.editType,
                            parsedText: _textController.text,
                          ),
                        ));
                  } else {
                    Navigator.pop(context);
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
                _textTitle,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black45,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 5),
              TextFormField(
                autofocus: true,
                controller: _textController,
                maxLength: _maxLength,
                maxLines: widget.editType == AccountEditType.bio ? null : 1,
                keyboardType: widget.editType == AccountEditType.phone
                    ? TextInputType.phone
                    : TextInputType.emailAddress,
                // inputFormatters: [
                //   FilteringTextInputFormatter.deny(RegExp('[\\\n]'))
                // ],
                cursorColor: Color(0xffff548e),
                validator: (text) {
                  return text.contains(' ') ? '' : text;
                },

                onChanged: (_) {
                  _accountSettingsProvider.updateProfileData();
                },

                buildCounter: (_, {currentLength, maxLength, isFocused}) {
                  return Visibility(
                    visible: widget.editType != AccountEditType.socialLinks,
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
                  prefixText:
                      widget.editType == AccountEditType.username ? '@ ' : '',
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
