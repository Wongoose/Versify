import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:versify/providers/providers_home/theme_data_provider.dart';
import 'package:versify/services/firebase/auth.dart';
import 'package:versify/shared/helper/helper_constants.dart';

class AuthCreateAccount extends StatefulWidget {
  final Function toggleSignIn;

  const AuthCreateAccount({Key key, this.toggleSignIn}) : super(key: key);

  @override
  _AuthCreateAccountState createState() => _AuthCreateAccountState();
}

class _AuthCreateAccountState extends State<AuthCreateAccount> {
  final TextEditingController emailTextController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String error = "";

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
                                child: TextFormField(
                                  controller: emailTextController,
                                  scrollPadding:
                                      EdgeInsets.fromLTRB(0, 0, 0, 80),
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
                                    fillColor:
                                        Theme.of(context).backgroundColor,
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                      borderSide: BorderSide(
                                        width: 0,
                                        color:
                                            _themeProvider.secondaryTextColor,
                                      ),
                                    ),
                                  ),
                                  validator: (val) {
                                    return error.isNotEmpty ? error : null;
                                  },
                                  onChanged: (val) {
                                    error = "";
                                    formKey.currentState.validate();
                                  },
                                ),
                              ),
                              SizedBox(height: 20),
                              SizedBox(
                                height: 65,
                                width: MediaQuery.of(context).size.width,
                                // margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: Theme.of(context).primaryColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(20)),
                                    ),
                                  ),
                                  onPressed: () async {
                                    if (emailTextController.text.isNotEmpty) {
                                      await _authService
                                          .verifyCreateAccountEmail(
                                              emailTextController.text.trim());
                                    } else {
                                      // EMPTY EMAIL
                                      setState(() =>
                                          error = "Email cannot be empty");
                                      formKey.currentState.validate();
                                    }
                                  },
                                  child: Text(
                                    "Create with Email",
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
                              SizedBox(height: 15),
                              // Align(
                              //   child: Text(
                              //     "Or create with...",
                              //     style: TextStyle(
                              //         fontFamily: "Nunito Sans",
                              //         color: _themeProvider.secondaryTextColor,
                              //         fontWeight: FontWeight.w400,
                              //         fontSize: 14),
                              //   ),
                              // ),
                              // SizedBox(height: 15),
                              Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        padding:
                                            EdgeInsets.fromLTRB(0, 20, 0, 20),
                                        // primary: Theme.of(context).backgroundColor.withOpacity(0.95),
                                        primary: Colors.transparent,

                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15)),
                                          side: BorderSide(
                                              color: _themeProvider
                                                  .primaryTextColor
                                                  .withOpacity(0.20)),
                                        ),
                                      ),
                                      onPressed: () async {
                                        // setState(() => loading = true);

                                        // final ReturnValue result = await _authService
                                        //     .signInWithFacebook(newUser: true);

                                        // setState(() => loading = false);

                                        // if (result.success) {
                                        //   toast("Logged in to ${result.value}");
                                        //   Navigator.popUntil(
                                        //       context,
                                        //       ModalRoute.withName(
                                        //           Navigator.defaultRouteName));
                                        // } else {
                                        //   setState(() {
                                        //     toast("Failed to sign in with Facebook");
                                        //     error = result.value;
                                        //   });
                                        // }
                                      },
                                      child: Icon(
                                        FontAwesomeIcons.facebookF,
                                        color: Colors.blue[400],
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 15),
                                  Expanded(
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        padding:
                                            EdgeInsets.fromLTRB(0, 20, 0, 20),
                                        // primary: Theme.of(context).backgroundColor.withOpacity(0.95),
                                        primary: Colors.transparent,
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15)),
                                          side: BorderSide(
                                              color: _themeProvider
                                                  .primaryTextColor
                                                  .withOpacity(0.20)),
                                        ),
                                      ),
                                      onPressed: () async {
                                        // setState(() => loading = true);

                                        // final ReturnValue result = await _authService
                                        //     .signInWithGoogle(newUser: true);

                                        // setState(() => loading = false);
                                        // if (result.success) {
                                        //   toast("Logged in to ${result.value}");
                                        //   Navigator.popUntil(
                                        //       context,
                                        //       ModalRoute.withName(
                                        //           Navigator.defaultRouteName));
                                        // } else {
                                        //   setState(() {
                                        //     toast("Failed to sign in with Google");
                                        //     error = result.value;
                                        //   });
                                        // }
                                      },
                                      child: Icon(
                                        FontAwesomeIcons.google,
                                        color: Colors.red[400],
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Already have an account?",
                          style: TextStyle(
                              fontFamily: "Nunito Sans",
                              color: _themeProvider.secondaryTextColor,
                              fontWeight: FontWeight.w400,
                              fontSize: 14),
                        ),
                        SizedBox(width: 5),
                        GestureDetector(
                          onTap: () => widget.toggleSignIn(),
                          child: Text(
                            "Sign In",
                            style: TextStyle(
                              fontFamily: "Nunito Sans",
                              decoration: TextDecoration.underline,
                              color: _themeProvider.primaryTextColor,
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
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
