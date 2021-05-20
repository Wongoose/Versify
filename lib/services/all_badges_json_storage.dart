import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:versify/services/auth.dart';
import 'package:versify/services/database.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class JsonAllBadgesStorage {
  final String uid;
  JsonAllBadgesStorage({this.uid});

  final CollectionReference usersPrivateCollection =
      FirebaseFirestore.instance.collection('usersPrivate');

  final CollectionReference systemSettings =
      FirebaseFirestore.instance.collection('systemSettings');

  final CollectionReference allBadgesCollection =
      FirebaseFirestore.instance.collection('allBadges');

  File jsonAllBadgesFile;
  Directory dir;
  String fileName = "allBadges-1.json";
  bool fileExists = false;

  Map<String, dynamic> fileContent; //reading as json

  Future<void> jsonInit() async {
    print('JSON Badges init!');
    await getApplicationDocumentsDirectory().then((Directory directory) async {
      dir = directory;
      jsonAllBadgesFile = new File(dir.path + "/" + fileName);
      fileExists = jsonAllBadgesFile.existsSync();
      if (fileExists) {
        print('JSON Badges File exists!');
        fileContent = json.decode(jsonAllBadgesFile.readAsStringSync());
        await _checkForUpdateBadges();
        //upload to Firebase as backup
      } else {
        print('JSON Badges File don\'t exist!');
        //retrieve from firebase
        //
        Map<String, dynamic> _content = {};

        createFile(_content, dir, fileName);
      }
    });
  }

  void createFile(
      Map<String, dynamic> content, Directory dir, String fileName) {
    print("Creating file!");
    fileContent = content;
    File file = new File(dir.path + "/" + fileName);
    file.createSync();
    fileExists = true;
    file.writeAsStringSync(jsonEncode(content));
  }

  Future<void> _checkForUpdateBadges() async {
    print('Json Check For Badge Updates RAN');
    DateTime _systemLatestUpdate;

    await getDeviceLatestBadgeVersion().then((deviceBadgeTs) async {
      await systemSettings.doc('allBadges').get().then((doc) {
        _systemLatestUpdate = doc['latestUpdate'].toDate();
        if (deviceBadgeTs != null && fileContent.isNotEmpty) {
          if (_systemLatestUpdate.isAfter(deviceBadgeTs)) {
            //download all badges with larger timestamp
            print('Downloading latestBadges: ' + fileContent.toString());

            allBadgesCollection
                .where('createdTs', isGreaterThan: deviceBadgeTs)
                .get()
                .then((snap) {
              snap.docs.forEach((doc) {
                fileContent.addAll(
                  {
                    doc.id: {
                      'title': doc['title'],
                      'imageUrl': doc['imageUrl'],
                      'description': doc['description'],
                      'category': doc['category'],
                    }
                  },
                );

                print('Downloaded latestBadges: ' + fileContent.toString());
              });
            });
          }
        } else {
          // no deviceBadgeTs stored then get allBadges from DB
          print('Downloading allBadges: ' + fileContent.isEmpty.toString());

          allBadgesCollection.get().then((snap) {
            snap.docs.forEach((doc) {
              fileContent.addAll(
                {
                  doc.id: {
                    'title': doc['title'],
                    'imageUrl': doc['imageUrl'],
                    'description': doc['description'],
                    'category': doc['category'],
                  }
                },
              );

              print('Downloaded allBadges: ' + fileContent.toString());
              updateDeviceLatestBadgeVersion(_systemLatestUpdate.toString());
            });
          });
        }
      });
    });
  }

  Future<DateTime> getDeviceLatestBadgeVersion() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    DateTime _latestTs;
    String _strLatestTs = prefs.getString('deviceLatestBadgeTs') ?? null;

    if (_strLatestTs != null) {
      _latestTs = DateTime.parse(_strLatestTs);
    } else {
      _latestTs = null;
    }
    return _latestTs;
  }

  Future<void> updateDeviceLatestBadgeVersion(String timestamp) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('deviceLatestBadgeTs', timestamp);
    //may have error storing
  }

  Future<Map<String, dynamic>> getUserWelcomeBadges(String uid) async {
    return await usersPrivateCollection
        .doc(uid)
        .collection('userBadges')
        .doc('welcomeBadges')
        .get()
        .then((doc) {
      Map<String, dynamic> _listOfBadges = doc['listOfBadges'];
      print(_listOfBadges);
      return _listOfBadges;
    });
  }
}
