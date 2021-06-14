import 'package:flutter/material.dart';

class ViewPostText extends StatelessWidget {
  final bool isFirst;
  final String value;

  ViewPostText({this.isFirst, this.value});

  @override
  Widget build(BuildContext context) {
    final ThemeData _theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.fromLTRB(8, isFirst ? 2 : 8, 0, 8),
      margin: EdgeInsets.fromLTRB(0, 0, 26, 0),
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(
            width: 2,
            color: _theme.primaryColor,
          ),
        ),
      ),
      child: Text(
        value,
        style: TextStyle(
            fontSize: 16,
            color: Colors.black,
            fontWeight: FontWeight.w400,
            height: 1.5),
      ),
    );
  }
}
