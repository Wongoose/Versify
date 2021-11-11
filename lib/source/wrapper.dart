import 'package:flutter/services.dart';
import 'package:versify/providers/providers_home/tutorial_provider.dart';
import 'package:versify/screens/app_register/new_user_options.dart';
import 'package:versify/screens/app_register/pick_topics.dart';
import 'package:versify/screens/app_register/create_new_username.dart';
import 'package:versify/screens/home/home_wrapper.dart';
import 'package:versify/screens/profile/settings/account_provider.dart';
import 'package:versify/services/json_storage/all_badges_json_storage.dart';
import 'package:versify/services/firebase/auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:versify/services/firebase/profile_database.dart';
import 'package:versify/services/json_storage/users_following_json_storage.dart';
import 'package:versify/shared/helper/helper_methods.dart';
import 'package:versify/shared/widgets/widgets_all_loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user_model.dart';

class Wrapper extends StatelessWidget {
  @override
  @override
  Widget build(BuildContext context) {
    final MyUser _streamUser = Provider.of<MyUser>(context, listen: true);
    final ProfileDBService _profileDBService =
        Provider.of<ProfileDBService>(context, listen: false);

    final AuthService _authService =
        Provider.of<AuthService>(context, listen: false);

    final JsonFollowingStorage _jsonFollowingStorage =
        Provider.of<JsonFollowingStorage>(context);

    final JsonAllBadgesStorage _jsonAllBadgesStorage =
        Provider.of<JsonAllBadgesStorage>(context);

    final TutorialProvider _tutorialProvider =
        Provider.of<TutorialProvider>(context, listen: false);

    final AccountSettingsProvider _accountSettingsProvider =
        Provider.of<AccountSettingsProvider>(context, listen: false);

    SystemChrome.setEnabledSystemUIOverlays(
        [SystemUiOverlay.top, SystemUiOverlay.bottom]);

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Theme.of(context).splashColor,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarDividerColor:
            Theme.of(context).dialogBackgroundColor,
        systemNavigationBarColor: Theme.of(context).dialogBackgroundColor,
      ),
    );

    if (_tutorialProvider.pickTopics) {
      // tutorial pick topics
      return IntroPickTopics(_authService);
    } else {
      if (_streamUser.streamStatus == StreamMyUserStatus.success) {
        // checkUser();
        print(purplePen(
            "Wrapper | has auth user with ID: ${_streamUser.userUID}"));

        return FutureBuilder<MyUser>(
            future: _profileDBService
                .whetherUserHasFirestoreAccount(_streamUser.userUID),
            builder: (context, myUserSnap) {
              if (myUserSnap.connectionState == ConnectionState.done) {
                if (myUserSnap.data != null) {
                  // User has document in firestore
                  print(greenPen(
                      "Wrapper() whetherUserHasFirestoreAccount | TRUE"));

                  _authService.hasFirestoreDocuments = true;
                  _authService.getCurrentSignInProvider();

                  // return Material(
                  //     clipBehavior: Clip.antiAlias,
                  //     child: Center(
                  //       child: Text(
                  //         "User has firestore account",
                  //         style: TextStyle(color: Colors.white, fontSize: 30),
                  //       ),
                  //     ));

                  // validate and update firebase (phone and email)
                  final Future<void> _futureSyncUserPhoneAndEmail =
                      syncUserPhoneAndEmail(
                    authService: _authService,
                    whetherHasAccUser: myUserSnap.data,
                    profileDBService: _profileDBService,
                  );

                  return FutureBuilder<void>(
                      future: _futureSyncUserPhoneAndEmail,
                      builder: (context, snap) {
                        if (snap.connectionState == ConnectionState.done) {
                          _accountSettingsProvider
                              .initSettingsUser(_authService.myUser);

                          if (_authService.isUserAnonymous) {
                            print(purplePen(
                                "FutureBuilder Sync: ${_authService.myUser.userUID} | is signInAnonymous"));

                            initSharedPrefs(
                                logInUserID: _authService.myUser.userUID);

                            // initialize services for ANONYMOUS account
                            _profileDBService.profileDBInit();
                            _jsonFollowingStorage.jsonInit(); // diff accounts
                            _jsonAllBadgesStorage.jsonInit();

                            return HomeWrapper();
                          } else {
                            if (myUserSnap.data.completeLogin == true) {
                              // EXISTING USER - Completed login process
                              print(grayPen(
                                  "${_authService.myUser.userUID} | is completeLogin = TRUE"));

                              initSharedPrefs(
                                  logInUserID: _authService.myUser.userUID);

                              // initialize services for account
                              _profileDBService.profileDBInit();
                              _jsonFollowingStorage.jsonInit(); // diff accounts
                              _jsonAllBadgesStorage.jsonInit();

                              return HomeWrapper();
                            } else {
                              // EXISTING USER - Not completed login process
                              return CreateNewUsername();
                            }
                          }
                        } else {
                          // CONNECTION STATE - not done (loading)
                          return SplashLoading();
                        }
                      });
                } else {
                  // no user document but authenticated
                  print(
                      purplePen("Wrapper whetherHasFirestoreAccount | FALSE"));

                  _authService.hasFirestoreDocuments = false;

                  if (_authService.isUserAnonymous) {
                    // ANONYMOUS NEW USER - When viewing Dynamic Link
                    print(purplePen(
                        "Wrapper whetherHasFirestoreAccount | FALSE: Anonymous new user with no firestore document!"));
                    return GestureDetector(
                        onTap: () async => _authService.logout(),
                        child: Container(
                          color: Colors.white,
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                        ));
                  } else {
                    // PART OF SIGN UP PROCESS
                    // user authenticated not-anonymous but no firestore document
                    // whetherHasAccount cannot create MyUser Model
                    print(purplePen(
                        "Wrapper whetherHasFirestoreAccount | FALSE: Signed-in new user with no firestore document! Continue sign-up process..."));
                    return CreateNewUsername();
                  }
                }
              } else {
                return SplashLoading();
              }
            });
      } else if (_streamUser.streamStatus == StreamMyUserStatus.none) {
        print(purplePen("Wrapper | Directed to Sign In screen"));
        return OnBoardingNewUser(boardingUserDetails: false);
      } else {
        return SplashLoading();
      }
    }
  }

  Future<void> initSharedPrefs({String logInUserID}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String _currentUserID = prefs.getString('currentUserID');

    if (_currentUserID != logInUserID) {
      prefs.setString('currentUserID', logInUserID);
      prefs.remove('sortedFollowingList');
      prefs.remove('lastUpdated');
    } else {
      // sameUser
      // prefs.setString('currentUserID', logInUserID);
    }
  }

  Future<void> syncUserPhoneAndEmail({
    @required AuthService authService,
    @required MyUser whetherHasAccUser,
    @required ProfileDBService profileDBService,
  }) async {
    try {
      print(purplePen("WRAPPER: syncUserPhoneAndEmail | Function called!"));
      // print('...authPhone is: ${authService.getCurrentUser.phoneNumber ?? 'is null'}');
      // print('...whetherHasAccUserPhone is: ${whetherHasAccUser.phoneNumber ?? 'is null'}');

      bool requiresUpdate = false;

      if (authService.getCurrentUser.phoneNumber !=
              whetherHasAccUser.phoneNumber ||
          authService.getCurrentUser.email != whetherHasAccUser.email) {
        // phone number or email not the same (update FB)
        print('syncUserPhoneAndEmail | phone or email not the same');
        print(
            'syncUserPhoneAndEmail | authPhone: ${authService.getCurrentUser.phoneNumber}' ??
                'is null');
        print(
            'syncUserPhoneAndEmail | authEmail: ${authService.getCurrentUser.email}' ??
                'is null');
        requiresUpdate = true;
      }

      // Updating whetherHasAccUser with newly synced Phone and Email
      whetherHasAccUser.phoneNumber = authService.getCurrentUser.phoneNumber;
      whetherHasAccUser.email = authService.getCurrentUser.email;

      // IMPORTANT: Updated finalize authService.myUser
      authService.updateAuthMyUser(whetherHasAccUser);

      if (requiresUpdate) {
        await profileDBService.updateSyncedPhoneAndEmail(
          phone: authService.getCurrentUser.phoneNumber,
          email: authService.getCurrentUser.email,
        );
        print(greenPen(
            "WRAPPER: syncUserPhoneAndEmail | Function END: Updated firebase!"));
      } else {
        print(greenPen(
            "WRAPPER: syncUserPhoneAndEmail | Function END: No syncing necessary!"));
      }
    } catch (err) {
      print(redPen(
          "WRAPPER: syncUserPhoneAndEmail | FAILED with catch error: $err"));
    }
  }
}
