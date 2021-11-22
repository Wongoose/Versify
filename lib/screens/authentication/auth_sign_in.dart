import 'package:versify/providers/providers_home/theme_data_provider.dart';
import "package:versify/services/firebase/auth.dart";
import 'package:versify/shared/helper/helper_methods.dart';
import "package:versify/shared/widgets/widgets_all_loading.dart";
import "package:versify/shared/helper/helper_constants.dart";
import "package:flutter/material.dart";
import "package:font_awesome_flutter/font_awesome_flutter.dart";
import "package:provider/provider.dart";

class SignInAuth extends StatefulWidget {
  final Function() toggleSignIn;

  const SignInAuth({this.toggleSignIn});
  @override
  _SignInAuthState createState() => _SignInAuthState();
}

class _SignInAuthState extends State<SignInAuth> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // final AuthService _auth = AuthService();

  bool loading = false;

  String email = "";
  String password = "";
  String error = "";

  @override
  Widget build(BuildContext context) {
    final AuthService _authService = Provider.of<AuthService>(context);
    final ThemeProvider _themeProvider = Provider.of<ThemeProvider>(context);

    print(purplePen("Auth Sign In | Start build!"));
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
        actions: [],
      ),
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 35.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: 25),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: SizedBox(
                          // width: 300,
                          child: RichText(
                            maxLines: 2,
                            text: TextSpan(children: [
                              TextSpan(
                                text: "Let's sign you in.",
                                style: TextStyle(
                                    color: _themeProvider.primaryTextColor,
                                    fontSize: 39,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "Nunito",
                                    height: 1.1),
                              ),
                            ]),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Welcome back.",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              color: _themeProvider.primaryTextColor,
                              fontSize: 28,
                              fontWeight: FontWeight.w300,
                              fontFamily: "Nunito",
                              height: 1.1),
                        ),
                      ),
                      SizedBox(height: 5),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "You've been missed!",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              color: _themeProvider.primaryTextColor,
                              fontSize: 28,
                              fontWeight: FontWeight.w300,
                              fontFamily: "Nunito",
                              height: 1.1),
                        ),
                      ),
                      SizedBox(height: 30),
                      SizedBox(height: error != "" ? 10 : 0),
                      if (error != "")
                        Text(
                          error,
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 14,
                          ),
                        )
                      else
                        Container(),
                      Form(
                        key: _formKey, //global key
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 20),
                            // Text(
                            //   " Email",
                            //   style: TextStyle(
                            //     color: _themeProvider.primaryTextColor.withOpacity(0.75),
                            //     fontSize: 16,
                            //     fontWeight: FontWeight.w700,
                            //     fontFamily: "Nunito",
                            //   ),
                            // ),
                            // SizedBox(height: 5),
                            TextFormField(
                              scrollPadding: EdgeInsets.fromLTRB(0, 0, 0, 80),
                              style: TextStyle(
                                color: _themeProvider.primaryTextColor,
                              ),
                              decoration: textInputDecoration.copyWith(
                                hintText: 'Email',
                                hintStyle: TextStyle(
                                  color: _themeProvider.secondaryTextColor,
                                ),
                                prefixIcon: Icon(
                                  Icons.mail_outline_rounded,
                                  color: _themeProvider.secondaryTextColor,
                                ),
                                fillColor: Theme.of(context).backgroundColor,
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  borderSide: BorderSide(
                                    color: _themeProvider.secondaryTextColor,
                                    width: 1,
                                  ),
                                ),
                              ),
                              validator: (val) =>
                                  val.isEmpty ? "Enter an email" : null,
                              onChanged: (val) {
                                setState(() => email = val);
                              },
                            ),
                            SizedBox(height: 25),
                            // Text(
                            //   " Password",
                            //   style: TextStyle(
                            //     color: _themeProvider.primaryTextColor.withOpacity(0.75),
                            //     fontSize: 16,
                            //     fontWeight: FontWeight.w700,
                            //     fontFamily: "Nunito",
                            //   ),
                            // ),
                            // SizedBox(height: 5),
                            TextFormField(
                              scrollPadding: EdgeInsets.fromLTRB(0, 0, 0, 80),
                              style: TextStyle(
                                color: _themeProvider.primaryTextColor,
                              ),
                              decoration: textInputDecoration.copyWith(
                                hintText: 'Password',
                                hintStyle: TextStyle(
                                  color: _themeProvider.secondaryTextColor,
                                ),
                                prefixIcon: Icon(
                                  Icons.lock_outline_rounded,
                                  color: _themeProvider.secondaryTextColor,
                                ),
                                fillColor: Theme.of(context).backgroundColor,
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  borderSide: BorderSide(
                                    color: _themeProvider.secondaryTextColor,
                                    width: 1,
                                  ),
                                ),
                              ),
                              validator: (val) => val.length < 6
                                  ? "Enter a password 6+ chars long"
                                  : null, //return null when it is valid
                              obscureText: true,
                              onChanged: (val) {
                                setState(() => password = val);
                              },
                            ),
                            SizedBox(height: 20),

                            SizedBox(height: 20),

                            Container(
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
                                    if (_formKey.currentState.validate()) {
                                      setState(() => loading = true);
                                      await _authService
                                          .signInWithEmailPassword(
                                              email.trim(), password.trim())
                                          .then((res) {
                                        if (res != false) {
                                          setState(() {
                                            loading = false;
                                            print(
                                                "Auth Screen result is equal TRUE");
                                            Navigator.popUntil(
                                                context,
                                                ModalRoute.withName(Navigator
                                                    .defaultRouteName));
                                          });
                                          // setState(() {});
                                        } else if (res == false) {
                                          print(
                                              "Auth Screen result is equal false");
                                          setState(() {
                                            error =
                                                "Could not sign in with those credentials";
                                            loading = false;
                                          });
                                        }
                                      });
                                    }
                                  },
                                  child: Text(
                                    "Login with email",
                                    style: TextStyle(
                                      // shadows: [
                                      //   Shadow(
                                      //       color: _themeProvider.primaryTextColor26,
                                      //       blurRadius: 10,
                                      //       offset: Offset(0.5, 0.5))
                                      // ],
                                      fontFamily: "Nunito",
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16,
                                    ),
                                  )),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 40),
                      Align(
                        child: Text(
                          "Or, login with...",
                          style: TextStyle(
                              fontFamily: "Nunito",
                              color: _themeProvider.secondaryTextColor,
                              fontWeight: FontWeight.w400,
                              fontSize: 14),
                        ),
                      ),
                      SizedBox(height: 40),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                                primary: Theme.of(context).backgroundColor,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15)),
                                  side: BorderSide(
                                      color: _themeProvider.primaryTextColor
                                          .withOpacity(0.20)),
                                ),
                              ),
                              onPressed: () => {},
                              child: Icon(
                                FontAwesomeIcons.facebookF,
                                color: Colors.blue[400],
                                size: 20,
                              ),
                            ),
                          ),
                          SizedBox(width: 20),
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                                primary: Theme.of(context).backgroundColor,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15)),
                                  side: BorderSide(
                                      color: _themeProvider.primaryTextColor
                                          .withOpacity(0.20)),
                                ),
                              ),
                              onPressed: () {
                                setState(() => loading = true);

                                _authService
                                    .signInWithGoogle(newUser: true)
                                    .then((user) {
                                  if (user != null) {
                                    Navigator.popUntil(
                                        context,
                                        ModalRoute.withName(
                                            Navigator.defaultRouteName));
                                  }
                                  setState(() => loading = false);
                                });
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
                      Expanded(child: Container()),
                      SizedBox(height: 30),
                      Padding(
                        padding: EdgeInsets.fromLTRB(30, 10, 30, 40),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Don't have an account?",
                              style: TextStyle(
                                  fontFamily: "Nunito",
                                  color: _themeProvider.secondaryTextColor,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14),
                            ),
                            SizedBox(width: 5),
                            GestureDetector(
                              onTap: () => widget.toggleSignIn(),
                              child: Text(
                                "Register",
                                style: TextStyle(
                                    fontFamily: "Nunito",
                                    color: _themeProvider.primaryTextColor,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14),
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
          Visibility(
            visible: loading,
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              color: _themeProvider.primaryTextColor.withOpacity(0.8),
              alignment: Alignment.center,
              child: Loading(),
            ),
          ),
        ],
      ),
    );
  }
}
