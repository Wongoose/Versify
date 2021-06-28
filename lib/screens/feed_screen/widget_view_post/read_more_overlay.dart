import 'package:provider/provider.dart';
import 'package:versify/providers/feeds/all_posts_provider.dart';
import 'package:flutter/material.dart';
import 'package:versify/providers/home/theme_data_provider.dart';

class ReadMoreOverlay extends StatelessWidget {
  final Function readMoreTap;
  final dynamic postsProvider;

  ReadMoreOverlay({this.readMoreTap, this.postsProvider});
  @override
  Widget build(BuildContext context) {
    final ThemeProvider _themeProvider =
        Provider.of<ThemeProvider>(context, listen: false);
    return Visibility(
      replacement: SizedBox.shrink(),
      visible: postsProvider.readVisible,
      child: GestureDetector(
        onTap: () {
          readMoreTap();
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
                height: MediaQuery.of(context).size.height - 200,
                width: MediaQuery.of(context).size.width,
                color: Colors.transparent),
            Container(
              alignment: Alignment.bottomCenter,
              height: 150,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).backgroundColor.withOpacity(0.1),
                    Theme.of(context).backgroundColor,
                  ],
                  stops: [0.0, 1.0],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
              height: 80,
              width: MediaQuery.of(context).size.width,
              color: Theme.of(context).backgroundColor,
              child: TextButton.icon(
                onPressed: () {
                  readMoreTap();
                },
                label: Text(
                  'Tap to read more',
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: _themeProvider.primaryTextColor.withOpacity(0.8),
                      fontFamily: 'Nunito'),
                ),
                style: ButtonStyle(),
                icon: Icon(
                  Icons.touch_app,
                  color: Theme.of(context).primaryColor.withOpacity(0.8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
