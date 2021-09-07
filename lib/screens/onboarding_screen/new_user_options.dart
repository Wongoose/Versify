import 'package:provider/provider.dart';
import 'package:versify/providers/home/dynamic_link_provider.dart';
import 'package:versify/providers/home/theme_data_provider.dart';
import 'package:versify/screens/authentication/auth_wrapper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:versify/services/auth.dart';
import 'package:versify/shared/constants.dart';
import 'package:versify/z-dynamic_link/profile_dynamic_link.dart';

class OnBoardingNewUser extends StatefulWidget {
  final bool boardingUserDetails;
  OnBoardingNewUser({this.boardingUserDetails});

  @override
  _OnBoardingNewUserState createState() => _OnBoardingNewUserState();
}

class _OnBoardingNewUserState extends State<OnBoardingNewUser> {
  DynamicLinkProvider _dynamicLinkProvider;
  ThemeProvider _themeProvider;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_dynamicLinkProvider.updatedEmail != null) {
        //need popup
        print('SCREEN newUserOption | start with updated email: ' +
            _dynamicLinkProvider.updatedEmail);
        showModalBottomSheet(
            backgroundColor: Theme.of(context).backgroundColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            isScrollControlled: true,
            enableDrag: false,
            context: context,
            builder: (context) {
              return UpdatedEmailSignIn(_dynamicLinkProvider.updatedEmail);
            });
      }
    });
  }
  // void _openDetails() {
  //   WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
  //     Navigator.push(
  //         context, MaterialPageRoute(builder: (context) => SignUpDetails()));
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    final ThemeData _theme = Theme.of(context);
    _themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    _dynamicLinkProvider =
        Provider.of<DynamicLinkProvider>(context, listen: true);

    return WillPopScope(
        child: Scaffold(
          backgroundColor: _theme.splashColor,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(child: Container()),
              SizedBox(height: 20),
              Image(
                height: 300,
                image: AssetImage('assets/images/purple_circle_v1.png'),
              ),
              // Container(
              //   alignment: Alignment.center,
              //   child: Card(
              //     elevation: 5,
              //     shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(1000)),
              //     child: ClipRRect(
              //       borderRadius: BorderRadius.all(Radius.circular(100000)),
              //       child: Image(
              //         height: 250,
              //         image: AssetImage('assets/images/versify_icon_v3.png'),
              //       ),
              //     ),
              //   ),
              // ),
              // SizedBox(height: 10),
              Text(
                'Versify App',
                style: TextStyle(
                  shadows: [
                    Shadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        offset: Offset(1, 1))
                  ],
                  color: Colors.black87,
                  fontSize: 35,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Nunito',
                ),
              ),
              SizedBox(height: 10),
              SizedBox(
                width: 270,
                child: Text(
                  'Welcome, let\'s get you signed in!',
                  maxLines: null,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Nunito',
                  ),
                ),
              ),
              Expanded(child: Container()),
              Container(
                height: 80,
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: _theme.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                    ),
                    onPressed: () => {
                          Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  // fullscreenDialog: true,
                                  builder: (context) => AuthWrapper(
                                        initialOption: false,
                                      ))),
                        },
                    child: Text(
                      "SIGN UP",
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
              Padding(
                padding: EdgeInsets.fromLTRB(30, 30, 0, 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Already have an account?',
                      style: TextStyle(
                        shadows: [
                          Shadow(
                              color: Colors.black26,
                              blurRadius: 10,
                              offset: Offset(1, 1))
                        ],
                        fontFamily: 'Nunito',
                        color: Colors.black87,
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                      ),
                    ),
                    FlatButton(
                      padding: EdgeInsets.fromLTRB(0, 20, 10, 20),
                      materialTapTargetSize: MaterialTapTargetSize.padded,
                      onPressed: () => {
                        Navigator.push(
                            context,
                            CupertinoPageRoute(
                                // fullscreenDialog: true,
                                builder: (context) => AuthWrapper(
                                      initialOption: true,
                                    ))),
                      },
                      child: Text(
                        'LOGIN',
                        style: TextStyle(
                            // shadows: [
                            //   Shadow(
                            //       color: Colors.black26,
                            //       blurRadius: 10,
                            //       offset: Offset(1, 1))
                            // ],
                            fontFamily: 'Nunito',
                            color: _theme.primaryColor,
                            fontWeight: FontWeight.w800,
                            fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        onWillPop: () => showDialog<bool>(
              context: context,
              builder: (c) => AlertDialog(
                title: Text(
                  'Exit App',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                content: Text('Do you really want to exit the app?'),
                actions: [
                  FlatButton(
                    child: Text('Yes'),
                    onPressed: () => SystemNavigator.pop(),
                  ),
                  FlatButton(
                    child: Text('No'),
                    onPressed: () => Navigator.pop(c, false),
                  ),
                ],
              ),
            ));
  }
}

class UpdatedEmailSignIn extends StatefulWidget {
  final String updatedEmail;
  UpdatedEmailSignIn(this.updatedEmail);

  @override
  _UpdatedEmailSignInState createState() => _UpdatedEmailSignInState();
}

class _UpdatedEmailSignInState extends State<UpdatedEmailSignIn> {
  final _formKey = GlobalKey<FormState>();
  String email;
  String password;
  String error = '';
  bool loading = false;

  @override
  void initState() {
    super.initState();
    email = widget.updatedEmail;
  }

  @override
  Widget build(BuildContext context) {
    final ThemeProvider _themeProvider =
        Provider.of<ThemeProvider>(context, listen: false);
    final DynamicLinkProvider _dynamicLinkProvider =
        Provider.of<DynamicLinkProvider>(context, listen: false);
    final AuthService _authService = Provider.of<AuthService>(context);

    return Padding(
      padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(27, 0, 25, 0),
            child: Text(
              'Login',
              style: TextStyle(
                fontSize: 24,
                fontFamily: 'Nunito',
                fontWeight: FontWeight.w700,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
          SizedBox(height: 5),
          SizedBox(height: error != '' ? 25 : 0),
          error.isNotEmpty
              ? Container(
                  padding: EdgeInsets.fromLTRB(25, 0, 25, 0),
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
          Padding(
            padding: EdgeInsets.fromLTRB(25, 0, 25, 0),
            child: Form(
              key: _formKey, //global key
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
                  Text(
                    ' Email',
                    style: TextStyle(
                      color: _themeProvider.primaryTextColor.withOpacity(0.75),
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Nunito',
                    ),
                  ),
                  SizedBox(height: 5),
                  TextFormField(
                    initialValue: email,
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
                        color: _themeProvider.primaryTextColor,
                      ),
                      fillColor: Theme.of(context).backgroundColor,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide(
                          color: _themeProvider.primaryTextColor,
                          width: 1,
                        ),
                      ),
                    ),
                    validator: (val) => val.isEmpty ? 'Enter an email' : null,
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
                      color: _themeProvider.primaryTextColor.withOpacity(0.75),
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
                        color: _themeProvider.primaryTextColor,
                      ),
                      fillColor: Theme.of(context).backgroundColor,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide(
                          color: _themeProvider.primaryTextColor,
                          width: 1,
                        ),
                      ),
                    ),
                    validator: (val) => val.length < 6
                        ? 'Password must have at least 7 characters.'
                        : null, //return null when it is valid
                    obscureText: true,
                    onChanged: (val) {
                      _dynamicLinkProvider.resetUpdatedEmail();
                      setState(() {
                        password = val;
                        error = '';
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          // Expanded(child: Container()),
          SizedBox(height: 40),
          Container(
            margin: EdgeInsets.all(0),
            width: MediaQuery.of(context).size.width,
            height: 60,
            color: Colors.transparent,
            child: FlatButton(
              materialTapTargetSize: MaterialTapTargetSize.padded,
              color: loading
                  ? Theme.of(context).backgroundColor
                  : Theme.of(context).primaryColor,
              splashColor: loading
                  ? Theme.of(context).backgroundColor
                  : Theme.of(context).primaryColor,
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
                        Navigator.popUntil(context,
                            ModalRoute.withName(Navigator.defaultRouteName));
                      });
                      // setState(() {});
                    } else if (res == false) {
                      print('Auth Screen result is equal false');
                      setState(() {
                        error = 'Could not sign in with those credentials';
                        loading = false;
                      });
                    }
                  });
                }
              },
              child: loading
                  ? SizedBox(
                      height: 15,
                      width: 15,
                      child: CircularProgressIndicator(
                        valueColor: new AlwaysStoppedAnimation<Color>(
                            Theme.of(context).primaryColor),
                        strokeWidth: 0.5,
                      ))
                  : Text(
                      'Continue',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
// SizedBox(
//   height: 60,
//   width: 175,
//   child: ElevatedButton(
//       style: ElevatedButton.styleFrom(
//         primary: _theme.primaryColor,
//         shape: RoundedRectangleBorder(
//           borderRadius:
//               BorderRadius.all(Radius.circular(10)),
//         ),
//         textStyle: TextStyle(
//             fontFamily: 'Nunito',
//             color: Colors.white,
//             fontWeight: FontWeight.w600,
//             fontSize: 16),
//       ),
//       onPressed: () => {
//             Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                     builder: (context) => AuthWrapper(
//                           initialOption: true,
//                         ))),
//           },
//       child: Text('I have an account')),
// ),
// SizedBox(
//   height: 60,
//   width: 175,
//   child: ElevatedButton(
//       style: ElevatedButton.styleFrom(
//         primary: Colors.blue[300],
//         shape: RoundedRectangleBorder(
//           borderRadius:
//               BorderRadius.all(Radius.circular(10)),
//         ),
//         textStyle: TextStyle(
//             fontFamily: 'Nunito',
//             color: Colors.white,
//             fontWeight: FontWeight.w600,
//             fontSize: 16),
//       ),
//       onPressed: () => {
//             Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                     builder: (context) => AuthWrapper(
//                           initialOption: false,
//                         ))),
//           },
//       child: Text("I'm new here")),
// )
