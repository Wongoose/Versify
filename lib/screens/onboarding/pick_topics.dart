import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:versify/services/database.dart';
import 'package:versify/providers/tutorial_provider.dart';

class IntroPickTopics extends StatefulWidget {
  @override
  _IntroPickTopicsState createState() => _IntroPickTopicsState();
}

class _IntroPickTopicsState extends State<IntroPickTopics> {
  final List<String> _topicList = [
    'Love',
    'Hope',
    'Peace',
    'Joy',
    'Healing',
    'Kindness',
    'Loss',
    'Patience',
    'Faith',
    'Prayer'
  ];

  List<int> _pickedIndex = [];
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    final DatabaseService _dbService = Provider.of<DatabaseService>(context);
    final TutorialProvider _tutorialProvider =
        Provider.of<TutorialProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        centerTitle: true,
        title: Text(
          'Pick your topics',
          style: TextStyle(
            fontSize: 17.5,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        actions: [
          Visibility(
            visible: !_loading,
            child: TextButton.icon(
              style: TextButton.styleFrom(
                padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                backgroundColor: Colors.white,
              ),
              onPressed: () async {
                setState(() => _loading = true);
                List<String> _topicInterests = [];
                _pickedIndex.forEach((index) {
                  _topicInterests.add(_topicList[index]);
                });
                bool _success =
                    await _dbService.completeSelectionTopics(_topicInterests);

                setState(() => _loading = false);
                if (_success) {
                  //Navigate
                  _tutorialProvider
                      .updateProgress(TutorialProgress.pickTopicsDone);
                } else {
                  toast('Oops! Please try again.');
                }
              },
              label: Text(''),
              icon: Icon(
                Icons.check_rounded,
                size: 25,
                color: Color(0xffff548e),
              ),
            ),
            replacement: SizedBox(
              height: 15,
              width: 15,
              child: CircularProgressIndicator(strokeWidth: 0.5),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(0, 25, 0, 25),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: SizedBox(
                  // width: 280,
                  child: RichText(
                    maxLines: 2,
                    text: TextSpan(children: [
                      TextSpan(
                        text: 'What',
                        style: TextStyle(
                            color: Color(0xffff548e),
                            fontSize: 38,
                            fontFamily: 'Nunito',
                            fontWeight: FontWeight.bold,
                            height: 1.1),
                      ),
                      TextSpan(
                        text: ' would\nyou like to find?',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 38,
                            fontFamily: 'Nunito',
                            fontWeight: FontWeight.bold,
                            height: 1.1),
                      )
                    ]),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.fromLTRB(24, 0, 24, 0),
                child: Text(
                  'PICK TOP 3 TOPICS',
                  style: TextStyle(
                    fontSize: 15.5,
                    color: Colors.black45,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: GridView.count(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 0,
                  mainAxisSpacing: 20,
                  childAspectRatio: 2 / 2.4,
                  children: _topicList
                      .map((String topic) {
                        int _indexOfTopic = _topicList.indexOf(topic);

                        return SingleTopicWidget(
                          topic: topic,
                          index: _indexOfTopic,
                          pickedIndex: _pickedIndex,
                        );
                      })
                      .toList()
                      .cast<Widget>(),
                ),
              ),
            ]),
      ),
    );
  }
}

class SingleTopicWidget extends StatefulWidget {
  final String topic;
  final int index;
  final List<int> pickedIndex;

  const SingleTopicWidget({
    Key key,
    this.topic,
    this.index,
    this.pickedIndex,
  }) : super(key: key);

  @override
  _SingleTopicWidgetState createState() => _SingleTopicWidgetState();
}

class _SingleTopicWidgetState extends State<SingleTopicWidget> {
  final Map<String, String> _topicPathMap = {
    'Love': 'assets/images/backgrounds/love_background.jpg',
    'Hope': 'assets/images/backgrounds/peace_background.jpg',
    'Peace': 'assets/images/backgrounds/peace_background.jpg',
    'Joy': 'assets/images/backgrounds/joy_background.jpg',
    'Healing': 'assets/images/backgrounds/healing_background.jpg',
    'Kindness': 'assets/images/backgrounds/love_background.jpg',
    'Loss': 'assets/images/backgrounds/grief_background.jpg',
    'Patience': 'assets/images/backgrounds/love_background.jpg',
    'Faith': 'assets/images/backgrounds/faith_background.jpg',
    'Prayer': 'assets/images/backgrounds/prayer_background.jpg',
  };

  bool isSelected;

  void initState() {
    super.initState();
    isSelected = widget.pickedIndex.contains(widget.index);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        if (isSelected) {
          //remove from picked list
          widget.pickedIndex.remove(widget.index);
          isSelected = false;
        } else if (widget.pickedIndex.length != 3) {
          //add to picked list
          widget.pickedIndex.add(widget.index);
          isSelected = true;
        }
        // widget.topicClicked(widget.topic, widget.index);
        setState(() {});
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 15),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Card(
              elevation: isSelected ? 3 : 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Ink(
                decoration: BoxDecoration(
                  image: isSelected
                      ? null
                      : DecorationImage(
                          image: AssetImage(_topicPathMap[widget.topic]),
                          fit: BoxFit.cover,
                        ),
                  color: isSelected ? Color(0xFFffdee9) : null,
                  // color: Color(0xFFffdee9),
                  // gradient: LinearGradient(
                  //   colors: false
                  //       ? [Colors.white, Colors.white]
                  //       : [Color(0xFFffdee9), Colors.pink[200]],
                  //   begin: Alignment.bottomLeft,
                  //   end: Alignment.topRight,
                  // ),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Stack(
                  children: [
                    Visibility(
                      visible: !isSelected,
                      child: Opacity(
                        opacity: 0.8,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(30, 20, 30, 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(flex: 1, child: Container()),

                          Text(
                            '${widget.topic}',
                            style: TextStyle(
                                color:
                                    isSelected ? Colors.black87 : Colors.white,
                                fontFamily: 'Nunito',
                                fontSize: 25,
                                fontWeight: FontWeight.w600),
                          ),
                          // Text(
                          //   'Versify\'s writing bot will guide you',
                          //   textAlign: TextAlign.center,
                          //   style: TextStyle(
                          //       color: isSelected ? Colors.black87 : Colors.white,
                          //       fontSize: 10,
                          //       fontWeight: FontWeight.w400),
                          // ),
                          Expanded(flex: 1, child: Container()),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Visibility(
              visible: isSelected,
              child: Positioned(
                bottom: -5,
                right: -5,
                child: Container(
                  height: 30,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: Container(
                    height: 30,
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(5),
                    margin: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).accentColor,
                    ),
                    child: Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 15,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
