import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:versify/providers/providers_home/theme_data_provider.dart';
import 'package:versify/services/firebase/auth.dart';
import 'package:versify/shared/helper/helper_classes.dart';
import 'package:versify/shared/helper/helper_constants.dart';
import 'package:versify/shared/helper/helper_functions.dart';
import 'package:versify/shared/widgets/widgets_all_loading.dart';

class AuthCreatePassword extends StatefulWidget {
  final String email;

  const AuthCreatePassword({Key key, this.email}) : super(key: key);
  @override
  _AuthCreatePasswordState createState() => _AuthCreatePasswordState();
}

class _AuthCreatePasswordState extends State<AuthCreatePassword> {
  final TextEditingController passwordTextController = TextEditingController();
  final TextEditingController confirmPasswordTextController =
      TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String error = "";
  bool loading = false;
  bool visiblePassword = false;
  bool doneFirstValidation = false;

  @override
  Widget build(BuildContext context) {
    final ThemeProvider _themeProvider = Provider.of<ThemeProvider>(context);
    final AuthService _authService = Provider.of<AuthService>(context);

    return Scaffold(
      backgroundColor: Theme.of(context).canvasColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).canvasColor,
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
              padding: EdgeInsets.fromLTRB(35, 0, 35, 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(child: Container()),
                  SizedBox(height: 50),
                  Stack(
                    alignment: Alignment.topCenter,
                    clipBehavior: Clip.none,
                    children: [
                      Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                            side: BorderSide(
                              color: _themeProvider.secondaryTextColor,
                            )),
                        child: Container(
                          padding: EdgeInsets.fromLTRB(30, 20, 30, 30),
                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .backgroundColor
                                .withOpacity(0.95),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(height: 40),
                              Text(
                                "Create Account",
                                style: TextStyle(
                                    color: _themeProvider.primaryTextColor,
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "Nunito Sans",
                                    height: 1.1),
                              ),
                              SizedBox(height: 30),
                              Form(
                                key: formKey,
                                child: Column(
                                  children: [
                                    TextFormField(
                                      scrollPadding:
                                          EdgeInsets.fromLTRB(0, 0, 0, 80),
                                      // enabled: false,
                                      readOnly: true,
                                      initialValue: widget.email,
                                      style: TextStyle(
                                        color: _themeProvider.primaryTextColor,
                                      ),
                                      decoration: textInputDecoration.copyWith(
                                        hintText: "Email",
                                        hintStyle: TextStyle(
                                          color:
                                              _themeProvider.secondaryTextColor,
                                        ),
                                        prefixIcon: Icon(
                                          Icons.mail_outline_rounded,
                                          color:
                                              _themeProvider.secondaryTextColor,
                                        ),
                                        fillColor: Colors.transparent,
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
                                          borderSide: BorderSide(
                                            width: 0,
                                            color: _themeProvider
                                                .secondaryTextColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 15),
                                    TextFormField(
                                      controller: passwordTextController,
                                      autofocus: true,
                                      scrollPadding:
                                          EdgeInsets.fromLTRB(0, 0, 0, 80),
                                      style: TextStyle(
                                        color: _themeProvider.primaryTextColor,
                                      ),
                                      decoration: textInputDecoration.copyWith(
                                        hintText: "Create password",
                                        hintStyle: TextStyle(
                                          color:
                                              _themeProvider.secondaryTextColor,
                                        ),
                                        prefixIcon: Icon(
                                          Icons.lock_outline_rounded,
                                          color:
                                              _themeProvider.secondaryTextColor,
                                        ),
                                        suffixIcon: GestureDetector(
                                          onTap: () {
                                            setState(() => visiblePassword =
                                                !visiblePassword);
                                          },
                                          child: Icon(
                                            visiblePassword
                                                ? FontAwesomeIcons.eye
                                                : FontAwesomeIcons.eyeSlash,
                                            size: 18,
                                            color: visiblePassword
                                                ? _themeProvider
                                                    .primaryTextColor
                                                : _themeProvider
                                                    .secondaryTextColor,
                                          ),
                                        ),
                                        fillColor:
                                            Theme.of(context).backgroundColor,
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
                                          borderSide: BorderSide(
                                            color: _themeProvider
                                                .secondaryTextColor,
                                          ),
                                        ),
                                      ),
                                      obscureText: !visiblePassword,
                                      validator: (val) => val.length < 6
                                          ? "Password must have 6 or more characters."
                                          : null, //return null when it is valid
                                      onChanged: (val) {
                                        if (doneFirstValidation) {
                                          formKey.currentState.validate();
                                        }
                                      },
                                    ),
                                    SizedBox(height: 15),
                                    TextFormField(
                                      controller: confirmPasswordTextController,
                                      scrollPadding:
                                          EdgeInsets.fromLTRB(0, 0, 0, 80),
                                      style: TextStyle(
                                        color: _themeProvider.primaryTextColor,
                                      ),
                                      decoration: textInputDecoration.copyWith(
                                        hintText: "Confirm password",
                                        hintStyle: TextStyle(
                                          color:
                                              _themeProvider.secondaryTextColor,
                                        ),
                                        prefixIcon: Icon(
                                          Icons.lock_outline_rounded,
                                          color:
                                              _themeProvider.secondaryTextColor,
                                        ),
                                        suffixIcon: GestureDetector(
                                          onTap: () {
                                            setState(() => visiblePassword =
                                                !visiblePassword);
                                          },
                                          child: Icon(
                                            visiblePassword
                                                ? FontAwesomeIcons.eye
                                                : FontAwesomeIcons.eyeSlash,
                                            size: 18,
                                            color: visiblePassword
                                                ? _themeProvider
                                                    .primaryTextColor
                                                : _themeProvider
                                                    .secondaryTextColor,
                                          ),
                                        ),
                                        fillColor:
                                            Theme.of(context).backgroundColor,
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
                                          borderSide: BorderSide(
                                            color: _themeProvider
                                                .secondaryTextColor,
                                          ),
                                        ),
                                      ),
                                      obscureText: !visiblePassword,
                                      validator: (val) {
                                        if (val.isEmpty) {
                                          return "This field cannot be empty.";
                                        } else if (val !=
                                            passwordTextController.text) {
                                          return "Password does not match.";
                                        } else {
                                          return null;
                                        }
                                      }, //return null when it is valid
                                      onChanged: (val) {
                                        if (doneFirstValidation) {
                                          formKey.currentState.validate();
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 20),
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
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20)),
                                      ),
                                    ),
                                    onPressed: () async {
                                      if (formKey.currentState.validate()) {
                                        setState(() {
                                          loading = true;
                                          doneFirstValidation = true;
                                        });
                                        final ReturnValue result =
                                            await _authService
                                                .createAccountWithEmailAndPassword(
                                                    widget.email.trim(),
                                                    confirmPasswordTextController
                                                        .text
                                                        .trim());

                                        setState(() => loading = false);

                                        if (result.success) {
                                          toast("Created ${result.value}!");
                                          // SUCCESS - REDIRECTED TO "Create Username"
                                          refreshToWrapper(context);
                                        } else {
                                          toast("Could not create account");
                                          setState(() => error = result.value);
                                        }
                                      } else {
                                        setState(
                                            () => doneFirstValidation = true);
                                      }
                                    },
                                    child: Text(
                                      "Confirm",
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
                              if (error != "")
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(5, 15, 15, 0),
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
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        top: -40,
                        child: Container(
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Theme.of(context).backgroundColor,
                            border: Border.all(
                              color: _themeProvider.secondaryTextColor,
                            ),
                          ),
                          child: Image(
                            image: AssetImage(
                                "assets/images/purple_circle_v1.png"),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Expanded(child: Container()),
                  SizedBox(height: 30),
                  Padding(
                    padding: EdgeInsets.fromLTRB(30, 10, 30, 40),
                    child: GestureDetector(
                      onTap: () => refreshToWrapper(context),
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                        child: Text(
                          "Click to go back to home",
                          style: TextStyle(
                              fontFamily: "Nunito Sans",
                              decoration: TextDecoration.underline,
                              color: _themeProvider.secondaryTextColor,
                              fontWeight: FontWeight.w400,
                              fontSize: 14),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
