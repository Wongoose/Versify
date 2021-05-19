import 'package:flutter/material.dart';

class SplashLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ThemeData _theme = Theme.of(context);

    return Scaffold(
      appBar: null,
      backgroundColor: _theme.accentColor,
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
