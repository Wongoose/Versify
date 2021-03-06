import 'package:versify/providers/create_post/content_body_provider.dart';
import 'package:versify/providers/home/theme_data_provider.dart';
import 'package:versify/services/auth.dart';
import 'package:versify/shared/profilePicture.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ContentBody extends StatelessWidget {
  final bool isFocus;
  // final TextEditingController textEditingController;
  // final List<Widget> contentBodyWidgets;

  ContentBody({this.isFocus});
  @override
  Widget build(BuildContext context) {
    final AuthService _authService = Provider.of<AuthService>(context);
    final ThemeProvider _themeProvider =
        Provider.of<ThemeProvider>(context, listen: false);

    return Column(
      children: [
        SizedBox(height: 20),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ProfilePic(
              userProfile: _authService.myUser,
              primary: Theme.of(context).primaryColor,
              secondary: Theme.of(context).primaryColor,
              size: 1,
            ),
            SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                    child: Text(
                      'writing...',

                      // ' Posted on ${lastUpdated.toString().split(' ')[0]}',

                      style: TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  Text(
                    'by ${_authService.myUser.username ?? 'me'}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.italic,
                      color: _themeProvider.secondaryTextColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 20),
        Divider(thickness: 0.5),
        SizedBox(height: 20),
        Align(
          alignment: Alignment.topLeft,
          child: Text(
            'Write',
            softWrap: true,
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              letterSpacing: 0,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        SizedBox(height: 8),
        Consumer<ContentBodyProvider>(
          builder: (context, contentProvider, child) {
            // isFocus ? contentProvider.refocusCurrent() : null;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: contentProvider.listOfContentWidgets
                  .map((contentWidget) => contentWidget.widget)
                  .toList()
                  .cast<Widget>(),
              // children: [ 
              //   TextContent(
              //     textEditingController: textEditingController,
              //     focus: focus,
              //     isFocus: isFocus,
              //   ),
              //   QuoteText(),
              //   ImageBody(),
              // ],
            );
          },
        ),
      ],
    );
  }
}
