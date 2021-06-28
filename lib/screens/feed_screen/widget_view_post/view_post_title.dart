import 'package:versify/models/feed_model.dart';
import 'package:versify/providers/feeds/all_posts_provider.dart';
import 'package:versify/providers/home/theme_data_provider.dart';
import 'package:versify/screens/feed_screen/widget_view_post/view_post.dart';
import 'package:versify/screens/feed_screen/visit_profile_sub/visit_profile_wrapper.dart';
import 'package:versify/providers/home/profile_blogs_provider.dart';
import 'package:versify/providers/home/profile_data_provider.dart';
import 'package:versify/providers/home/profile_pageview_provider.dart';
import 'package:versify/services/auth.dart';
import 'package:versify/services/notification.dart';
import 'package:versify/services/profile_database.dart';
import 'package:versify/shared/profilePicture.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ViewPostTitle extends StatefulWidget {
  final bool isProfileViewPost;
  final bool postFrameDone;
  final PageViewType pageViewType;

  final Feed feed;

  final int daysAgo;

  const ViewPostTitle({
    Key key,
    this.isProfileViewPost,
    @required this.daysAgo,
    @required this.feed,
    this.postFrameDone,
    this.pageViewType,
  });

  @override
  _ViewPostTitleState createState() => _ViewPostTitleState();
}

class _ViewPostTitleState extends State<ViewPostTitle> {
  ProfileDBService _profileDBService;
  AllPostsView _allPostsView;
  ProfileAllPostsView _profileAllPostsView;
  ProfileBlogsProvider _profileBlogsProvider;
  ProfileDataProvider _profileDataProvider;
  VisitProfileWrapper _visitprofileWrapper;
  bool _titlePostFrameDone = false;

  void initState() {
    super.initState();
    print('ViewPost Title initState');

    if (widget.postFrameDone) {
      //ViewPostWidget postframe is done -- execute code below
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
        await _profileDBService
            .getProfileData(profileUID: widget.feed.userID)
            .then((userProfile) {
          if (widget.pageViewType == PageViewType.allPosts) {
            _allPostsView.newViewPostUser(userProfile);
          } else {
            //profile ALlPostsView

            _profileDataProvider.newViewPostUser(userProfile);
            // _profileAllPostsView.newViewPostUser(userProfile);
          }

          _visitprofileWrapper = VisitProfileWrapper(
            // allPostsView: _allPostsView,
            userProfile: userProfile,
            feed: widget.feed,
            profileBlogsProvider: _profileBlogsProvider,
            profileAllPostsView: _profileAllPostsView,
          );
          //title widget postframs is done
          _titlePostFrameDone = true;
        });
      });
    }
  }

  void profileTapped() {
    print('Profile tapped');
    if (_titlePostFrameDone) {
      if (_profileDataProvider.currentProfileUID == widget.feed.userID &&
          widget.isProfileViewPost) {
        _profileDataProvider.popFunc();
        // Navigator.pop(context);
      } else {
        _profileDataProvider.currentProfileUID = widget.feed.userID;
        print('Updated Profile UID: ' + _profileDataProvider.currentProfileUID);

        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => _visitprofileWrapper,
          ),
        );
      }
    } else {
      print('ViewPostTitle not yet rendered VisitProfileWrapper');
    }
  }

  bool _followLoading = false;
  @override
  Widget build(BuildContext context) {
    final ThemeData _theme = Theme.of(context);
    final AuthService _authService = Provider.of<AuthService>(context);
    final ThemeProvider _themeProvider =
        Provider.of<ThemeProvider>(context, listen: false);

    _profileDataProvider =
        Provider.of<ProfileDataProvider>(context, listen: false);

    _allPostsView = Provider.of<AllPostsView>(context, listen: false);

    _profileDBService = Provider.of<ProfileDBService>(context);

    final PageController _profilePageViewController = PageController();

    _profileAllPostsView =
        ProfileAllPostsView(pageController: _profilePageViewController);

    _profileBlogsProvider =
        ProfileBlogsProvider(viewsProvider: _profileAllPostsView);

    return Padding(
      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          widget.pageViewType == PageViewType.allPosts
              ? Consumer<AllPostsView>(
                  builder: (context, state, _) => GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () => profileTapped(),
                    child: ProfilePic(
                      userProfile: state.currentViewPostUser,
                      primary: _theme.primaryColor,
                      secondary: _theme.primaryColor,
                      size: 1,
                    ),
                  ),
                )
              : Consumer<ProfileDataProvider>(
                  builder: (context, state, _) => GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () => profileTapped(),
                      child: state.currentViewPostUser != null
                          ? ProfilePic(
                              userProfile: state.currentViewPostUser,
                              primary: _theme.primaryColor,
                              secondary: _theme.primaryColor,
                              size: 1,
                            )
                          : Align(
                              alignment: Alignment.centerLeft,
                              child: SizedBox(
                                height: 15,
                                width: 15,
                                child: CircularProgressIndicator(
                                  valueColor: new AlwaysStoppedAnimation<Color>(
                                      Theme.of(context).primaryColor),
                                  strokeWidth: 0.5,
                                ),
                              ),
                            )),
                ),
          SizedBox(width: 8),
          Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () => profileTapped(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                    child: Text(
                      widget.daysAgo == 0
                          ? 'New today!'
                          : widget.daysAgo == 1
                              ? widget.daysAgo.toString() + ' day ago'
                              : widget.daysAgo.toString() + ' days ago',

                      // ' Posted on ${lastUpdated.toString().split(' ')[0]}',

                      style: TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                        color: _theme.primaryColor,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  Text(
                    'by ' + widget.feed.username,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.italic,
                      color: _themeProvider.secondaryTextColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
          widget.pageViewType == PageViewType.allPosts
              ? Consumer<AllPostsView>(
                  builder: (context, state, _) {
                    bool _isOtherProfile =
                        state.currentUserUID != _authService.myUser.userUID;
                    return GestureDetector(
                      onTap: () async {
                        if (_authService.isUserAnonymous) {
                          //dialog cannot perform action - need sign up
                          NotificationOverlay().showNormalImageDialog(context,
                              body: 'You can\'t follow them without an account. Sign up now!',
                              buttonText: 'Sign-up',
                              clickFunc: null,
                              imagePath: 'assets/images/user.png',
                              title: 'Create Account',
                              delay: Duration(milliseconds: 0));
                        } else if (_isOtherProfile &&
                            !state.currentUserIsFollowing) {
                          setState(() => _followLoading = true);

                          bool _isFollowing =
                              !state.currentViewPostUser.isFollowing;

                          await _profileDBService
                              .updateFollowing(
                            profileUID: state.currentViewPostUser.userUID,
                            isFollowing: _isFollowing,
                            usersPublicFollowID:
                                state.currentViewPostUser.usersPublicFollowID,
                          )
                              .then(
                            (publicFollowID) {
                              state.currentViewPostUser.usersPublicFollowID =
                                  publicFollowID;
                              state.currentViewPostUser.isFollowing =
                                  _isFollowing;
                              _followLoading = false;
                              state.updateListeners();
                            },
                          );
                        }
                      },
                      child: Visibility(
                        visible: !_followLoading,
                        child: Text(
                          _isOtherProfile
                              ? state.currentUserIsFollowing
                                  ? 'Followed'
                                  : 'Quick follow'
                              : 'View details',
                          style: TextStyle(
                            fontSize: 12,
                            color: !state.currentUserIsFollowing
                                ? Theme.of(context).accentColor
                                : _themeProvider.secondaryTextColor,
                          ),
                        ),
                        replacement: SizedBox(
                          height: 15,
                          width: 15,
                          child: CircularProgressIndicator(
                            valueColor: new AlwaysStoppedAnimation<Color>(
                                Theme.of(context).primaryColor),
                            strokeWidth: 0.5,
                          ),
                        ),
                      ),
                    );
                  },
                )
              : Consumer<ProfileDataProvider>(
                  builder: (context, state, _) {
                    print('ViewPostTitle ProfileData exists: ' +
                        (state.visitProfileProvider != null).toString());

                    bool _isOtherProfile =
                        state.visitProfileProvider.userProfile.userUID !=
                            _authService.myUser.userUID;
                    return GestureDetector(
                      onTap: () {
                        if (_isOtherProfile &&
                            !state
                                .visitProfileProvider.userProfile.isFollowing) {
                          setState(() => _followLoading = true);

                          bool _isFollowing = !state
                              .visitProfileProvider.userProfile.isFollowing;

                          _profileDBService
                              .updateFollowing(
                            profileUID:
                                state.visitProfileProvider.userProfile.userUID,
                            isFollowing: _isFollowing,
                            usersPublicFollowID: state.visitProfileProvider
                                .userProfile.usersPublicFollowID,
                          )
                              .then(
                            (publicFollowID) {
                              state.visitProfileProvider.userProfile
                                  .usersPublicFollowID = publicFollowID;
                              // state.userProfile.isFollowing =
                              //     _isFollowing;
                              _followLoading = false;
                              state.visitProfileProvider
                                  .updateFollowing(_isFollowing);
                            },
                          );
                        }
                      },
                      child: Visibility(
                        visible: !_followLoading,
                        child: Text(
                          _isOtherProfile
                              ? state.visitProfileProvider.userProfile
                                      .isFollowing
                                  ? 'Followed'
                                  : 'Quick follow'
                              : 'View details',
                          style: TextStyle(
                            fontSize: 12,
                            color: !state.visitProfileProvider.userProfile
                                    .isFollowing
                                ? Theme.of(context).accentColor
                                : _themeProvider.secondaryTextColor,
                          ),
                        ),
                        replacement: SizedBox(
                          height: 15,
                          width: 15,
                          child: CircularProgressIndicator(
                            valueColor: new AlwaysStoppedAnimation<Color>(
                                Theme.of(context).primaryColor),
                            strokeWidth: 0.5,
                          ),
                        ),
                      ),
                    );
                  },
                ),
          SizedBox(width: 8),
        ],
      ),
    );
  }
}
