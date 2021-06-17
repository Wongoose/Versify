import 'package:cached_network_image/cached_network_image.dart';
import 'package:versify/models/user_model.dart';
import 'package:versify/providers/home/edit_profile_provider.dart';
import 'package:versify/screens/profile_screen/edit_profile_folder/edit_specific_row.dart';
import 'package:versify/services/auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  EditProfileProvider _editProfileProvider;
  MyUser _user;

  void popEditProfile() {
    if (_editProfileProvider.hasChanges) {
      showDialog(
          context: context,
          builder: (context) {
            return SimpleDialog(
              title: Align(
                alignment: Alignment.center,
                child: Text(
                  'Unsaved changes',
                  style: TextStyle(fontSize: 23, fontWeight: FontWeight.w600),
                ),
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(30, 15, 30, 10),
                  alignment: Alignment.center,
                  width: 40,
                  child: Text(
                    'If you go back now, your profile will not be updated. ',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                ),
                // Divider(thickness: 0.5, height: 0),
                Container(
                  margin: EdgeInsets.all(0),
                  height: 60,
                  child: FlatButton(
                    materialTapTargetSize: MaterialTapTargetSize.padded,
                    onPressed: () {
                      Navigator.popUntil(context,
                          ModalRoute.withName(Navigator.defaultRouteName));
                    },
                    child: Text(
                      'Don\'t save',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                Divider(thickness: 0.5, height: 0),
                Container(
                  margin: EdgeInsets.all(0),
                  height: 60,
                  child: FlatButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        color: Colors.black38,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            );
          });
    } else {
      Navigator.pop(context);
    }
  }
  // void updateData() {}

  // void initState() {
  //   super.initState();
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     _editProfileProvider.initProfileUser(_user);
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    final AuthService _authService = Provider.of<AuthService>(context);

    // _user = _authService.myUser;

    _editProfileProvider =
        Provider.of<EditProfileProvider>(context, listen: true);

    _user = _editProfileProvider.user;

    print(_user);

    return WillPopScope(
      onWillPop: () {
        popEditProfile();
        return null;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          elevation: 0.5,
          title: Text(
            'Edit Profile',
            style: TextStyle(
              fontSize: 17.5,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          leading: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              popEditProfile();
            },
            child: Icon(
              Icons.arrow_back_rounded,
              color: Colors.black,
              size: 25,
            ),
          ),
          actions: [
            TextButton.icon(
              style: TextButton.styleFrom(
                padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                backgroundColor: Colors.white,
              ),
              label: Text(''),
              icon: Icon(
                Icons.check_rounded,
                size: 28,
                color: _editProfileProvider.hasChanges
                    ? Theme.of(context).primaryColor
                    : Theme.of(context).primaryColor.withOpacity(0.4),
              ),
              onPressed: () {
                if (_editProfileProvider.hasChanges) {
                  DateTime _tempLastUpdated = _authService.myUser.lastUpdated;
                  _editProfileProvider.user.lastUpdated = _tempLastUpdated;
                  _authService.myUser = _editProfileProvider.user;
                  // MyUser(
                  //   userUID: _editProfileProvider.user.userUID,
                  //   username: _editProfileProvider.user.username,
                  //   description: _editProfileProvider.user.description,
                  //   phoneNumber: _editProfileProvider.user.phoneNumber,
                  //   email: _editProfileProvider.user.email,
                  //   socialLinks: _editProfileProvider.user.socialLinks,
                  //   isFollowing: _editProfileProvider.user.isFollowing ?? false,
                  // );

                  //updateProfileDB
                  _editProfileProvider.confirmUpdate();
                  Navigator.pop(context);
                }
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(20, 30, 20, 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.center,
                child: Container(
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(200),
                    child: AspectRatio(
                      aspectRatio: 1 / 1,
                      child: Stack(
                        children: [
                          Image(
                            image: CachedNetworkImageProvider(
                                'https://firebasestorage.googleapis.com/v0/b/goconnect-745e7.appspot.com/o/images%2Ffashion.png?alt=media&token=f2e8484d-6874-420c-9401-615063e53b8d',
                                cacheKey: '1'),
                          ),
                          Container(
                            color: Colors.black26,
                            height: 100,
                            alignment: Alignment.center,
                            child: Icon(
                              Icons.camera_alt_outlined,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Align(
                alignment: Alignment.center,
                child: Text(
                  'Change photo',
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Divider(thickness: 0.5),
              SizedBox(height: 10),
              Text(
                'ACCOUNT',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black45,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 10),
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () => Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) =>
                          EditRowPage(editType: EditType.username),
                    )),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        FontAwesomeIcons.user,
                        size: 15,
                        color: Theme.of(context).primaryColor.withOpacity(0.6),
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Username',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.black87,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Expanded(child: Container()),
                      Text(
                        '@${_user.username}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black45,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(width: 10),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: Colors.black45,
                        size: 15,
                      ),
                    ],
                  ),
                ),
              ),
              // SizedBox(height: 30),
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () => Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => EditRowPage(editType: EditType.bio),
                    )),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        FontAwesomeIcons.pencilAlt,
                        size: 15,
                        color: Theme.of(context).primaryColor.withOpacity(0.6),
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Bio',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.black87,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Expanded(child: Container()),
                      SizedBox(
                        width: 180,
                        child: Text(
                          _user.description ?? 'No bio written . . .',
                          textAlign: TextAlign.end,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black45,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: Colors.black45,
                        size: 15,
                      ),
                    ],
                  ),
                ),
              ),
              // SizedBox(height: 30),
              // GestureDetector(
              //   behavior: HitTestBehavior.translucent,
              //   onTap: () => Navigator.push(
              //       context,
              //       CupertinoPageRoute(
              //         builder: (context) =>
              //             EditRowPage(editType: EditType.phone),
              //       )),
              //   child: Padding(
              //     padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
              //     child: Row(
              //       crossAxisAlignment: CrossAxisAlignment.center,
              //       children: [
              //         Icon(
              //           Icons.phone,
              //           size: 16.5,
              //           color: Theme.of(context).primaryColor.withOpacity(0.6),
              //         ),
              //         SizedBox(width: 10),
              //         Text(
              //           'Contact number',
              //           style: TextStyle(
              //             fontSize: 15,
              //             color: Colors.black87,
              //             fontWeight: FontWeight.w500,
              //           ),
              //         ),
              //         Expanded(child: Container()),
              //         Text(
              //           _user.phoneNumber,
              //           style: TextStyle(
              //             fontSize: 14,
              //             color: Colors.black45,
              //             fontWeight: FontWeight.w500,
              //           ),
              //         ),
              //         SizedBox(width: 10),
              //         Icon(
              //           Icons.arrow_forward_ios_rounded,
              //           color: Colors.black45,
              //           size: 15,
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
              // // SizedBox(height: 30),
              // GestureDetector(
              //   behavior: HitTestBehavior.translucent,
              //   onTap: () => Navigator.push(
              //       context,
              //       CupertinoPageRoute(
              //         builder: (context) =>
              //             EditRowPage(editType: EditType.email),
              //       )),
              //   child: Padding(
              //     padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
              //     child: Row(
              //       crossAxisAlignment: CrossAxisAlignment.center,
              //       children: [
              //         Icon(
              //           Icons.email_outlined,
              //           size: 16.5,
              //           color: Theme.of(context).primaryColor.withOpacity(0.6),
              //         ),
              //         SizedBox(width: 10),
              //         Text(
              //           'Email',
              //           style: TextStyle(
              //             fontSize: 15,
              //             color: Colors.black87,
              //             fontWeight: FontWeight.w500,
              //           ),
              //         ),
              //         Expanded(child: Container()),
              //         Text(
              //           _user.email ?? 'None',
              //           style: TextStyle(
              //             fontSize: 14,
              //             color: Colors.black45,
              //             fontWeight: FontWeight.w500,
              //           ),
              //         ),
              //         SizedBox(width: 10),
              //         Icon(
              //           Icons.arrow_forward_ios_rounded,
              //           color: Colors.black45,
              //           size: 15,
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
              SizedBox(height: 10),
              Divider(thickness: 0.5),
              SizedBox(height: 10),
              Text(
                'SOCIAL LINKS',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black45,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 10),
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () => Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => EditRowPage(
                          editType: EditType.socialLinks,
                          socialLink: 'instagram'),
                    )),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        FontAwesomeIcons.instagram,
                        size: 15,
                        color: Theme.of(context).primaryColor.withOpacity(0.6),
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Instagram',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.black87,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Expanded(child: Container()),
                      SizedBox(
                        width: 180,
                        child: Text(
                          _user.socialLinks['instagram'] ?? 'None',
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.end,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black45,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: Colors.black45,
                        size: 15,
                      ),
                    ],
                  ),
                ),
              ),
              // SizedBox(height: 30),
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () => Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => EditRowPage(
                          editType: EditType.socialLinks, socialLink: 'tiktok'),
                    )),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        FontAwesomeIcons.tiktok,
                        size: 15,
                        color: Theme.of(context).primaryColor.withOpacity(0.6),
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Tiktok',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.black87,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Expanded(child: Container()),
                      SizedBox(
                        width: 180,
                        child: Text(
                          _user.socialLinks['tiktok'] ?? 'None',
                          textAlign: TextAlign.end,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black45,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: Colors.black45,
                        size: 15,
                      ),
                    ],
                  ),
                ),
              ),
              // SizedBox(height: 30),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      FontAwesomeIcons.youtube,
                      size: 15,
                      color: Theme.of(context).primaryColor.withOpacity(0.6),
                    ),
                    SizedBox(width: 10),
                    Text(
                      'YouTube',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Expanded(child: Container()),
                    SizedBox(
                      width: 180,
                      child: Text(
                        _user.socialLinks['youtube'] ?? 'None',
                        textAlign: TextAlign.end,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black45,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Colors.black45,
                      size: 15,
                    ),
                  ],
                ),
              ),
              // SizedBox(height: 30),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      FontAwesomeIcons.link,
                      size: 15,
                      color: Theme.of(context).primaryColor.withOpacity(0.6),
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Personal website',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Expanded(child: Container()),
                    SizedBox(
                      width: 180,
                      child: Text(
                        _user.socialLinks['website'] ?? 'None',
                        textAlign: TextAlign.end,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black45,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Colors.black45,
                      size: 15,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Divider(thickness: 0.5),
              SizedBox(height: 10),
              Text(
                'MORE',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black45,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      FontAwesomeIcons.shoppingBag,
                      size: 15,
                      color: Theme.of(context).primaryColor.withOpacity(0.6),
                    ),
                    SizedBox(width: 10),
                    Text(
                      'E-Shop',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Expanded(child: Container()),
                    Text(
                      'zheng_xiang_wong',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black45,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(width: 10),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Colors.black45,
                      size: 15,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
