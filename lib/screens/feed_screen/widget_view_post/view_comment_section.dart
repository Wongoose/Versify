import 'package:versify/screens/feed_screen/widget_view_post/view_post.dart';
import 'package:versify/screens/feed_screen/widget_view_post/comment_widget.dart';
import 'package:flutter/material.dart';

class ViewPostComments extends StatelessWidget {
  final ViewPostWidget widget;
  final Function bottomSheetComments;

  const ViewPostComments({
    Key key,
    @required this.bottomSheetComments,
    @required this.widget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // void uneditableTapShowScaffold() {
    //   print('Uneditable Tap show scaffold RAN');
    //   showBottomSheet(
    //       context: context,
    //       builder: (context) {
    //         return Scaffold(
    //           body: InputComment(
    //             isViewOnly: false,
    //             inputFocus: FocusNode(),
    //           ),
    //         );
    //       });
    // }

    final ThemeData _theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // VerseInScroll(
        //     colorScheme: widget.colorScheme,
        //     themeIndex: widget.themeIndex),
        Padding(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: Column(
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Comments',
                    style: TextStyle(
                      letterSpacing: 0,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      primary: Colors.white,
                      padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                      backgroundColor: Colors.white,
                    ),
                    onPressed: () => {
                      showModalBottomSheet(
                        
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            ),
                          ),
                          isScrollControlled: true,
                          
                          // isDismissible: true,
                          context: context,
                          builder: (context) {
                            return bottomSheetComments(
                              isViewOnly: true,
                            );
                          }),
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //       builder: (context) => AllComments(isViewOnly: true),
                      //     ))
                    },
                    child: Text(
                      'View all...',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xffff548e),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
              Comment(
                primaryColor: _theme.primaryColor,
                secondaryColor: _theme.accentColor,
              ),
              Comment(
                primaryColor: _theme.primaryColor,
                secondaryColor: _theme.accentColor,
              ),
              Comment(
                primaryColor: _theme.primaryColor,
                secondaryColor: _theme.accentColor,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
