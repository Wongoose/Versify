import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:versify/providers/create_post/create_topics_provider.dart';
import 'package:versify/providers/home/theme_data_provider.dart';
import 'package:versify/providers/home/tutorial_provider.dart';

class TutorialFeedList extends StatefulWidget {
  @override
  _TutorialFeedListState createState() => _TutorialFeedListState();
}

class _TutorialFeedListState extends State<TutorialFeedList> {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  TutorialProvider _tutorialProvider;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Future.delayed(Duration(seconds: 1)).then((_) => onInitShowDialog());
    });
  }

  void onInitShowDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return WelcomeDialog();
        });
  }

  void _onRefresh() {
    Future.delayed(Duration(seconds: 1)).then((value) {
      _tutorialProvider
          .updateProgress(TutorialProgress.refreshTutorialFeedDone);
      _refreshController.refreshCompleted();
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData _theme = Theme.of(context);
    _tutorialProvider = Provider.of<TutorialProvider>(context, listen: false);
    final ThemeProvider _themeProvider =
        Provider.of<ThemeProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: _theme.backgroundColor,
      body: SmartRefresher(
        controller: _refreshController,
        scrollController: null,
        key: PageStorageKey<String>('tutorialFeedList'),
        enablePullDown: true,
        enablePullUp: false,
        onRefresh: _onRefresh,
        header: WaterDropHeader(
          complete: Icon(
            Icons.done_rounded,
            color: Colors.black54,
          ),
          waterDropColor: Colors.pink[300],
          // backgroundColor: Colors.white,
          // distance: 50,
        ),
        physics: AlwaysScrollableScrollPhysics(),
        reverse: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(30, 0, 20, 55),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 30),
              SizedBox(height: 100, child: BouncingRefresh()),

              Expanded(child: Container()),
              GestureDetector(
                onTap: () => onInitShowDialog(),
                child: Image.asset(
                  'assets/images/copywriting.png',
                  height: 160,
                  width: 160,
                ),
              ),
              SizedBox(height: 40),
              SizedBox(
                width: 260,
                child: RichText(
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  text: TextSpan(children: [
                    TextSpan(
                      text: 'Blogs',
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 35,
                          fontFamily: 'Nunito',
                          fontWeight: FontWeight.w600,
                          height: 1.1),
                    ),
                    TextSpan(
                      text: ' feed',
                      style: TextStyle(
                          color: _themeProvider.primaryTextColor,
                          fontSize: 35,
                          fontFamily: 'Nunito',
                          fontWeight: FontWeight.w600,
                          height: 1.1),
                    )
                  ]),
                ),
              ),
              // Expanded(flex: 1, child: Container()),
              SizedBox(height: 30),
              SizedBox(
                width: 280,
                child: Text(
                  'Feed is empty. Refresh to find more!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: _themeProvider.secondaryTextColor,
                  ),
                ),
              ),
              SizedBox(height: 80),
              Expanded(flex: 1, child: Container()),
            ],
          ),
        ),
      ),
    );
  }
}

class WelcomeDialog extends StatelessWidget {
  const WelcomeDialog({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeProvider _themeProvider =
        Provider.of<ThemeProvider>(context, listen: false);
    return Dialog(
      elevation: 2,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0)), //this right here
      backgroundColor: _themeProvider.dialogColor,

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
                  SizedBox(height: 20),
                  // Text(
                  //   'Visitor Arrived',
                  //   style: TextStyle(
                  //     color: Colors.black,
                  //     fontWeight: FontWeight.bold,
                  //     fontFamily: 'Nunito',
                  //     fontSize: 22,
                  //   ),
                  // ),
                  SizedBox(height: 15),
                  Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100)),
                    clipBehavior: Clip.antiAlias,
                    color: _themeProvider.dialogColor,
                    elevation: 0,
                    child: Image(
                      image: AssetImage('assets/images/laugh.png'),
                      height: 100,
                    ),
                  ),
                  SizedBox(height: 15),
                  Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 40),
                      child: Text(
                        'Hi, I\'m Vicky!',
                        maxLines: null,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color:
                              _themeProvider.primaryTextColor.withOpacity(0.7),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 25),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: SizedBox(
                      width: 220,
                      child: Text(
                        'Welcome to your blogs feed. Take a look around, I\'ll see you soon!',
                        maxLines: null,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  SizedBox(height: 35),
                  // Divider(
                  //   thickness: 3,
                  // ),
                  GestureDetector(
                    onTap: () => {Navigator.pop(context)},
                    child: Text(
                      'Explore',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
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
              backgroundColor: Theme.of(context).primaryColor,
              child: Icon(
                FontAwesomeIcons.check,
                size: 16,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
    );
  }
}

class BouncingRefresh extends StatefulWidget {
  const BouncingRefresh({
    Key key,
  }) : super(key: key);

  @override
  _BouncingRefreshState createState() => _BouncingRefreshState();
}

class _BouncingRefreshState extends State<BouncingRefresh> {
  double marginTop = 2;
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
      increment = (end - start) / 50;
    });
  }

  @override
  void initState() {
    super.initState();
    marginTop = 2;
    start = 2;
    end = 15;
    interpolate(start, end);
    Timer.periodic(const Duration(milliseconds: 8), bounce);
  }

  void dispose() {
    super.dispose();
    timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeProvider _themeProvider =
        Provider.of<ThemeProvider>(context, listen: false);
    return Container(
      margin: EdgeInsets.only(top: marginTop),
      child: Column(
        children: [
          Text(
            'swipe to refresh blogs',
            style:
                TextStyle(color: _themeProvider.primaryTextColor, fontSize: 11),
          ),
          SizedBox(height: 5),
          Icon(
            Icons.arrow_downward_rounded,
            color: _themeProvider.primaryTextColor,
            size: 15,
          ),
        ],
      ),
    );
  }
}
