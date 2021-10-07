import 'package:flutter/services.dart';
import 'package:versify/providers/providers_home/tutorial_provider.dart';
import 'package:versify/screens/app_register/new_user_options.dart';
import 'package:versify/screens/app_register/pick_topics.dart';
import 'package:versify/screens/app_register/create_new_username.dart';
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

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  MyUser _cacheUser = MyUser();
  Future<MyUser> _futureInit;
  MyUser _streamUser;
  ProfileDBService _profileDBService;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // checkUser();
    });
  }

  void checkUser() {
    if (_streamUser != null) {
      if (_streamUser.userUID != _cacheUser.userUID) {
        _futureInit = _profileDBService
            .whetherUserHasFirestoreAccount(_streamUser.userUID);
        _cacheUser = _streamUser;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    _streamUser = Provider.of<MyUser>(context, listen: true);
    _profileDBService = Provider.of<ProfileDBService>(context, listen: false);

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

                  return Material(
                    clipBehavior: Clip.antiAlias,
                    
                      child: Center(
                        child: Text(
                    "User has firestore account",
                    style: TextStyle(color: Colors.white, fontSize: 30),
                  ),
                      ));

                  // validate and update firebase (phone and email)
                  // final Future<MyUser> _validateFuture =
                  //     validateUserPhoneAndEmail(
                  //   authService: _authService,
                  //   whetherHasAccUser: myUserSnap.data,
                  //   profileDBService: _profileDBService,
                  // );
                  // return FutureBuilder<MyUser>(
                  //     future: _validateFuture,
                  //     builder: (context, authUserSnap) {
                  //       if (authUserSnap.connectionState ==
                  //           ConnectionState.done) {
                  //         _accountSettingsProvider
                  //             .initSettingsUser(authUserSnap.data);
                  //         if (_authService.isUserAnonymous) {
                  //           print(myUserSnap.data.userUID +
                  //               "| is signInAnonymous");
                  //           // _authService.myUser = myUserSnap.data;

                  //           initSharedPrefs(
                  //               logInUserID: myUserSnap.data.userUID);
                  //           _profileDBService.profileDBInit();
                  //           _jsonFollowingStorage.jsonInit(); //diff accounts
                  //           _jsonAllBadgesStorage.jsonInit();

                  //           return new HomeWrapper();
                  //         } else {
                  //           if (myUserSnap.data.completeLogin == true) {
                  //             //oldUser compelte login
                  //             print(myUserSnap.data.userUID +
                  //                 "| is completeLogin = true");
                  //             // _authService.myUser = myUserSnap.data;

                  //             initSharedPrefs(
                  //                 logInUserID: myUserSnap.data.userUID);
                  //             _profileDBService.profileDBInit();
                  //             _jsonFollowingStorage.jsonInit(); //diff accounts
                  //             _jsonAllBadgesStorage.jsonInit();

                  //             // return DynamicLinkPost(
                  //             //   postId: '5ACsnQ8gciM6nO85qCCp',
                  //             //   onPopExitApp: false,
                  //             // );
                  //             return new HomeWrapper();
                  //           } else {
                  //             //not complete login
                  //             return CreateNewUsername();
                  //           }
                  //         }
                  //       } else {
                  //         return SplashLoading();
                  //       }
                  //     });
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
                    //whetherHasAccount cannot creat MyUser Model
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

  Future<MyUser> validateUserPhoneAndEmail({
    @required AuthService authService,
    // @required MyUser authServiceMyUser,
    @required MyUser whetherHasAccUser,
    @required ProfileDBService profileDBService,
  }) async {
    print('WRAPPER: validateUserPhoneAndEmail | Function called!');
    print('...authPhone is: ' +
        (authService.getCurrentUser.phoneNumber ?? 'is null'));
    print('...whetherHasAccUserPhone is: ' +
        (whetherHasAccUser.phoneNumber ?? 'is null'));

    bool requiresUpdate = false;

    if (authService.getCurrentUser.phoneNumber !=
            whetherHasAccUser.phoneNumber ||
        authService.getCurrentUser.email != whetherHasAccUser.email) {
      //phone number or email not the same (update FB)
      print('validateUserPhoneAndEmail | phone or email not the same');
      print('validateUserPhoneAndEmail | AuthPhone: ' +
              authService.getCurrentUser.phoneNumber ??
          'is null');
      print('validateUserPhoneAndEmail | AuthEmail: ' +
              authService.getCurrentUser.email ??
          'is null');
      requiresUpdate = true;
    }

    //Filtering
    // authServiceMyUser.phoneNumber = authServiceMyUser.phoneNumber != null
    //     ? authServiceMyUser.phoneNumber.isEmpty
    //         ? null
    //         : authServiceMyUser.phoneNumber
    //     : null;

    // authServiceMyUser.email = authServiceMyUser.email != null
    //     ? authServiceMyUser.email.isEmpty
    //         ? null
    //         : authServiceMyUser.email
    //     : null;

    //Updating whetherHasAccUser with valid email and phone
    whetherHasAccUser.phoneNumber = authService.getCurrentUser.phoneNumber;
    whetherHasAccUser.email = authService.getCurrentUser.email;

    // authServiceMyUser = whetherHasAccUser;

    //IMPORTANT: Updated finalize authService.myUser
    authService.updateAuthMyUser(whetherHasAccUser);

    if (requiresUpdate) {
      await profileDBService.updatedValidatedPhoneAndEmail(
        phone: authService.getCurrentUser.phoneNumber,
        email: authService.getCurrentUser.email,
      );
      print(
          'WRAPPER: validateUserPhoneAndEmail | Function END Updated firebase!');
      return authService.myUser;
    } else {
      print('WRAPPER: validateUserPhoneAndEmail | Function END!');
      return authService.myUser;
    }
  }
}
