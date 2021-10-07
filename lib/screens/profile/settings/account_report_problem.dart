import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:versify/providers/providers_home/theme_data_provider.dart';
import 'package:versify/services/firebase/auth.dart';
import 'package:versify/services/firebase/database.dart';
import 'package:versify/services/others/notification.dart';

class AccountReportProblem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ThemeProvider _themeProvider =
        Provider.of<ThemeProvider>(context, listen: false);

    final TextEditingController _textController = TextEditingController();

    final AuthService _authService = Provider.of<AuthService>(context);
    final DatabaseService _databaseService =
        Provider.of<DatabaseService>(context);

    return WillPopScope(
      onWillPop: () async {
        if (Navigator.of(context).userGestureInProgress)
          return false;
        else
          return true;
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          backgroundColor: Theme.of(context).backgroundColor,
          centerTitle: true,
          elevation: 0.5,
          title: Text(
            'Report a problem',
            style: TextStyle(
              fontSize: 17.5,
              fontWeight: FontWeight.w600,
              color: _themeProvider.primaryTextColor.withOpacity(0.87),
            ),
          ),
          leadingWidth: 60,
          leading: TextButton(
            style: TextButton.styleFrom(
                padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                backgroundColor: Theme.of(context).backgroundColor,
                primary: Theme.of(context).backgroundColor),
            child: Text(
              'Back',
              style: TextStyle(
                fontSize: 14,
                color: _themeProvider.secondaryTextColor,
                fontWeight: FontWeight.w500,
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: [
            TextButton(
                style: TextButton.styleFrom(
                  padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                  backgroundColor: Theme.of(context).backgroundColor,
                  primary: Theme.of(context).backgroundColor,
                ),
                child: Text(
                  'Submit',
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onPressed: () {
                  if (_textController.text.isNotEmpty) {
                    //do something
                    NotificationOverlay().showNormalImageDialog(
                      context,
                      body:
                          "Thank you for choosing to help improve the Versify community. Your feedback matters to us!",
                      buttonText: "Close",
                      clickFunc: () {
                        Navigator.pop(context);
                      },
                      imagePath: 'assets/images/laugh.png',
                      title: "Submitted",
                      delay: Duration(seconds: 0),
                    );

                    _databaseService.reportAProblem(
                      reportDescription: _textController.text.trim(),
                      username: _authService.myUser.username,
                      userID: _authService.myUser.userUID,
                    );
                  }
                }),
          ],
        ),
        body: Padding(
          padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Please tell us more about the problem: ',
                style: TextStyle(
                  fontSize: 14,
                  color: _themeProvider.secondaryTextColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 5),
              TextFormField(
                autofocus: true,
                controller: _textController,
                maxLength: 300,
                maxLines: null,
                cursorColor: Theme.of(context).primaryColor,
                onChanged: (_) {
                  //trigger has change text
                },
                buildCounter: (_, {currentLength, maxLength, isFocused}) {
                  return Container(
                    padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '${currentLength.toString()}/${maxLength.toString()}',
                      style: TextStyle(
                        fontSize: 12,
                        color: currentLength > maxLength
                            ? Colors.red
                            : _themeProvider.secondaryTextColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                },
                style: TextStyle(
                  color: _themeProvider.primaryTextColor,
                ),
                decoration: InputDecoration(
                  // prefixText:
                  //     widget.editType == AccountEditType.username ? '@ ' : '',
                  prefixStyle: TextStyle(
                      color: _themeProvider.secondaryTextColor, fontSize: 15),
                  isDense: true,
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color:
                            _themeProvider.primaryTextColor.withOpacity(0.26),
                        width: 0.5),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color:
                            _themeProvider.primaryTextColor.withOpacity(0.26),
                        width: 0.5),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
