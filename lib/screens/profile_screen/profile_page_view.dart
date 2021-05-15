import 'package:versify/models/feed_model.dart';
import 'package:versify/models/user_model.dart';
import 'package:versify/providers/input_comments_provider.dart';
import 'package:versify/screens/feed_screen/widgets/input_comment.dart';
import 'package:versify/screens/profile_screen/profile_data_provider.dart';
import 'package:versify/screens/profile_screen/profile_blogs_provider.dart';
import 'package:versify/screens/profile_screen/profile_pageview_provider.dart';
import 'package:versify/screens/profile_screen/visit_profile_provider.dart';
import 'package:versify/services/auth.dart';
import 'package:versify/services/database.dart';
import 'package:versify/services/profile_database.dart';
import 'package:versify/shared/loading.dart';
import 'package:versify/shared/report_post_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

class ProfilePageView extends StatefulWidget {
  final String userUID;
  final MyUser profileUser;
  final ProfileBlogsProvider profileBlogsProvider;
  final ProfileAllPostsView profileAllPostsView;
  final VisitProfileProvider visitProfileProvider;
  final bool isFromPageView;

  ProfilePageView({
    this.userUID,
    this.profileUser,
    this.profileBlogsProvider,
    this.profileAllPostsView,
    this.visitProfileProvider,
    this.isFromPageView,
  });

  @override
  _ProfilePageViewState createState() => _ProfilePageViewState();
}

class _ProfilePageViewState extends State<ProfilePageView> {
  // ProfileAllPostsView widget.profileAllPostsView;
  ProfileDataProvider _profileDataProvider;
  PageController _pageController;
  DatabaseService _databaseService;
  ProfileDBService _profileDBService;
  int _prevIndex = 0;
  bool _loading = false;

  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print('OpenView with index: ' +
          widget.profileAllPostsView.currentIndex.toString());
      print('OpenView with controller: ' +
          widget.profileAllPostsView.pageController.hasClients.toString());
      _pageController = widget.profileAllPostsView.pageController;
      widget.profileAllPostsView.updatePageViewPostFrame(true);

      _pageController.jumpToPage(widget.profileAllPostsView.currentIndex);

      _profileDataProvider.popFunc = popScopeUpdateFeed;
    });
  }

  Future<void> popScopeUpdateFeed() async {
    Feed _feedToBeUpdated = widget.profileAllPostsView.currentFeed;
    // setState(() => _loading = true);
    Navigator.pop(context);
    await _databaseService
        .updateFeedAfterSwipe(
            feed: _feedToBeUpdated,
            user: _profileDataProvider.currentViewPostUser,
            hasUpdateLike: _feedToBeUpdated.hasUpdatelike)
        .then((_) {
      // setState(() => _loading = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    // widget.profileAllPostsView =
    //     Provider.of<ProfileAllPostsView>(context, listen: false);
    _databaseService = Provider.of<DatabaseService>(context);
    _profileDBService = Provider.of<ProfileDBService>(context);
    _profileDataProvider = Provider.of<ProfileDataProvider>(context);

    // ProfileBlogsProvider _profileBlogsProvider =
    //     Provider.of<ProfileBlogsProvider>(context);
    InputCommentsProvider _inputCommentsProvider =
        Provider.of<InputCommentsProvider>(context, listen: false);

    print('itemCount is :' +
        widget.profileAllPostsView.allViews.length.toString());

    widget.profileAllPostsView.updatePageViewPostFrame(false);

    return WillPopScope(
      onWillPop: () => popScopeUpdateFeed(),
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider<ProfileAllPostsView>.value(
              value: widget.profileAllPostsView),
          ChangeNotifierProvider<ProfileBlogsProvider>.value(
              value: widget.profileBlogsProvider)
        ],
        child: Scaffold(
          backgroundColor: Colors.white,
          extendBodyBehindAppBar: false,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(kToolbarHeight),
            child: Stack(
              children: [
                AppBar(
                  // centerTitle: true,

                  titleSpacing: 5,

                  elevation: 0.5,

                  backgroundColor: Colors.white,

                  title: Text(
                    'Blogs',
                    style: TextStyle(
                        fontSize: 22,
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Nunito'),
                  ),

                  // titleSpacing: -10,

                  leading: TextButton.icon(
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),

                      backgroundColor: Colors.transparent,

                      // focusColor: Colors.white,

                      // highlightColor: Color(0xfffffcfe),
                    ),
                    clipBehavior: Clip.none,
                    icon: Icon(Icons.arrow_back_rounded, color: Colors.black),
                    label: Text(''),
                    onPressed: () => popScopeUpdateFeed(),
                  ),

                  actions: [
                    TextButton.icon(
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.fromLTRB(25, 0, 0, 0),

                        backgroundColor: Colors.white,

                        // focusColor: Colors.white,

                        // highlightColor: Color(0xfffffcfe),
                      ),
                      clipBehavior: Clip.none,
                      icon: Icon(Icons.more_vert_rounded, color: Colors.black),
                      label: Text(''),
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
                              return BottomSheetActions(
                                profileAllPostsView: widget.profileAllPostsView,
                                profileDataProvider: _profileDataProvider,
                                isFromPageView: widget.isFromPageView,
                                visitProfileProvider:
                                    widget.visitProfileProvider,
                              );
                            });
                      },
                    ),
                  ],

                  automaticallyImplyLeading: false,
                ),
                Positioned(
                  bottom: 0,
                  child: Consumer<InputCommentsProvider>(
                      builder: (context, state, __) {
                    // state.attachController();
                    return Visibility(
                        visible: state.isFocused,
                        child: GestureDetector(
                            onTapUp: (details) => state.focusNode.unfocus(),
                            child: Container(
                              height: kToolbarHeight,
                              width: MediaQuery.of(context).size.width,
                              color: Colors.black.withOpacity(0.1),
                            )));
                  }),
                ),
              ],
            ),
          ),
          body: Stack(
            children: [
              Consumer<ProfileBlogsProvider>(builder: (context, value, _) {
                return PageView.builder(
                  physics: BouncingScrollPhysics(),
                  controller: widget.profileAllPostsView.pageController,
                  onPageChanged: (currentIndex) async {
                    _inputCommentsProvider.nextPostClearComment();
                    widget.profileAllPostsView.onSwipe(currentIndex);

                    Feed prevFeed;

                    if (currentIndex > _prevIndex) {
                      prevFeed = widget
                          .profileAllPostsView.listOfFeeds[currentIndex - 1];
                    } else if (currentIndex < _prevIndex) {
                      prevFeed = widget
                          .profileAllPostsView.listOfFeeds[currentIndex + 1];
                    }

                    // if (widget.profileAllPostsView.readMoreVisible == false) {
                    // widget.profileAllPostsView.setReadMoreVisible(true);

                    // }
                    if (!widget.profileAllPostsView.clickFromPostFeedWidget) {
                      await _databaseService.updateFeedAfterSwipe(
                        feed: prevFeed,
                        user: _profileDataProvider.currentViewPostUser,
                        hasUpdateLike: prevFeed.hasUpdatelike,
                      );
                    }

                    if (currentIndex ==
                        widget.profileAllPostsView.allViews.length - 1) {
                      _profileDBService
                          .getProfileBlogs(
                              profileUser: widget.profileUser,
                              provider: widget.profileBlogsProvider,
                              isFirst: false)
                          .then(
                              (_) => widget.profileBlogsProvider.callFuture());
                    }

                    _prevIndex = currentIndex;
                  },
                  scrollDirection: Axis.vertical,
                  itemCount: widget.profileAllPostsView.allViews.length,
                  itemBuilder: (context, index) {
                    return widget.profileAllPostsView.allViews[index];
                  },
                );
              }),
              Visibility(
                visible: _loading,
                child: Align(
                  alignment: Alignment.center,
                  child: Loading(),
                ),
              ),
              Positioned(
                bottom: 0,
                child: Consumer<InputCommentsProvider>(
                  builder: (context, state, __) {
                    // state.attachController();
                    return Visibility(
                      visible: state.isFocused,
                      child: Column(mainAxisSize: MainAxisSize.max, children: [
                        GestureDetector(
                          onTapUp: (details) => state.focusNode.unfocus(),
                          child: Container(
                            height: MediaQuery.of(context).size.height - 55,
                            width: MediaQuery.of(context).size.width,
                            color: Colors.black.withOpacity(0.1),
                          ),
                        ),
                        InputComment(
                          textEditingController: state.textEditingController,
                          focusNode: state.focusNode,
                          isViewOnly: true,
                        ),
                      ]),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BottomSheetActions extends StatefulWidget {
  final ProfileDataProvider profileDataProvider;
  final ProfileAllPostsView profileAllPostsView;
  final VisitProfileProvider visitProfileProvider;
  final bool isFromPageView;

  BottomSheetActions({
    this.profileDataProvider,
    Key key,
    this.visitProfileProvider,
    this.isFromPageView,
    this.profileAllPostsView,
  }) : super(key: key);

  @override
  _BottomSheetActionsState createState() => _BottomSheetActionsState();
}

class _BottomSheetActionsState extends State<BottomSheetActions> {
  bool _followLoading = false;

  @override
  Widget build(BuildContext context) {
    final AuthService _authService = Provider.of<AuthService>(context);
    final ProfileDBService _profileDBService =
        Provider.of<ProfileDBService>(context);

    print('Profile BottomSheet profileDataProvider is: ' +
        widget.profileDataProvider.hashCode.toString());

    print('CurrentUserID is: ' + widget.profileDataProvider.currentUserUID);

    bool _isVisitProfile = widget.profileDataProvider.currentUserUID !=
        _authService.myUser.userUID;

    return Container(
      margin: EdgeInsets.fromLTRB(4, 4, 4, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: EdgeInsets.all(0),
            height: 60,
            child: FlatButton(
              materialTapTargetSize: MaterialTapTargetSize.padded,
              onPressed: () {
                if (_isVisitProfile) {
                  //report
                  Feed _reportFeed = widget.profileAllPostsView.currentFeed;
                  Navigator.pop(context);
                  showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) {
                        return ReportPostDialog(
                          feed: _reportFeed,
                        );
                      });
                  // _profileDBService.reportPost();
                }
              },
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  _isVisitProfile ? 'Report...' : 'Delete post',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 16,
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
            child: FlatButton(
              materialTapTargetSize: MaterialTapTargetSize.padded,
              onPressed: () {},
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Share to...',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
          Divider(thickness: 0.5, height: 0),
          Visibility(
            visible: _isVisitProfile,
            child: Container(
              margin: EdgeInsets.all(0),
              height: 60,
              child: FlatButton(
                materialTapTargetSize: MaterialTapTargetSize.padded,
                onPressed: () {
                  setState(() => _followLoading = true);

                  bool _isFollowing =
                      !widget.visitProfileProvider.userProfile.isFollowing;

                  _profileDBService
                      .updateFollowing(
                    profileUID: widget.visitProfileProvider.userProfile.userUID,
                    isFollowing: _isFollowing,
                    usersPublicFollowID: widget
                        .visitProfileProvider.userProfile.usersPublicFollowID,
                  )
                      .then(
                    (publicFollowID) {
                      widget.visitProfileProvider.userProfile
                          .usersPublicFollowID = publicFollowID;
                      // widget.visitProfileProvider.userProfile.isFollowing =
                      //     _isFollowing;
                      widget.visitProfileProvider.updateFollowing(_isFollowing);
                      setState(() => _followLoading = false);
                    },
                  );
                },
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Visibility(
                    visible: !_followLoading,
                    child: Text(
                      widget.isFromPageView
                          ? widget.visitProfileProvider.userProfile.isFollowing
                              ? 'Unfollow'
                              : 'Follow'
                          : 'none',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    replacement: SizedBox(
                      height: 15,
                      width: 15,
                      child: CircularProgressIndicator(
                        strokeWidth: 0.5,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            replacement: Container(
              margin: EdgeInsets.all(0),
              height: 60,
              child: FlatButton(
                materialTapTargetSize: MaterialTapTargetSize.padded,
                onPressed: () {},
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Edit post',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Divider(thickness: 0.5, height: 0),
          // Container(
          //   margin: EdgeInsets.all(0),
          //   height: 60,
          //   child: FlatButton(
          //     materialTapTargetSize: MaterialTapTargetSize.padded,
          //     onPressed: () {},
          //     child: Align(
          //       alignment: Alignment.centerLeft,
          //       child: Text(
          //         'Save post',
          //         style: TextStyle(
          //           color: Colors.black,
          //           fontSize: 16,
          //           fontWeight: FontWeight.w600,
          //         ),
          //       ),
          //     ),
          //   ),
          // ),
          // Divider(thickness: 0.5, height: 0),
          // Container(
          //   margin: EdgeInsets.all(0),
          //   height: 60,
          //   child: FlatButton(
          //     materialTapTargetSize: MaterialTapTargetSize.padded,
          //     onPressed: () {
          //       allPostsViewProvider.viewPostLikeProvider.likeTrigger();
          //       Navigator.pop(context);
          //     },
          //     child: Align(
          //       alignment: Alignment.centerLeft,
          //       child: Text(
          //         'Like',
          //         style: TextStyle(
          //           color: Colors.black,
          //           fontSize: 16,
          //           fontWeight: FontWeight.w600,
          //         ),
          //       ),
          //     ),
          //   ),
          // ),
          // Divider(thickness: 0.5, height: 0),
          // Container(
          //   margin: EdgeInsets.all(0),
          //   height: 60,
          //   child: FlatButton(
          //     materialTapTargetSize: MaterialTapTargetSize.padded,
          //     onPressed: () {},
          //     child: Align(
          //       alignment: Alignment.centerLeft,
          //       child: Text(
          //         'Comment',
          //         style: TextStyle(
          //           color: Colors.black,
          //           fontSize: 16,
          //           fontWeight: FontWeight.w600,
          //         ),
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
