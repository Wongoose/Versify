import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:versify/home_wrapper.dart';
import 'package:versify/providers/home/theme_data_provider.dart';
import 'package:versify/providers/home/tutorial_provider.dart';
import 'package:versify/screens/onboarding_screen/new_user_options.dart';
import 'package:versify/screens/onboarding_screen/pick_topics.dart';
import 'package:versify/screens/onboarding_screen/create_new_username.dart';
import 'package:versify/providers/home/profile_data_provider.dart';
import 'package:versify/screens/profile_screen/settings/account_provider.dart';
import 'package:versify/services/all_badges_json_storage.dart';
import 'package:versify/services/auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:versify/services/profile_database.dart';
import 'package:versify/services/users_following_json_storage.dart';
import 'package:versify/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:versify/shared/splash_loading.dart';
import 'package:versify/z-dynamic_link/post_dynamic_link.dart';
import 'models/user_model.dart';

class Wrapper extends StatelessWidget {
  final Function completePickTutorials;

  Wrapper({this.completePickTutorials});

  @override
  Widget build(BuildContext context) {
    final MyUser user = Provider.of<MyUser>(context, listen: true);

    final AuthService _authService =
        Provider.of<AuthService>(context, listen: false);

    final JsonFollowingStorage _jsonFollowingStorage =
        Provider.of<JsonFollowingStorage>(context);

    final JsonAllBadgesStorage _jsonAllBadgesStorage =
        Provider.of<JsonAllBadgesStorage>(context);

    final TutorialProvider _tutorialProvider =
        Provider.of<TutorialProvider>(context, listen: false);

    final ProfileDBService _profileDBService =
        Provider.of<ProfileDBService>(context, listen: false);

    final ThemeProvider _themeProvider =
        Provider.of<ThemeProvider>(context, listen: false);

    AccountSettingsProvider _accountSettingsProvider =
        Provider.of<AccountSettingsProvider>(context, listen: false);

    SystemChrome.setEnabledSystemUIOverlays(
        [SystemUiOverlay.top, SystemUiOverlay.bottom]);

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Color(0xFFffdee9),
        statusBarIconBrightness:
            _themeProvider.isDark ? Brightness.light : Brightness.dark,
        systemNavigationBarDividerColor:
            Theme.of(context).dialogBackgroundColor,
        systemNavigationBarColor: Theme.of(context).dialogBackgroundColor,
      ),
    );

    if (_tutorialProvider.pickTopics) {
      //tutorial pick topics
      return IntroPickTopics(completePickTutorials);
    } else {
      if (user != null) {
        print('Wrapper stream user: ' + user.userUID.toString());
        print('Hash: ' + hashCode.toString());
        return FutureBuilder<MyUser>(
            future: _profileDBService.whetherHasAccount(user.userUID),
            //change whetherHasAcc function to return MyUser
            builder: (context, myUserSnap) {
              if (myUserSnap.connectionState == ConnectionState.done) {
                if (myUserSnap.data != null) {
                  //has user document in firestore
                  _authService.hasFirestoreDocuments = true;

                  return FutureBuilder<void>(
                      future: validateUserPhoneAndEmail(
                        authService: _authService,
                        authServiceMyUser: _authService.myUser,
                        whetherHasAccUser: myUserSnap.data,
                        profileDBService: _profileDBService,
                      ),
                      builder: (context, res) {
                        if (res.connectionState == ConnectionState.done) {
                          _accountSettingsProvider
                              .initSettingsUser(_authService.myUser);
                          if (_authService.isUserAnonymous) {
                            print(myUserSnap.data.userUID +
                                "| is signInAnonymous");
                            // _authService.myUser = myUserSnap.data;

                            initSharedPrefs(
                                logInUserID: myUserSnap.data.userUID);
                            _profileDBService.profileDBInit();
                            _jsonFollowingStorage.jsonInit(); //diff accounts
                            _jsonAllBadgesStorage.jsonInit();

                            return new HomeWrapper();
                          } else {
                            if (myUserSnap.data.completeLogin == true) {
                              //oldUser compelte login
                              print(myUserSnap.data.userUID +
                                  "| is completeLogin = true");
                              // _authService.myUser = myUserSnap.data;

                              initSharedPrefs(
                                  logInUserID: myUserSnap.data.userUID);
                              _profileDBService.profileDBInit();
                              _jsonFollowingStorage.jsonInit(); //diff accounts
                              _jsonAllBadgesStorage.jsonInit();

                              // return DynamicLinkPost(
                              //   postId: '5ACsnQ8gciM6nO85qCCp',
                              //   onPopExitApp: false,
                              // );
                              return new HomeWrapper();
                            } else {
                              //not complete login
                              return CreateNewUsername();
                            }
                          }
                        }else{
                          return SplashLoading();
                        }
                      });
                } else {
                  // no user document but authenticated
                  _authService.hasFirestoreDocuments = false;

                  if (_authService.isUserAnonymous) {
                    //dynamic linking with new user (anonymous)
                    print('Anonymous User | DynamicLink');
                    return GestureDetector(
                        onTap: () async {
                          await _authService.logout();
                        },
                        child: Container(
                          color: Colors.white,
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                        ));
                  } else {
                    //user authenticated not-anonymous but no firestore document
                    //part of sign up process
                    return CreateNewUsername();
                  }
                }
              } else {
                return SplashLoading();
              }
            });
      } else {
        return OnBoardingNewUser(boardingUserDetails: false);
      }
    }
  }

  Future<void> initSharedPrefs({String logInUserID}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String _currentUserID = prefs.getString('currentUserID');

    if (_currentUserID != logInUserID) {
      prefs.setString('currentUserID', logInUserID);
      prefs.remove('sortedFollowingList');
      prefs.remove('lastUpdated');
    } else {
      //sameUser
      // prefs.setString('currentUserID', logInUserID);
    }
  }

  Future<void> validateUserPhoneAndEmail({
    @required AuthService authService,
    @required MyUser authServiceMyUser,
    @required MyUser whetherHasAccUser,
    @required ProfileDBService profileDBService,
  }) async {
    bool requiresUpdate = false;

    if (authServiceMyUser.phoneNumber != whetherHasAccUser.phoneNumber ||
        authServiceMyUser.email != whetherHasAccUser.email) {
      //phone number or email not the same (update FB)
      requiresUpdate = true;
    }
    whetherHasAccUser.phoneNumber = authServiceMyUser.phoneNumber;
    whetherHasAccUser.email = authServiceMyUser.email;

    authServiceMyUser = whetherHasAccUser;
    authService.myUser = authServiceMyUser;

    if (requiresUpdate) {
      await profileDBService.updatedValidatedPhoneAndEmail(
        phone: authServiceMyUser.phoneNumber,
        email: authServiceMyUser.email,
      );
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
