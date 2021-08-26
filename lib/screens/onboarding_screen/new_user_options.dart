import 'package:versify/screens/authentication/auth_wrapper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OnBoardingNewUser extends StatefulWidget {
  final bool boardingUserDetails;
  OnBoardingNewUser({this.boardingUserDetails});

  @override
  _OnBoardingNewUserState createState() => _OnBoardingNewUserState();
}

class _OnBoardingNewUserState extends State<OnBoardingNewUser> {
  // void _openDetails() {
  //   WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
  //     Navigator.push(
  //         context, MaterialPageRoute(builder: (context) => SignUpDetails()));
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    final ThemeData _theme = Theme.of(context);

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
                image:AssetImage('assets/images/purple_circle_v1.png'),
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
