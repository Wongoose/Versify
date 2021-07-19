import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:versify/models/feed_model.dart';
import 'package:versify/models/user_model.dart';
import 'package:versify/providers/feeds/feed_list_provider.dart';
import 'package:versify/services/profile_database.dart';
import 'package:versify/services/users_following_json_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum CreateAcc { hasAccount, newAccount, error }
enum ReportFeed {
  violence,
  sensitive,
  political,
  adultContent,
  language,
  others
}

class DatabaseService {
  final String uid;
  final FeedListProvider feedListProvider;
  final JsonFollowingStorage jsonFollowingStorage;
  List<String> seenDocsList = [];
  // List<String> listUsersFollowing = [];
  DateTime _lastUpdated;
  bool _hasLastUpdated = false;
  int readCount = 0;
  List<DocumentSnapshot> latestEntry = [];

  DatabaseService({this.jsonFollowingStorage, this.uid, this.feedListProvider});

  //collection reference--------------------------------------------------------

  final CollectionReference feedsAllCollection =
      FirebaseFirestore.instance.collection('feedNew');

  final CollectionReference allPostsCollection =
      FirebaseFirestore.instance.collection('allPosts');

  final CollectionReference usersPrivateCollection =
      FirebaseFirestore.instance.collection('usersPrivate');

  final CollectionReference usersPublicCollection =
      FirebaseFirestore.instance.collection('usersPublicFollow');

  CollectionReference privateAllFollowingCollection;

  final CollectionReference likedPostsCollection =
      FirebaseFirestore.instance.collection('likedPosts');

  final CollectionReference reportedPostsCollection =
      FirebaseFirestore.instance.collection('reportedPosts');

  Future firestoreInit() async {
    print('firestore iNIT RAN!');
    return await getSeenDocs().then((value) async {
      await getLastUpdated();
      return value;
    });
  }

  Future getSeenDocs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    this.seenDocsList = prefs.getStringList('seenDocs') ?? [];
    print('got seenDocs INIT:' + seenDocsList.toString());
    return seenDocsList;
  }

  Future getLastUpdated() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String result = prefs.getString('lastUpdated');
    if (result == null) {
      _hasLastUpdated = false;
    } else {
      _hasLastUpdated = true;
      _lastUpdated = DateTime.parse(result);
    }
    print('got Last Update from local INIT: ' + _lastUpdated.toString());
    // _hasLastUpdated = result == null ? false : true;
    // _lastUpdated = DateTime.parse(result);
  }
  //getters--------------------------------------------------------

  //setters--------------------------------------------------------

  //methods & functions--------------------------------------------------------
  //
  //
  //

  // Future<void> x() async {
  //   await usersPrivateCollection.get().then((snaps) {
  //     snaps.docs.forEach((doc) async {
  //       String _currentID = doc.id;
  //       print('UserID is: ' + doc.id);
  //       final String _allFollowingCollectionPath =
  //           '${usersPrivateCollection.path}/${doc.id}/allFollowing';

  //       final CollectionReference privateAllFollowingCollection =
  //           FirebaseFirestore.instance.collection(_allFollowingCollectionPath);

  //       print('Collection Path is: ' + privateAllFollowingCollection.path);

  //       await usersPublicCollection
  //           .where('followers', arrayContains: _currentID)
  //           .get()
  //           .then((followingSnaps) async {
  //         print(doc['username']);
  //         print(followingSnaps.size);
  //         followingSnaps.docs.forEach((followingDoc) async {
  //           print(followingDoc.data()['userID']);

  //           // await privateAllFollowingCollection.doc(addedDoc.path).update({
  //           //   'numFollowing': FieldValue.increment(1),
  //           //   'usersFollowing':
  //           //       FieldValue.arrayUnion(followingDoc.data()['userID']),
  //           // });
  //         });
  //       });

  //       // await privateAllFollowingCollection.get().then((followingSnaps) {
  //       //   DocumentSnapshot _followingDoc = followingSnaps.docs.single;
  //       // });
  //     });
  //   });
  // }

  Future<List<String>> getFollowingList() async {
    List<String> _tempListUID = [];

    String _allFollowingCollectionPath =
        '${usersPrivateCollection.path}/${this.uid}/allFollowing';
    privateAllFollowingCollection =
        FirebaseFirestore.instance.collection(_allFollowingCollectionPath);

    return await privateAllFollowingCollection.get().then((snaps) {
      snaps.docs.forEach((doc) {
        (doc['usersFollowing'] as List).forEach((_userID) {
          _tempListUID.add(_userID.toString());
        });
      });

      // listUsersFollowing = _tempListUID;
      print(_tempListUID);
      return _tempListUID;
      //store List of users following
    });
  }

  Future<List<String>> getSortedFollowing() async {
    print('GetSortedFollowing RAN!');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> _tempList = prefs.getStringList('sortedFollowingList') ?? [];
    if (_tempList.isNotEmpty) {
      print('PREFS Sorted list has value!');
      return _tempList;
    } else {
      print('PREFS Sorted list NO value!');
      return await getFollowingList().then((followingList) {
        prefs.setStringList('sortedFollowingList', followingList);
        return followingList;
      });
    }
  }

  Future<void> getFollowingFeeds2({bool isRefresh}) async {
    //newFollowsPriority
    // int _totalFeedGot = 0;
    // int _followingListIndex = 0;
    List<Feed> _tempFeedList = [];
    bool _repeatRequest = true;
    int _prevTempFeedLength = 0;

    await getSortedFollowing().then((_followingList) async {
      while (_repeatRequest) {
        List<Feed> _forLoopFeedList = [];

        for (var i = 0; i < _followingList.length; i++) {
          String uid = _followingList[i];
          // _followingList.shuffle();

          // List<String> _tempUIDs = _followingList.getRange(0, 2).toList();
          //loop from start until get 5 post

          // _tempUIDs.forEach((uid) async {
          Map<String, dynamic> _postDetails =
              jsonFollowingStorage.getUserPostDetails(uid);
          // List<Feed> _tempFeedList = [];

          DateTime _latestPost;
          DateTime _oldestPost;
          bool _hasOlderPost;

          if (_postDetails != null) {
            _latestPost = _postDetails['latestPost'];
            _oldestPost = _postDetails['oldestPost'];
            _hasOlderPost = _postDetails['hasOlderPost'];

            print('HasOlderPost? ' + _hasOlderPost.toString());

            if (isRefresh) {
              await allPostsCollection
                  .where('userID', isEqualTo: uid)
                  .where('postedTimeStamp', isGreaterThan: _latestPost)
                  .orderBy('postedTimeStamp', descending: true)
                  .limit(1)
                  .get()
                  .then((snaps) async {
                if (snaps.docs.isNotEmpty) {
                  DocumentSnapshot doc = snaps.docs.single;

                  Feed _feed = Feed(
                    documentID: doc.id,
                    userID: doc['userID'],
                    username: doc['username'],
                    profileImageUrl: doc['profileImageUrl'] ?? null,
                    hasViewed: false,

                    // content: doc['content'] ?? 'No Content',
                    contentLength: doc['contentLength'] ?? 0,

                    featuredTopic: doc['featuredTopic'] ?? null,
                    featuredValue: doc['featuredValue'] ?? ". . .",

                    giftLove: doc['giftLove'] ?? 0,
                    giftBird: doc['giftBird'] ?? 0,

                    title: doc['title'] ?? 'Just Me',
                    tags: doc['tags'] ?? [],
                    initLike: doc['isLiked'] != null
                        ? doc['isLiked'].contains(this.uid)
                        : false,
                    numberOfLikes: doc['likes'],
                    numberOfViews: doc['views'],
                    listMapContent: doc['listMapContent'] ?? [],
                    postedTimestamp: doc['postedTimeStamp'].toDate(),
                  );

                  _tempFeedList.add(_feed);
                  _forLoopFeedList.add(_feed);
                } else if (_hasOlderPost) {
                  //no new post (latestPost is not > localStorage)
                  print('hasPost get olderpost');
                  await allPostsCollection
                      .where('userID', isEqualTo: uid)
                      .where('postedTimeStamp', isLessThan: _oldestPost)
                      .orderBy('postedTimeStamp', descending: true)
                      .limit(1)
                      .get()
                      .then((snaps) {
                    if (snaps.docs.isNotEmpty) {
                      DocumentSnapshot doc = snaps.docs.single;

                      Feed _feed = Feed(
                        documentID: doc.id,
                        userID: doc['userID'],
                        username: doc['username'],
                        profileImageUrl: doc['profileImageUrl'] ?? null,
                        hasViewed: false,

                        // content: doc['content'] ?? 'No Content',
                        contentLength: doc['contentLength'] ?? 0,

                        featuredTopic: doc['featuredTopic'] ?? null,
                        featuredValue: doc['featuredValue'] ?? ". . .",

                        giftLove: doc['giftLove'] ?? 0,
                        giftBird: doc['giftBird'] ?? 0,

                        title: doc['title'] ?? 'Just Me',
                        tags: doc['tags'] ?? [],
                        initLike: doc['isLiked'] != null
                            ? doc['isLiked'].contains(this.uid)
                            : false,
                        numberOfLikes: doc['likes'],
                        numberOfViews: doc['views'],
                        listMapContent: doc['listMapContent'] ?? [],
                        postedTimestamp: doc['postedTimeStamp'].toDate(),
                      );

                      _tempFeedList.add(_feed);
                      _forLoopFeedList.add(_feed);
                    } else {
                      //no new post, no older post
                      print('JSON Updated no older post');
                      jsonFollowingStorage.updateNoOlderPosts(uid);
                    }
                  });
                } else {
                  print('No older post called');
                }
              });
            } else if (_hasOlderPost) {
              //no new post (latestPost is not > localStorage)
              print('hasPost get olderpost');
              await allPostsCollection
                  .where('userID', isEqualTo: uid)
                  .where('postedTimeStamp', isLessThan: _oldestPost)
                  .orderBy('postedTimeStamp', descending: true)
                  .limit(1)
                  .get()
                  .then((snaps) {
                if (snaps.docs.isNotEmpty) {
                  DocumentSnapshot doc = snaps.docs.single;

                  Feed _feed = Feed(
                    documentID: doc.id,
                    userID: doc['userID'],
                    username: doc['username'],
                    profileImageUrl: doc['profileImageUrl'] ?? null,
                    hasViewed: false,

                    // content: doc['content'] ?? 'No Content',
                    contentLength: doc['contentLength'] ?? 0,

                    featuredTopic: doc['featuredTopic'] ?? null,
                    featuredValue: doc['featuredValue'] ?? ". . .",

                    giftLove: doc['giftLove'] ?? 0,
                    giftBird: doc['giftBird'] ?? 0,

                    title: doc['title'] ?? 'Just Me',
                    tags: doc['tags'] ?? [],
                    initLike: doc['isLiked'] != null
                        ? doc['isLiked'].contains(this.uid)
                        : false,
                    numberOfLikes: doc['likes'],
                    numberOfViews: doc['views'],
                    listMapContent: doc['listMapContent'] ?? [],
                    postedTimestamp: doc['postedTimeStamp'].toDate(),
                  );

                  _tempFeedList.add(_feed);
                  _forLoopFeedList.add(_feed);
                } else {
                  //no new post, no older post
                  print('JSON Updated no older post');
                  jsonFollowingStorage.updateNoOlderPosts(uid);
                }
              });
            } else {
              print('No older/latest post called');
              //no more older post
            }
          } else {
            //no json data of userDetails
            await allPostsCollection
                .where('userID', isEqualTo: uid)
                .where('postedTimeStamp', isLessThan: DateTime.now())
                .orderBy('postedTimeStamp', descending: true)
                .limit(1)
                .get()
                .then((snaps) {
              DocumentSnapshot doc = snaps.docs.single;

              Feed _feed = Feed(
                documentID: doc.id,
                userID: doc['userID'],
                username: doc['username'],
                profileImageUrl: doc['profileImageUrl'] ?? null,
                hasViewed: false,

                // content: doc['content'] ?? 'No Content',
                contentLength: doc['contentLength'] ?? 0,

                featuredTopic: doc['featuredTopic'] ?? null,
                featuredValue: doc['featuredValue'] ?? ". . .",

                giftLove: doc['giftLove'] ?? 0,
                giftBird: doc['giftBird'] ?? 0,

                title: doc['title'] ?? 'Just Me',
                tags: doc['tags'] ?? [],
                initLike: doc['isLiked'] != null
                    ? doc['isLiked'].contains(this.uid)
                    : false,
                numberOfLikes: doc['likes'],
                numberOfViews: doc['views'],
                listMapContent: doc['listMapContent'] ?? [],
                postedTimestamp: doc['postedTimeStamp'].toDate(),
              );

              _tempFeedList.add(_feed);
              _forLoopFeedList.add(_feed);
            });
          }

          // });
          if (_tempFeedList.length >= 5) {
            break;
            //break for loop
          }
          //  print('getFollowingFeeds: ' + _tempFeedList.toString());

        }

        if (isRefresh) {
          _tempFeedList.forEach((feed) async {
            await jsonFollowingStorage.updateUserDetailsWithUid(
                uid: feed.userID, timestamp: feed.postedTimestamp);
          });

          _repeatRequest = false;
        } else if (_tempFeedList.length < 5) {
          if (_prevTempFeedLength == _tempFeedList.length) {
            //no change in length means no more post to get

            _repeatRequest = false;
          } else {
            _forLoopFeedList.forEach((feed) async {
              await jsonFollowingStorage.updateUserDetailsWithUid(
                  uid: feed.userID, timestamp: feed.postedTimestamp);
            });
            _forLoopFeedList.clear();
            _prevTempFeedLength = _tempFeedList.length;
            _repeatRequest = true;
          }
        } else {
          //got enought old post
          _forLoopFeedList.forEach((feed) async {
            await jsonFollowingStorage.updateUserDetailsWithUid(
                uid: feed.userID, timestamp: feed.postedTimestamp);
          });

          _repeatRequest = false;
        }
      }

      feedListProvider.updateFollowingData(_tempFeedList);
      if (isRefresh) {
        getFollowingFeeds2(isRefresh: false);
      }
      // feedListProvider.callFuture();
      //calling after every document (Refresh FollowingPageView)
    });
  }

  Future<void> get getNewFeeds async {
    print('getNewFeeds has been CALLED is DATABASE');
    List<Feed> tempList = [];

    print(_lastUpdated);
    print(readCount);
    readCount < 100
        ? _hasLastUpdated
            ? await allPostsCollection
                .orderBy('postedTimeStamp', descending: true)
                .where('postedTimeStamp', isLessThan: _lastUpdated)
                .limit(5)
                .get()
                .then((QuerySnapshot snap) async {
                snap.docs.forEach((doc) async {
                  print('got doc: ' + doc.id);

                  if (!seenDocsList.contains(doc.id)) {
                    tempList.add(Feed(
                      documentID: doc.id,
                      userID: doc['userID'],

                      username: doc['username'],
                      profileImageUrl: doc['profileImageUrl'] ?? null,
                      hasViewed: false,

                      // content: doc['content'] ?? 'No Content',
                      contentLength: doc['contentLength'] ?? 0,

                      featuredTopic: doc['featuredTopic'] ?? null,
                      featuredValue: doc['featuredValue'] ?? ". . .",

                      giftLove: doc['giftLove'] ?? 0,
                      giftBird: doc['giftBird'] ?? 0,

                      title: doc['title'] ?? 'Just Me',
                      tags: doc['tags'] ?? [],
                      initLike: doc['isLiked'] != null
                          ? doc['isLiked'].contains(this.uid)
                          : false,
                      numberOfLikes: doc['likes'],
                      numberOfViews: doc['views'],
                      listMapContent: doc['listMapContent'] ?? [],
                      postedTimestamp: doc['postedTimeStamp'].toDate(),
                    ));
                    //add to seen
                    seenDocsList.add(doc.id);
                  }
                  readCount += 1;
                });
                await storeLastUpdatedLocal(snap.docs.last);
              }).catchError((e) => print('Failed getNewFeeds: $e'))
            : await allPostsCollection
                .orderBy('postedTimeStamp', descending: true)
                .limit(5)
                .get()
                .then((QuerySnapshot snap) async {
                snap.docs.forEach((doc) async {
                  print('got doc: ' + doc.id);
                  if (!seenDocsList.contains(doc.id)) {
                    tempList.add(Feed(
                      documentID: doc.id,
                      username: doc['username'],
                      profileImageUrl: doc['profileImageUrl'] ?? null,
                      hasViewed: false,

                      userID: doc['userID'],
                      // content: doc['content'] ?? 'No Content',
                      contentLength: doc['contentLength'] ?? 0,

                      featuredTopic: doc['featuredTopic'] ?? null,
                      featuredValue: doc['featuredValue'] ?? ". . .",

                      giftLove: doc['giftLove'] ?? 0,
                      giftBird: doc['giftBird'] ?? 0,

                      title: doc['title'] ?? 'Just Me',
                      tags: doc['tags'] ?? [],
                      initLike: doc['isLiked'] != null
                          ? doc['isLiked'].contains(this.uid)
                          : false,
                      numberOfLikes: doc['likes'],
                      numberOfViews: doc['views'],
                      listMapContent: doc['listMapContent'] ?? [],
                      postedTimestamp: doc['postedTimeStamp'].toDate(),
                    ));
                    //add to seen
                    seenDocsList.add(doc.id);
                  }
                  readCount += 1;
                });
                await storeLastUpdatedLocal(snap.docs.last);
              }).catchError((e) => print('Failed getNewFeeds: $e'))
        : print('can\'t read no more: ' + readCount.toString());

    print('getNewFeeds: ' + tempList.toString());

    getSortedFollowing().then((sortedFollowingList) {
      //get from shared preferences or Firebase if null
      tempList.forEach((feed) async {
        if (sortedFollowingList.contains(feed.userID)) {
          //if is following
          await jsonFollowingStorage.updateUserDetailsWithUid(
              uid: feed.userID, timestamp: feed.postedTimestamp);
        }
      });
    });

    feedListProvider.updateForYouData(tempList);
  }

  Future<void> storeLastUpdatedLocal(DocumentSnapshot doc) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _hasLastUpdated = true;
    _lastUpdated = doc['postedTimeStamp'].toDate();
    prefs.setString('lastUpdated', _lastUpdated.toString());
    print('lastUpdated stored: ' + _lastUpdated.toString());
    // prefs.setStringList('seenDocs', seenDocsList);
    // this.latestEntry.add(doc);
  }

  // Future<void> createNewPost(String title, String content,
  //     {List<String> tags}) async {
  //   List<String> tempTags = getTags(tags);
  //   print('createNewPost with tags: ' + tempTags.toString());
  //   await allPostsCollection.add({
  //     'title': title,
  //     'content': content,
  //     'name': 'zheng_xiang_wong',
  //     'tags': tempTags,
  //     'verse': 'Psalm 4:8',
  //     'verseTag': 'versePeace',
  //     'user': 'Dummy user ID',
  //     'peaceRating': 50.00,
  //     'loveRating': 45.00,
  //     'usersSeen': ['xiang'],
  //     'isLiked': [],
  //     'lastUpdated': FieldValue.serverTimestamp(),
  //   }).catchError((e) {
  //     print('Failed to add data: $e');
  //   });
  // }

  Future<void> createPostWithMap(
      {String title,
      String content,
      List<Map<String, String>> listMapContent,
      List<String> tags,
      MyUser myUser,
      String featuredTopic,
      String featuredValue}) async {
    List<String> _reformatTags = reformatTags(tags);

    Map _reformatTagMap = {};
    tags.forEach((tag) {
      _reformatTagMap[tag.toString()] = 35;
    });

    await allPostsCollection.add({
      'userID': this.uid ?? 'no user id',
      'username': myUser.username ?? 'no username uploaded',
      'profileImageUrl': myUser.profileImageUrl ?? null,
      'likes': 0,
      'isLiked': [],
      'title': title,
      // 'content': content,
      'giftLove': 0,
      'giftBird': 0,
      'featuredTopic': featuredTopic,
      'featuredValue': featuredValue,
      'contentLength': content.length,
      'listMapContent': listMapContent,
      'tags': _reformatTags,
      'tagsValue': _reformatTagMap,
      'views': 9,
      'postedTimeStamp': FieldValue.serverTimestamp(),
    }).catchError((e) {
      print('Failed to add data: $e');
    });
  }

  Future<void> updateFeedAfterSwipe(
      {Feed feed, MyUser user, bool hasUpdateLike}) async {
    print('updateFeedAfterSwipe RAN!');

    feed.swipeUpdatedToFB();

    getSortedFollowing().then((followingList) {
      if (followingList.contains(feed.userID)) {
        jsonFollowingStorage.updateUserDetailsWithUid(
            uid: feed.userID, timestamp: feed.postedTimestamp);
      }
    });

    try {
      if (hasUpdateLike) {
        print('hasLikeUpdate is true');
        if (feed.isLiked) {
          await allPostsCollection.doc(feed.documentID).update({
            'isLiked': FieldValue.arrayUnion([this.uid]),
            'likes': FieldValue.increment(1),
            'views': FieldValue.increment(feed.hasViewed ? 0 : 1),
            'profileImageUrl': user.profileImageUrl,
          });
        } else {
          await allPostsCollection.doc(feed.documentID).update({
            'isLiked': FieldValue.arrayRemove([this.uid]),
            'likes': FieldValue.increment(-1),
            'views': FieldValue.increment(feed.hasViewed ? 0 : 1),
            'profileImageUrl': user.profileImageUrl,
          });
        }
      } else if (!feed.hasViewed) {
        await allPostsCollection.doc(feed.documentID).update({
          'views': FieldValue.increment(1),
          'profileImageUrl': user.profileImageUrl,
        });
        print('Updated Views of Feed');
      } else {
        print('No update to DB feed');
      }

      feed.hasViewed = true;
      //has viewed feed after swipe
    } catch (e) {
      print('Failed to updateFeedAfterSwipe $e');
    }
  }

  Future<void> updateFeedDynamicPost({Feed feed}) async {
    if (feed.isLiked) {
      await allPostsCollection.doc(feed.documentID).update({
        'isLiked': FieldValue.arrayUnion([this.uid]),
        'likes': FieldValue.increment(1),
        'views': FieldValue.increment(feed.hasViewed ? 0 : 1),
      });
    } else {
      await allPostsCollection.doc(feed.documentID).update({
        'isLiked': FieldValue.arrayRemove([this.uid]),
        'likes': FieldValue.increment(-1),
        'views': FieldValue.increment(feed.hasViewed ? 0 : 1),
      });
    }
  }

  List<String> reformatTags(List<String> tags) {
    List<String> tempList = [];
    tags.forEach((val) => {
          if (val != null)
            {
              val = val + '30',
              tempList.add(val.toLowerCase()),
            }
        });
    return tempList;
  }

  Future<void> firestoreCreateAnonAccount({
    @required String userUID,
    @required String username,
    @required bool completeLogin,
  }) async {
    try {
      print('firestoreCreateAnonAccount | START');
      return usersPrivateCollection.doc(userUID).set({
        'username': username ?? null,
        'description': null,
        'profileImageUrl': null,
        'phone': null,
        'email': null,
        'totalFollowers': 0,
        'totalFollowing': 0,
        'tagRatings': ['love10', 'peace30'],
        'tagTimestamps': {
          'love': FieldValue.serverTimestamp(),
          'peace': FieldValue.serverTimestamp(),
        },
        'socialLinks': null,
        'completeLogin': completeLogin ?? false,
      });
    } catch (err) {
      print('firestoreCreateAccount | Failed');
    }
  }

  Future<CreateAcc> firestoreCreateAccount(
      {@required String userUID,
      @required String email,
      @required String username,
      @required String phone,
      @required bool completeLogin}) async {
    try {
      print('firestoreCreateAccount | with uid: $userUID');
      return usersPrivateCollection.doc(userUID).set({
        'username': username ?? null,
        'description': null,
        'profileImageUrl': null,
        'phone': phone ?? null,
        'email': email ?? null,
        'totalFollowers': 0,
        'totalFollowing': 0,
        'tagRatings': ['love10', 'peace30'],
        'tagTimestamps': {
          'love': FieldValue.serverTimestamp(),
          'peace': FieldValue.serverTimestamp(),
        },
        'socialLinks': null,
        'completeLogin': completeLogin ?? false,
      }).then((_) async {
        final String _allFollowingCollectionPath =
            '${usersPrivateCollection.path}/$userUID/allFollowing';

        final CollectionReference privateAllFollowingCollection =
            FirebaseFirestore.instance.collection(_allFollowingCollectionPath);

        privateAllFollowingCollection.add({
          'numFollowing': 0,
          'usersFollowing': [],
        });

        usersPublicCollection.add({
          'userID': userUID,
          'username': username ?? null,
          'phone': phone ?? null,
          'email': email ?? null,
          'totalFollowers': 0,
          'followers': [],
          'latestPost': FieldValue.serverTimestamp(),
        });
        print('firestoreCreateAccount | FINISH');
        return CreateAcc.newAccount;
      });
    } catch (e) {
      print('Error creating account: ' + e.toString());
      return CreateAcc.error;
    }
  }

  // Future<void> updateNewAccUser(
  //     {String uid, String username, String phone, String email}) async {
  //   try {
  //     await usersPrivateCollection.doc(uid).get().then((doc) async {
  //       if (doc.exists) {
  //         await usersPrivateCollection.doc(uid).update({
  //           'username': username,
  //           'phone': phone,
  //           'completeLogin': true, //shouldn't be true
  //           'profileImageUrl': null,
  //         });
  //       } else {
  //         // firestoreCreateAccount
  //         firestoreCreateAccount(
  //             userUID: uid,
  //             username: username,
  //             phone: phone,
  //             email: email,
  //             completeLogin: true);
  //       }
  //       await usersPublicCollection
  //           .where('userID', isEqualTo: uid)
  //           .get()
  //           .then((snap) async {
  //         if (snap.docs.isNotEmpty) {
  //           snap.docs.forEach((doc) async {
  //             await usersPublicCollection.doc(doc.id).update({
  //               'username': username,
  //               'phone': phone,
  //               'profileImageUrl': null,
  //             });
  //           });
  //         } else {
  //           await usersPublicCollection.add({
  //             'userID': uid,
  //             'username': username,
  //             'phone': phone,
  //             'profileImageUrl': null,
  //             'email': '',
  //             'totalFollowers': 0,
  //             'followers': [],
  //             'latestPost': FieldValue.serverTimestamp(),
  //           });
  //         }
  //       });
  //     });
  //   } catch (e) {}
  // }

  Future<bool> checkIfValidUsername(String username) async {
    return await usersPrivateCollection
        .where('username', isEqualTo: username)
        .get()
        .then((snap) {
      return snap.docs.isEmpty;
    });
  }

  Future<void> giftFeed({String postID, int giftLove, int giftBird}) async {
    await allPostsCollection.doc(postID).update({
      'giftLove': FieldValue.increment(giftLove),
      'giftBird': FieldValue.increment(giftBird),
    });
  }

  Future<void> addLike() async {
    await allPostsCollection.get().then((querySnaps) {
      querySnaps.docs.forEach((doc) {
        allPostsCollection.doc(doc.id).update({'isLiked': []});
      });
    });
  }

  Future<void> transferToLikeCollection() async {
    try {
      await allPostsCollection.get().then((QuerySnapshot querySnapshot) {
        print('Success get from allposts');
        querySnapshot.docs.forEach((doc) async {
          String _postID = doc.id;
          print('iterate Post ID: ' + _postID);

          List _listLiked = doc['isLiked'] ?? [];

          await likedPostsCollection
              .where('postID', isEqualTo: _postID)
              .orderBy('timeCreated', descending: false)
              .limit(5)
              .get()
              .then((snaps) async {
            print('SNAPS ARE: ' + snaps.toString());
            if (snaps.size > 0) {
              print('Existing like document with ID: ' + snaps.docs.last.id);
              String _docID = snaps.docs.last.id;
              await likedPostsCollection.doc(_docID).update({
                'postID': _postID,
                'likedBy': FieldValue.arrayUnion(_listLiked),
                // 'timeCreated': FieldValue.serverTimestamp(),
              });
            } else {
              print('Create New document with Post ID: ' + _postID);
              await likedPostsCollection.add({
                'postID': _postID,
                'likedBy': FieldValue.arrayUnion(_listLiked),
                'numberOfLikes': _listLiked.length,
                'timeCreated': FieldValue.serverTimestamp(),
              });
            }
          });
        });
      });
    } catch (e) {
      print('ERROR: transfer to like collection failed');
    }
  }

  Future<void> reportPost({
    Feed feed,
    List<ReportFeed> reportEnumList,
    String description,
  }) async {
    await reportedPostsCollection
        .where('postID', isEqualTo: feed.documentID)
        .get()
        .then((snap) async {
      if (snap.docs.isNotEmpty) {
        DocumentSnapshot doc = snap.docs.last;
        await reportedPostsCollection.doc(doc.id).update({
          'totalReports': FieldValue.increment(1),
          'users': FieldValue.arrayUnion([this.uid]),
          'reasonList': FieldValue.arrayUnion([description]),
          'latestReport': FieldValue.serverTimestamp(),
          'violence': reportEnumList.contains(ReportFeed.violence)
              ? FieldValue.increment(1)
              : FieldValue.increment(0),
          'sensitive': reportEnumList.contains(ReportFeed.sensitive)
              ? FieldValue.increment(1)
              : FieldValue.increment(0),
          'political': reportEnumList.contains(ReportFeed.political)
              ? FieldValue.increment(1)
              : FieldValue.increment(0),
          'adultContent': reportEnumList.contains(ReportFeed.adultContent)
              ? FieldValue.increment(1)
              : FieldValue.increment(0),
          'language': reportEnumList.contains(ReportFeed.language)
              ? FieldValue.increment(1)
              : FieldValue.increment(0),
          'others': reportEnumList.contains(ReportFeed.others)
              ? FieldValue.increment(1)
              : FieldValue.increment(0),
        });
      } else {
        await reportedPostsCollection.add({
          'postID': feed.documentID,
          'totalReports': 1,
          'users': FieldValue.arrayUnion([this.uid]),
          'reasonList': [description],
          'latestReport': FieldValue.serverTimestamp(),
          'violence': reportEnumList.contains(ReportFeed.violence) ? 1 : 0,
          'sensitive': reportEnumList.contains(ReportFeed.sensitive) ? 1 : 0,
          'political': reportEnumList.contains(ReportFeed.political) ? 1 : 0,
          'adultContent':
              reportEnumList.contains(ReportFeed.adultContent) ? 1 : 0,
          'language': reportEnumList.contains(ReportFeed.language) ? 1 : 0,
          'others': reportEnumList.contains(ReportFeed.others) ? 1 : 0,
        });
      }
    });
  }

  //tutorial
  Future<bool> completeSelectionTopics(List<String> topicInterests) async {
    try {
      await usersPrivateCollection.doc(this.uid).update({
        'topicInterests': topicInterests,
      });
      return true;
    } catch (err) {
      return false;
    }
  }

  // Future<void> updateAllPostWithFields() async {
  //   await allPostsCollection
  //       .where('featuredTopic', isEqualTo: null)
  //       .get()
  //       .then((snap) {
  //     snap.docs.forEach((doc) async {
  //       await allPostsCollection.doc(doc.id).update({
  //         'giftBird': 0,
  //         'giftLove': 0,
  //         'featuredTopic': null,
  //         'featuredValue': null,
  //       });
  //     });
  //   });
  // }

  // Future<void> updateCompleteLogin() async {
  //   await usersPrivateCollection.get().then((snaps) {
  //     snaps.docs.forEach((doc) async {
  //       await usersPrivateCollection.doc(doc.id).update({
  //         'completeLogin': true,
  //       });
  //     });
  //   });
  // }

  // Future<void> removeContentField() async {
  //   await allPostsCollection.get().then((snaps) {
  //     snaps.docs.forEach((doc) async {
  //       allPostsCollection.doc(doc.id).update({
  //         'content': FieldValue.delete(),
  //         // 'contentLength':
  //         //     doc['content'] != null ? doc['content'].length : 0,
  //       });
  //     });
  //   });
  // }
  //
  //
  //   Future<void> updateMyFollowings() async {
  //   await usersPrivateCollection.get().then((snaps) {
  //     snaps.docs.forEach((doc) async {
  //       String _currentID = doc.id;
  //       print('UserID is: ' + doc.id);
  //       final String _allFollowingCollectionPath =
  //           '${usersPrivateCollection.path}/${doc.id}/allFollowing';

  //       final CollectionReference privateAllFollowingCollection =
  //           FirebaseFirestore.instance.collection(_allFollowingCollectionPath);

  //       print('Collection Path is: ' + privateAllFollowingCollection.path);

  //       await privateAllFollowingCollection.get().then((snaps) async {
  //         snaps.docs.forEach((doc) async {
  //           await FirebaseFirestore.instance
  //               .runTransaction((Transaction myTransaction) async {
  //             myTransaction.delete(doc.reference);
  //           });
  //         });
  //       }).then((_) async {
  //         await privateAllFollowingCollection.add({
  //           'numFollowing': 0,
  //           'usersFollowing': [],
  //         }).then((addedDoc) async {
  //           print('Doc added at: ' + _currentID);

  //           await usersPublicCollection
  //               .where('followers', arrayContains: _currentID)
  //               .get()
  //               .then((followingSnaps) async {
  //             print(doc['username']);
  //             print(followingSnaps.size);
  //             followingSnaps.docs.forEach((followingDoc) async {
  //               print(followingDoc.data()['userID']);
  //               await privateAllFollowingCollection.doc(addedDoc.id).update({
  //                 'numFollowing': FieldValue.increment(1),
  //                 'usersFollowing':
  //                     FieldValue.arrayUnion([followingDoc.data()['userID']]),
  //               });
  //             });
  //           });
  //         });
  //       });
  //     });
  //   });
  // }
}
