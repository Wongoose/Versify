import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:versify/providers/providers_home/theme_data_provider.dart';

class NormalImageDialog extends StatelessWidget {
  final String imagePath;
  final String title;
  final String body;
  final String buttonText;
  final Function clickFunc;

  const NormalImageDialog(
      {Key key,
      @required this.imagePath,
      @required this.title,
      @required this.body,
      @required this.clickFunc,
      @required this.buttonText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeProvider _themeProvider =
        Provider.of<ThemeProvider>(context, listen: false);
    return Dialog(
      elevation: 2,
      insetAnimationDuration: Duration(milliseconds: 700),

      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0)), //this right here
      backgroundColor: _themeProvider.dialogColor,

      child: WillPopScope(
        onWillPop: () async {
          if (clickFunc != null) {
            clickFunc();
            Navigator.pop(context);
          } else {
            Navigator.pop(context);
          }
          return false;
        },
        child: Stack(
          alignment: Alignment.topCenter,
          clipBehavior: Clip.none,
          children: [
            FittedBox(
              child: Container(
                padding: EdgeInsets.fromLTRB(10, 10, 10, 20),
                // color: Theme.of(context).backgroundColor,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 35),
                    Image(
                      image: AssetImage(imagePath),
                      height: 100,
                      width: 100,
                    ),
                    SizedBox(height: 20),
                    Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 40),
                        child: Text(
                          title,
                          maxLines: null,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: _themeProvider.primaryTextColor
                                .withOpacity(0.7),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: SizedBox(
                        width: 200,
                        child: Text(
                          body,
                          maxLines: null,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    SizedBox(height: 30),

                    GestureDetector(
                      onTap: () {
                        if (clickFunc != null) {
                          clickFunc();
                        }
                        Navigator.pop(context);
                      },
                      child: Text(
                        buttonText ?? 'Close',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: -20,
              child: CircleAvatar(
                backgroundColor: Theme.of(context).splashColor,
                child: Icon(
                  FontAwesomeIcons.check,
                  size: 16,
                  color: Colors.black87,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
