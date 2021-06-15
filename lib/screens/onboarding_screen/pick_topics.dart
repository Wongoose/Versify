import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:versify/services/auth.dart';
import 'package:versify/services/database.dart';
import 'package:versify/providers/home/tutorial_provider.dart';

class IntroPickTopics extends StatefulWidget {
  final Function completePickTutorials;
  IntroPickTopics(this.completePickTutorials);

  @override
  _IntroPickTopicsState createState() => _IntroPickTopicsState();
}

class _IntroPickTopicsState extends State<IntroPickTopics> {
  bool _loading = false;

  //providers
  DatabaseService _dbService;
  TutorialProvider _tutorialProvider;

  void updateSelectionTopics(List<String> topicInterests) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      bool _success = await _dbService.completeSelectionTopics(topicInterests);

      if (_success) {
        //Navigate
        _tutorialProvider.updateProgress(TutorialProgress.pickTopicsDone);
        widget.completePickTutorials();
      } else {
        toast('Oops! Please try again.');
      }
      setState(() => _loading = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final AuthService _authService = Provider.of<AuthService>(context);
    _dbService = Provider.of<DatabaseService>(context);
    _tutorialProvider = Provider.of<TutorialProvider>(context, listen: false);

    print('Whole rebuild with dbService | ${_dbService.toString()}');
    print('authUserID is: ' + _authService.userUID.toString() ?? 'none');
    // print('authUser is: ' + _authService.authUser.uid.toString());
    print('dbUser is: ' + _dbService.uid.toString());

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
                List<String> _listOfTopicInterests =
                    _tutorialProvider.listOfSelectedTopics;

                if (!_authService.isUserSignedIn) {
                  //user not signed in
                  _authService.signInAnon().then((successSignIn) async {
                    if (successSignIn) {
                      //create usersPrivateCollection
                      _dbService
                          .firestoreCreateAccount(
                              userUID: _authService.authUser.uid,
                              username: _authService.authUser.uid)
                          .then((createAcc) {
                        updateSelectionTopics(_listOfTopicInterests);
                      });
                    }
                  });
                } else {
                  updateSelectionTopics(_listOfTopicInterests);
                }
              },
              label: Text(''),
              icon: Icon(
                Icons.check_rounded,
                size: 25,
                color: Color(0xffff548e),
              ),
            ),
            replacement: Container(
              child: SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(strokeWidth: 0.5),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(0, 25, 0, 0),
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
                  addAutomaticKeepAlives: true,
                  addRepaintBoundaries: false,
                  physics: NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 0,
                  mainAxisSpacing: 5,
                  childAspectRatio: 2 / 2.4,
                  children: _tutorialProvider.listOfTopics
                      .map((String topic) {
                        int _indexOfTopic =
                            _tutorialProvider.listOfTopics.indexOf(topic);

                        return SingleTopicWidget(
                          topic: topic,
                          index: _indexOfTopic,
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

class SingleTopicWidget extends StatelessWidget {
  final String topic;
  final int index;

  SingleTopicWidget({
    Key key,
    this.topic,
    this.index,
  }) : super(key: key);

  final Map<String, DecorationImage> _topicPathMap = {
    'Love': DecorationImage(
        image: AssetImage('assets/images/backgrounds/r-love_background.jpg'),
        fit: BoxFit.cover),
    'Hope': DecorationImage(
        image: AssetImage('assets/images/backgrounds/r-peace_background.jpg'),
        fit: BoxFit.cover),
    'Peace': DecorationImage(
        image: AssetImage('assets/images/backgrounds/r-peace_background.jpg'),
        fit: BoxFit.cover),
    'Joy': DecorationImage(
        image: AssetImage('assets/images/backgrounds/r-joy_background.jpg'),
        fit: BoxFit.cover),
    'Healing': DecorationImage(
        image: AssetImage('assets/images/backgrounds/r-healing_background.jpg'),
        fit: BoxFit.cover),
    'Kindness': DecorationImage(
        image: AssetImage('assets/images/backgrounds/r-love_background.jpg'),
        fit: BoxFit.cover),
    'Loss': DecorationImage(
        image: AssetImage('assets/images/backgrounds/r-grief_background.jpg'),
        fit: BoxFit.cover),
    'Patience': DecorationImage(
        image: AssetImage('assets/images/backgrounds/r-love_background.jpg'),
        fit: BoxFit.cover),
    'Faith': DecorationImage(
        image: AssetImage('assets/images/backgrounds/r-faith_background.jpg'),
        fit: BoxFit.cover),
    'Prayer': DecorationImage(
        image: AssetImage('assets/images/backgrounds/r-prayer_background.jpg'),
        fit: BoxFit.cover),
  };

  // bool isSelected;

  // @override
  // void initState() {
  //   super.initState();
  //   isSelected = widget.pickedIndex.contains(widget.index);
  // }

  @override
  Widget build(BuildContext context) {
    final TutorialProvider _tutorialProvider =
        Provider.of<TutorialProvider>(context, listen: false);

    print('Individual Topic rebuild');
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        _tutorialProvider.topicClicked(topic);
      },
      child: Container(
        margin: EdgeInsets.fromLTRB(15, 0, 15, 15),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              decoration: BoxDecoration(
                // border: _isSelected
                //     ? Border.all(
                //         color: Colors.greenAccent,
                //         width: 2,
                //       )
                //     : null,

                image: _topicPathMap[topic],

                // color: _isSelected ? Colors.black87 : null,
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
            ),
            Consumer<TutorialProvider>(
              builder: (context, state, _) {
                bool _isSelected = state.topicIsSelected(topic);

                return Container(
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(15),
                    border: _isSelected
                        ? Border.all(
                            color: Colors.greenAccent,
                            width: 2,
                          )
                        : null,
                  ),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Visibility(
                        visible: true,
                        child: Opacity(
                          opacity: _isSelected ? 0.95 : 0.7,
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
                            _isSelected
                                ? Text(
                                    'Selected',
                                    style: TextStyle(
                                        color: Colors.greenAccent,
                                        fontFamily: 'Nunito',
                                        fontSize: 10,
                                        fontWeight: FontWeight.w400),
                                  )
                                : SizedBox.shrink(),
                            Expanded(flex: 1, child: Container()),
                            FittedBox(
                              child: Text(
                                '$topic',
                                style: TextStyle(
                                    color: _isSelected
                                        ? Colors.white
                                        : Colors.white,
                                    fontFamily: 'Nunito',
                                    fontSize: 25,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                            SizedBox(height: _isSelected ? 10 : 0),
                            Expanded(flex: 2, child: Container()),
                          ],
                        ),
                      ),
                      Visibility(
                        visible: _isSelected,
                        child: Positioned(
                          bottom: -8,
                          right: -8,
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
                                color: Colors.greenAccent,
                              ),
                              child: Icon(
                                Icons.check,
                                color: Colors.black,
                                size: 15,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
