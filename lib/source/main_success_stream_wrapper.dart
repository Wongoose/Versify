import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:versify/main.dart';
import 'package:versify/providers/providers_home/dynamic_link_provider.dart';
import 'package:versify/providers/providers_home/profile_data_provider.dart';
import 'package:versify/providers/providers_home/theme_data_provider.dart';
import 'package:versify/providers/providers_home/tutorial_provider.dart';
import 'package:versify/services/firebase/auth.dart';
import 'package:versify/services/firebase/database.dart';
import 'package:versify/services/firebase/profile_database.dart';
import 'package:versify/services/json_storage/all_badges_json_storage.dart';
import 'package:versify/services/json_storage/shared_preferences.dart';
import 'package:versify/services/json_storage/users_following_json_storage.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:versify/providers/providers_home/bottom_nav_provider.dart';
import 'package:versify/providers/providers_create_post/content_body_provider.dart';
import 'package:versify/providers/providers_home/edit_profile_provider.dart';
import 'package:versify/providers/providers_feeds/feed_list_provider.dart';
import 'package:versify/providers/providers_feeds/all_posts_provider.dart';
import 'package:versify/providers/providers_feeds/feed_type_provider.dart';
import 'package:versify/providers/providers_feeds/input_comments_provider.dart';
import 'package:versify/providers/providers_feeds/post_swipe_up_provider.dart';
import 'package:versify/screens/profile/settings/account_provider.dart';
import 'package:versify/services/firebase/dynamic_links.dart';
import 'package:provider/provider.dart';

class MainSuccessStreamWrapper extends StatelessWidget {
  const MainSuccessStreamWrapper({
    Key key,
    @required AuthService authService,
    @required DatabaseService firestoreDBService,
    @required ProfileDBService profileDBService,
    @required JsonFollowingStorage jsonFollowingStorage,
    @required JsonAllBadgesStorage jsonAllBadgesStorage,
    @required MySharedPreferences mySharedPreferences,
    @required ThemeProvider themeProvider,
    @required DynamicLinkProvider dynamicLinkProvider,
    @required TutorialProvider tutorialProvider,
    @required ProfileDataProvider profileDataProvider,
    @required EditProfileProvider editProfileProvider,
    @required AccountSettingsProvider accountSettingsProvider,
    @required PostSwipeUpProvider postSwipeUpProvider,
    @required FeedTypeProvider feedTypeProvider,
    @required ContentBodyProvider contentBodyWidgets,
    @required FeedListProvider feedListProvider,
    @required AllPostsView allPostsProvider,
    @required BottomNavProvider bottomNavProvider,
    @required PageViewProvider pageViewProvider,
    @required InputCommentsProvider inputCommentsProvider,
    @required DynamicLinkService dynamicLinkService,
  })  : _authService = authService,
        _firestoreDBService = firestoreDBService,
        _profileDBService = profileDBService,
        _jsonFollowingStorage = jsonFollowingStorage,
        _jsonAllBadgesStorage = jsonAllBadgesStorage,
        _mySharedPreferences = mySharedPreferences,
        _themeProvider = themeProvider,
        _dynamicLinkProvider = dynamicLinkProvider,
        _tutorialProvider = tutorialProvider,
        _profileDataProvider = profileDataProvider,
        _editProfileProvider = editProfileProvider,
        _accountSettingsProvider = accountSettingsProvider,
        _postSwipeUpProvider = postSwipeUpProvider,
        _feedTypeProvider = feedTypeProvider,
        _contentBodyWidgets = contentBodyWidgets,
        _feedListProvider = feedListProvider,
        _allPostsProvider = allPostsProvider,
        _bottomNavProvider = bottomNavProvider,
        _pageViewProvider = pageViewProvider,
        _inputCommentsProvider = inputCommentsProvider,
        _dynamicLinkService = dynamicLinkService,
        super(key: key);

  final AuthService _authService;
  final DatabaseService _firestoreDBService;
  final ProfileDBService _profileDBService;
  final JsonFollowingStorage _jsonFollowingStorage;
  final JsonAllBadgesStorage _jsonAllBadgesStorage;
  final MySharedPreferences _mySharedPreferences;
  final ThemeProvider _themeProvider;
  final DynamicLinkProvider _dynamicLinkProvider;
  final TutorialProvider _tutorialProvider;
  final ProfileDataProvider _profileDataProvider;
  final EditProfileProvider _editProfileProvider;
  final AccountSettingsProvider _accountSettingsProvider;
  final PostSwipeUpProvider _postSwipeUpProvider;
  final FeedTypeProvider _feedTypeProvider;
  final ContentBodyProvider _contentBodyWidgets;
  final FeedListProvider _feedListProvider;
  final AllPostsView _allPostsProvider;
  final BottomNavProvider _bottomNavProvider;
  final PageViewProvider _pageViewProvider;
  final InputCommentsProvider _inputCommentsProvider;
  final DynamicLinkService _dynamicLinkService;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthService>.value(value: _authService),
        Provider<DatabaseService>.value(value: _firestoreDBService),
        Provider<ProfileDBService>.value(value: _profileDBService),
        Provider<JsonFollowingStorage>.value(value: _jsonFollowingStorage),
        Provider<JsonAllBadgesStorage>.value(value: _jsonAllBadgesStorage),
        Provider<MySharedPreferences>.value(value: _mySharedPreferences),

        ChangeNotifierProvider<ThemeProvider>.value(value: _themeProvider),
        ChangeNotifierProvider<DynamicLinkProvider>.value(
            value: _dynamicLinkProvider),
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
        ChangeNotifierProvider<AllPostsView>.value(value: _allPostsProvider),
        ChangeNotifierProvider<BottomNavProvider>.value(
            value: _bottomNavProvider),
        ChangeNotifierProvider<PageViewProvider>.value(
            value: _pageViewProvider),
        ChangeNotifierProvider<InputCommentsProvider>.value(
            value: _inputCommentsProvider),
        // ChangeNotifierProvider<ProfileBlogsProvider>.value(
        //     value: _profileBlogsProvider),
        // ChangeNotifierProvider<ProfileAllPostsView>.value(
        //     value: _profileAllPostsView),
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
                fontFamily: GoogleFonts.getFont('Nunito Sans').fontFamily,
                canvasColor: Color(0xFF202020),
                // canvasColor: Color(0xFF0d090d),
                backgroundColor: Color(0xFF272727),
                // backgroundColor: Color(0xFF0d0a0c),
                dialogBackgroundColor: Colors.grey[900],
              ),
              theme: ThemeData(
                // colorScheme: ColorScheme.fromSwatch(),
                primaryColor: Color(0xFFcc99ff),
                accentColor: Color(0xFF33cccc),
                splashColor: Color(0xFFefdaff),
                fontFamily: GoogleFonts.getFont('Nunito Sans').fontFamily,
                canvasColor: Colors.white,
                backgroundColor: Colors.white,
                dialogBackgroundColor: Colors.white,
              ),
              builder: (context, child) {
                return MediaQuery(
                  data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                  child: child,
                );
              },
              home: VersifyHome(
                authService: _authService,
                dynamicLinkService: _dynamicLinkService,
                mySharedPreferences: _mySharedPreferences,
              ),
            );
          },
        ),
      ),
    );
  }
}
