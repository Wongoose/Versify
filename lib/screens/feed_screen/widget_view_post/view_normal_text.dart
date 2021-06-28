import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:versify/providers/home/theme_data_provider.dart';

class ViewPostText extends StatelessWidget {
  final bool isFirst;
  final String value;

  ViewPostText({this.isFirst, this.value});

  @override
  Widget build(BuildContext context) {
    final ThemeData _theme = Theme.of(context);
    final ThemeProvider _themeProvider =
        Provider.of<ThemeProvider>(context, listen: false);

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
            color: _themeProvider.primaryTextColor,
            fontWeight: FontWeight.w400,
            height: 1.5),
      ),
    );
  }
}
