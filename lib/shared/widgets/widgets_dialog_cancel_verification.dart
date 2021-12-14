import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:versify/providers/providers_home/theme_data_provider.dart';

class DialogCancelVerification extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ThemeProvider _themeProvider = Provider.of<ThemeProvider>(context);

    return SimpleDialog(
      title: Align(
        child: Text(
          "Warning",
          style: TextStyle(
            fontSize: 23,
            fontWeight: FontWeight.w600,
            color: _themeProvider.primaryTextColor,
          ),
        ),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      children: [
        Container(
          padding: EdgeInsets.fromLTRB(30, 15, 30, 10),
          alignment: Alignment.center,
          width: 40,
          child: Text(
            "Verification is still in progress. Do you want to cancel the verification process?",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ),
        // Divider(thickness: 0.5, height: 0),
        Container(
          margin: EdgeInsets.all(0),
          height: 60,
          child: FlatButton(
            materialTapTargetSize: MaterialTapTargetSize.padded,
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: Text(
              "Yes, cancel",
              style: TextStyle(
                color: Colors.red,
                fontSize: 16,
              ),
            ),
          ),
        ),
        Divider(thickness: 0.5, height: 0),
        Container(
          margin: EdgeInsets.all(0),
          height: 60,
          child: FlatButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              "No, go back",
              style: TextStyle(
                color: _themeProvider.primaryTextColor,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
