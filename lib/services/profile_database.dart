import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:versify/models/feed_model.dart';
import 'package:versify/models/user_model.dart';
import 'package:versify/providers/home/profile_blogs_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum ReportUser {
  offTopic,
  copyAccount,
  disrespectful,
  others,
}

class ProfileDBService {
  final String uid;
  // DateTime _lastUpdated;

  ProfileDBService({this.uid});

  String _myCurrentFollowingDoc = '';

  CollectionReference _allPostsCollection =
      FirebaseFirestore.instance.collection('allPosts');

  CollectionReference usersPrivateCollection =
      FirebaseFirestore.instance.collection('usersPrivate');

  CollectionReference usersPublicCollection =
      FirebaseFirestore.instance.collection('usersPublicFollow');

  CollectionReference reportedUsersCollection =
      FirebaseFirestore.instance.collection('reportedUsers');

  CollectionReference privateAllFollowingCollection;

  Future<void> profileDBInit() async {
    String _allFollowingCollectionPath =
        '${usersPrivateCollection.path}/${this.uid}/allFollowing';
    privateAllFollowingCollection =
        FirebaseFirestore.instance.collection(_allFollowingCollectionPath);

    await privateAllFollowingCollection.get().then((snaps) {
      //add .where createdTimestamp
      DocumentSnapshot _followingDoc = snaps.docs.last;
      _myCurrentFollowingDoc = _followingDoc.id;
    });
  }

  Future<MyUser> getProfileData({String profileUID}) async {
    print('getProfileData RAN');
    try {
      return await usersPublicCollection
          .where('followers', arrayContains: this.uid)
          .where('userID', isEqualTo: profileUID)
          .get()
          .then((snaps) async {
        if (snaps.docs.length > 0) {
          //current user is following
          DocumentSnapshot _doc = snaps.docs.last;
          return MyUser(
            userUID: _doc['userID'],
            username: _doc['username'],
            description: _doc['description'] ?? '',
            profileImageUrl: _doc['profileImageUrl'] ??
                'https://firebasestorage.googleapis.com/v0/b/goconnect-745e7.appspot.com/o/images%2Ffashion.png?alt=media&token=f2e8484d-6874-420c-9401-615063e53b8d',
            phoneNumber: _doc['phone'],
            email: _doc['email'],
            socialLinks: _doc['socialLinks'] ??
                {
                  'instagram': null,
                  'tiktok': null,
                  'youtube': null,
                  'website': null,
                },
            usersPublicFollowID: _doc.id,
            isFollowing: (_doc['followers'] as List).contains(this.uid),
          );
        } else {
          //current user not following
          return await usersPrivateCollection.doc(profileUID).get().then((doc) {
            return MyUser(
              userUID: doc.id,
              username: doc['username'],
              description: doc['description'] ?? '',
              profileImageUrl: doc['profileImageUrl'] ??
                  'https://firebasestorage.googleapis.com/v0/b/goconnect-745e7.appspot.com/o/images%2Ffashion.png?alt=media&token=f2e8484d-6874-420c-9401-615063e53b8d',
              phoneNumber: doc['phone'],
              email: doc['email'],
              socialLinks: doc['socialLinks'] ??
                  {
                    'instagram': null,
                    'tiktok': null,
                    'youtube': null,
                    'website': null,
                  },
              usersPublicFollowID: null,
              isFollowing: false,
            );
          });
        }
      });
    } catch (e) {
      print('Error while getting profile data: ' + e.toString());
      return null;
    }
  }

  Future<void> getNewProfileBlogs(
      {MyUser profileUser, ProfileBlogsProvider provider, bool isFirst}) async {
    List<Feed> tempList = [];

    // DateTime _newestFeedTs =
    //     provider.data.first.postedTimestamp ?? profileUser.lastBlogsUpdated;
    // DateTime _newestFeedTs = profileUser.lastBlogsUpdated;
    DateTime _newestFeedTs = provider.data.isNotEmpty
        ? provider.data.first.postedTimestamp
        : profileUser.lastBlogsUpdated;
    print('getNewProfileBlogs | with TS: ' + _newestFeedTs.toString());

    await _allPostsCollection
        .where('userID', isEqualTo: profileUser.userUID)
        .where('postedTimeStamp', isGreaterThan: _newestFeedTs)
        .get()
        .then((snaps) {
      snaps.docs.forEach((doc) async {
        tempList.add(Feed(
          documentID: doc.id,
          userID: doc['userID'],

          username: doc['username'],
          profileImageUrl: doc['profileImageUrl'] ?? null,
          hasViewed: false,

          // content: doc['content'] ?? 'No Content',
          contentLength: doc['contentLength'] ?? 0,
          title: doc['title'] ?? 'Just Me',
          tags: doc['tags'] ?? [],
          initLike: doc['isLiked'] != null
              ? doc['isLiked'].contains(this.uid)
              : false,

          featuredTopic: doc['featuredTopic'] ?? null,
          featuredValue: doc['featuredValue'] ?? ". . .",

          giftLove: doc['giftLove'] ?? 0,
          giftBird: doc['giftBird'] ?? 0,

          numberOfLikes: doc['likes'],
          numberOfViews: doc['views'],
          listMapContent: doc['listMapContent'] ?? [],
          postedTimestamp: doc['postedTimeStamp'].toDate(),
        ));
      });
    }).catchError((e) => print('Failed getNewProfileBlogs: $e'));

    print('getNewProfileBlogs: ' + tempList.toString());
    profileUser.lastBlogsUpdated = DateTime.now();
    await provider.insertNewData(tempList);
  }

  Future<void> getProfileBlogs(
      {MyUser profileUser, ProfileBlogsProvider provider, bool isFirst}) async {
    print('getProfileBlogs has been CALLED is DATABASE');
    List<Feed> tempList = [];
    DateTime _lastUpdated = profileUser.lastUpdated;
    print(profileUser.username + ': ' + profileUser.lastUpdated.toString());
    _lastUpdated == null ? _lastUpdated = DateTime.now() : null;
    print(_lastUpdated);
    await _allPostsCollection
        .where('userID', isEqualTo: profileUser.userUID)
        .where('postedTimeStamp',
            isLessThan: isFirst ? DateTime.now() : _lastUpdated)
        .orderBy('postedTimeStamp', descending: true)
        .limit(5)
        .get()
        .then((QuerySnapshot snap) async {
      snap.docs.forEach((doc) async {
        print('got doc: ' + doc.id);
        tempList.add(Feed(
          documentID: doc.id,
          userID: doc['userID'],

          username: doc['username'],
          profileImageUrl: doc['profileImageUrl'] ?? null,
          hasViewed: false,

          // content: doc['content'] ?? 'No Content',
          contentLength: doc['contentLength'] ?? 0,
          title: doc['title'] ?? 'Just Me',
          tags: doc['tags'] ?? [],
          initLike: doc['isLiked'] != null
              ? doc['isLiked'].contains(this.uid)
              : false,

          featuredTopic: doc['featuredTopic'] ?? null,
          featuredValue: doc['featuredValue'] ?? ". . .",

          giftLove: doc['giftLove'] ?? 0,
          giftBird: doc['giftBird'] ?? 0,

          numberOfLikes: doc['likes'],
          numberOfViews: doc['views'],
          listMapContent: doc['listMapContent'] ?? [],
          postedTimestamp: doc['postedTimeStamp'].toDate(),
        ));
        //add to seen
      });
      storeLastUpdated(doc: snap.docs.last, profileUser: profileUser);
    }).catchError((e) => print('Failed getProfileBlogs: $e'));

    print('getProfileBlogs: ' + tempList.toString());
    profileUser.lastBlogsUpdated = DateTime.now();
    await provider.updateData(tempList);
  }

  void storeLastUpdated({DocumentSnapshot doc, MyUser profileUser}) {
    profileUser.lastUpdated = doc['postedTimeStamp'].toDate();
  }

  Future<String> updateFollowing(
      {String profileUID, bool isFollowing, String usersPublicFollowID}) async {
    String _currentPublicFollowID;
    try {
      if (usersPublicFollowID == null) {
        //no publicFollowID

        await usersPublicCollection
            .where('userID', isEqualTo: profileUID)
            .get()
            .then((snaps) {
          DocumentSnapshot _doc = snaps.docs.last;
          _currentPublicFollowID = _doc.id;
        });
      } else {
        _currentPublicFollowID = usersPublicFollowID;
      }

      if (isFollowing) {
        //follow user
        updateFollowingPreference(newUserID: profileUID, isFollowing: true);

        await usersPublicCollection.doc(_currentPublicFollowID).update({
          'followers': FieldValue.arrayUnion([this.uid]),
          'totalFollowing': FieldValue.increment(1),
        });
        // return usersPublicFollowID;
      } else {
        //unfollow user
        updateFollowingPreference(newUserID: profileUID, isFollowing: false);

        await usersPublicCollection.doc(_currentPublicFollowID).update({
          'followers': FieldValue.arrayRemove([this.uid]),
          'totalFollowing': FieldValue.increment(-1),
        });
      }

      await privateAllFollowingCollection.doc(_myCurrentFollowingDoc).update({
        //update my private followings
        'usersFollowing': isFollowing
            ? FieldValue.arrayUnion([profileUID])
            : FieldValue.arrayRemove([profileUID]),
        'numFollowing':
            isFollowing ? FieldValue.increment(1) : FieldValue.increment(-1),
      });

      return _currentPublicFollowID;
    } catch (err) {
      return null;
    }
  }

  Future<void> updateFollowingPreference(
      {String newUserID, bool isFollowing}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> _followingList = prefs.getStringList('sortedFollowingList');
    // List<String> _reducedList = [];

    if (isFollowing) {
      _followingList.insert(0, newUserID);
    } else {
      _followingList.remove(newUserID);
    }

    // _followingList.reduce((value, element) {
    //   if (value != element) {
    //     _reducedList.add(value);
    //   }
    //   return element;
    // });
    _followingList.forEach((item) {
      if (item.isEmpty || item.length < 3) {
        //invalid userID
        _followingList.remove(item);
      }
    });

    print('SharedPref: UpdateFollowing new list: ' + _followingList.toString());
    prefs.setStringList('sortedFollowingList', _followingList);
  }

  Future<MyUser> whetherHasAccount(String userID) async {
    try {
      print('WhetherhasAccount RAN | $userID');

      return await usersPrivateCollection.doc(userID).get().then((doc) {
        print(doc.exists);
        if (doc.exists) {
          return MyUser(
            userUID: doc.id,
            username: doc['username'],
            description: doc['description'] ?? '',
            profileImageUrl: doc['profileImageUrl'] ??
                'https://firebasestorage.googleapis.com/v0/b/goconnect-745e7.appspot.com/o/images%2Ffashion.png?alt=media&token=f2e8484d-6874-420c-9401-615063e53b8d',
            phoneNumber: doc['phone'],
            email: doc['email'],
            socialLinks: doc['socialLinks'] ??
                {
                  'instagram': null,
                  'tiktok': null,
                  'youtube': null,
                  'website': null,
                },
            totalFollowers: doc['totalFollowers'],
            totalFollowing: doc['totalFollowing'],
            isFollowing: false,
            completeLogin: doc['completeLogin'] ?? false,
          );
        } else {
          return null;
        }
      });
    } catch (e) {
      print('error while signInUser: ' + e.toString());
      return null;
    }
  }

  Future<void> updatedValidatedPhoneAndEmail(
      {String phone, String email}) async {
    try {
      await usersPrivateCollection.doc(this.uid).update({
        'phone': phone ?? null,
        'email': email,
      });
    } catch (err) {
      print('updateValidatedPhoneAndEmail | Failed');
    }
  }

  Future<void> updateEditedProfile(MyUser user) async {
    try {
      await usersPrivateCollection.doc(this.uid).update({
        'username': user.username,
        'description': user.description,
        'phone': user.phoneNumber,
        'email': user.email,
        'socialLinks': user.socialLinks,
      });
      await usersPublicCollection
          .where('userID', isEqualTo: user.userUID)
          .get()
          .then((snaps) {
        snaps.docs.forEach((doc) async {
          usersPublicCollection.doc(doc.id).update({
            'username': user.username,
            'description': user.description,
            'phone': user.phoneNumber,
            'email': user.email,
            'socialLinks': user.socialLinks,
          });
        });
      });
    } catch (e) {}
  }

  Future<void> reportUser({
    MyUser user,
    List<ReportUser> reportEnumList,
    String description,
  }) async {
    await reportedUsersCollection
        .where('userID', isEqualTo: user.userUID)
        // .where('latestReport', isLessThanOrEqualTo: DateTime.now())
        // .orderBy('latestReport', descending: false)
        .get()
        .then((snap) async {
      if (snap.docs.isNotEmpty) {
        DocumentSnapshot doc = snap.docs.last;
        await reportedUsersCollection.doc(doc.id).update({
          'totalReports': FieldValue.increment(1),
          'users': FieldValue.arrayUnion([this.uid]),
          'reasonList': FieldValue.arrayUnion([description]),
          'latestReport': FieldValue.serverTimestamp(),
          'offTopic': reportEnumList.contains(ReportUser.offTopic)
              ? FieldValue.increment(1)
              : FieldValue.increment(0),
          'copyAccount': reportEnumList.contains(ReportUser.copyAccount)
              ? FieldValue.increment(1)
              : FieldValue.increment(0),
          'disrespectful': reportEnumList.contains(ReportUser.disrespectful)
              ? FieldValue.increment(1)
              : FieldValue.increment(0),
          'others': reportEnumList.contains(ReportUser.others)
              ? FieldValue.increment(1)
              : FieldValue.increment(0),
        });
      } else {
        await reportedUsersCollection.add({
          'userID': user.userUID,
          'totalReports': 1,
          'users': FieldValue.arrayUnion([this.uid]),
          'reasonList': [description],
          'latestReport': FieldValue.serverTimestamp(),
          'dateCreated': FieldValue.serverTimestamp(),
          'offTopic': reportEnumList.contains(ReportUser.offTopic) ? 1 : 0,
          'copyAccount':
              reportEnumList.contains(ReportUser.copyAccount) ? 1 : 0,
          'disrespectful':
              reportEnumList.contains(ReportUser.disrespectful) ? 1 : 0,
          'others': reportEnumList.contains(ReportUser.others) ? 1 : 0,
        });
      }
    });
  }

  Future<void> updatePhoneVerification({String phone}) async {
    print(
        'updatePhoneVerification() | update firebase phoneNumber to: ' + phone);
    await usersPrivateCollection.doc(this.uid).update({
      'phone': phone,
    });
  }

  Future<void> updateEmailVerification({String email}) async {
    await usersPrivateCollection.doc(this.uid).update({
      'email': email,
    });
  }

  // Future<void> updateAllUserProfileImage() async {
  //   await usersPrivateCollection
  //       .where('profileImageUrl', isEqualTo: null)
  //       .get()
  //       .then((snap) {
  //     snap.docs.forEach((doc) async {
  //       usersPrivateCollection.doc(doc.id).update({
  //         'profileImageUrl': null,
  //       });
  //     });
  //   });
  //   await usersPublicCollection
  //       .where('profileImageUrl', isEqualTo: null)
  //       .get()
  //       .then((snap) {
  //     snap.docs.forEach((doc) async {
  //       usersPublicCollection.doc(doc.id).update({
  //         'profileImageUrl': null,
  //       });
  //     });
  //   });
  // }
  // Future<MyUser> signInGetUserInfo({String uid}) async {
  //   print('ProfileDb SignIN User Info RAN');
  //   return await usersPrivateCollection.doc(uid).get().then((doc) {
  //     return MyUser(
  //       userUID: doc.id,
  //       username: doc['username'],
  //       description: doc['description'],
  //       phoneNumber: doc['phone'],
  //       totalFollowers: doc['totalFollowers'],
  //       totalFollowing: doc['totalFollowing'],
  //     );
  //   });
  // }
}

// if (isFollowing) {
//   updateFollowingPreference(newUserID: profileUID, isFollowing: true);

//   return await usersPublicCollection
//       .where('userID', isEqualTo: profileUID)
//       //orderBy Date Created
//       .get()
//       .then((snaps) async {
//     DocumentSnapshot _doc = snaps.docs.last;
//     await usersPublicCollection.doc(_doc.id).update({
//       'followers': FieldValue.arrayUnion([this.uid]),
//     });
//     await privateAllFollowingCollection
//         .doc(_myCurrentFollowingDoc)
//         .update({
//       //update my private followings
//       'usersFollowing': FieldValue.arrayUnion([profileUID]),
//       'numFollowing': FieldValue.increment(1),
//     });
//     return _doc.id;
//   });
// } else {
//   updateFollowingPreference(newUserID: profileUID, isFollowing: false);

//   await privateAllFollowingCollection.doc(_myCurrentFollowingDoc).update({
//     //update my private followings
//     'usersFollowing': FieldValue.arrayRemove([profileUID]),
//     'numFollowing': FieldValue.increment(-1),
//   });

//   //userPublicFollowiD is to save on read count
//   return await usersPublicCollection.doc(usersPublicFollowID).update({
//     'followers': FieldValue.arrayRemove([this.uid])
//   }).then((_) => usersPublicFollowID);
// }
