import 'dart:async';
import 'dart:io';
import 'package:ansicolor/ansicolor.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:versify/providers/providers_home/bottom_nav_provider.dart';
import 'package:versify/providers/providers_create_post/content_body_provider.dart';
import 'package:versify/providers/providers_home/dynamic_link_provider.dart';
import 'package:versify/providers/providers_home/edit_profile_provider.dart';
import 'package:versify/providers/providers_feeds/feed_list_provider.dart';
import 'package:versify/providers/providers_feeds/all_posts_provider.dart';
import 'package:versify/providers/providers_feeds/feed_type_provider.dart';
import 'package:versify/providers/providers_feeds/input_comments_provider.dart';
import 'package:versify/providers/providers_feeds/post_swipe_up_provider.dart';
import 'package:versify/providers/providers_home/theme_data_provider.dart';
import 'package:versify/providers/providers_home/tutorial_provider.dart';
import 'package:versify/screens/app_register/onboarding.dart';
import 'package:versify/providers/providers_home/profile_data_provider.dart';
import 'package:versify/screens/profile/settings/account_provider.dart';
import 'package:versify/services/json_storage/all_badges_json_storage.dart';
import 'package:versify/services/firebase/auth.dart';
import 'package:versify/services/firebase/database.dart';
import 'package:versify/services/firebase/dynamic_links.dart';
import 'package:versify/services/firebase/profile_database.dart';
import 'package:versify/services/json_storage/shared_preferences.dart';
import 'package:versify/services/json_storage/users_following_json_storage.dart';
import 'package:versify/shared/helper/helper_classes.dart';
import 'package:versify/shared/helper/helper_methods.dart';
import 'package:versify/source/wrapper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:versify/shared/widgets/widgets_all_loading.dart';
import 'models/user_model.dart';
import 'source/main_success_stream_wrapper.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  ansiColorDisabled = false;
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(VersifyApp());
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  print(purplePen("Handling a background message: ${message.messageId}"));
}

class VersifyApp extends StatelessWidget {
  final Future<FirebaseApp> _initializeFirebaseApp = Firebase.initializeApp();
  final ThemeProvider _themeProvider = ThemeProvider();
  final MySharedPreferences _mySharedPreferences = MySharedPreferences();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([
      SystemUiOverlay.top,
      SystemUiOverlay.bottom,
    ]);

    SystemChrome.setPreferredOrientations(
      [
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ],
    );

    precacheImage(AssetImage("assets/images/logo_circle.png"), context);
    precacheImage(AssetImage("assets/images/purple_circle_v1.png"), context);
    precacheImage(AssetImage("assets/images/relatable.png"), context);
    precacheImage(AssetImage("assets/images/community.png"), context);
    precacheImage(AssetImage("assets/images/get-started.png"), context);
    precacheImage(
        AssetImage("assets/images/backgrounds/r-love_background.jpg"), context);
    precacheImage(
        AssetImage("assets/images/backgrounds/r-faith_background.jpg"),
        context);
    precacheImage(
        AssetImage("assets/images/backgrounds/r-grief_background.jpg"),
        context);
    precacheImage(
        AssetImage("assets/images/backgrounds/r-healing_background.jpg"),
        context);
    precacheImage(
        AssetImage("assets/images/backgrounds/r-joy_background.jpg"), context);
    precacheImage(
        AssetImage("assets/images/backgrounds/r-peace_background.jpg"),
        context);
    precacheImage(
        AssetImage("assets/images/backgrounds/r-prayer_background.jpg"),
        context);

    return FutureBuilder(
        future: Future.wait([
          _initializeFirebaseApp,
          _themeProvider.initPreferences(),
          _mySharedPreferences.initMySharedPreferences(),
        ]),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            print(redPen(
                "main.dart | FutureBuilder futureinitializeFirebase FAILED with error: ${snapshot.error}"));
          }
          if (snapshot.connectionState == ConnectionState.done) {
            print(purplePen("main.dart | initialized Firebase App!"));

            final PageController _followingPageViewController =
                PageController();
            final PageController _forYouPageViewController = PageController();

            final FeedTypeProvider _feedTypeProvider = FeedTypeProvider();

            final AllPostsView _allPostsProvider = AllPostsView(
              followingPageController: _followingPageViewController,
              forYouPageController: _forYouPageViewController,
              feedTypeProvider: _feedTypeProvider,
            );

            final FeedListProvider _feedListProvider =
                FeedListProvider(viewsProvider: _allPostsProvider);

            final BottomNavProvider _bottomNavProvider = BottomNavProvider();
            final PageViewProvider _pageViewProvider = PageViewProvider();
            final ContentBodyProvider _contentBodyWidgets =
                ContentBodyProvider();
            final InputCommentsProvider _inputCommentsProvider =
                InputCommentsProvider();

            final PostSwipeUpProvider _postSwipeUpProvider =
                PostSwipeUpProvider();

            final JsonFollowingStorage _jsonFollowingStorage =
                JsonFollowingStorage();

            final TutorialProvider _tutorialProvider = TutorialProvider();

            final DynamicLinkProvider _dynamicLinkProvider =
                DynamicLinkProvider();

            final AccountSettingsProvider _accountSettingsProvider =
                AccountSettingsProvider();

            JsonAllBadgesStorage _jsonAllBadgesStorage;

            EditProfileProvider _editProfileProvider;

            ProfileDataProvider _profileDataProvider;

            DatabaseService _firestoreDBService;
            ProfileDBService _profileDBService;

            final AuthService _authService = AuthService();
            final DynamicLinkService _dynamicLinkService = DynamicLinkService(
              authService: _authService,
              dynamicLinkProvider: _dynamicLinkProvider,
            );

            return StreamProvider<MyUser>.value(
              initialData: MyUser(streamStatus: StreamMyUserStatus.loading),
              value: _authService.user,
              catchError: (context, error) {
                print(redPen(
                    "main.dart StreamProvider<MyUser> | catchError: $error"));
                return MyUser(streamStatus: StreamMyUserStatus.error);
              },
              // ignore: missing_return
              child: Consumer<MyUser>(builder: (context, user, _) {
                print(purplePen("main.dart Consumer<MyUser> | Rebuild RAN!"));
                // Rebuilds everytime user auth changes
                // if user is different than before. Reset all feed and data required

                switch (user.streamStatus) {
                  case StreamMyUserStatus.error:
                    // return an error page (Check connection and try again)
                    return MaterialApp(
                        debugShowCheckedModeBanner: false,
                        home: SplashLoading());
                    break;
                  case StreamMyUserStatus.success:
                    print(greenPen(
                        "StreamMyUserStatus | is SUCCESS - initializing providers..."));
                    _firestoreDBService = DatabaseService(
                      uid: user.userUID,
                      jsonFollowingStorage: _jsonFollowingStorage,
                      feedListProvider: _feedListProvider,
                    );

                    _profileDBService = ProfileDBService(uid: user.userUID);

                    _editProfileProvider =
                        EditProfileProvider(profileDB: _profileDBService);
                    _profileDataProvider =
                        ProfileDataProvider(authUserUID: user.userUID);

                    _jsonAllBadgesStorage =
                        JsonAllBadgesStorage(uid: user.userUID);
                    return MainSuccessStreamWrapper(
                      authService: _authService,
                      firestoreDBService: _firestoreDBService,
                      profileDBService: _profileDBService,
                      jsonFollowingStorage: _jsonFollowingStorage,
                      jsonAllBadgesStorage: _jsonAllBadgesStorage,
                      mySharedPreferences: _mySharedPreferences,
                      themeProvider: _themeProvider,
                      dynamicLinkProvider: _dynamicLinkProvider,
                      tutorialProvider: _tutorialProvider,
                      profileDataProvider: _profileDataProvider,
                      editProfileProvider: _editProfileProvider,
                      accountSettingsProvider: _accountSettingsProvider,
                      postSwipeUpProvider: _postSwipeUpProvider,
                      feedTypeProvider: _feedTypeProvider,
                      contentBodyWidgets: _contentBodyWidgets,
                      feedListProvider: _feedListProvider,
                      allPostsProvider: _allPostsProvider,
                      bottomNavProvider: _bottomNavProvider,
                      pageViewProvider: _pageViewProvider,
                      inputCommentsProvider: _inputCommentsProvider,
                      dynamicLinkService: _dynamicLinkService,
                    );
                    break;
                  case StreamMyUserStatus.none:
                    // not authenticated
                    // initialize services for dynamicLink and tutorial (later will be anon)
                    print(greenPen(
                        "StreamMyUserStatus | is NONE - not authenticated"));
                    _firestoreDBService = DatabaseService();
                    _profileDBService = ProfileDBService();
                    return MainSuccessStreamWrapper(
                      authService: _authService,
                      firestoreDBService: _firestoreDBService,
                      profileDBService: _profileDBService,
                      jsonFollowingStorage: _jsonFollowingStorage,
                      jsonAllBadgesStorage: _jsonAllBadgesStorage,
                      mySharedPreferences: _mySharedPreferences,
                      themeProvider: _themeProvider,
                      dynamicLinkProvider: _dynamicLinkProvider,
                      tutorialProvider: _tutorialProvider,
                      profileDataProvider: _profileDataProvider,
                      editProfileProvider: _editProfileProvider,
                      accountSettingsProvider: _accountSettingsProvider,
                      postSwipeUpProvider: _postSwipeUpProvider,
                      feedTypeProvider: _feedTypeProvider,
                      contentBodyWidgets: _contentBodyWidgets,
                      feedListProvider: _feedListProvider,
                      allPostsProvider: _allPostsProvider,
                      bottomNavProvider: _bottomNavProvider,
                      pageViewProvider: _pageViewProvider,
                      inputCommentsProvider: _inputCommentsProvider,
                      dynamicLinkService: _dynamicLinkService,
                    );
                    break;
                  case StreamMyUserStatus.loading:
                    print(greenPen(
                        "StreamMyUserStatus | is LOADING - no myUser data yet"));
                    return MaterialApp(
                        debugShowCheckedModeBanner: false,
                        home: SplashLoading());
                    break;
                }
              }),
            );
          } else {
            print(purplePen("main.dart | initializing Firebase App LOADING"));

            return MaterialApp(
              debugShowCheckedModeBanner: false,
              home: SplashLoading(),
            );
          }
        });
  }
}

class VersifyHome extends StatefulWidget {
  final AuthService authService;
  final DynamicLinkService dynamicLinkService;
  final MySharedPreferences mySharedPreferences;

  const VersifyHome(
      {this.authService, this.dynamicLinkService, this.mySharedPreferences});

  @override
  _VersifyHomeState createState() => _VersifyHomeState();
}

class _VersifyHomeState extends State<VersifyHome> {
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  // providers
  TutorialProvider tutorialProvider;

  // state
  bool _completedBoarding;
  bool _completedTutorial;
  Future<void> _futureInitState;

  // functions
  // Future<void> _saveDeviceToken() async {}
  Future<void> myInitState() async {
    // initState() Check OnBoarding and Tutorial SharedPreferences
    print(purplePen("VersifyHome | myInitState RAN!"));
    _completedBoarding = widget.mySharedPreferences.isCompletedBoarding;
    _completedTutorial = widget.mySharedPreferences.isCompletedTutorial;

    if (!_completedBoarding && !widget.authService.isUserAuthenticated) {
      print(greenPen(
          "VersifyHome | initState() User is new and unauthenticated - signing in anon()!"));
      final ReturnValue result = await widget.authService.signInAnon();
      if (!result.success) {
        toast(result.value);
      }
    }

    // update tutorialProvider after get SharedPreferences
    WidgetsBinding.instance.addPostFrameCallback((_) {
      tutorialProvider.setTutorialComplete(_completedTutorial);
      // widget.authService.logout();
    });
  }

  @override
  void initState() {
    super.initState();
    print(purplePen("VersifyHome | initState() RAN!"));
    if (Platform.isAndroid) {
      firebaseMessaging.getToken().then((token) {
        print(grayPen(
            "VersifyHome | firebaseMessaging.getToken() with token: $token"));
      });
    }

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print(
          purplePen("FirebaseMessaging | listen has message: ${message.data}"));

      if (message.notification != null) {
        print(greenPen("FirebaseMessaging | Message has notification!"));
        print(grayPen("Notification Title: ${message.notification.title}"));

        final SnackBar snackBar = SnackBar(
          content: Padding(
            padding: EdgeInsets.all(8),
            child: Text(
              message.notification.title,
            ),
          ),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        print(purplePen("FirebaseMessaging | snackBar SHOWN"));
      }
    });

    // initState() Dynamic Link
    widget.dynamicLinkService.handleDynamicLink(context);
    _futureInitState = myInitState();
  }

  @override
  Widget build(BuildContext context) {
    tutorialProvider = Provider.of<TutorialProvider>(context, listen: false);

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

    return FutureBuilder(
      future: _futureInitState,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (_completedBoarding) {
            return Wrapper();
          } else {
            return OnBoarding();
          }
        } else {
          return SplashLoading();
        }
      },
    );
  }
}

typedef RefreshFunc = void Function();
