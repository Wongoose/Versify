import 'package:google_fonts/google_fonts.dart';
import 'package:versify/providers/bottom_nav_provider.dart';
import 'package:versify/providers/content_body_provider.dart';
import 'package:versify/providers/edit_profile_provider.dart';
import 'package:versify/providers/feed_list_provider.dart';
import 'package:versify/providers/all_posts_provider.dart';
import 'package:versify/providers/feed_type_provider.dart';
import 'package:versify/providers/input_comments_provider.dart';
import 'package:versify/providers/post_swipe_up_provider.dart';
import 'package:versify/screens/profile_screen/profile_data_provider.dart';
import 'package:versify/screens/profile_screen/settings/account_provider.dart';
import 'package:versify/screens/profile_screen/settings/account_settings.dart';
import 'package:versify/services/all_badges_json_storage.dart';
import 'package:versify/services/auth.dart';
import 'package:versify/services/database.dart';
import 'package:versify/services/dynamic_links.dart';
import 'package:versify/services/profile_database.dart';
import 'package:versify/services/users_following_json_storage.dart';
import 'package:versify/shared/loading.dart';
import 'package:versify/wrapper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:versify/z-wrappers/post_dynamic_link.dart';
import 'package:versify/z-wrappers/wrapper_dynamic_links.dart';
import 'models/user_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(VersifyApp());
}

class VersifyApp extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays(
        [SystemUiOverlay.top, SystemUiOverlay.bottom]);
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.black.withOpacity(0.8),
        systemNavigationBarDividerColor: Colors.black,
        systemNavigationBarColor: Colors.black,
      ),
    );

    SystemChrome.setPreferredOrientations(
      [
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ],
    );
    precacheImage(AssetImage("assets/images/logo_circle.png"), context);

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

            return StreamProvider<MyUser>.value(
              value: _authService.user,
              child: Consumer<MyUser>(builder: (_, user, __) {
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
                  child: MaterialApp(
                    debugShowCheckedModeBanner: false,
                    title: 'Versify',
                    theme: ThemeData(
                      // colorScheme: ColorScheme.fromSwatch(),
                      canvasColor: Colors.white,
                      primaryColor: Color(0xFFFF696A),

                      accentColor: Color(0xFFffae3d9),
                      fontFamily: GoogleFonts.getFont('Nunito Sans').fontFamily,
                      backgroundColor: Colors.white,
                    ),
                    builder: (context, child) {
                      return MediaQuery(
                        child: child,
                        data: MediaQuery.of(context)
                            .copyWith(textScaleFactor: 1.0),
                      );
                    },
                    home: VersifyHome(authService: _authService),
                    routes: {
                      '/accountSettings': (context) => AccountSettings(),
                    },
                  ),
                );
              }),
            );
          }
          return MaterialApp(
              debugShowCheckedModeBanner: false,
              home: Scaffold(
                backgroundColor: Colors.white,
                appBar: null,
                body: Loading(),
              ));
        });
  }
}

class VersifyHome extends StatefulWidget {
  final AuthService authService;
  VersifyHome({this.authService});

  @override
  _VersifyHomeState createState() => _VersifyHomeState();
}

class _VersifyHomeState extends State<VersifyHome> {
  final DynamicLinkService _dynamicLinkService = DynamicLinkService();
  bool _completedBoarding = false;
  bool _hasDynamicLink;

  void navigateDynamicLink(String postId) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => DynamicLinksWrapper(
                  postId: postId,
                )));
  }

  void initState() {
    super.initState();
    print('Main App initState RAN!');
    _dynamicLinkService.addContext(context);

    _dynamicLinkService.handleDynamicLink().then((value) {
      setState(() => _hasDynamicLink = value);
    });

    sharedPreferencesInit().then((result) {
      _completedBoarding = result;
    });
    // widget.authService.logout();
  }

  @override
  Widget build(BuildContext context) {
    if (_hasDynamicLink != null) {
      if (_completedBoarding) {
        return Wrapper();
        // return DynamicLinkPost(
        //   postId: 'aQtV58oqPh2ZfuGL4CrZ',
        // );
      } else {
        return Wrapper();
        //return boarding
      }
    } else {
      return Loading();
    }
  }
  // return ReviewPost();

  Future<bool> sharedPreferencesInit() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await deletePrefs(prefs);
    bool _completedBoarding = prefs.getBool('completedBoarding') ?? true;

    return _completedBoarding;
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
