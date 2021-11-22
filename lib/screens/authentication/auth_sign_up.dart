import 'package:overlay_support/overlay_support.dart';
import 'package:versify/providers/providers_home/theme_data_provider.dart';
import 'package:versify/services/firebase/auth.dart';
import 'package:versify/shared/widgets/widgets_all_loading.dart';
import 'package:versify/shared/helper/helper_constants.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class SignUpAuth extends StatefulWidget {
  final Function() toggleSignIn;

  SignUpAuth({this.toggleSignIn});
  @override
  _SignUpAuthState createState() => _SignUpAuthState();
}

class _SignUpAuthState extends State<SignUpAuth> {
  final _formKey = GlobalKey<FormState>();
  // final AuthService _auth = AuthService();
  //
  AuthService _authService;

  bool loading = false;
  bool _dialogLoading = false;

  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    final ThemeProvider _themeProvider =
        Provider.of<ThemeProvider>(context, listen: false);
    _authService = Provider.of<AuthService>(context);

    print('SIGN UP AUTH');
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
          SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 35.0, vertical: 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Expanded(child: Container()),
                // Text(
                //   'Sign Up',
                //   style: TextStyle(
                //     shadows: [
                //       Shadow(
                //           color: Colors.black12,
                //           blurRadius: 10,
                //           offset: Offset(1, 1))
                //     ],
                //     color: Colors.black87,
                //     fontSize: 25,
                //     fontWeight: FontWeight.w700,
                //     fontFamily: 'Nunito',
                //   ),
                // ),
                // SizedBox(height: 15),
                // Text(
                //   'Let\'s get your account up and ready!',
                //   style: TextStyle(
                //       fontFamily: 'Nunito',
                //       color: Colors.black54,
                //       fontWeight: FontWeight.w400,
                //       fontSize: 14),
                // ),
                SizedBox(height: 40),
                Align(
                  alignment: Alignment.centerLeft,
                  child: SizedBox(
                    width: 250,
                    child: RichText(
                      maxLines: 2,
                      text: TextSpan(children: [
                        TextSpan(
                          text: 'Create',
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 37,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Nunito',
                              height: 1.1),
                        ),
                        TextSpan(
                          text: ' an Account',
                          style: TextStyle(
                              color: _themeProvider.primaryTextColor,
                              fontSize: 37,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Nunito',
                              height: 1.1),
                        )
                      ]),
                    ),
                  ),
                ),
                // Expanded(child: Container()),
                SizedBox(height: 40),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                          primary: Theme.of(context).dialogBackgroundColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
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
                          primary: Theme.of(context).dialogBackgroundColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                        ),
                        onPressed: () async {
                          setState(() => loading = true);
                          _authService
                              .signInWithGoogle(newUser: true)
                              .then((authUser) {
                            setState(() => loading = false);
                            if (authUser != null) {
                              Navigator.popUntil(
                                  context,
                                  ModalRoute.withName(
                                    Navigator.defaultRouteName,
                                  ));
                            } else {
                              toast('Failed to sign up. Please try again.');
                            }
                          });

                          // setState(() => loading = true);

                          // await _authService
                          //     .createGoogleAccount()
                          //     .then((createAcc) {
                          //   if (createAcc == CreateAcc.newAccount) {
                          //     Navigator.popUntil(
                          //         context,
                          //         ModalRoute.withName(
                          //           Navigator.defaultRouteName,
                          //         ));
                          //   } else if (createAcc == CreateAcc.hasAccount) {
                          //     //already has account - switch to login
                          //     showDialogWhenCancel();
                          //   } else {
                          //     //error occured
                          //     ScaffoldMessenger.of(context)
                          //         .showSnackBar(SnackBar(
                          //       content: Text(
                          //         'An error has occured while logging in. Please try again.',
                          //       ),
                          //     ));
                          //   }
                          //   setState(() => loading = false);
                          // });
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
                SizedBox(height: 30),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    'or Sign Up with Email',
                    style: TextStyle(
                        fontFamily: 'Nunito',
                        color: _themeProvider.secondaryTextColor,
                        fontWeight: FontWeight.w400,
                        fontSize: 14),
                  ),
                ),
                SizedBox(height: error != '' ? 25 : 0),
                error != ''
                    ? Align(
                        alignment: Alignment.center,
                        child: Text(
                          error,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                          ),
                        ),
                      )
                    : Container(),
                Form(
                  key: _formKey, //global key
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20),
                      Text(
                        ' Email',
                        style: TextStyle(
                          color:
                              _themeProvider.primaryTextColor.withOpacity(0.75),
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Nunito',
                        ),
                      ),
                      SizedBox(height: 5),
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
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(
                              color: _themeProvider.secondaryTextColor,
                              width: 1,
                            ),
                          ),
                        ),
                        validator: (val) =>
                            val.isEmpty ? 'Enter an email' : null,
                        onChanged: (val) {
                          setState(() {
                            email = val;
                            error = '';
                          });
                        },
                      ),
                      SizedBox(height: 25),
                      Text(
                        ' Password',
                        style: TextStyle(
                          color:
                              _themeProvider.primaryTextColor.withOpacity(0.75),
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Nunito',
                        ),
                      ),
                      SizedBox(height: 5),
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
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(
                              color: _themeProvider.secondaryTextColor,
                              width: 1,
                            ),
                          ),
                        ),
                        validator: (val) => val.length < 6
                            ? 'Password must have at least 7 characters.'
                            : null, //return null when it is valid
                        obscureText: true,
                        onChanged: (val) {
                          setState(() {
                            password = val;
                            error = '';
                          });
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 100),
                // Expanded(child: Container()),

                Container(
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
                        if (_formKey.currentState.validate()) {
                          setState(() => loading = true);
                          _authService
                              .createUserEmailPassword(
                                  email.trim(), password.trim())
                              .then((errorMap) {
                            setState(() => loading = false);
                            if (errorMap == null) {
                              //no errors -> pop and go to createUsername screen
                              Navigator.popUntil(
                                  context,
                                  ModalRoute.withName(
                                      Navigator.defaultRouteName));
                            } else {
                              //has errors
                              toast(errorMap['errorMessage'],
                                  duration: Toast.LENGTH_LONG);
                              setState(() => error = errorMap['errorMessage']);
                            }
                          });
                        }

                        // if (_formKey.currentState.validate()) {
                        //   setState(() => loading = true);
                        //   await _authService
                        //       .createAccount(email.trim(), password.trim())
                        //       .then((res) {
                        //     if (res == null) {
                        //       setState(() {
                        //         loading = false;
                        //         error = "Couldn't create account!";
                        //       });
                        //     } else {
                        //       Navigator.pop(context);
                        //     }
                        //   });
                        // }
                      },
                      child: Text(
                        "Sign Up with email",
                        style: TextStyle(
                          // shadows: [
                          //   Shadow(
                          //       color: Colors.black26,
                          //       blurRadius: 10,
                          //       offset: Offset(0.5, 0.5))
                          // ],
                          fontFamily: 'Nunito',
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      )),
                ),

                SizedBox(height: 20),

                Padding(
                  padding: EdgeInsets.fromLTRB(30, 10, 30, 40),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already have an account?',
                        style: TextStyle(
                            fontFamily: 'Nunito',
                            color: _themeProvider.secondaryTextColor,
                            fontWeight: FontWeight.w400,
                            fontSize: 14),
                      ),
                      SizedBox(width: 5),
                      GestureDetector(
                        onTap: () {
                          widget.toggleSignIn();
                          // Navigator.pop(context);
                        },
                        child: Text(
                          'Login',
                          style: TextStyle(
                              fontFamily: 'Nunito',
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
          Visibility(
            visible: loading,
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              color: Colors.black.withOpacity(0.8),
              alignment: Alignment.center,
              child: Loading(),
            ),
          ),
        ],
      ),
    );
  }

  void showDialogWhenCancel() {
    showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: Align(
              alignment: Alignment.center,
              child: Text(
                'Existing Account',
                style: TextStyle(fontSize: 23, fontWeight: FontWeight.w600),
              ),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(30, 15, 30, 10),
                alignment: Alignment.center,
                width: 40,
                child: Text(
                  'This account has already been registered. Log In instead?',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
              ),
              // Divider(thickness: 0.5, height: 0),
              Container(
                margin: EdgeInsets.all(0),
                height: 60,
                child: FlatButton(
                  materialTapTargetSize: MaterialTapTargetSize.padded,
                  onPressed: () {
                    // setState(() => _dialogLoading = true);

                    // _authService.signInWithGoogle(newUser: false).then((user) {
                    //   setState(() => _dialogLoading = false);
                    //   if (user != null) {
                    //     Navigator.popUntil(context,
                    //         ModalRoute.withName(Navigator.defaultRouteName));
                    //   }
                    // });
                    if (_authService.authUser != null) {
                      Navigator.popUntil(context,
                          ModalRoute.withName(Navigator.defaultRouteName));
                    }
                  },
                  child: _dialogLoading
                      ? SizedBox(
                          height: 15,
                          width: 15,
                          child: CircularProgressIndicator(
                            valueColor: new AlwaysStoppedAnimation<Color>(
                                Theme.of(context).primaryColor),
                            strokeWidth: 0.5,
                          ),
                        )
                      : Text(
                          'Login',
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
              Divider(thickness: 0.5, height: 0),
              Container(
                margin: EdgeInsets.all(0),
                height: 60,
                child: FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _authService.logout();
                  },
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      color: Colors.black45,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          );
        });
  }
}
