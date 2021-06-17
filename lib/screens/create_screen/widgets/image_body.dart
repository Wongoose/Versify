import 'package:flutter/material.dart';

class ImageBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.fromLTRB(15, 30, 30, 30),
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(
            width: 2,
            color: Theme.of(context).primaryColor,
          ),
        ),
      ),
      child: ClipRRect(
        
        child: Image(
          height: 300,
          image: AssetImage('assets/images/philipians_4_13.png'),
        ),
      ),
    );
  }
}
