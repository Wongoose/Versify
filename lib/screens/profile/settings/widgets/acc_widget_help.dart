import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:versify/providers/providers_home/theme_data_provider.dart';

class AccWidgetHelp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ThemeProvider _themeProvider =
        Provider.of<ThemeProvider>(context, listen: false);

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () async {
        const String _url =
            "mailto:versifyapp@gmail.com?subject=❗HELP!%20(Versify's%20Individual%20Support%20Service)&body=How%20can%20we%20help%20you?\n\nDescription:\n\n";

        await canLaunch(_url)
            ? await launch(_url)
            : throw "Could not launch $_url";
      },
      child: Padding(
        padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
        child: Row(
          children: [
            Icon(
              Icons.help,
              size: 16.5,
              color: Theme.of(context).primaryColor.withOpacity(0.6),
            ),
            SizedBox(width: 10),
            Text(
              "Help",
              style: TextStyle(
                fontSize: 15,
                color: _themeProvider.primaryTextColor.withOpacity(0.87),
                fontWeight: FontWeight.w500,
              ),
            ),
            Expanded(child: Container()),
          ],
        ),
      ),
    );
  }
}
