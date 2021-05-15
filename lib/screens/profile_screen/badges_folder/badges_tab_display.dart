import 'package:versify/providers/view_post_gift_provider.dart';
import 'package:versify/screens/feed_screen/widgets/gift_widget.dart';
import 'package:versify/screens/profile_screen/badges_folder/badge_widget.dart';
import 'package:versify/services/all_badges_json_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BadgesTabDisplay extends StatefulWidget {
  @override
  _BadgesTabDisplayState createState() => _BadgesTabDisplayState();
}

class _BadgesTabDisplayState extends State<BadgesTabDisplay> {
  JsonAllBadgesStorage _jsonAllBadgesStorage;
  List<BadgeWidget> _listOfBadges = [];

  List<List<BadgeWidget>> _listOfRowBadges = [];

  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _jsonAllBadgesStorage
          .getUserWelcomeBadges('OuPlwP2MaSWrLQiKH78BYAy5Pj22')
          .then((result) {
        List<BadgeWidget> _listBadgeInCurrentRow = [];

        result.forEach((badgeId, badgeDetailsMap) {
          print('\ngetUserWelcomeBadges id: $badgeId\n');
          print('FileContent is empty:' +
              _jsonAllBadgesStorage.fileContent[badgeId.trim()].isEmpty
                  .toString());
          print(_jsonAllBadgesStorage.fileContent[badgeId.trim()]['title'] ??
              'Oops');

          _listBadgeInCurrentRow.add(
            BadgeWidget(
              text: _jsonAllBadgesStorage.fileContent[badgeId.trim()]
                      ['title'] ??
                  'Oops',
              color: Colors.amber,
              image: 'assets/images/badge.png',
            ),
          );
          if (_listBadgeInCurrentRow.length == 3) {
            // if it's third
            _listOfRowBadges.add(_listBadgeInCurrentRow);
            _listBadgeInCurrentRow.clear();
          } else if (result.length < 3) {
            setState(() {
              _listOfRowBadges.add(_listBadgeInCurrentRow);
            });
          }
          _listOfBadges.add(
            BadgeWidget(
              text: _jsonAllBadgesStorage.fileContent[badgeId.trim()]
                      ['title'] ??
                  'Oops',
              color: Colors.amber,
              image: 'assets/images/badge.png',
            ),
          );
        });
        setState(() {});
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    _jsonAllBadgesStorage = Provider.of<JsonAllBadgesStorage>(context);

    return ChangeNotifierProvider<GiftProvider>(
      create: (_) => GiftProvider(),
      child: SingleChildScrollView(
        key: PageStorageKey<String>('Badges'),
        child: Container(
          alignment: Alignment.topLeft,
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10),

              // SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 25, 0, 0),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    'DAILY BADGES',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black54,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Table(
                children: _listOfRowBadges
                    .map((rowBadges) {
                      return TableRow(children: rowBadges);
                    })
                    .toList()
                    .cast<TableRow>(),

                // [
                //   //build dynamically
                //   TableRow(children: [
                //     BadgeWidget(
                //       text: 'Just getting started',
                //       color: Colors.amber,
                //       image: 'assets/images/badge.png',
                //     ),
                //     BadgeWidget(
                //       text: 'The good samaritan',
                //       color: Colors.amber,
                //       image: 'assets/images/badge.png',
                //     ),
                //     BadgeWidget(
                //       text: 'Connecting with people',
                //       color: Colors.amber,
                //       image: 'assets/images/badge.png',
                //     ),
                //   ]),
                //   TableRow(children: [
                //     BadgeWidget(
                //       text: 'Double-Taps',
                //       color: Colors.amber,
                //       image: 'assets/images/badge.png',
                //     ),
                //     BadgeWidget(
                //       text: 'Save it for later',
                //       color: Colors.amber,
                //       image: 'assets/images/badge.png',
                //     ),
                //     BadgeWidget(
                //       text: 'Loving the blogs',
                //       color: Colors.amber,
                //       image: 'assets/images/badge.png',
                //     ),
                //   ]),
                // ],
              ),

              SizedBox(height: 10),
              Divider(thickness: 0.5),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 25, 0, 0),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    'WRITING BADGES',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black54,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Table(
                children: [
                  TableRow(children: [
                    BadgeWidget(
                      text: 'Just getting started',
                      color: Colors.amber,
                      image: 'assets/images/badge.png',
                    ),
                    BadgeWidget(
                      text: 'The good samaritan',
                      color: Colors.amber,
                      image: 'assets/images/badge.png',
                    ),
                    BadgeWidget(
                      text: 'Connecting with people',
                      color: Colors.amber,
                      image: 'assets/images/badge.png',
                    ),
                  ]),
                  TableRow(children: [
                    BadgeWidget(
                      text: 'Double-Taps',
                      color: Colors.amber,
                      image: 'assets/images/badge.png',
                    ),
                    BadgeWidget(
                      text: 'Save it for later',
                      color: Colors.amber,
                      image: 'assets/images/badge.png',
                    ),
                    BadgeWidget(
                      text: 'Loving the blogs',
                      color: Colors.amber,
                      image: 'assets/images/badge.png',
                    ),
                  ]),
                ],
              ),
              SizedBox(height: 10),
              Divider(thickness: 0.5),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 25, 0, 0),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    'WELCOME BADGES',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black54,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  BadgeWidget(
                    text: 'Getting started',
                    color: Colors.amber,
                    image: 'assets/images/badge.png',
                  ),
                  BadgeWidget(
                    text: 'Getting started',
                    color: Colors.amber,
                    image: 'assets/images/badge.png',
                  ),
                  BadgeWidget(
                    text: 'Getting started',
                    color: Colors.amber,
                    image: 'assets/images/badge.png',
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  BadgeWidget(
                    text: 'Getting started',
                    color: Colors.amber,
                    image: 'assets/images/badge.png',
                  ),
                  BadgeWidget(
                    text: 'Getting started',
                    color: Colors.amber,
                    image: 'assets/images/badge.png',
                  ),
                  BadgeWidget(
                    text: 'Getting started',
                    color: Colors.amber,
                    image: 'assets/images/badge.png',
                  ),
                ],
              ),
              SizedBox(height: 10),
              Divider(thickness: 0.5),
              Padding(
                padding: EdgeInsets.fromLTRB(20, 25, 0, 0),
                child: Text(
                  'ACCOUNT BADGES',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black54,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(height: 10),
              SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(10, 0, 0, 5),
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    BadgeWidget(
                      text: 'Getting started',
                      color: Colors.amber,
                      image: 'assets/images/badge.png',
                    ),
                    BadgeWidget(
                      text: 'Getting started',
                      color: Colors.amber,
                      image: 'assets/images/badge.png',
                    ),
                    BadgeWidget(
                      text: 'Getting started',
                      color: Colors.amber,
                      image: 'assets/images/badge.png',
                    ),
                    BadgeWidget(
                      text: 'Getting started',
                      color: Colors.amber,
                      image: 'assets/images/badge.png',
                    ),
                    BadgeWidget(
                      text: 'Getting started',
                      color: Colors.amber,
                      image: 'assets/images/badge.png',
                    ),
                    BadgeWidget(
                      text: 'Getting started',
                      color: Colors.amber,
                      image: 'assets/images/badge.png',
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.fromLTRB(20, 25, 0, 0),
                child: Text(
                  'EVENT BADGES',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black54,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(height: 20),
              SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(17, 0, 0, 5),
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    BadgeWidget(
                      text: 'Getting started',
                      color: Colors.amber,
                      image: 'assets/images/badge.png',
                    ),
                    BadgeWidget(
                      text: 'Getting started',
                      color: Colors.amber,
                      image: 'assets/images/badge.png',
                    ),
                    BadgeWidget(
                      text: 'Getting started',
                      color: Colors.amber,
                      image: 'assets/images/badge.png',
                    ),
                    BadgeWidget(
                      text: 'Getting started',
                      color: Colors.amber,
                      image: 'assets/images/badge.png',
                    ),
                    BadgeWidget(
                      text: 'Getting started',
                      color: Colors.amber,
                      image: 'assets/images/badge.png',
                    ),
                    BadgeWidget(
                      text: 'Getting started',
                      color: Colors.amber,
                      image: 'assets/images/badge.png',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
