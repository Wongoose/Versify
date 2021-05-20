import 'package:share/share.dart';
import 'package:versify/models/feed_model.dart';
import 'package:versify/providers/feed_list_provider.dart';
import 'package:versify/providers/all_posts_provider.dart';
import 'package:versify/providers/feed_type_provider.dart';
import 'package:versify/providers/input_comments_provider.dart';
import 'package:versify/providers/post_swipe_up_provider.dart';
import 'package:versify/screens/feed_screen/feed_list_wrapper.dart';
import 'package:versify/screens/feed_screen/widgets/input_comment.dart';
import 'package:versify/services/auth.dart';
import 'package:versify/services/database.dart';
import 'package:versify/services/dynamic_links.dart';
import 'package:versify/services/profile_database.dart';
import 'package:versify/shared/loading.dart';
import 'package:versify/shared/report_post_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

class ForYouPageView extends StatefulWidget {
  @override
  _ForYouPageViewState createState() => _ForYouPageViewState();
}

class _ForYouPageViewState extends State<ForYouPageView> {
  AllPostsView _allPostsViewProvider;
  PageController _pageController;
  DatabaseService _databaseService;
  int _prevIndex = 0;
  bool _loading = false;
  FeedType _feedType = FeedType.forYou;
  Widget _bottomSheetActions;

  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print('OpenView with index: ' +
          _allPostsViewProvider.forYouCurrentIndex.toString());
      print('OpenView with controller: ' +
          _allPostsViewProvider.forYouPageController.hasClients.toString());
      _pageController = _allPostsViewProvider.forYouPageController;
      _allPostsViewProvider.updatePageViewPostFrame(true);
      _pageController.jumpToPage(_allPostsViewProvider.forYouCurrentIndex);

      _bottomSheetActions = BottomSheetActions();
    });
  }

  Future<void> popScopeUpdateFeed() async {
    Feed _feedToBeUpdated = _allPostsViewProvider.forYouCurrentFeed;
    // setState(() => _loading = true);
    Navigator.pop(context);
    await _databaseService
        .updateFeedAfterSwipe(
            feed: _feedToBeUpdated,
            user: _allPostsViewProvider.currentViewPostUser,
            hasUpdateLike: _feedToBeUpdated.hasUpdatelike)
        .then((_) {
      // setState(() => _loading = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    _allPostsViewProvider = Provider.of<AllPostsView>(context, listen: false);
    _databaseService = Provider.of<DatabaseService>(context);
    FeedListProvider _feedListProvider = Provider.of<FeedListProvider>(context);
    InputCommentsProvider _inputCommentsProvider =
        Provider.of<InputCommentsProvider>(context, listen: false);

    print('For You PageView Build with allPostsView: ' +
        _allPostsViewProvider.toString());
    _allPostsViewProvider.updatePageViewPostFrame(false);

    return _allPostsViewProvider != null
        ? WillPopScope(
            onWillPop: () async {
              await popScopeUpdateFeed();
              return null;
            },
            child: Scaffold(
              backgroundColor: Colors.white,
              extendBodyBehindAppBar: false,
              appBar: PreferredSize(
                preferredSize: Size.fromHeight(kToolbarHeight),
                child: Stack(
                  children: [
                    Consumer<FeedTypeProvider>(
                      builder: (context, state, _) {
                        _feedType = state.currentFeedType;
                        return AppBar(
                          centerTitle: false,
                          titleSpacing: 5,
                          elevation: 0.5,
                          backgroundColor: Colors.white,
                          title: Padding(
                            padding: EdgeInsets.fromLTRB(0, 1, 0, 0),
                            child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      // state.typeClicked(
                                      //     selection:
                                      //         _feedType == FeedType.following
                                      //             ? FeedType.forYou
                                      //             : FeedType.following);
                                    },
                                    child: Text(
                                      'For You',
                                      style: TextStyle(
                                          letterSpacing: -0.3,
                                          fontSize: 18,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: 'Nunito'),
                                    ),
                                  ),
                                  Text(
                                    ' | ',
                                    style: TextStyle(
                                        letterSpacing: 1.0,
                                        fontSize: 9,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'Nunito'),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      state.typeClicked(
                                          selection: FeedType.following);
                                      Navigator.pop(context);
                                      if (_allPostsViewProvider
                                          .followingViews.isNotEmpty) {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    state.followingPageView));
                                      }
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.fromLTRB(0, 1, 0, 0),
                                      child: Text(
                                        'Following',
                                        style: TextStyle(
                                            letterSpacing: 1,
                                            fontSize: 13,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w400,
                                            fontFamily: 'Nunito'),
                                      ),
                                    ),
                                  ),
                                ]),
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
                            icon: Icon(Icons.arrow_back_rounded,
                                color: Colors.black),
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
                              icon: Icon(Icons.more_vert_rounded,
                                  color: Colors.black),
                              label: Text(''),
                              onPressed: () {
                                if (_allPostsViewProvider.hasSetNewuser) {
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
                                        return _bottomSheetActions;
                                      });
                                }
                              },
                            ),
                          ],

                          automaticallyImplyLeading: false,
                        );
                      },
                    ),
                    Positioned(
                      bottom: 0,
                      child: Consumer<InputCommentsProvider>(
                        builder: (context, state, __) {
                          return Visibility(
                            visible: state.isFocused,
                            child: GestureDetector(
                              onTapUp: (details) => state.focusNode.unfocus(),
                              child: Container(
                                height: kToolbarHeight,
                                width: MediaQuery.of(context).size.width,
                                color: Colors.black.withOpacity(0.1),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      child: Consumer<PostSwipeUpProvider>(
                        builder: (context, state, __) {
                          return Visibility(
                            visible: state.swipeUpVisible,
                            child: Container(
                              height: kToolbarHeight,
                              width: MediaQuery.of(context).size.width,
                              color: Colors.black.withOpacity(0.8),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              body: Stack(
                children: [
                  PageView.builder(
                    physics: BouncingScrollPhysics(),
                    controller: _allPostsViewProvider.forYouPageController,
                    onPageChanged: (currentIndex) async {
                      _allPostsViewProvider.hasSetNewuser = false;

                      _inputCommentsProvider.nextPostClearComment();

                      _allPostsViewProvider.forYouOnSwipe(currentIndex);

                      Feed prevFeed;

                      if (currentIndex > _prevIndex) {
                        prevFeed = _allPostsViewProvider
                            .forYouListOfFeeds[currentIndex - 1];
                      } else if (currentIndex < _prevIndex) {
                        prevFeed = _allPostsViewProvider
                            .forYouListOfFeeds[currentIndex + 1];
                      }

                      // if (_allPostsViewProvider.readMoreVisible == false) {
                      _allPostsViewProvider.setReadMoreVisible(true);
                      // }
                      //add click from postFeedWidget in ForYou
                      if (!_allPostsViewProvider
                          .forYouClickFromPostFeedWidget) {
                        await _databaseService.updateFeedAfterSwipe(
                            feed: prevFeed,
                            user: _allPostsViewProvider.currentViewPostUser,
                            hasUpdateLike: prevFeed.hasUpdatelike);
                      }

                      if (currentIndex ==
                          _allPostsViewProvider.forYouViews.length - 1) {
                        await _databaseService.getNewFeeds
                            .then((value) => _feedListProvider.callFuture());
                      }

                      _prevIndex = currentIndex;
                    },
                    scrollDirection: Axis.horizontal,
                    itemCount: _allPostsViewProvider.forYouViews.length,
                    itemBuilder: (context, index) {
                      return _allPostsViewProvider.forYouViews[index];
                    },
                  ),
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
                          child:
                              Column(mainAxisSize: MainAxisSize.max, children: [
                            GestureDetector(
                              onTapUp: (details) => state.focusNode.unfocus(),
                              child: Container(
                                height: MediaQuery.of(context).size.height - 55,
                                width: MediaQuery.of(context).size.width,
                                color: Colors.black.withOpacity(0.1),
                              ),
                            ),
                            InputComment(
                              textEditingController:
                                  state.textEditingController,
                              focusNode: state.focusNode,
                              isViewOnly: true,
                            )
                          ]),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          )
        : Loading();
  }
}

class BottomSheetActions extends StatefulWidget {
  // final AllPostsView allPostsViewProvider;
  BottomSheetActions({
    // this.allPostsViewProvider,
    Key key,
  }) : super(key: key);

  @override
  _BottomSheetActionsState createState() => _BottomSheetActionsState();
}

class _BottomSheetActionsState extends State<BottomSheetActions> {
  bool _followLoading = false;
  bool _shareLoading = false;
  bool _isVisitProfile;
  AllPostsView allPostsViewProvider;
  AuthService _authService;

  void initState() {
    print('BottomSheetActions InitState');
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (allPostsViewProvider.hasSetNewuser) {
        print('BottomSheet hasSetNewUser TRUE');
        _isVisitProfile =
            allPostsViewProvider.currentUserUID != _authService.myUser.userUID;
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _authService = Provider.of<AuthService>(context);
    final ProfileDBService _profileDBService =
        Provider.of<ProfileDBService>(context);
    allPostsViewProvider = Provider.of<AllPostsView>(context, listen: true);

    print(
        'Build bottomSheet with isVisitProfile: ' + _isVisitProfile.toString());

    return Container(
        margin: EdgeInsets.fromLTRB(4, 4, 4, 8),
        child: _isVisitProfile != null
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    margin: EdgeInsets.all(0),
                    height: 60,
                    child: TextButton(
                      style: TextButton.styleFrom(
                          padding: EdgeInsets.all(15), primary: Colors.white),
                      onPressed: () {
                        if (_isVisitProfile) {
                          //report
                          Feed _reportFeed =
                              allPostsViewProvider.forYouCurrentFeed;
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
                        setState(() => _shareLoading = true);
                        DynamicLinkService()
                            .createPostDynamicLink(allPostsViewProvider
                                .forYouCurrentFeed.documentID)
                            .then((res) async {
                          setState(() => _shareLoading = false);
                          Share.share(
                            _isVisitProfile
                                ? 'Check out this amazing blog on the Versify app!\n$res'
                                : 'Check out the blog that I wrote on the Versify app!\n$res',
                            subject: 'Versify Blogs',
                          );
                        });
                      },
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Visibility(
                          visible: !_shareLoading,
                          child: Text(
                            'Share post',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontFamily: 'Nunito',
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
                  Divider(thickness: 0.5, height: 0),
                  Visibility(
                    visible: _isVisitProfile,
                    child: Container(
                      margin: EdgeInsets.all(0),
                      height: 60,
                      child: TextButton(
                        style: TextButton.styleFrom(
                            padding: EdgeInsets.all(15), primary: Colors.white),
                        onPressed: () {
                          setState(() => _followLoading = true);

                          bool _isFollowing = !allPostsViewProvider
                              .currentViewPostUser.isFollowing;

                          _profileDBService
                              .updateFollowing(
                            profileUID: allPostsViewProvider
                                .currentViewPostUser.userUID,
                            isFollowing: _isFollowing,
                            usersPublicFollowID: allPostsViewProvider
                                .currentViewPostUser.usersPublicFollowID,
                          )
                              .then(
                            (publicFollowID) {
                              allPostsViewProvider.currentViewPostUser
                                  .usersPublicFollowID = publicFollowID;
                              allPostsViewProvider.currentViewPostUser
                                  .isFollowing = _isFollowing;
                              _followLoading = false;
                              allPostsViewProvider.updateListeners();
                            },
                          );
                        },
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Visibility(
                            visible: !_followLoading,
                            child: Text(
                              allPostsViewProvider.currentUserIsFollowing
                                  ? 'Unfollow'
                                  : 'Follow',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontFamily: 'Nunito',
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
                      child: TextButton(
                        style: TextButton.styleFrom(
                            padding: EdgeInsets.all(15), primary: Colors.white),
                        onPressed: () {},
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Edit post',
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
                  ),
                  // Divider(thickness: 0.5, height: 0),
                  // Container(
                  //   margin: EdgeInsets.all(0),
                  //   height: 60,
                  //   child: TextButton(
                  //     onPressed: () {},
                  //     child: Align(
                  //       alignment: Alignment.centerLeft,
                  //       child: Text(
                  //         'Save post',
                  //         style: TextStyle(
                  //           color: Colors.black,
                  //           fontSize: 16,
                  //           fontWeight: FontWeight.w00,
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // ),

                  // Divider(thickness: 0.5, height: 0),
                  // Container(
                  //   margin: EdgeInsets.all(0),
                  //   height: 60,
                  //   child: TextButton(
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
                  //   child: TextButton(
                  //     onPressed: () {},
                  //     child: Align(
                  //       alignment: Alignment.centerLeft,
                  //       child: Text(
                  //         'Comment',
                  //         style: TextStyle(
                  //           color: Colors.black,
                  //           fontSize: 16,
                  //           fontWeight: FontWeight.w00,
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              )
            : Loading());
  }

  void showDialogWhenCancel() {}
}
