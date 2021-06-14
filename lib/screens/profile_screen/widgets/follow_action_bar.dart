import 'package:share/share.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:versify/models/user_model.dart';
import 'package:versify/providers/home/edit_profile_provider.dart';
import 'package:versify/screens/profile_screen/edit_profile_folder/edit_profile.dart';
import 'package:versify/providers/home/visit_profile_provider.dart';
import 'package:versify/services/auth.dart';
import 'package:versify/services/dynamic_links.dart';
import 'package:versify/services/profile_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileActionBar extends StatefulWidget {
  final bool visitProfile;
  final ProfileDBService profileDBService;
  final EditProfileProvider editProfileProvider;
  final MyUser userProfile;

  ProfileActionBar({
    this.visitProfile,
    this.profileDBService,
    this.editProfileProvider,
    this.userProfile,
  });

  @override
  _ProfileActionBarState createState() => _ProfileActionBarState();
}

class _ProfileActionBarState extends State<ProfileActionBar> {
  // bool _isFollowing = false;
  bool _followLoading = false;
  bool _profileDetailsIsEmpty = false;

  void _launchUrl(String _url) async {
    await canLaunch(_url) ? await launch(_url) : throw 'Could not launch $_url';
  }

  // @override
  // void initState() {
  //   super.initState();
  //   if (!widget.visitProfile) {
  //     //userIsMe
  //     _profileDetailsIsEmpty = widget.userProfile.description.isEmpty ||
  //         widget.userProfile.profileImageUrl.isEmpty;
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    print('Mainprofile ProfileActionBar rebuilt');

    final AuthService _authService = Provider.of<AuthService>(context);
    final EditProfileProvider _editProfileProvider =
        Provider.of<EditProfileProvider>(context, listen: true);

    final VisitProfileProvider _visitProfileProvider =
        Provider.of<VisitProfileProvider>(context, listen: true);

    if (!widget.visitProfile) {
      //userIsMe
      _profileDetailsIsEmpty = _authService.myUser.description.isEmpty ||
          _authService.myUser.profileImageUrl == null;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Visibility(
          visible: widget.visitProfile ? widget.userProfile.isFollowing : true,
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  if (widget.visitProfile) {
                    DynamicLinkService()
                        .createProfileDynamicLink(widget.userProfile.userUID)
                        .then((res) async {
                      Share.share(
                        'Check out this user account on the Versify App!\n$res',
                        subject: 'Versify Blogs',
                      );
                    });
                  } else {
                    //init with authService user
                    widget.editProfileProvider
                        .initProfileUser(_authService.myUser);

                    Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => EditProfile(),
                        ));
                    // showModalBottomSheet(
                    //     backgroundColor: Colors.white,
                    //     shape: RoundedRectangleBorder(
                    //       borderRadius: BorderRadius.only(
                    //         topLeft: Radius.circular(20),
                    //         topRight: Radius.circular(20),
                    //       ),
                    //     ),
                    //     isScrollControlled: false,
                    //     enableDrag: false,
                    //     context: context,
                    //     builder: (context) {
                    //       return EditProfileBottomSheet();
                    //     });
                  }
                },
                child: Stack(
                  children: [
                    Shimmer(
                      enabled: _profileDetailsIsEmpty,
                      duration: Duration(milliseconds: 500),
                      interval: Duration(milliseconds: 500),
                      color: Colors.pink,
                      direction: ShimmerDirection.fromLTRB(),
                      child: Container(
                        height: 40,
                        alignment: Alignment.center,
                        padding: EdgeInsets.fromLTRB(25, 10, 25, 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(3),
                          border: Border.all(color: Colors.black54, width: 0.5),
                        ),
                        child: Text(
                          widget.visitProfile ? 'Share' : 'Edit profile',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.black87,
                            fontFamily: 'Nunito',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 8,
                      right: 10,
                      child: Visibility(
                        visible: _profileDetailsIsEmpty,
                        child: Icon(
                          Icons.circle,
                          color: Theme.of(context).accentColor,
                          size: 10,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                  onTap: () async {
                    if (!_followLoading) {
                      setState(() => _followLoading = true);
                      await widget.profileDBService
                          .updateFollowing(
                        profileUID: widget.userProfile.userUID,
                        isFollowing: false,
                        usersPublicFollowID:
                            widget.userProfile.usersPublicFollowID,
                      )
                          .then((publicFollowID) {
                        widget.userProfile.usersPublicFollowID = publicFollowID;
                        // _isFollowing = false;
                        _followLoading = false;
                        _visitProfileProvider.updateFollowing(false);
                      });
                    }
                  },
                  child: widget.visitProfile
                      ? Container(
                          height: 40,
                          width: 40,
                          padding: EdgeInsets.all(4),
                          alignment: Alignment.center,
                          margin: EdgeInsets.fromLTRB(5, 0, 0, 0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(3),
                            border:
                                Border.all(color: Colors.black54, width: 0.5),
                          ),
                          child: Visibility(
                            visible: !_followLoading,
                            child: Icon(
                              FontAwesomeIcons.userCheck,
                              size: 18,
                              color: Colors.black87,
                            ),
                            replacement: SizedBox(
                              height: 15,
                              width: 15,
                              child: CircularProgressIndicator(
                                strokeWidth: 0.5,
                              ),
                            ),
                          ))
                      : SizedBox.shrink()),
            ],
          ),
          replacement: GestureDetector(
            onTap: () async {
              if (!_authService.isUserAnonymous) {
                if (!_followLoading) {
                  print('Follow onTap() with hash provider: ' +
                      widget.hashCode.toString());
                  setState(() => _followLoading = true);

                  await widget.profileDBService
                      .updateFollowing(
                    profileUID: widget.userProfile.userUID,
                    isFollowing: true,
                    usersPublicFollowID: widget.userProfile.usersPublicFollowID,
                  )
                      .then((publicFollowID) {
                    widget.userProfile.usersPublicFollowID = publicFollowID;
                    _followLoading = false;
                    _visitProfileProvider.updateFollowing(true);

                    // _isFollowing = true;
                  });
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Padding(
                  padding: EdgeInsets.all(8),
                  child: Text('Sign up to follow'),
                )));
              }
            },
            child: Container(
              height: 40,
              width: 130,
              alignment: Alignment.center,
              padding: EdgeInsets.fromLTRB(25, 10, 25, 10),
              decoration: BoxDecoration(
                color: _followLoading ? Colors.white : Color(0xffff548e),
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(3),
                border: Border.all(
                    color: _followLoading ? Colors.black54 : Color(0xffff548e),
                    width: 0.5),
              ),
              child: Visibility(
                visible: !_followLoading,
                child: Text(
                  'Follow',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                    fontFamily: 'Nunito',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                replacement: SizedBox(
                    height: 15,
                    width: 15,
                    child: CircularProgressIndicator(
                      strokeWidth: 0.5,
                    )),
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () => _launchUrl(widget.userProfile.socialLinks['instagram']),
          child: Container(
              height: 40,
              width: 40,
              padding: EdgeInsets.all(4),
              alignment: Alignment.center,
              margin: EdgeInsets.fromLTRB(5, 0, 0, 0),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(3),
                border: Border.all(color: Colors.black54, width: 0.5),
              ),
              child: Icon(
                FontAwesomeIcons.instagram,
                size: 20,
                color: Colors.black87,
              )),
        ),
        GestureDetector(
          onTap: () => _launchUrl(widget.userProfile.socialLinks['tiktok']),
          child: Container(
              height: 40,
              width: 40,
              padding: EdgeInsets.all(4),
              alignment: Alignment.center,
              margin: EdgeInsets.fromLTRB(5, 0, 0, 0),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(3),
                border: Border.all(color: Colors.black54, width: 0.5),
              ),
              child: Icon(
                FontAwesomeIcons.tiktok,
                size: 18,
                color: Colors.black87,
              )),
        ),
        Container(
            height: 40,
            width: 40,
            padding: EdgeInsets.all(4),
            alignment: Alignment.center,
            margin: EdgeInsets.fromLTRB(5, 0, 0, 0),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(3),
              border: Border.all(color: Colors.black54, width: 0.5),
            ),
            child: Icon(
              Icons.arrow_drop_down,
              size: 22,
              color: Colors.black87,
            )),
      ],
    );
  }
}
