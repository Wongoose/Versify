import 'package:flutter/services.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:overlay_tutorial/overlay_tutorial.dart';
import 'package:versify/providers/feeds/all_posts_provider.dart';
import 'package:versify/providers/home/bottom_nav_provider.dart';
import 'package:versify/providers/home/edit_profile_provider.dart';
import 'package:versify/providers/feeds/feed_type_provider.dart';
import 'package:versify/providers/home/tutorial_provider.dart';
import 'package:versify/screens/feed_screen/feed_list_wrapper.dart';
import 'package:versify/screens/feed_screen/following_page_view.dart';
import 'package:versify/screens/feed_screen/for_you_page_view.dart';
import 'package:versify/screens/profile_screen/edit_profile_folder/edit_profile.dart';
import 'package:versify/screens/profile_screen/main_profile.dart';
import 'package:versify/screens/profile_screen/profile_blogs_provider.dart';
import 'package:versify/screens/profile_screen/profile_pageview_provider.dart';
import 'package:versify/screens/profile_screen/settings/account_settings.dart';
import 'package:versify/screens/profile_screen/visit_profile_provider.dart';
import 'package:versify/screens/word_screen/word_screen.dart';
import 'package:versify/services/auth.dart';
import 'package:versify/services/database.dart';
import 'package:versify/services/profile_database.dart';
import 'package:versify/shared/bottom_navigation.dart';
import 'package:versify/shared/loading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:versify/shared/splash_loading.dart';
import 'package:versify/tutorial/feed_list_tutorial.dart';
import 'package:versify/services/notification.dart';

class HomeWrapper extends StatefulWidget {
  // RefreshFunc _refresh;
  @override
  _HomeWrapperState createState() => _HomeWrapperState();
}

class _HomeWrapperState extends State<HomeWrapper> {
  final bottomNavController = PageController(initialPage: 1);
  final ScrollController _forYouController =
      ScrollController(initialScrollOffset: 0.0, keepScrollOffset: true);
  final ScrollController _followingController =
      ScrollController(initialScrollOffset: 0.0, keepScrollOffset: true);

  DatabaseService _databaseService;
  Future _future;
  ForYouPageView forYouPageView;
  FollowingPageView followingPageView;

  FeedTypeProvider _feedTypeProvider;
  // ProfileDBService _profileDBService;

  AuthService userProfile;

  @override
  void initState() {
    super.initState();
    // Widget _image =  Image.network('');

    forYouPageView = ForYouPageView();
    followingPageView = FollowingPageView();

    _future =
        _databaseService != null ? _databaseService.firestoreInit() : null;

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _feedTypeProvider.initAddPageViews(forYouPageView, followingPageView);
      // userProfile = _profileDBService.getProfileData(uid: _databaseService.uid);
    });
    // myScroll();
  }

  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        systemNavigationBarDividerColor: Colors.white,
        systemNavigationBarColor: Colors.white,
      ),
    );

    _feedTypeProvider = Provider.of<FeedTypeProvider>(context, listen: false);
    _databaseService = Provider.of<DatabaseService>(context, listen: false);
    _future =
        _databaseService != null ? _databaseService.firestoreInit() : null;

    final PageController _profilePageViewController = PageController();

    final ProfileAllPostsView _profileAllPostsView =
        ProfileAllPostsView(pageController: _profilePageViewController);

    final ProfileBlogsProvider _profileBlogsProvider =
        ProfileBlogsProvider(viewsProvider: _profileAllPostsView);

    final AuthService _authService =
        Provider.of<AuthService>(context, listen: false);

    // final TutorialProvider _tutorialProvider =
    //     Provider.of<TutorialProvider>(context, listen: false);

    print('HomeWidget Built!!! WOIII');

    return FutureBuilder(
      future: _future,
      builder: (context, snapshot) {
        print(snapshot.data);
        if (snapshot.data != null) {
          print('Future builder DONE');
          return MultiProvider(
            providers: [
              Provider<ForYouPageView>.value(value: forYouPageView),
              Provider<FollowingPageView>.value(value: followingPageView),
            ],
            child: Consumer<TutorialProvider>(
              builder: (context, state, child) => OverlayTutorialScope(
                enabled: false,
                overlayColor: Colors.black.withOpacity(0.8),
                child: Scaffold(
                  resizeToAvoidBottomInset: false,
                  backgroundColor: Colors.white,
                  appBar: PreferredSize(
                    preferredSize: Size.fromHeight(kToolbarHeight),
                    child: Container(
                      decoration: BoxDecoration(
                          // boxShadow: [
                          //   BoxShadow(
                          //     color: Colors.black26,
                          //     offset: Offset(0, 0),
                          //     blurRadius: 5,
                          //   )
                          // ],
                          ),
                      child: Stack(
                        alignment: Alignment.bottomLeft,
                        children: [
                          Consumer<PageViewProvider>(
                            builder: (context, pageViewProvider, _) {
                              return GestureDetector(
                                onTap: () async {
                                  if (_feedTypeProvider.currentFeedType ==
                                      FeedType.following) {
                                    await _followingController.animateTo(0.0,
                                        curve: Curves.fastLinearToSlowEaseIn,
                                        duration: Duration(milliseconds: 1200));
                                  } else {
                                    await _forYouController.animateTo(0.0,
                                        curve: Curves.fastLinearToSlowEaseIn,
                                        duration: Duration(milliseconds: 1200));
                                  }
                                },
                                child: pageViewProvider.pageIndex == 1
                                    ? FeedListAppBar()
                                    : HomeAppBar(
                                        pageViewProvider: pageViewProvider),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  body: Stack(
                    alignment: Alignment.bottomCenter,
                    fit: StackFit.loose,
                    children: [
                      Container(
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(15),
                            bottomLeft: Radius.circular(15),
                          ),
                        ),
                        child: Consumer<PageViewProvider>(
                          builder: (context, pageViewProvider, _) {
                            return PageView(
                              controller: bottomNavController,
                              onPageChanged: (index) =>
                                  pageViewProvider.pageChanged(index),
                              allowImplicitScrolling: true,
                              scrollDirection: Axis.horizontal,
                              pageSnapping: true,
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(0),
                                  // padding: EdgeInsets.fromLTRB(5, 8, 8, 5),
                                  child: WordScreen(),
                                ),
                                FeedListWrapper(
                                  followingController: _followingController,
                                  forYouController: _forYouController,
                                ),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                  child: ChangeNotifierProvider<
                                      VisitProfileProvider>(
                                    create: (_) => VisitProfileProvider(),
                                    child: MainProfilePage(
                                      bottomNavController: bottomNavController,
                                      visitProfile: false,
                                      userID: _authService.myUser.userUID,
                                      profileBlogsProvider:
                                          _profileBlogsProvider,
                                      profileAllPostsView: _profileAllPostsView,
                                      bottomNavVisible: true,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                      CustomBottomNavigationBar(
                        controller: bottomNavController,
                        // pageViewProvider: _pageViewProvider,
                        // scrollController: _followingController,
                        // pageIndex: pageViewProvider.pageIndex,
                      ),
                    ],
                  ),
                  // floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
                ),
              ),
            ),
          );
        }
        return SplashLoading();
      },
    );
  }
}

class HomeAppBar extends StatelessWidget {
  final PageViewProvider pageViewProvider;
  const HomeAppBar({
    this.pageViewProvider,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AuthService _authService =
        Provider.of<AuthService>(context, listen: false);

    print('HomeApp Bar BUILT with _authService uid: ' +
        _authService.myUser.userUID);

    return AppBar(
      elevation: 1,
      centerTitle: pageViewProvider.pageIndex == 2 ? false : true,
      backgroundColor: Colors.white,
      title: GestureDetector(
        onTap: () => {},
        child: Consumer<EditProfileProvider>(
          builder: (context, value, child) => Text(
            pageViewProvider.pageIndex == 0
                ? 'Verse'
                : pageViewProvider.pageIndex == 1
                    ? 'Blogs'
                    : _authService.myUser.username ?? "Dummy_Username",
            style: TextStyle(
              fontFamily: 'Nunito',
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: Color(0xff050000),
            ),
          ),
        ),
      ),
      actions: [
        pageViewProvider.pageIndex == 2
            ? TextButton.icon(
                style: TextButton.styleFrom(
                  padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
                ),
                onPressed: () {
                  showModalBottomSheet(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                      context: context,
                      builder: (context) {
                        return HomeProfileBottomSheet();
                      });
                },
                icon: Icon(
                  FontAwesomeIcons.ellipsisV,
                  color: Colors.black,
                  size: 18,
                ),
                label: Text(''))
            : Container(),
      ],
    );
  }
}

// ignore: must_be_immutable
class FeedListAppBar extends StatelessWidget {
  FeedType _feedType = FeedType.forYou;

  @override
  Widget build(BuildContext context) {
    final AllPostsView _allPostsView =
        Provider.of<AllPostsView>(context, listen: false);

    final FeedTypeProvider _feedTypeProvider =
        Provider.of<FeedTypeProvider>(context, listen: false);
    final ForYouPageView forYouPageView =
        Provider.of<ForYouPageView>(context, listen: false);
    final FollowingPageView followingPageView =
        Provider.of<FollowingPageView>(context, listen: false);

    return Consumer<FeedTypeProvider>(
      builder: (context, state, __) {
        _feedType = state.currentFeedType;
        return AppBar(
          centerTitle: true,
          elevation: 0.5,
          backgroundColor: Colors.white,
          title: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    if (_allPostsView.followingCurrentIndex == -1) {
                      _allPostsView.followingCurrentIndex = 0;
                    }
                    state.typeClicked(selection: FeedType.following);
                  },
                  child: Text(
                    'Following',
                    style: TextStyle(
                        letterSpacing:
                            _feedType == FeedType.following ? -0.3 : 1,
                        fontSize: _feedType == FeedType.following ? 17.5 : 14,
                        color: Colors.black,
                        fontWeight: _feedType == FeedType.following
                            ? FontWeight.w600
                            : FontWeight.w400,
                        fontFamily: 'Nunito'),
                  ),
                ),
                Text(
                  ' | ',
                  style: TextStyle(
                      letterSpacing: 1.0,
                      fontSize: 10,
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Nunito'),
                ),
                GestureDetector(
                  onTap: () {
                    if (_allPostsView.forYouCurrentIndex == -1) {
                      _allPostsView.forYouCurrentIndex = 0;
                    }
                    state.typeClicked(selection: FeedType.forYou);
                  },
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                        0, _feedType == FeedType.forYou ? 0 : 1.5, 0, 0),
                    child: Text(
                      'For You',
                      style: TextStyle(
                          letterSpacing:
                              _feedType == FeedType.forYou ? -0.3 : 1,
                          fontSize: _feedType == FeedType.forYou ? 17.5 : 14,
                          color: Colors.black,
                          fontWeight: _feedType == FeedType.forYou
                              ? FontWeight.w600
                              : FontWeight.w400,
                          fontFamily: 'Nunito'),
                    ),
                  ),
                ),
              ]),
          leading: TextButton.icon(
              style: TextButton.styleFrom(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                backgroundColor: Colors.transparent,
              ),
              clipBehavior: Clip.none,
              icon: Icon(Icons.view_day_outlined, color: Colors.black),
              label: Text(''),
              onPressed: () {
                // allforYouPageView.onClick(index);
                Navigator.push(
                  context,
                  CupertinoPageRoute(builder: (_) {
                    if (_feedTypeProvider.currentFeedType == FeedType.forYou) {
                      if (_allPostsView.forYouCurrentIndex == -1) {
                        _allPostsView.forYouCurrentIndex = 0;
                      }
                      return forYouPageView;
                    } else {
                      if (_allPostsView.followingCurrentIndex == -1) {
                        _allPostsView.followingCurrentIndex = 0;
                      }
                      return followingPageView;
                    }
                  }),
                );
              }),
          actions: [
            TextButton.icon(
              style: TextButton.styleFrom(
                padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                backgroundColor: Colors.white,
              ),
              onPressed: () {
                NotificationOverlay().simpleNotification(
                    duration: Duration(seconds: 4),
                    delay: Duration(seconds: 0));
                // showOverlayNotification(
                //   (context) {
                //     return Material(
                //       color: Colors.transparent,
                //       child: Container(
                //         margin: EdgeInsets.fromLTRB(20, 40, 20, 20),
                //         alignment: Alignment.center,
                //         height: 80,
                //         width: 400,
                //         decoration: BoxDecoration(
                //           color: Colors.black,
                //           borderRadius: BorderRadius.circular(20),
                //         ),
                //         child: Text(
                //           'Hello world',
                //           style: TextStyle(color: Colors.white),
                //         ),
                //       ),
                //     );
                //   },
                //   position: NotificationPosition.top,
                //   duration: Duration(seconds: 4),
                // );
              },
              clipBehavior: Clip.none,
              icon: Icon(
                Icons.notifications_none_rounded,
                color: Colors.black,
                size: 26,
              ),
              label: Text(''),
            ),
          ],
          automaticallyImplyLeading: false,
        );
      },
    );
  }
}

class HomeProfileBottomSheet extends StatelessWidget {
  const HomeProfileBottomSheet({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    EditProfileProvider _editProfileProvider =
        Provider.of<EditProfileProvider>(context, listen: false);
    AuthService _authService = Provider.of<AuthService>(context);

    return Container(
      margin: EdgeInsets.fromLTRB(4, 4, 4, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: EdgeInsets.all(0),
            height: 60,
            child: TextButton(
              style: TextButton.styleFrom(
                  padding: EdgeInsets.all(15), primary: Colors.white),
              onPressed: () {},
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Share profile',
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 16,
                    fontFamily: 'Nunito',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
          Divider(thickness: 0.5, height: 0),
          Container(
            margin: EdgeInsets.all(0),
            height: 60,
            child: TextButton(
              style: TextButton.styleFrom(
                  padding: EdgeInsets.all(15), primary: Colors.white),
              onPressed: () {
                _editProfileProvider.initProfileUser(_authService.myUser);
                Navigator.pop(context);
                Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => EditProfile(),
                    ));
              },
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Edit profile',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontFamily: 'Nunito',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
          Divider(thickness: 0.5, height: 0),
          Container(
            margin: EdgeInsets.all(0),
            height: 60,
            child: TextButton(
              style: TextButton.styleFrom(
                  padding: EdgeInsets.all(15), primary: Colors.white),
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => AccountSettings(),
                    ));
              },
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Settings',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontFamily: 'Nunito',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
