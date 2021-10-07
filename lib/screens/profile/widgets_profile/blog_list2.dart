import 'package:versify/models/feed_model.dart';
import 'package:versify/models/user_model.dart';
import 'package:versify/providers/providers_home/profile_data_provider.dart';
import 'package:versify/providers/providers_home/profile_blogs_provider.dart';
import 'package:versify/providers/providers_home/theme_data_provider.dart';
import 'package:versify/screens/profile/widgets_profile/profile_feed_widget.dart';
import 'package:versify/screens/profile/widgets_profile/profile_page_view.dart';
import 'package:versify/providers/providers_home/profile_pageview_provider.dart';
import 'package:versify/providers/providers_home/visit_profile_provider.dart';
import 'package:versify/services/firebase/profile_database.dart';
import 'package:versify/shared/helper/helper_widgets.dart';
import 'package:versify/shared/widgets/widgets_all_loading.dart';
import 'package:versify/shared/helper/helper_constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileBlogList2 extends StatefulWidget {
  final MyUser userProfile;
  final bool visitProfile;
  final bool isFromPageView;
  final ScrollController nestedViewController;

  ProfileBlogList2(
      {this.userProfile,
      this.isFromPageView,
      this.nestedViewController,
      this.visitProfile});

  @override
  _ProfileBlogList2State createState() => _ProfileBlogList2State();
}

class _ProfileBlogList2State extends State<ProfileBlogList2> {
  // final ScrollController _profileBlogController = ScrollController();
  // final RefreshController _refreshController = RefreshController();

  ProfileDBService _profileDBService;
  ProfileBlogsProvider _profileBlogsProvider;
  // VisitProfileProvider _visitProfileProvider;
  // ProfileDataProvider _profileDataProvider;

  // Future _future;
  Map<int, double> _dynamicItemExtentList = {};

  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print('init state in personal blog list');
    });
  }

  // Future<List<Feed>> _loadData() async {
  //   print('load data RAN!');

  //   await _profileDBService.getProfileBlogs(
  //       profileUser: widget.userProfile,
  //       provider: _profileBlogsProvider,
  //       isFirst: false);

  //   _profileBlogsProvider.callFuture();
  //   return _profileBlogsProvider.data;
  // }

  // VisitProfileProvider _visitProfileProvider = VisitProfileProvider();
  ProfileAllPostsView _profileAllPostsView;

  @override
  Widget build(BuildContext context) {
    // print(
    //     'profile blog list built with future? ' + (_future != null).toString());
    _profileDBService = Provider.of<ProfileDBService>(context);
    _profileBlogsProvider =
        Provider.of<ProfileBlogsProvider>(context, listen: true);
    // final AuthService _authService = Provider.of<AuthService>(context);
    final ProfileDataProvider _profileDataProvider =
        Provider.of<ProfileDataProvider>(context, listen: false);

    // if (widget.isFromPageView) {
    final VisitProfileProvider _visitProfileProvider =
        Provider.of<VisitProfileProvider>(context, listen: false);

    final ThemeProvider _themeProvider =
        Provider.of<ThemeProvider>(context, listen: false);
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

    return _profileBlogsProvider.doneLoading
        ? _profileBlogsProvider.noData
            ? SliverFillRemaining(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(child: Container()),
                    Image.asset(
                      'assets/images/copywriting.png',
                      height: 130,
                      width: 130,
                    ),
                    SizedBox(height: 30),
                    SizedBox(
                      width: 280,
                      child: Text(
                        widget.visitProfile
                            ? 'Nothing here. No blogs written yet!'
                            : 'Hmm... you haven\'t written any blogs yet.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: _themeProvider.secondaryTextColor,
                        ),
                      ),
                    ),
                    Expanded(child: Container()),
                  ],
                ),
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
                    return SliverToBoxAdapter(
                      child: Column(
                        key: PageStorageKey<String>('Blogs'),
                        children: _profileBlogsProvider.data
                            .map((Feed feed) {
                              int index =
                                  _profileBlogsProvider.data.indexOf(feed);
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
                            })
                            .toList()
                            .cast<Widget>(),
                      ),
                    );
                  },
                ),
              )
        : SliverFillRemaining(child: Loading());
  }

  // Future<void> _onRefresh() async {
  //   // print('Refresh Ran with postsView: ' + _profileAllPostsView.toString());
  //   // _profileAllPostsView.clearViews();

  //   // print('Views:' + _profileAllPostsView.allViews.toString());

  //   // await _loadData();

  //   // _refreshController.loadComplete();
  // }

  // Future<void> _onLoading() async {
  //   await _loadData();

  //   // _refresh();

  //   _refreshController.loadComplete();
  // }
}
