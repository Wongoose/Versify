import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:versify/providers/providers_home/theme_data_provider.dart';
import 'package:versify/services/firebase/auth.dart';
import 'package:versify/shared/helper/helper_classes.dart';
import 'package:versify/shared/helper/helper_constants.dart';
import 'package:versify/shared/widgets/widgets_all_loading.dart';

import 'auth_screen_open_inbox.dart';

class ScreenResetPassword extends StatefulWidget {
  final String initialEmail;
  final bool editAccess;

  const ScreenResetPassword({this.initialEmail, this.editAccess});

  @override
  _ScreenResetPasswordState createState() => _ScreenResetPasswordState();
}

class _ScreenResetPasswordState extends State<ScreenResetPassword> {
  final TextEditingController emailTextController = TextEditingController();

  String error = "";
  bool loading = false;

  @override
  void initState() {
    super.initState();
    emailTextController.text = widget.initialEmail;
  }

  @override
  Widget build(BuildContext context) {
    final ThemeProvider _themeProvider = Provider.of<ThemeProvider>(context);
    final AuthService _authService = Provider.of<AuthService>(context);

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).backgroundColor,
        elevation: 0.0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(
            Icons.arrow_back_ios_rounded,
            color: _themeProvider.primaryTextColor,
          ),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 35.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(),
                  ),
                  Text(
                    "Reset password",
                    style: TextStyle(
                        color: _themeProvider.primaryTextColor,
                        fontSize: 39,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Nunito Sans",
                        height: 1.1),
                  ),
                  Expanded(
                    child: Container(),
                  ),
                  SizedBox(height: 30),
                  Image(
                    height: 250,
                    width: 250,
                    image: AssetImage("assets/images/reset_password.png"),
                  ),
                  SizedBox(height: 30),
                  SizedBox(
                    width: 320,
                    child: Text(
                      "Don't worry. This action will only update your sign in details. Your account data will not be affected.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: _themeProvider.primaryTextColor,
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                        fontFamily: "Nunito Sans",
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  if (error != "")
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(5, 0, 15, 10),
                        child: Text(
                          error,
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    )
                  else
                    Container(),
                  TextFormField(
                    controller: emailTextController,
                    scrollPadding: EdgeInsets.fromLTRB(0, 0, 0, 80),
                    readOnly: !widget.editAccess,
                    style: TextStyle(
                      color: _themeProvider.primaryTextColor,
                    ),
                    decoration: textInputDecoration.copyWith(
                      hintText: "Enter email",
                      hintStyle: TextStyle(
                        color: _themeProvider.secondaryTextColor,
                      ),
                      prefixIcon: Icon(
                        Icons.mail_outline_rounded,
                        color: _themeProvider.secondaryTextColor,
                      ),
                      fillColor: Theme.of(context).backgroundColor,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide(
                          color: _themeProvider.secondaryTextColor,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  Visibility(
                    visible: !loading,
                    replacement: CircleLoading(),
                    child: SizedBox(
                      height: 65,
                      width: MediaQuery.of(context).size.width,
                      // margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Theme.of(context).primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                        ),
                        onPressed: () async {
                          if (emailTextController.text.isNotEmpty) {
                            setState(() => loading = true);

                            final ReturnValue result =
                                await _authService.resetPasswordWithEmail(
                                    emailTextController.text.trim());

                            setState(() => loading = false);

                            if (result.success) {
                              // OPEN INBOX
                              toast("An email was sent to your inbox!");
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ScreenOpenInbox(
                                            description:
                                                "We have sent an email to your inbox. Please follow the steps in the email to reset your password.",
                                          )));
                            } else {
                              toast("Could not reset password");
                              setState(() => error = result.value);
                            }
                          }
                        },
                        child: Text(
                          "Reset password",
                          style: TextStyle(
                            // shadows: [
                            //   Shadow(
                            //       color: _themeProvider.primaryTextColor26,
                            //       blurRadius: 10,
                            //       offset: Offset(0.5, 0.5))
                            // ],
                            fontFamily: "Nunito Sans",
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(),
                  ),
                  SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
