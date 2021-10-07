import 'dart:async';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:versify/providers/providers_home/bottom_nav_provider.dart';
import 'package:versify/providers/providers_home/theme_data_provider.dart';
import 'package:versify/providers/providers_home/tutorial_provider.dart';
import 'package:versify/screens/create_post/sub_screens/create_wrapper.dart';
import 'package:versify/services/firebase/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int pageIndex;
  final PageController controller;
  final ScrollController scrollController;
  // final bool show;
  // final BottomNavProvider bottomNavProvider;

  CustomBottomNavigationBar({
    this.pageIndex,
    this.controller,
    this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData _theme = Theme.of(context);
    final TutorialProvider _tutorialProvider =
        Provider.of<TutorialProvider>(context, listen: true);
    final ThemeProvider _themeProvider =
        Provider.of<ThemeProvider>(context, listen: false);

    print('BOTTOM Nav BAR Rebuilt!');
    PageViewProvider pageViewProvider =
        Provider.of<PageViewProvider>(context, listen: true);
    DatabaseService _databaseService = Provider.of<DatabaseService>(context);

    return Consumer<BottomNavProvider>(
        builder: (context, bottomNavProvider, _) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          pageViewProvider.pageIndex != 1
              ? SizedBox.shrink()
              : AnimatedBuilder(
                  animation: pageViewProvider,
                  builder: (context, child) {
                    return AnimatedContainer(
                      duration: Duration(milliseconds: 2020),
                      padding: EdgeInsets.all(15),
                      child: _tutorialProvider.refreshFeedList == false
                          ? bottomNavProvider.show
                              ? FloatingActionButton.extended(
                                  tooltip: 'Write your story!',
                                  elevation: 2.0,
                                  label: Text(
                                    'Write',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Nunito',
                                    ),
                                  ),
                                  icon: Icon(
                                    FontAwesomeIcons.penAlt,
                                    size: 18,
                                    color: Colors.white,
                                  ),
                                  backgroundColor: _theme.primaryColor,
                                  onPressed: () => {
                                    Navigator.push(context, CupertinoPageRoute(
                                      builder: (context) {
                                        return CreateWrapper();

                                        //   return CreateTopics(
                                        //       databaseService: _databaseService);
                                      },
                                    )),
                                    // _databaseService.dummyAddData(),
                                    // print('FAB clicked!'),
                                  },
                                )
                              : FloatingActionButton(
                                  elevation: 2.0,
                                  child: Icon(FontAwesomeIcons.penAlt,
                                      size: 18, color: Colors.white),
                                  backgroundColor: _theme.primaryColor,
                                  onPressed: () => {
                                    Navigator.push(context, CupertinoPageRoute(
                                      builder: (context) {
                                        return CreateWrapper();
                                        // return CreateTopics(
                                        //   databaseService: _databaseService,
                                        // );
                                      },
                                    )),
                                    // _databaseService.dummyAddData(),
                                  },
                                )
                          : Container(),
                    );
                  }),
          AnimatedBuilder(
              animation: pageViewProvider,
              builder: (context, child) {
                return AnimatedContainer(
                    decoration: BoxDecoration(
                      // color: _theme.canvasColor,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black12,
                            offset: Offset(0, -0.1),
                            blurRadius: 5)
                      ],
                      // border: Border(top: BorderSide(color: Colors.black12))
                    ),
                    height: bottomNavProvider != null
                        ? bottomNavProvider.show ||
                                pageViewProvider.pageIndex != 1
                            ? 55
                            : 0
                        : 55,
                    duration: Duration(milliseconds: 200),
                    child: Shimmer(
                      enabled: _tutorialProvider.signUpProfileNotif,
                      duration: Duration(milliseconds: 500),
                      interval: Duration(milliseconds: 500),
                      color: _themeProvider.isDark ? Colors.white : Colors.pink,
                      direction: ShimmerDirection.fromLTRB(),
                      child: BottomAppBar(
                        elevation: 1,
                        color: _theme.backgroundColor,
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(40, 2, 40, 2),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              // Expanded(
                              //   child: TextButton.icon(
                              //     style: TextButton.styleFrom(
                              //       primary: Colors.white,
                              //       padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                              //       backgroundColor: Colors.white,
                              //     ),
                              //     onPressed: () => {
                              //       controller.animateToPage(
                              //         0,
                              //         duration: Duration(milliseconds: 300),
                              //         curve: Curves.easeInOut,
                              //       ),
                              //     },
                              //     icon: Icon(
                              //       pageViewProvider.pageIndex != 0
                              //           ? Icons.format_quote_rounded
                              //           : Icons.format_quote_rounded,
                              //       color: pageViewProvider.pageIndex != 0
                              //           ? Colors.black87
                              //           : _theme.primaryColor,
                              //       size: 33,
                              //     ),
                              //     label: Text(''),
                              //   ),
                              // ),
                              Expanded(
                                child: TextButton.icon(
                                  style: TextButton.styleFrom(
                                    primary: _theme.canvasColor,
                                    padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                  ),
                                  onPressed: () => {
                                    controller.animateToPage(
                                      1,
                                      duration: Duration(milliseconds: 300),
                                      curve: Curves.easeInOut,
                                    )
                                  },
                                  label: Text(''),
                                  icon: pageViewProvider.pageIndex != 1
                                      ? Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(0, 0, 0, 5),
                                          child: Icon(
                                            AntDesign.home,
                                            color:
                                                _themeProvider.primaryTextColor,
                                            size: 27,
                                          ),
                                        )
                                      : Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(0, 0, 0, 5),
                                          child: Icon(
                                            Entypo.home,
                                            color: _theme.primaryColor,
                                            size: 29,
                                          ),
                                        ),
                                ),
                              ),
                              Expanded(
                                child: _tutorialProvider.signUpProfileNotif
                                    ? BouncingProfile(
                                        controller: controller,
                                        pageViewProvider: pageViewProvider,
                                        theme: _theme)
                                    : TextButton.icon(
                                        style: TextButton.styleFrom(
                                          primary: _theme.canvasColor,
                                          padding:
                                              EdgeInsets.fromLTRB(10, 0, 0, 0),
                                        ),
                                        label: Text(''),
                                        onPressed: () => {
                                          controller.animateToPage(
                                            2,
                                            duration:
                                                Duration(milliseconds: 300),
                                            curve: Curves.easeInOut,
                                          )
                                        },
                                        icon: Icon(
                                          pageViewProvider.pageIndex != 2
                                              ? Icons.person_outline_rounded
                                              : Icons.person_rounded,
                                          color: pageViewProvider.pageIndex != 2
                                              ? _themeProvider.primaryTextColor
                                              : _theme.primaryColor,
                                          size: 34,
                                        ),
                                      ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ));
              }),
        ],
      );
    });
  }
}

class BouncingProfile extends StatefulWidget {
  const BouncingProfile({
    Key key,
    @required this.controller,
    @required this.pageViewProvider,
    @required ThemeData theme,
  })  : _theme = theme,
        super(key: key);

  final PageController controller;
  final PageViewProvider pageViewProvider;
  final ThemeData _theme;

  @override
  _BouncingProfileState createState() => _BouncingProfileState();
}

class _BouncingProfileState extends State<BouncingProfile> {
  double marginTop = 1;
  double start;
  double end;
  double increment;

  Timer timer;

  bool isGoingDown = true;

  void bounce(Timer t) async {
    timer = t;
    if (marginTop <= start) {
      setState(() {
        marginTop += increment;
        isGoingDown = true;
      });
    } else if (marginTop >= end) {
      setState(() {
        marginTop -= increment;
        isGoingDown = false;
      });
    }

    if (marginTop < end && marginTop > start) {
      if (isGoingDown) {
        setState(() {
          marginTop += increment;
        });
      } else {
        setState(() {
          marginTop -= increment;
        });
      }
    }
  }

  void interpolate(double start, double end) {
    setState(() {
      increment = (end - start) / 60;
    });
  }

  @override
  void initState() {
    super.initState();
    marginTop = 1;
    start = 1;
    end = 6;
    interpolate(start, end);
    Timer.periodic(const Duration(milliseconds: 3), bounce);
  }

  void dispose() {
    super.dispose();
    timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeProvider _themeProvider =
        Provider.of<ThemeProvider>(context, listen: false);
    return TextButton.icon(
      style: TextButton.styleFrom(
        primary: Theme.of(context).backgroundColor,
        padding: EdgeInsets.fromLTRB(10, 0, 0, 3),
      ),
      label: Text(''),
      onPressed: () => {
        widget.controller.animateToPage(
          2,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        )
      },
      icon: Container(
        margin: EdgeInsets.only(top: marginTop),
        child: Stack(
          children: [
            Icon(
              widget.pageViewProvider.pageIndex != 2
                  ? Icons.person_outline_rounded
                  : Icons.person_rounded,
              color: widget.pageViewProvider.pageIndex != 2
                  ? _themeProvider.primaryTextColor.withOpacity(0.87)
                  : widget._theme.primaryColor,
              size: 34,
            ),
            Positioned(
              right: 0,
              child: Icon(
                Icons.circle,
                color: widget._theme.accentColor,
                size: 10,
              ),
            )
          ],
        ),
      ),
    );
  }
}
