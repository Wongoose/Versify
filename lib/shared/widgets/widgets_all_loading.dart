import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

// splash loading
class SplashLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ThemeData _theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Color(0xFFefdaff),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        alignment: Alignment.center,
        child: Image(
          height: 150,
          width: 150,
          image: AssetImage('assets/images/purple_circle_v1.png'),
        ),
      ),
    );
  }
}

// normal loading
class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            SpinKitDoubleBounce(
              duration: Duration(milliseconds: 2000),
              color: Color(0xFFf7eaff),
              size: 100,
            ),
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Image(
                  height: 80,
                  image: AssetImage('assets/images/purple_circle_v1.png'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// circle progress loading
class CircleLoading extends StatelessWidget {
  final double size;

  const CircleLoading({this.size});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size != null ? size * 15 : 15,
      width: size != null ? size * 15 : 15,
      child: CircularProgressIndicator(
        valueColor:
            new AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
        strokeWidth: 0.5,
      ),
    );
  }
}
