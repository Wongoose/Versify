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
        _tutorialProvider.updateProgress(TutorialProgress.pickTopics, true);
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
            Expanded(child: Container()),
            OverlayTutorialHole(
              enabled: true,
              overlayTutorialEntry: OverlayTutorialRectEntry(
                  padding: EdgeInsets.all(45),
                  radius: Radius.circular(1000),
                  overlayTutorialHints: [
                    OverlayTutorialWidgetHint(
                        position: (rect) => Offset(0, rect.bottom),
                        builder: (context, rect, rRect) {
                          return Material(
                            color: Colors.transparent,
                            child: Container(
                              // height: MediaQuery.of(context).size.height,
                              width: MediaQuery.of(context).size.width,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(height: 100),
                                  SizedBox(
                                    width: 300,
                                    child: Text(
                                      'Hi, I\'m Vicky.\nI will help you get your away around Versify for the first time!',
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 30),
                                  GestureDetector(
                                    onTap: () {
                                      _tutorialProvider
                                          .updateOverlayScope(false);
                                    },
                                    child: Text(
                                      'Let\'s get started!',
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                  ]),
              child: Image.asset(
                'assets/images/laugh.png',
                height: 120,
                width: 120,
              ),
            ),
            // Expanded(child: Container()),
            Expanded(child: Container()),
            Container(
              padding: EdgeInsets.fromLTRB(2, 0, 0, 0),
              alignment: Alignment.centerLeft,
              child: SizedBox(
                width: 260,
                child: RichText(
                  maxLines: 2,
                  text: TextSpan(children: [
                    TextSpan(
                      text: 'Welcome',
                      style: TextStyle(
                          color: Color(0xffff548e),
                          fontSize: 35,
                          fontFamily: 'Nunito',
                          fontWeight: FontWeight.bold,
                          height: 1.1),
                    ),
                    TextSpan(
                      text: ' to\nyour blogs feed',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 35,
                          fontFamily: 'Nunito',
                          fontWeight: FontWeight.bold,
                          height: 1.1),
                    )
                  ]),
                ),
              ),
            ),
            SizedBox(height: 25),
            Container(
              padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
              alignment: Alignment.centerLeft,
              child: Text(
                'PICK YOUR FAVOURITE TOPICS',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.black45,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(height: 10),
            Align(
              alignment: Alignment.topLeft,
              child: Wrap(
                spacing: 15,
                alignment: WrapAlignment.start,
                children: _topicsProvider.chipSnaps
                    .map(
                      (chipData) => FilterChip(
                          selected: chipData.checked,
                          checkmarkColor: Colors.white,
                          selectedColor: Color(0xffff548e),
                          showCheckmark: true,
                          onSelected: ((onSelected) {
                            chipData.checked = onSelected;
                            _topicsProvider.updateChips();
                          }),
                          shape: StadiumBorder(
                            side: BorderSide(
                              color: Color(0xffff548e),
                              width: 1.0,
                            ),
                          ),
                          backgroundColor: Colors.white,
                          label: Text(chipData.topic),
                          labelStyle: TextStyle(
                              fontFamily: 'Nunito',
                              fontWeight: FontWeight.w600,
                              color: chipData.checked
                                  ? Colors.white
                                  : Color(0xffff548e))),
                    )
                    .toList()
                    .cast<Widget>(),
              ),
            ),
            SizedBox(height: 20),
            // Expanded(flex: 3, child: Container()),
          ],
        ),
      ),
    );
  }
}
