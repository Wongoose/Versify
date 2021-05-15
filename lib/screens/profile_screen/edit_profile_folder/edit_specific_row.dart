import 'package:versify/models/user_model.dart';
import 'package:versify/providers/edit_profile_provider.dart';
import 'package:versify/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

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

  @override
  Widget build(BuildContext context) {
    // final AuthService _authService = Provider.of<AuthService>(context);

    final EditProfileProvider _editProfileProvider =
        Provider.of<EditProfileProvider>(context, listen: false);

    final MyUser _editingUser = _editProfileProvider.user;

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
              child: Text(
                'Save',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xffff548e),
                  fontWeight: FontWeight.w600,
                ),
              ),
              onPressed: () {
                // _authService.myUser.username = _textController.text;
                // updateFunc();
                switch (widget.editType) {
                  case EditType.username:
                    _editingUser.username = _textController.text.trim();
                    break;
                  case EditType.bio:
                    _editingUser.description = _textController.text.trim();
                    break;
                  case EditType.phone:
                    _editingUser.phoneNumber = _textController.text.trim();
                    break;
                  case EditType.email:
                    _editingUser.email = _textController.text.trim();
                    break;
                  case EditType.socialLinks:
                    _editingUser.socialLinks[widget.socialLink] =
                        _textController.text.trim() == ''
                            ? null
                            : _textController.text.trim();
                    break;
                }
                // MyUser _editedUser = _editingUser;

                _editProfileProvider.updateProfileData(_editingUser);
                Navigator.pop(context);
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
                maxLines: widget.editType == EditType.bio ? null : 1,
                // keyboardType: TextInputType.multiline,
                inputFormatters: [
                  FilteringTextInputFormatter.deny(RegExp('[\\\n]'))
                ],
                cursorColor: Color(0xffff548e),
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
                              : Colors.black54,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  );
                },
                decoration: InputDecoration(
                  prefixText: widget.editType == EditType.username ? '@ ' : '',
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
