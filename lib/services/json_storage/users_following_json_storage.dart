import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class JsonFollowingStorage {
  File jsonFollowingFile;
  Directory dir;
  String fileName = "usersFollowing-2.json";
  bool fileExists = false;

  Map<String, dynamic> fileContent; //reading as json

  List<String> tempListLastModified = [];
  DateTime jsonLastModified;

  SharedPreferences prefs;

  Future<void> jsonInit() async {
    print('JSON initstate!');
    prefs = await SharedPreferences.getInstance();

    await getApplicationDocumentsDirectory().then((Directory directory) {
      dir = directory;
      jsonFollowingFile = new File(dir.path + "/" + fileName);
      fileExists = jsonFollowingFile.existsSync();
      if (fileExists) {
        print('JSON File exists!');
        fileContent = json.decode(jsonFollowingFile.readAsStringSync());
        //upload to Firebase as backup
      } else {
        print('JSON File don\'t exist!');
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

  void writeToFile() {}

  Map<String, dynamic> getUserPostDetails(String uid) {
    Map<String, dynamic> _tempMap = {};
    print('JSON getUserPostDetails RAN!');
    if (fileContent[uid] != null) {
      // DateTime.parse(formattedString); ??
      _tempMap['latestPost'] = DateTime.parse(fileContent[uid]['latestPost']);
      _tempMap['oldestPost'] = DateTime.parse(fileContent[uid]['oldestPost']);
      _tempMap['hasOlderPost'] = fileContent[uid]['hasOlderPost'] ?? true;

      return _tempMap;
    } else {
      //userDetails don't  exist
      print('JSON No details of $uid exist');
      List<String> _followingList =
          prefs.getStringList('sortedFollowingList') ?? [];

      _followingList.removeWhere((element) => element == uid);

      prefs.setStringList('sortedFollowingList', _followingList);

      print('Deleted user ID from sorted pref uid: ' + uid);
      return null;
    }
  }

  Future<void> updateUserDetailsWithUid(
      {String uid, DateTime timestamp}) async {
    if (fileContent[uid] != null) {
      print('User Post Details exists in JSON!');

      DateTime _latestPost = DateTime.parse(fileContent[uid]['latestPost']);
      DateTime _oldestPost = DateTime.parse(fileContent[uid]['oldestPost']);

      if (timestamp.isAfter(_latestPost) || _latestPost == null) {
        //update latest
        fileContent[uid]['latestPost'] = timestamp.toString();
      }
      if (timestamp.isBefore(_oldestPost) || _oldestPost == null) {
        //update oldest
        fileContent[uid]['oldestPost'] = timestamp.toString();
      }
      fileContent[uid]['hasOlderPost'] = true;
    } else {
      print('JSON Update Swipe Create New User Details');
      fileContent.addAll({
        uid: {
          'latestPost': timestamp.toString(),
          'oldestPost': timestamp.toString(),
          'hasOlderPost': true,
        }
      });
    }
    //run sorting following list

    sortFollowingList(timestamp: timestamp, uid: uid);
  }

  Future<void> sortFollowingList({DateTime timestamp, String uid}) async {
    print('sortFollowingList RAN');
    List<String> _followingList =
        prefs.getStringList('sortedFollowingList') ?? []; //list of uids sorted

    _followingList.forEach((userID) {
      // print('Followinglist userID: ' + userID);
      // print(fileContent);

      if (fileContent[userID] != null) {
        DateTime _thisUserLatest =
            DateTime.parse(fileContent[userID]['latestPost']);

        if (timestamp.isAfter(_thisUserLatest)) {
          //remove first
          _followingList.remove(uid);
          int _insertAfterIndex = _followingList.indexOf(userID);
          //then add back sorted order
          if (_insertAfterIndex != -1) {
            _followingList.insert(_insertAfterIndex + 1, uid);
          } else {
            _followingList.insert(0, uid);
          }
          return true;
        }
      }
    });

    print('Sorted following list is: ' + _followingList.toString());
    prefs.setStringList('sortedFollowingList', _followingList);
  }

  void updateNoOlderPosts(String uid) {
    fileContent[uid]['hasOlderPost'] = false;
  }
}
