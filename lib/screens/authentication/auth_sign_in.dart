import 'package:versify/services/firebase/auth.dart';
import 'package:versify/shared/widgets/widgets_all_loading.dart';
import 'package:versify/shared/helper/helper_constants.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class SignInAuth extends StatefulWidget {
  final Function() toggleSignIn;

  SignInAuth({this.toggleSignIn});
  @override
  _SignInAuthState createState() => _SignInAuthState();
}

class _SignInAuthState extends State<SignInAuth> {
  final _formKey = GlobalKey<FormState>();
  // final AuthService _auth = AuthService();

  bool loading = false;

  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    final AuthService _authService = Provider.of<AuthService>(context);

    print('SIGN IN AUTH');
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(
            Icons.arrow_back_ios_rounded,
            color: Colors.black87,
          ),
        ),
        actions: [],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 35.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 40),
                Align(
                  alignment: Alignment.centerLeft,
                  child: SizedBox(
                    width: 260,
                    child: RichText(
                      maxLines: 2,
                      text: TextSpan(children: [
                        TextSpan(
                          text: 'Welcome',
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 37,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Nunito',
                              height: 1.1),
                        ),
                        TextSpan(
                          text: '',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 37,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Nunito',
                              height: 1.1),
                        ),
                        TextSpan(
                          text: ' back to Versify.',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 37,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Nunito',
                              height: 1.1),
                        )
                      ]),
                    ),
                  ),
                ),
                SizedBox(height: 40),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                          primary: Colors.white,
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
                          primary: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
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
                SizedBox(height: 30),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    'or Login with Email',
                    style: TextStyle(
                        fontFamily: 'Nunito',
                        color: Colors.black54,
                        fontWeight: FontWeight.w400,
                        fontSize: 14),
                  ),
                ),
                SizedBox(height: error != '' ? 10 : 0),
                error != ''
                    ? Text(
                        error,
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 14,
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
                          color: Colors.black.withOpacity(0.75),
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Nunito',
                        ),
                      ),
                      SizedBox(height: 5),
                      TextFormField(
                        scrollPadding: EdgeInsets.fromLTRB(0, 0, 0, 80),
                        decoration: textInputDecoration.copyWith(
                          hintText: 'Email',
                          prefixIcon: Icon(Icons.mail_outline_rounded),
                        ),
                        validator: (val) =>
                            val.isEmpty ? 'Enter an email' : null,
                        onChanged: (val) {
                          setState(() => email = val);
                        },
                      ),
                      SizedBox(height: 25),
                      Text(
                        ' Password',
                        style: TextStyle(
                          color: Colors.black.withOpacity(0.75),
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Nunito',
                        ),
                      ),
                      SizedBox(height: 5),
                      TextFormField(
                        scrollPadding: EdgeInsets.fromLTRB(0, 0, 0, 80),
                        decoration: textInputDecoration.copyWith(
                          hintText: 'Password',
                          prefixIcon: Icon(Icons.lock_outline_rounded),
                        ),
                        validator: (val) => val.length < 6
                            ? 'Enter a password 6+ chars long'
                            : null, //return null when it is valid
                        obscureText: true,
                        onChanged: (val) {
                          setState(() => password = val);
                        },
                      ),
                      SizedBox(height: 20),
                      // RaisedButton(
                      //   color: Theme.of(context).primaryColor,
                      //   child: Text(
                      //     'Log In',
                      //     style: TextStyle(
                      //       color: Colors.white,
                      //     ),
                      //   ),
                      //   onPressed: () async {
                      //     if (_formKey.currentState.validate()) {
                      //       setState(() => loading = true);
                      //       await _authService
                      //           .signInEmail(
                      //               email.trim(), password.trim())
                      //           .then((res) {
                      //         if (res != false) {
                      //           setState(() {
                      //             loading = false;
                      //             print(
                      //                 'Auth Screen result is equal TRUE');
                      //             Navigator.pop(context);
                      //           });
                      //           // setState(() {});
                      //         } else if (res == false) {
                      //           print(
                      //               'Auth Screen result is equal false');
                      //           setState(() {
                      //             error =
                      //                 'Could not sign in with those credentials';
                      //             loading = false;
                      //           });
                      //         }
                      //       });
                      //     }
                      //   },
                      // ),
                    ],
                  ),
                ),
                // Expanded(child: Container()),
                SizedBox(height: 100),

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
                          await _authService
                              .signInWithEmailPassword(email.trim(), password.trim())
                              .then((res) {
                            if (res != false) {
                              setState(() {
                                loading = false;
                                print('Auth Screen result is equal TRUE');
                                Navigator.popUntil(
                                    context,
                                    ModalRoute.withName(
                                        Navigator.defaultRouteName));
                              });
                              // setState(() {});
                            } else if (res == false) {
                              print('Auth Screen result is equal false');
                              setState(() {
                                error =
                                    'Could not sign in with those credentials';
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
                        'Don\'t have an account?',
                        style: TextStyle(
                            fontFamily: 'Nunito',
                            color: Colors.black54,
                            fontWeight: FontWeight.w400,
                            fontSize: 14),
                      ),
                      SizedBox(width: 5),
                      GestureDetector(
                        onTap: () => widget.toggleSignIn(),
                        child: Text(
                          'Register',
                          style: TextStyle(
                              fontFamily: 'Nunito',
                              color: Colors.black87,
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
}
