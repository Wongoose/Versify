import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WordScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
          child: ClipRRect(
        clipBehavior: Clip.hardEdge,
          child: Image(
        image: AssetImage('assets/images/philipians_4_13.png'),
      )),
    );
  }
}

class Body extends StatelessWidget {
  const Body({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        Positioned(
          top: -5,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 0,
                )
              ],
            ),
            height: 100,
            width: 230,
          ),
        ),
        Container(
          height: 450,
          margin: EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black38,
                blurRadius: 2,
              )
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image(
              image: AssetImage('assets/images/philipians_4_13.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          bottom: -20,
          child: Container(
            width: 150,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icon(
                //   Icons.share,
                //   color: Colors.pink,
                //   size: 25,
                // ),
                Container(
                  height: 45,
                  width: 45,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.pink,
                  ),
                  child: Center(
                    child: Icon(
                      CupertinoIcons.heart_solid,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
                // Icon(
                //   Icons.cloud_download,
                //   color: Colors.pink,
                //   size: 25,
                // ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
