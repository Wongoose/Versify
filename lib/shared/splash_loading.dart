import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SplashLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Color(0xFFffdee9),
        systemNavigationBarDividerColor: Colors.white,
        systemNavigationBarColor: Colors.white,
      ),
    );

    final ThemeData _theme = Theme.of(context);

    return Scaffold(
      appBar: null,
      backgroundColor: Color(0xFFffdee9),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        alignment: Alignment.center,
        child: Image(
          height: 150,
          width: 150,
          image: AssetImage('assets/images/versify_logo_circle.png'),
        ),
      ),
    );
  }
}
