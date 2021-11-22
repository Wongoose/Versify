import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:versify/providers/providers_home/theme_data_provider.dart';
import 'package:provider/provider.dart';
import 'package:versify/services/firebase/auth.dart';
import 'package:versify/services/firebase/database.dart';
import 'package:vibration/vibration.dart';

class UsernameValidatingTextField extends StatefulWidget {
  final TextEditingController usernameController;
  final Function updateValidUsername;

  UsernameValidatingTextField({
    @required this.usernameController,
    @required this.updateValidUsername,
  });

  @override
  _UsernameValidatingTextFieldState createState() =>
      _UsernameValidatingTextFieldState();
}

class _UsernameValidatingTextFieldState
    extends State<UsernameValidatingTextField> {
  Timer _debounce;
  String _text;
  bool _validUsername = true;
  bool _validLoading = false;

  AuthService _authService;

  Future<void> _checkForValidUsername(String username) async {
    DatabaseService().checkIfValidUsername(username).then((isValid) {
      print('ValidUsername: ' + isValid.toString());
      setState(() {
        _validUsername = isValid;
        _validLoading = false;
      });
      //setsState update _validUsername (add)
      widget.updateValidUsername(
        validUsername: _validUsername,
        isSetState: true,
      );
    });
  }

  void _onUsernameChanged(String username) {
    setState(() {
      _validUsername = false;
      _validLoading = true;
    });
    widget.updateValidUsername(
      validUsername: _validUsername,
      isSetState: false,
    );

    if (_debounce?.isActive ?? false) _debounce.cancel();
    _debounce = Timer(const Duration(seconds: 1), () {
      if (username != "" && username != (_authService.myUser?.username ?? "")) {
        _checkForValidUsername(username);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeProvider _themeProvider =
        Provider.of<ThemeProvider>(context, listen: false);
    _authService = Provider.of<AuthService>(context);
    return TextFormField(
      autofocus: true,
      controller: widget.usernameController,
      maxLength: 20,
      maxLines: 1,
      inputFormatters: [
        new FilteringTextInputFormatter.allow(RegExp("[a-z0-9|\\_|\\.]")),
      ],
      cursorColor: Theme.of(context).primaryColor,
      // onSaved: (newValue) => ,
      autovalidateMode: AutovalidateMode.always,
      onChanged: (newVal) {
        if (newVal.length <= 20) {
          _text = newVal;
        } else {
          Vibration.vibrate(duration: 200);
          widget.usernameController.value = TextEditingValue(
              text: _text,
              selection: TextSelection(
                  baseOffset: 20,
                  extentOffset: 20,
                  affinity: TextAffinity.downstream,
                  isDirectional: false),
              composing: TextRange(start: 0, end: 20));

          widget.usernameController.text = _text;
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
                    : _themeProvider.secondaryTextColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        );
      },
      style: TextStyle(color: _themeProvider.primaryTextColor),
      decoration: InputDecoration(
        prefixText: '@ ',
        suffix: Visibility(
          visible: !_validLoading,
          replacement: SizedBox(
            height: 15,
            width: 15,
            child: CircularProgressIndicator(
              valueColor:
                  AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
              strokeWidth: 0.5,
            ),
          ),
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
        ),
        prefixStyle:
            TextStyle(color: _themeProvider.secondaryTextColor, fontSize: 15),
        isDense: true,
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
              color: _themeProvider.primaryTextColor.withOpacity(0.26),
              width: 0.5),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
              color: _themeProvider.primaryTextColor.withOpacity(0.26),
              width: 0.5),
        ),
      ),
    );
  }
}
