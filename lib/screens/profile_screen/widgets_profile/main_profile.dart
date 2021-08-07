import 'package:cached_network_image/cached_network_image.dart';
import 'package:versify/models/feed_model.dart';
import 'package:versify/models/user_model.dart';
import 'package:versify/providers/home/edit_profile_provider.dart';
import 'package:versify/providers/home/theme_data_provider.dart';
import 'package:versify/screens/profile_screen/badges_folder/badges_tab_display.dart';
import 'package:versify/screens/profile_screen/widgets_profile/blog_list2.dart';
import 'package:versify/screens/profile_screen/widgets/follow_action_bar.dart';
import 'package:versify/screens/profile_screen/widgets/sliver_tab_bar.dart';
import 'package:versify/providers/home/profile_blogs_provider.dart';
import 'package:versify/providers/home/profile_pageview_provider.dart';
import 'package:versify/providers/home/visit_profile_provider.dart';
import 'package:versify/services/auth.dart';
import 'package:versify/services/profile_database.dart';
import 'package:versify/shared/constants.dart';
import 'package:versify/shared/loading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class MainProfilePage extends StatefulWidget {
  final PageController bottomNavController;
  final bool visitProfile;
  final MyUser userProfile;
  final String userID;
  final ProfileBlogsProvider profileBlogsProvider;
  final ProfileAllPostsView profileAllPostsView;
  final bool bottomNavVisible;

  MainProfilePage(
      {this.bottomNavController,
      this.visitProfile,
      this.userProfile,
      this.userID,
      this.profileBlogsProvider,
      this.profileAllPostsView,
      this.bottomNavVisible});

  @override
  _MainProfilePageState createState() => _MainProfilePageState();
}

class _MainProfilePageState extends State<MainProfilePage> {
  final ScrollController _nestedMasterController = ScrollController();
  final RefreshController _refreshController = RefreshController();
  Map<String, double> _mapControllerPosition = {'blogs': 0, 'badges': 0};
  bool _tabBarSliverPinned = false;
  double _sliverPinnedPosition;

  ProfileDBService _profileDBService;
  AuthService _authService;
  VisitProfileProvider _visitProfileProvider;
  EditProfileProvider _editProfileProvider;
  // ProfileBlogsProvider _profileBlogsProvider;

  Future<MyUser> _future;
  Future _futureBlogs;
  MyUser _userProfile;

  Future<bool> _popFunc() async {
    widget.bottomNavController.animateToPage(1,
        duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
    return false;
  }

  void initState() {
    super.initState();
    print('Profile Main Init state RAN: ' + widget.visitProfile.toString());
    if (widget.visitProfile) {
      print('userProfile from visit ViewPostTitle');
      _userProfile = this.widget.userProfile;

      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        if (widget.profileBlogsProvider.initialOpen) {
          _futureBlogs = _loadFirstData();
          widget.profileBlogsProvider.initialOpen = false;
        } else {
          _futureBlogs = dummyFunc();
          // _future = _loadData();

        }
      });
    } else {
      //visit my own profile
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        _visitProfileProvider.setUserProfile(_userProfile);
        _editProfileProvider.initProfileUser(_userProfile);
        if (widget.profileBlogsProvider.initialOpen) {
          _futureBlogs = _loadFirstData();
          widget.profileBlogsProvider.initialOpen = false;
        } else {
          _futureBlogs = dummyFunc();
          // _future = _loadData();

        }
      });

      // WidgetsBinding.instance.addPostFrameCallback((_) {
      //   //function should shift to homewrapper
      //   _profileDBService
      //       .getProfileData(profileUID: widget.userID)
      //       .then((myProfile) {
      //     setState(() {
      //       // _visitProfileProvider.setUserProfile(myProfile);
      //       _userProfile = myProfile;
      //       _editProfileProvider.initProfileUser(myProfile);
      //     });
      //   });
      // });
      //
    }
  }

  //not used
  void updateTabBarPinned(bool value) {
    if (value == true) {
      _sliverPinnedPosition = _nestedMasterController.position.pixels;
    } else {
      _tabBarSliverPinned = value;
    }
    //resetValues
  }

  int tabIndex = 0;

  void changeTab(int index) {
    setState(() => tabIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final ThemeProvider _themeProvider =
        Provider.of<ThemeProvider>(context, listen: false);
    print('Profile Main is rebuilt');
    _authService = Provider.of<AuthService>(context);
    _profileDBService = Provider.of<ProfileDBService>(context);
    // _profileBlogsProvider =
    //     Provider.of<ProfileBlogsProvider>(context, listen: false);

    _visitProfileProvider =
        Provider.of<VisitProfileProvider>(context, listen: true);

    if (!widget.visitProfile) {
      _userProfile = _authService.myUser;
    }

    _editProfileProvider =
        Provider.of<EditProfileProvider>(context, listen: false);
    // if (widget.visitProfile) {
    //   _visitProfileProvider =
    //       Provider.of<VisitProfileProvider>(context, listen: false);
    // }

    // Future<MyUser> _future =
    //     _profileDBService.getProfileData(uid: widget.userID);
    // _userProfile = _visitProfileProvider.userProfile;

    return WillPopScope(
        onWillPop: () async {
          if (widget.bottomNavVisible == false) {
            return true;
          } else {
            return await _popFunc();
          }
        },
        child: MultiProvider(
          providers: [
            ChangeNotifierProvider<ProfileBlogsProvider>.value(
              value: widget.profileBlogsProvider,
            ),
            ChangeNotifierProvider<ProfileAllPostsView>.value(
                value: widget.profileAllPostsView),
          ],
          child: _userProfile != null
              ? Scaffold(
                  backgroundColor: Theme.of(context).backgroundColor,
                  body: Container(
                    margin: EdgeInsets.fromLTRB(
                        0, 0, 0, !widget.bottomNavVisible ? 0 : 55),
                    child: DefaultTabController(
                      initialIndex: 0,
                      length: 3,
                      child: SmartRefresher(
                        cacheExtent: 1000,
                        enablePullDown: true,
                        enablePullUp: true,
                        onRefresh: _onRefresh,
                        onLoading: _loadData,
                        controller: _refreshController,
                        header: WaterDropHeader(
                          complete: Icon(
                            Icons.done_rounded,
                            color: _themeProvider.secondaryTextColor,
                          ),
                          waterDropColor: Colors.pink[300],
                          // backgroundColor: Colors.white,
                          // distance: 50,
                        ),
                        footer: CustomFooter(
                          height: tabIndex == 0 ? 60 : 0,
                          builder: (BuildContext context, LoadStatus mode) {
                            Widget body;
                            if (widget.profileBlogsProvider.noData) {
                              body = Text('None left for today!');
                            } else if (mode == LoadStatus.idle) {
                              body = SizedBox.shrink();
                            } else if (mode == LoadStatus.loading) {
                              body = SpinKitThreeBounce(
                                color: Colors.pink[300],
                                size: 30,
                              );
                            } else if (mode == LoadStatus.failed) {
                              body = Text(
                                "Load Failed. Click retry!",
                                style: TextStyle(color: Colors.black),
                              );
                            } else if (mode == LoadStatus.canLoading) {
                              body = SpinKitThreeBounce(
                                  color: Colors.pink[200], size: 30);
                            } else {
                              body = Text(
                                "No more Data",
                                style: TextStyle(color: Colors.black),
                              );
                            }
                            return Container(
                              height: 55.0,
                              child: Center(child: body),
                            );
                          },
                        ),
                        child: CustomScrollView(
                          controller: _nestedMasterController,
                          slivers: [
                            SliverToBoxAdapter(
                              child: Container(
                                padding: EdgeInsets.all(0),
                                margin: EdgeInsets.all(0),
                                color: Colors.transparent,
                                // height: 400,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    SizedBox(height: 30),
                                    SizedBox(
                                      height: 100,
                                      width: 100,
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          CircleLoading(size: 2),
                                          Card(
                                            elevation: 0,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(300),
                                              side: BorderSide(
                                                  color: Colors.black12),
                                            ),
                                            color: Theme.of(context)
                                                .backgroundColor,
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(300),
                                              child: Image(
                                                fit: BoxFit.contain,
                                                width: 100,
                                                image:
                                                    CachedNetworkImageProvider(
                                                        _userProfile
                                                            .profileImageUrl,
                                                        cacheKey: _userProfile
                                                            .userUID,
                                                        scale: 0.5),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 15),
                                    Consumer<EditProfileProvider>(
                                      builder: (context, state, _) {
                                        //userprofile update here
                                        if (!widget.visitProfile) {
                                          _userProfile = _authService.myUser;
                                        }
                                        return Text(
                                          '@${_userProfile.username}',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                            fontFamily: 'Nunito',
                                            color:
                                                _themeProvider.primaryTextColor,
                                          ),
                                        );
                                      },
                                    ),
                                    SizedBox(height: 25),
                                    ChangeNotifierProvider<
                                        VisitProfileProvider>.value(
                                      value: _visitProfileProvider,
                                      child: ProfileActionBar(
                                          editProfileProvider:
                                              _editProfileProvider,
                                          userProfile: _userProfile,
                                          visitProfile: widget.visitProfile,
                                          profileDBService: _profileDBService),
                                    ),

                                    SizedBox(height: 25),
                                    SizedBox(
                                      width: 300,
                                      // height: 50,
                                      child: Consumer<EditProfileProvider>(
                                        builder: (context, state, _) => Text(
                                          _userProfile.description.isNotEmpty
                                              ? _userProfile.description
                                              : 'No description...',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 12.5,
                                              fontWeight: FontWeight.normal,
                                              color:
                                                  _userProfile
                                                          .description.isEmpty
                                                      ? _themeProvider
                                                          .secondaryTextColor
                                                      : _themeProvider
                                                          .primaryTextColor),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 25),
                                    Divider(thickness: 0.3),
                                    // SizedBox(height: 25),
                                  ],
                                ),
                              ),
                            ),
                            TabBarSliver(changeTab: changeTab),
                            Builder(builder: (context) {
                              if (tabIndex == 0) {
                                return Consumer<EditProfileProvider>(
                                  builder: (context, state, _) =>
                                      ProfileBlogList2(
                                    // nestedViewController: _nestedMasterController,
                                    visitProfile: widget.visitProfile,
                                    userProfile: _userProfile,
                                    isFromPageView: !widget.bottomNavVisible,
                                  ),
                                );
                              } else if (tabIndex == 1) {
                                return SliverToBoxAdapter(
                                  child: SingleChildScrollView(
                                      key: PageStorageKey<String>('Saved'),
                                      child: Table(
                                        defaultColumnWidth:
                                            FlexColumnWidth(1.0),
                                        children: [
                                          TableRow(children: [
                                            SavedCard(),
                                            SavedCard(),
                                            SavedCard(),
                                          ]),
                                          TableRow(children: [
                                            SavedCard(),
                                            SavedCard(),
                                            SavedCard(),
                                          ]),
                                          TableRow(children: [
                                            SavedCard(),
                                            SavedCard(),
                                            SavedCard(),
                                          ]),
                                          TableRow(children: [
                                            SavedCard(),
                                            SavedCard(),
                                            SavedCard(),
                                          ]),
                                          TableRow(children: [
                                            SavedCard(),
                                            SavedCard(),
                                            SavedCard(),
                                          ]),
                                          TableRow(children: [
                                            SavedCard(),
                                            SavedCard(),
                                            SavedCard(),
                                          ]),
                                          TableRow(children: [
                                            SavedCard(),
                                            SavedCard(),
                                            SavedCard(),
                                          ]),
                                        ],
                                      )),
                                );
                              } else {
                                return SliverToBoxAdapter(
                                    child: BadgesTabDisplay());
                              }
                            }),
                          ],
                        ),
                      ),
                    ),
                  ))
              : Loading(),
        ));
  }

  Future<void> _onRefresh() async {
    print('refresh ran');
    await _profileDBService
        .getNewProfileBlogs(
      profileUser: _userProfile,
      provider: widget.profileBlogsProvider,
      isFirst: false,
    )
        .then((_) async {
      widget.profileBlogsProvider.callFuture();

      if (widget.visitProfile) {
        // //don't allow to save read count
        // _profileDBService
        //     .getProfileData(profileUID: _userProfile.userUID)
        //     .then((MyUser newUserProfile) {
        //   setState(() => _userProfile = newUserProfile);
        //   _visitProfileProvider.setUserProfile(newUserProfile);
        // });
      } else {
        await _profileDBService
            .whetherHasAccount(_userProfile.userUID)
            .then((newUserProfile) {
          DateTime _tempLastUpdated = _authService.myUser.lastUpdated;
          newUserProfile.lastUpdated = _tempLastUpdated;
          _authService.myUser = newUserProfile;

          _visitProfileProvider.setUserProfile(newUserProfile);
        });
      }
      _refreshController.refreshCompleted();
    });
  }

  Future<List<Feed>> _loadData() async {
    if (tabIndex == 0) {
      print('load data RAN!');

      await _profileDBService.getProfileBlogs(
        profileUser: _userProfile,
        provider: widget.profileBlogsProvider,
        isFirst: false,
      );

      widget.profileBlogsProvider.callFuture();
      _refreshController.loadComplete();
    } else {
      _refreshController.loadComplete();
    }
    return widget.profileBlogsProvider.data;
  }

  Future<String> dummyFunc() async {
    print('dummy FUNC RAN!');
    widget.profileBlogsProvider.callFuture();

    return 'done';
  }

  Future<List<Feed>> _loadFirstData() async {
    print('load FIRST data RAN!');

    await _profileDBService.getProfileBlogs(
        profileUser: _userProfile,
        provider: widget.profileBlogsProvider,
        isFirst: true);

    widget.profileBlogsProvider.doneLoading = true;

    widget.profileBlogsProvider.callFuture();
    return widget.profileBlogsProvider.data;
  }
}

class SavedCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1 / 1,
      child: Card(
        margin: EdgeInsets.all(10),
        elevation: 1,
        // color: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: ([
              Colors.purple[300],
              Colors.pink[300],
              Colors.orange[300],
              Colors.blue[300],
            ]..shuffle())
                .first,
            borderRadius: BorderRadius.circular(20),
          ),
          alignment: Alignment.center,
          padding: EdgeInsets.all(10),
          height: 110,
          width: 110,
          child: Text(
            ((['M16:1', 'J3:16', '1C13:4'])..shuffle()).first,
            style: TextStyle(
                color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}
