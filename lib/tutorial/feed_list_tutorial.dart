import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:overlay_tutorial/overlay_tutorial.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:versify/providers/create_topics_provider.dart';
import 'package:versify/providers/tutorial_provider.dart';

class TutorialFeedList extends StatelessWidget {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  final CreateTopicsProvider _topicsProvider = CreateTopicsProvider();

  @override
  Widget build(BuildContext context) {
    final ThemeData _theme = Theme.of(context);
    final TutorialProvider _tutorialProvider =
        Provider.of<TutorialProvider>(context, listen: false);

    void _onRefresh() {
      Future.delayed(Duration(seconds: 1)).then((value) {
        _tutorialProvider
            .updateProgress(TutorialProgress.refreshTutorialFeedDone);
        _refreshController.refreshCompleted();
      });
    }

    return SmartRefresher(
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
            BouncingRefresh(),

            Expanded(child: Container()),
            Image.asset(
              'assets/images/laugh.png',
              height: 160,
              width: 160,
            ),
            SizedBox(height: 30),
            SizedBox(
              width: 260,
              child: RichText(
                maxLines: 2,
                textAlign: TextAlign.center,
                text: TextSpan(children: [
                  TextSpan(
                    text: 'Welcome',
                    style: TextStyle(
                        color: Color(0xffff548e),
                        fontSize: 30,
                        fontFamily: 'Nunito',
                        fontWeight: FontWeight.bold,
                        height: 1.1),
                  ),
                  TextSpan(
                    text: ' to your\nblogs feed',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 30,
                        fontFamily: 'Nunito',
                        fontWeight: FontWeight.bold,
                        height: 1.1),
                  )
                ]),
              ),
            ),
            // Expanded(flex: 1, child: Container()),
            SizedBox(height: 120),
            SizedBox(
              width: 280,
              child: Text(
                '"For God so loved the world, he sent his only begotten son."',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black54,
                ),
              ),
            ),
            // Expanded(flex: 1, child: Container()),
            SizedBox(height: 80),
          ],
        ),
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
    return Container(
      margin: EdgeInsets.only(top: marginTop),
      child: Column(
        children: [
          Text(
            'swipe to refresh blogs',
            style: TextStyle(color: Colors.black54, fontSize: 11),
          ),
          SizedBox(height: 5),
          Icon(
            Icons.arrow_downward_rounded,
            color: Colors.black54,
            size: 15,
          ),
        ],
      ),
    );
  }
}
