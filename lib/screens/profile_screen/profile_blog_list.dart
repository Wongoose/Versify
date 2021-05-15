import 'package:versify/models/feed_model.dart';
import 'package:versify/models/user_model.dart';
import 'package:versify/screens/profile_screen/profile_data_provider.dart';
import 'package:versify/screens/profile_screen/profile_blogs_provider.dart';
import 'package:versify/screens/profile_screen/profile_feed_widget.dart';
import 'package:versify/screens/profile_screen/profile_page_view.dart';
import 'package:versify/screens/profile_screen/profile_pageview_provider.dart';
import 'package:versify/screens/profile_screen/visit_profile_provider.dart';
import 'package:versify/services/auth.dart';
import 'package:versify/services/profile_database.dart';
import 'package:versify/shared/constants.dart';
import 'package:versify/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ProfileBlogList extends StatefulWidget {
  final MyUser userProfile;
  final bool isFromPageView;
  final ScrollController nestedViewController;

  ProfileBlogList(
      {this.userProfile, this.isFromPageView, this.nestedViewController});

  @override
  _ProfileBlogListState createState() => _ProfileBlogListState();
}

class _ProfileBlogListState extends State<ProfileBlogList> {
  // final ScrollController _profileBlogController = ScrollController();
  final RefreshController _refreshController = RefreshController();

  ProfileDBService _profileDBService;
  ProfileBlogsProvider _profileBlogsProvider;
  // VisitProfileProvider _visitProfileProvider;
  // ProfileDataProvider _profileDataProvider;

  Future _future;
  Map<int, double> _dynamicItemExtentList = {};

  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print('init state in personal blog list');

      if (_profileBlogsProvider.initialOpen) {
        _future = _loadFirstData();
        _profileBlogsProvider.initialOpen = false;
      } else {
        _future = dummyFunc();
        // _future = _loadData();

      }
    });
  }

  Future<String> dummyFunc() async {
    print('dummy FUNC RAN!');
    _profileBlogsProvider.callFuture();

    return 'done';
  }

  Future<List<Feed>> _loadFirstData() async {
    print('load FIRST data RAN!');

    await _profileDBService.getProfileBlogs(
        profileUser: widget.userProfile,
        provider: _profileBlogsProvider,
        isFirst: true);

    _profileBlogsProvider.callFuture();
    return _profileBlogsProvider.data;
  }

  Future<List<Feed>> _loadData() async {
    print('load data RAN!');

    await _profileDBService.getProfileBlogs(
        profileUser: widget.userProfile,
        provider: _profileBlogsProvider,
        isFirst: false);

    _profileBlogsProvider.callFuture();
    return _profileBlogsProvider.data;
  }

  // VisitProfileProvider _visitProfileProvider = VisitProfileProvider();
  ProfileAllPostsView _profileAllPostsView;

  @override
  Widget build(BuildContext context) {
    print(
        'profile blog list built with future? ' + (_future != null).toString());
    _profileDBService = Provider.of<ProfileDBService>(context);
    _profileBlogsProvider =
        Provider.of<ProfileBlogsProvider>(context, listen: true);
    // final AuthService _authService = Provider.of<AuthService>(context);
    final ProfileDataProvider _profileDataProvider =
        Provider.of<ProfileDataProvider>(context, listen: false);

    // if (widget.isFromPageView) {
    final VisitProfileProvider _visitProfileProvider =
        Provider.of<VisitProfileProvider>(context, listen: false);
    // }
    _profileDataProvider.setVisitProfileProvider(_visitProfileProvider);

    _profileAllPostsView =
        Provider.of<ProfileAllPostsView>(context, listen: false);
    print('ProfileBLOG List with ProfileAllPostsView: ' +
        _profileAllPostsView.hashCode.toString());
    // _profileDataProvider =
    //     Provider.of<ProfileDataProvider>(context, listen: false);
    //
    final ProfilePageView _postsView = ProfilePageView(
      visitProfileProvider: _visitProfileProvider,
      isFromPageView: widget.isFromPageView,
      userUID: widget.userProfile.userUID,
      profileUser: widget.userProfile,
      profileBlogsProvider: _profileBlogsProvider,
      profileAllPostsView: _profileAllPostsView,
    );
    // _visitProfileProvider.setUserProfile(widget.userProfile);

    return _future == null
        ? Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 55),
            child: Loading(),
          )
        : Provider<ProfilePageView>.value(
            value: _postsView,
            child: Consumer<ProfileAllPostsView>(
              builder: (context, value, child) {
                // if (_profileBlogController.hasClients == true &&
                //     _prevIndexFromPageView != value.currentIndex) {
                //   scrollPositionAfterView(value.currentIndex);
                //   _prevIndexFromPageView = value.currentIndex;
                // }

                return SmartRefresher(
                  enablePullDown: false,
                  enablePullUp: true,
                  header: MaterialClassicHeader(
                    color: Colors.pink[300],
                    backgroundColor: Colors.white,
                    distance: 50,
                  ),
                  physics: ClampingScrollPhysics(),
                  reverse: false,
                  footer: CustomFooter(
                    builder: (BuildContext context, LoadStatus mode) {
                      Widget body;
                      if (_profileBlogsProvider.noData) {
                        body = Text('None left for today!');
                      } else if (mode == LoadStatus.idle) {
                        body = Text(
                          "",
                          style: TextStyle(color: Colors.black),
                        );
                      } else if (mode == LoadStatus.loading) {
                        body = SpinKitThreeBounce(
                          color: Colors.pink[300],
                          size: 30,
                        );
                      } else if (mode == LoadStatus.failed) {
                        body = Text(
                          "Load Failed!Click retry!",
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
                  controller: _refreshController,
                  // scrollController: _profileBlogController,
                  key: PageStorageKey<String>('Blogs'),

                  onRefresh: _onRefresh,
                  onLoading: _onLoading,
                  child: ListView.builder(
                    key: PageStorageKey<String>('Blogs'),

                    addAutomaticKeepAlives: true,
                    itemCount: _profileBlogsProvider.data.length,
                    scrollDirection: Axis.vertical,
                    // controller: _profileBlogController,
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      return SizeProviderWidget(
                        onChildSize: (size) {
                          print('Feed Widget height is: ' +
                              size.height.toString());
                          _dynamicItemExtentList[index] = size.height;
                          // print(_dynamicItemExtentList);
                        },
                        child: ProfileFeedWidget(
                            index: index,
                            feed: _profileBlogsProvider.data[index]),
                      );
                    },
                  ),
                );
              },
            ),
          );
  }

  Future<void> _onRefresh() async {
    // print('Refresh Ran with postsView: ' + _profileAllPostsView.toString());
    // _profileAllPostsView.clearViews();

    // print('Views:' + _profileAllPostsView.allViews.toString());

    // await _loadData();

    // _refreshController.loadComplete();
  }

  Future<void> _onLoading() async {
    await _loadData();

    // _refresh();

    _refreshController.loadComplete();
  }
}
