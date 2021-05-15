import 'package:cached_network_image/cached_network_image.dart';
import 'package:versify/home_wrapper.dart';
import 'package:versify/screens/onboarding/new_user_options.dart';
import 'package:versify/screens/onboarding/sign_up_user_details.dart';
import 'package:versify/screens/profile_screen/profile_data_provider.dart';
import 'package:versify/screens/profile_screen/settings/account_provider.dart';
import 'package:versify/services/all_badges_json_storage.dart';
import 'package:versify/services/auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:versify/services/profile_database.dart';
import 'package:versify/services/users_following_json_storage.dart';
import 'package:versify/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/user_model.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final MyUser user = Provider.of<MyUser>(context, listen: true);

    ProfileDBService _profileDBService =
        Provider.of<ProfileDBService>(context, listen: false);

    final AuthService _authService =
        Provider.of<AuthService>(context, listen: false);

    final JsonFollowingStorage _jsonFollowingStorage =
        Provider.of<JsonFollowingStorage>(context);

    final JsonAllBadgesStorage _jsonAllBadgesStorage =
        Provider.of<JsonAllBadgesStorage>(context);

    // print('Wrapper: ' + jsonProvider.toString());

    // MyUser user = _authProvider.user;

    // futurebuilder maybe??
    if (user != null) {
      return FutureBuilder<MyUser>(
          future: _profileDBService.whetherHasAccount(user.userUID),
          //change whetherHasAcc function to return MyUser
          // ignore: missing_return
          builder: (context, myUserSnap) {
            if (myUserSnap.connectionState == ConnectionState.done) {
              if (myUserSnap.data != null &&
                  myUserSnap.data.completeLogin == true) {
                _authService.myUser = myUserSnap.data;

                // CachedNetworkImage(
                //   cacheKey: myUserSnap.data.userUID,
                //   imageUrl: myUserSnap.data.profileImageUrl,
                //   progressIndicatorBuilder: (context, url, downloadProgress) =>
                //       CircularProgressIndicator(
                //           value: downloadProgress.progress),
                //   errorWidget: (context, url, error) => Icon(Icons.error),
                // );

                initSharedPrefs(logInUserID: myUserSnap.data.userUID);
                _profileDBService.profileDBInit();
                _jsonFollowingStorage.jsonInit(); //diff accounts
                _jsonAllBadgesStorage.jsonInit();
                return new HomeWrapper();
              } else {
                return SignUpDetails();
              }
            } else {
              return Scaffold(
                backgroundColor: Colors.white,
                appBar: null,
                body: Loading(),
              );
            }
          });
    } else {
      return OnBoardingNewUser(boardingUserDetails: false);
    }
  }

  Future<void> initSharedPrefs({String logInUserID}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String _currentUserID = prefs.getString('currentUserID');

    if (_currentUserID != logInUserID) {
      prefs.setString('currentUserID', logInUserID);
      prefs.remove('sortedFollowingList');
    } else {
      //sameUser
      // prefs.setString('currentUserID', logInUserID);
    }
  }

  // Future<void> getAuthLocal(MyUser user) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String prefsUID = prefs.getString('userUID');
  //   String prefsResidenceID;
  //   String prefsHouseID;

  //   if (prefsUID != null && user.userUID == prefsUID) {
  //     print('WRAPPER auth got from local!');
  //     prefsResidenceID = prefs.getString('residenceID');
  //     prefsHouseID = prefs.getString('householdID');

  //     _profileDBService.updateExistingIDs(prefsHouseID, prefsResidenceID);
  //   } else {
  //     await _profileDBService.initNewUser();
  //   }
  // }
}
