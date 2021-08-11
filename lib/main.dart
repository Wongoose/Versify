import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:versify/providers/home/bottom_nav_provider.dart';
import 'package:versify/providers/create_post/content_body_provider.dart';
import 'package:versify/providers/home/edit_profile_provider.dart';
import 'package:versify/providers/feeds/feed_list_provider.dart';
import 'package:versify/providers/feeds/all_posts_provider.dart';
import 'package:versify/providers/feeds/feed_type_provider.dart';
import 'package:versify/providers/feeds/input_comments_provider.dart';
import 'package:versify/providers/feeds/post_swipe_up_provider.dart';
import 'package:versify/screens/onboarding_screen/onboarding.dart';
import 'package:versify/providers/home/profile_data_provider.dart';
import 'package:versify/screens/profile_screen/settings/account_provider.dart';
import 'package:versify/screens/profile_screen/settings/account_settings.dart';
import 'package:versify/services/all_badges_json_storage.dart';
import 'package:versify/services/auth.dart';
import 'package:versify/services/database.dart';
import 'package:versify/services/dynamic_links.dart';
import 'package:versify/services/profile_database.dart';
import 'package:versify/services/users_following_json_storage.dart';
import 'package:versify/wrapper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:versify/shared/splash_loading.dart';
import 'models/user_model.dart';
import 'package:versify/providers/home/tutorial_provider.dart';
import 'package:versify/providers/home/theme_data_provider.dart';

import 'z-dynamic_link/post_dynamic_link.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(VersifyApp());
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  print("Handling a background message: ${message.messageId}");
}

class VersifyApp extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([
      SystemUiOverlay.top,
      SystemUiOverlay.bottom,
    ]);
    // SystemChrome.setSystemUIOverlayStyle(
    //   SystemUiOverlayStyle(
    //     statusBarColor: Color(0xFFffdee9),
    //     statusBarIconBrightness: Brightness.dark,
    //     systemNavigationBarDividerColor: Colors.white,
    //     systemNavigationBarColor: Color(0xFFffdee9),
    //   ),
    // );

    SystemChrome.setPreferredOrientations(
      [
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ],
    );
    precacheImage(AssetImage("assets/images/logo_circle.png"), context);
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
        future: _initialization,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            print('Firebase Init ERROR');
          }
          if (snapshot.connectionState == ConnectionState.done) {
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

            // final ProfileBlogsProvider _profileBlogsProvider =
            //     ProfileBlogsProvider(viewsProvider: _profileAllPostsView);

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

            final ThemeProvider _themeProvider = ThemeProvider();

            final Wrapper wrapperScreen = Wrapper();

            JsonAllBadgesStorage _jsonAllBadgesStorage;

            EditProfileProvider _editProfileProvider;
            AccountSettingsProvider _accountSettingsProvider;

            ProfileDataProvider _profileDataProvider;

            DatabaseService _firestoreDBService;
            ProfileDBService _profileDBService;

            // Future<List<Feed>> Function() _getFeedDataMain; //define a function

            void refreshFeeds() {
              // setState(() => _getFeedDataMain = DatabaseService().getFeedData);
            }
            AuthService _authService = AuthService();
            DynamicLinkService _dynamicLinkService =
                DynamicLinkService(authService: _authService);

            return StreamProvider<MyUser>.value(
              initialData: null,
              value: _authService.user,
              child: Consumer<MyUser>(builder: (context, user, _) {
                print('Stream was triggered in MAIN.dart with user hashcode');
                //parse anything to database service
                //Rebuilds everytime user auth changes

                // if user is different than before. Reset all feed and data required
                if (user != null) {
                  _firestoreDBService = DatabaseService(
                    jsonFollowingStorage: _jsonFollowingStorage,
                    feedListProvider: _feedListProvider,
                    uid: user.userUID,
                  );

                  _profileDBService = ProfileDBService(
                      // profileBlogsProvider: _profileBlogsProvider,
                      uid: user.userUID);

                  _editProfileProvider =
                      EditProfileProvider(profileDB: _profileDBService);

                  _accountSettingsProvider = AccountSettingsProvider();

                  _profileDataProvider =
                      ProfileDataProvider(authUserUID: user.userUID);

                  _jsonAllBadgesStorage =
                      JsonAllBadgesStorage(uid: _authService.userUID);
                } else {
                  //not authenticated
                  // initialize services for dynamicLink and tutorial
                  _firestoreDBService = DatabaseService();
                  _profileDBService = ProfileDBService();
                }
                return MultiProvider(
                  providers: [
                    Provider<AuthService>.value(value: _authService),
                    Provider<DatabaseService>.value(value: _firestoreDBService),
                    Provider<ProfileDBService>.value(value: _profileDBService),
                    Provider<JsonFollowingStorage>.value(
                        value: _jsonFollowingStorage),
                    Provider<JsonAllBadgesStorage>.value(
                        value: _jsonAllBadgesStorage),

                    ChangeNotifierProvider<ThemeProvider>.value(
                        value: _themeProvider),
                    ChangeNotifierProvider<TutorialProvider>.value(
                        value: _tutorialProvider),
                    ChangeNotifierProvider<ProfileDataProvider>.value(
                        value: _profileDataProvider),
                    ChangeNotifierProvider<EditProfileProvider>.value(
                        value: _editProfileProvider),
                    ChangeNotifierProvider<AccountSettingsProvider>.value(
                        value: _accountSettingsProvider),
                    ChangeNotifierProvider<PostSwipeUpProvider>.value(
                        value: _postSwipeUpProvider),

                    ChangeNotifierProvider<FeedTypeProvider>.value(
                        value: _feedTypeProvider),
                    ChangeNotifierProvider<ContentBodyProvider>.value(
                        value: _contentBodyWidgets),
                    ChangeNotifierProvider<FeedListProvider>.value(
                        value: _feedListProvider),
                    // ChangeNotifierProvider<ProfileBlogsProvider>.value(
                    //     value: _profileBlogsProvider),
                    ChangeNotifierProvider<AllPostsView>.value(
                        value: _allPostsProvider),
                    // ChangeNotifierProvider<ProfileAllPostsView>.value(
                    //     value: _profileAllPostsView),
                    ChangeNotifierProvider<BottomNavProvider>.value(
                        value: _bottomNavProvider),
                    ChangeNotifierProvider<PageViewProvider>.value(
                        value: _pageViewProvider),
                    ChangeNotifierProvider<InputCommentsProvider>.value(
                        value: _inputCommentsProvider),
                    Provider<RefreshFunc>.value(value: refreshFeeds),
                    // FutureProvider<List<Feed>>.value(value: _getFeedDataMain()),
                  ],
                  child: OverlaySupport.global(
                    child: Consumer<ThemeProvider>(
                      builder: (context, state, _) {
                        return MaterialApp(
                          debugShowCheckedModeBanner: false,
                          title: 'Versify',
                          themeMode: state.currentTheme(),
                          darkTheme: ThemeData(
                            primaryColor: Color(0xFFcc99ff),
                            accentColor: Color(0xFF33cccc),
                            splashColor: Color(0xFFefdaff),
                            textTheme: TextTheme(
                                bodyText1: TextStyle(color: Colors.white),
                                bodyText2: TextStyle(color: Colors.white)),
                            fontFamily:
                                GoogleFonts.getFont('Nunito Sans').fontFamily,
                            canvasColor: Color(0xFF0d090d),
                            backgroundColor: Color(0xFF0d0a0c),
                            dialogBackgroundColor: Colors.grey[900],
                          ),
                          theme: ThemeData(
                            // colorScheme: ColorScheme.fromSwatch(),
                            primaryColor: Color(0xFFcc99ff),
                            accentColor: Color(0xFF33cccc),
                            splashColor: Color(0xFFefdaff),
                            fontFamily:
                                GoogleFonts.getFont('Nunito Sans').fontFamily,
                            canvasColor: Colors.white,
                            backgroundColor: Colors.white,
                            dialogBackgroundColor: Colors.white,
                          ),
                          builder: (context, child) {
                            return MediaQuery(
                              child: child,
                              data: MediaQuery.of(context)
                                  .copyWith(textScaleFactor: 1.0),
                            );
                          },
                          home: VersifyHome(
                              authService: _authService,
                              dynamicLinkService: _dynamicLinkService),
                          routes: {
                            '/accountSettings': (context) => AccountSettings(),
                            '/wrapper': (context) => wrapperScreen,
                          },
                        );
                        // return MaterialApp(
                        //   debugShowCheckedModeBanner: false,
                        //   title: 'Versify',
                        //   themeMode: state.currentTheme(),
                        //   darkTheme: ThemeData(
                        //     primaryColor: Color(0xFFff699F),
                        //     accentColor: Color(0xFF61c0bf),
                        //     splashColor: Color(0xFFffdee9),
                        //     textTheme: TextTheme(
                        //         bodyText1: TextStyle(color: Colors.white),
                        //         bodyText2: TextStyle(color: Colors.white)),
                        //     fontFamily:
                        //         GoogleFonts.getFont('Nunito Sans').fontFamily,
                        //     canvasColor: Color(0xFF0d090d),
                        //     backgroundColor: Color(0xFF0d0a0c),
                        //     dialogBackgroundColor: Colors.grey[900],
                        //   ),
                        //   theme: ThemeData(
                        //     // colorScheme: ColorScheme.fromSwatch(),
                        //     primaryColor: Color(0xFFff699F),
                        //     accentColor: Color(0xFF61c0bf),
                        //     splashColor: Color(0xFFffdee9),
                        //     fontFamily:
                        //         GoogleFonts.getFont('Nunito Sans').fontFamily,
                        //     canvasColor: Colors.white,
                        //     backgroundColor: Colors.white,
                        //     dialogBackgroundColor: Colors.white,
                        //   ),
                        //   builder: (context, child) {
                        //     return MediaQuery(
                        //       child: child,
                        //       data: MediaQuery.of(context)
                        //           .copyWith(textScaleFactor: 1.0),
                        //     );
                        //   },
                        //   home: VersifyHome(
                        //       authService: _authService,
                        //       dynamicLinkService: _dynamicLinkService),
                        //   routes: {
                        //     '/accountSettings': (context) => AccountSettings(),
                        //     '/wrapper': (context) => wrapperScreen,
                        //   },
                        // );
                      },
                    ),
                  ),
                );
              }),
            );
          }
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: SplashLoading(),
          );
        });
  }
}

class VersifyHome extends StatefulWidget {
  final AuthService authService;
  final DynamicLinkService dynamicLinkService;
  VersifyHome({this.authService, this.dynamicLinkService});

  @override
  _VersifyHomeState createState() => _VersifyHomeState();
}

class _VersifyHomeState extends State<VersifyHome> {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  //providers
  TutorialProvider _tutorialProvider;

  bool _completedBoarding;
  bool _completedTutorial;

  Future<void> _saveDeviceToken() async {}

  @override
  void initState() {
    super.initState();
    print('Main App initState RAN!');
    if (Platform.isAndroid) {
      _fcm.getToken().then((token) {
        print('getToken | token is: $token');
      });
    }

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('FirebaseMessaging | onMessage GOT');
      print('Message Data: ${message.data}');

      if (message.notification != null) {
        print('message also has a notification!');
        print('Notification Title: ${message.notification.title}');

        final SnackBar snackBar = SnackBar(
          content: Padding(
              padding: EdgeInsets.all(8),
              child: Text(message.notification.title)),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    });

    //dynamic link
    widget.dynamicLinkService.handleDynamicLink(context);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      sharedPreferencesInit().then((result) {
        if (result) {
          //tutorial done
          _tutorialProvider.updateTutorialComplete(true);
        } else {
          // tutorial not done
          _tutorialProvider.updateTutorialComplete(false);
        }
        setState(() => _completedBoarding = result);
      });
    });

    // widget.authService.logout();
  }

  void completeBoarding() {
    setState(() => _completedBoarding = true);
  }

  void completePickTutorials() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    print("MAIN rebuilt!");
    //tutorialProvider
    _tutorialProvider = Provider.of<TutorialProvider>(context, listen: false);
    final ThemeProvider _themeProvider =
        Provider.of<ThemeProvider>(context, listen: false);

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

    if (_completedBoarding != null) {
      if (_completedBoarding == true) {
        return Wrapper(completePickTutorials: completePickTutorials);
      } else {
        return OnBoarding(completeBoarding: completeBoarding);
        //return boarding
      }
    } else {
      return SplashLoading();
    }
  }

  Future<bool> sharedPreferencesInit() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await deletePrefs(prefs);
    bool result = prefs.getBool('completedBoarding') ?? false;

    return result;
  }

  Future<void> deletePrefs(SharedPreferences prefs) async {
    // prefs.remove('seenDocs');
    // prefs.remove('sortedFollowingList');
    prefs.remove('lastUpdated');
    prefs.remove('deviceLatestBadgeTs');
    //then get last updated from firestore
  }
}

typedef RefreshFunc = void Function();
