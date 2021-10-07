import 'package:versify/models/feed_model.dart';
import 'package:versify/models/user_model.dart';
import 'package:versify/providers/providers_feeds/all_posts_provider.dart';
import 'package:versify/providers/providers_home/theme_data_provider.dart';
import 'package:versify/screens/profile/widgets_profile/main_profile.dart';
import 'package:versify/providers/providers_home/profile_data_provider.dart';
import 'package:versify/providers/providers_home/profile_blogs_provider.dart';
import 'package:versify/providers/providers_home/profile_pageview_provider.dart';
import 'package:versify/providers/providers_home/visit_profile_provider.dart';
import 'package:versify/services/firebase/auth.dart';
import 'package:versify/services/firebase/profile_database.dart';
import 'package:versify/shared/widgets/widgets_dialog_report_user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VisitProfileWrapper extends StatelessWidget {
  final MyUser userProfile;
  final ProfileBlogsProvider profileBlogsProvider;
  final ProfileAllPostsView profileAllPostsView;
  final Feed feed;

  VisitProfileWrapper({
    this.profileBlogsProvider,
    this.profileAllPostsView,
    this.userProfile,
    this.feed,
  });

  @override
  Widget build(BuildContext context) {
    final AuthService _authService = Provider.of<AuthService>(context);
    final ProfileDataProvider _profileDataProvider =
        Provider.of<ProfileDataProvider>(context, listen: false);

    final AllPostsView _allPostsView =
        Provider.of<AllPostsView>(context, listen: false);

    final VisitProfileProvider _visitProfileProvider = VisitProfileProvider(
        allPostsView: _allPostsView, profileDataProvider: _profileDataProvider);

    final ThemeProvider _themeProvider =
        Provider.of<ThemeProvider>(context, listen: false);

    _visitProfileProvider.setUserProfile(userProfile);
    print('VisitProfileWrapper setUserProfile: ' +
        userProfile.username +
        ' hash ' +
        _visitProfileProvider.hashCode.toString());
    return ChangeNotifierProvider<VisitProfileProvider>(
      create: (_) => _visitProfileProvider,
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          titleSpacing: 5,
          elevation: 0.5,
          backgroundColor: Theme.of(context).canvasColor,
          title: Text(
            userProfile.username,
            style: TextStyle(
                fontSize: 22,
                color: _themeProvider.primaryTextColor,
                fontWeight: FontWeight.w600,
                fontFamily: 'Nunito'),
          ),
          leading: TextButton.icon(
            style: TextButton.styleFrom(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
              backgroundColor: Colors.transparent,
            ),
            clipBehavior: Clip.none,
            icon: Icon(
              Icons.arrow_back_rounded,
              color: _themeProvider.primaryTextColor,
            ),
            label: Text(''),
            onPressed: () => Navigator.pop(context),
          ),
          actions: [
            TextButton.icon(
              style: TextButton.styleFrom(
                padding: EdgeInsets.fromLTRB(25, 0, 0, 0),
                backgroundColor: Theme.of(context).canvasColor,
              ),
              clipBehavior: Clip.none,
              icon: Icon(
                Icons.more_vert_rounded,
                color: _themeProvider.primaryTextColor,
              ),
              label: Text(''),
              onPressed: () {
                showModalBottomSheet(
                    backgroundColor: Theme.of(context).dialogBackgroundColor,
                    clipBehavior: Clip.hardEdge,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    context: context,
                    builder: (context) {
                      return BottomSheetActions(
                        profileProvider: _visitProfileProvider,
                        visitProfile:
                            feed.userID != _authService.myUser.userUID,
                      );
                    });
              },
            ),
          ],
          automaticallyImplyLeading: false,
        ),
        body: MainProfilePage(
          visitProfile: feed.userID != _authService.myUser.userUID,
          userProfile: userProfile,
          userID: feed.userID,
          profileBlogsProvider: profileBlogsProvider,
          profileAllPostsView: profileAllPostsView,
          bottomNavVisible: false,
        ),
      ),
    );
  }
}

class BottomSheetActions extends StatefulWidget {
  final VisitProfileProvider profileProvider;
  final bool visitProfile;

  BottomSheetActions({
    this.profileProvider,
    this.visitProfile,
  });

  @override
  _BottomSheetActionsState createState() => _BottomSheetActionsState();
}

class _BottomSheetActionsState extends State<BottomSheetActions> {
  bool _followLoading = false;

  @override
  Widget build(BuildContext context) {
    MyUser _userProfile = widget.profileProvider.userProfile;
    ProfileDBService _profileDBService = Provider.of<ProfileDBService>(context);
    final ThemeProvider _themeProvider =
        Provider.of<ThemeProvider>(context, listen: false);

    return Container(
      color: Colors.transparent,
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
                padding: EdgeInsets.all(15),
                primary: Theme.of(context).dialogBackgroundColor,
                backgroundColor: Theme.of(context).dialogBackgroundColor,
              ),
              onPressed: () {
                if (widget.visitProfile) {
                  MyUser _reportUser = widget.profileProvider.userProfile;
                  print(_reportUser.username);
                  Navigator.pop(context);
                  showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) {
                        return ReportUserDialog(
                          user: _reportUser,
                        );
                      });
                  // _profileDBService.reportPost();
                }
              },
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Report user...',
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
                padding: EdgeInsets.all(15),
                primary: Theme.of(context).dialogBackgroundColor,
                backgroundColor: Theme.of(context).dialogBackgroundColor,
              ),
              onPressed: () {},
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Block',
                  style: TextStyle(
                    color: _themeProvider.primaryTextColor,
                    fontSize: 16,
                    fontFamily: 'Nunito',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
          Divider(thickness: 0.5, height: 0),
          Visibility(
            visible: widget.visitProfile,
            child: Container(
              margin: EdgeInsets.all(0),
              height: 60,
              child: TextButton(
                style: TextButton.styleFrom(
                  padding: EdgeInsets.all(15),
                  primary: Theme.of(context).dialogBackgroundColor,
                  backgroundColor: Theme.of(context).dialogBackgroundColor,
                ),
                onPressed: () async {
                  setState(() => _followLoading = true);

                  bool _isFollowing =
                      !widget.profileProvider.userProfile.isFollowing;

                  await _profileDBService
                      .updateFollowing(
                    profileUID: widget.profileProvider.userProfile.userUID,
                    isFollowing: _isFollowing,
                    //only if unfollow then give Public
                    usersPublicFollowID:
                        _userProfile.usersPublicFollowID ?? null,
                  )
                      .then((publicFollowID) {
                    widget.profileProvider.userProfile.usersPublicFollowID =
                        publicFollowID;

                    _followLoading = false;
                    widget.profileProvider.updateFollowing(_isFollowing);
                    Navigator.pop(context);
                  });
                },
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Visibility(
                    visible: !_followLoading,
                    child: Text(
                      _userProfile.isFollowing ? 'Unfollow' : 'Follow',
                      style: TextStyle(
                        color: _themeProvider.primaryTextColor,
                        fontSize: 16,
                        fontFamily: 'Nunito',
                        fontWeight: FontWeight.w600,
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
                padding: EdgeInsets.all(15),
                primary: Theme.of(context).dialogBackgroundColor,
                backgroundColor: Theme.of(context).dialogBackgroundColor,
              ),
              onPressed: () {},
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Share this profile',
                  style: TextStyle(
                    color: _themeProvider.primaryTextColor,
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
