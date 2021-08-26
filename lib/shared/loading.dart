import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Container(
            //   height: MediaQuery.of(context).size.height,
            //   color: Colors.black.withOpacity(0.3),
            // ),
            // SizedBox(height: 15),
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
                  image:AssetImage('assets/images/purple_circle_v1.png'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
