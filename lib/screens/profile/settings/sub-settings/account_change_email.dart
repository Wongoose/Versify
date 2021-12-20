import "package:versify/providers/providers_home/theme_data_provider.dart";
import 'package:versify/screens/verification/verification_email.dart';
import "package:versify/services/firebase/auth.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:provider/provider.dart";

class AccountChangeEmail extends StatefulWidget {
  final String parsedEmail;

  const AccountChangeEmail({Key key, this.parsedEmail}) : super(key: key);
  @override
  _AccountChangeEmailState createState() => _AccountChangeEmailState();
}

class _AccountChangeEmailState extends State<AccountChangeEmail> {
  final TextEditingController _textController = TextEditingController();

  // providers
  AuthService _authService;

  // variables
  bool validNewEmail = false;

  // functions
  @override
  void initState() {
    super.initState();
    _textController.text = widget.parsedEmail;
  }

  void validateNewEmail() {
    if (_textController.text.trim() != _authService.getCurrentUser.email &&
        _textController.text.trim().isNotEmpty) {
      setState(() => validNewEmail = true);
    } else {
      setState(() => validNewEmail = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeProvider _themeProvider =
        Provider.of<ThemeProvider>(context, listen: false);
    _authService = Provider.of<AuthService>(context);

    return WillPopScope(
      onWillPop: () async {
        if (Navigator.of(context).userGestureInProgress) {
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          backgroundColor: Theme.of(context).backgroundColor,
          centerTitle: true,
          elevation: 0.5,
          title: Text(
            "Email",
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
              "Back",
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
              onPressed: () {
                if (validNewEmail) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => VerificationEmail(
                                parsedEmail: _textController.text.trim(),
                              )));
                }
              },
              child: Text(
                "Next",
                style: TextStyle(
                  fontSize: 14,
                  color: validNewEmail
                      ? Theme.of(context).primaryColor
                      : Theme.of(context).primaryColor.withOpacity(0.4),
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
                "Change to new email address",
                style: TextStyle(
                  fontSize: 14,
                  color: _themeProvider.secondaryTextColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 5),
              TextFormField(
                controller: _textController,
                keyboardType: TextInputType.emailAddress,
                cursorColor: Theme.of(context).primaryColor,
                onChanged: (_) => validateNewEmail(),
                style: TextStyle(
                  color: _themeProvider.primaryTextColor,
                ),
                decoration: InputDecoration(
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
              SizedBox(height: 15),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
                child: SizedBox(
                  child: Text(
                    "This Versify account is currently linked to ${_authService.getCurrentUser.email}.",
                    style: TextStyle(
                      height: 1.7,
                      fontSize: 12,
                      color: _themeProvider.secondaryTextColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
