import 'package:cached_network_image/cached_network_image.dart';
import 'package:versify/models/user_model.dart';
import 'package:versify/providers/home/edit_profile_provider.dart';
import 'package:versify/providers/home/theme_data_provider.dart';
import 'package:versify/screens/profile_screen/edit_profile_folder/edit_specific_row.dart';
import 'package:versify/screens/profile_screen/settings/account_edit_row.dart';
import 'package:versify/screens/profile_screen/settings/account_provider.dart';
import 'package:versify/services/auth.dart';
import 'package:versify/wrapper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountSettings extends StatefulWidget {
  static const routeName = '/accountSettings';

  @override
  _AccountSettingsState createState() => _AccountSettingsState();
}

class _AccountSettingsState extends State<AccountSettings> {
  AccountSettingsProvider _accountSettingsProvider;
  MyUser _user;

  // void popAccountSettings() {
  //   if () {
  //     showDialog(
  //         context: context,
  //         builder: (context) {
  //           return SimpleDialog(
  //             title: Align(
  //               alignment: Alignment.center,
  //               child: Text(
  //                 'Unsaved changes',
  //                 style: TextStyle(fontSize: 23, fontWeight: FontWeight.w600),
  //               ),
  //             ),
  //             contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
  //             shape: RoundedRectangleBorder(
  //                 borderRadius: BorderRadius.circular(10.0)),
  //             children: [
  //               Container(
  //                 padding: EdgeInsets.fromLTRB(30, 15, 30, 10),
  //                 alignment: Alignment.center,
  //                 width: 40,
  //                 child: Text(
  //                   'If you go back now, your profile will not be updated. ',
  //                   textAlign: TextAlign.center,
  //                   style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
  //                 ),
  //               ),
  //               // Divider(thickness: 0.5, height: 0),
  //               Container(
  //                 margin: EdgeInsets.all(0),
  //                 height: 60,
  //                 child: FlatButton(
  //                   materialTapTargetSize: MaterialTapTargetSize.padded,
  //                   onPressed: () {
  //                     Navigator.popUntil(context,
  //                         ModalRoute.withName(Navigator.defaultRouteName));
  //                   },
  //                   child: Text(
  //                     'Don\'t save',
  //                     style: TextStyle(
  //                       color: Colors.red,
  //                       fontSize: 16,
  //                       fontWeight: FontWeight.w600,
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //               Divider(thickness: 0.5, height: 0),
  //               Container(
  //                 margin: EdgeInsets.all(0),
  //                 height: 60,
  //                 child: FlatButton(
  //                   onPressed: () {
  //                     Navigator.pop(context);
  //                   },
  //                   child: Text(
  //                     'Cancel',
  //                     style: TextStyle(
  //                       color: _themeProvider.primaryTextColor38,
  //                       fontSize: 16,
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           );
  //         });
  //   } else {
  //     Navigator.pop(context);
  //   }
  // }
  // void updateData() {}

  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _accountSettingsProvider.initProfileUser(_user);
    });
  }

  @override
  Widget build(BuildContext context) {
    final AuthService _authService = Provider.of<AuthService>(context);
    final ThemeProvider _themeProvider =
        Provider.of<ThemeProvider>(context, listen: false);

    _accountSettingsProvider =
        Provider.of<AccountSettingsProvider>(context, listen: true);

    _user = _authService.myUser;

    print(_user);

    return WillPopScope(
      onWillPop: () async {
        // popAccountSettings();
        return true;
      },
      child: Scaffold(
        extendBodyBehindAppBar: false,
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          backgroundColor: Theme.of(context).canvasColor,
          centerTitle: true,
          elevation: 0.5,
          title: Text(
            'Settings and privacy',
            style: TextStyle(
              fontSize: 17.5,
              fontWeight: FontWeight.w600,
              color: _themeProvider.primaryTextColor,
            ),
          ),
          leading: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              // popAccountSettings();
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back_rounded,
              color: _themeProvider.primaryTextColor,
              size: 25,
            ),
          ),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(20, 30, 20, 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'ACCOUNT',
                style: TextStyle(
                  fontSize: 14,
                  color: _themeProvider.secondaryTextColor,
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
                          AccountEditRow(editType: AccountEditType.phone),
                    )),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.phone,
                        size: 16.5,
                        color: Theme.of(context).primaryColor.withOpacity(0.6),
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Phone number',
                        style: TextStyle(
                          fontSize: 15,
                          color:
                              _themeProvider.primaryTextColor.withOpacity(0.87),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Expanded(child: Container()),
                      Text(
                        '${_user.phoneNumber}',
                        style: TextStyle(
                          fontSize: 14,
                          color: _themeProvider.secondaryTextColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(width: 10),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: _themeProvider.secondaryTextColor,
                        size: 15,
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () => Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) =>
                          AccountEditRow(editType: AccountEditType.email),
                    )),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.email_rounded,
                        size: 16.5,
                        color: Theme.of(context).primaryColor.withOpacity(0.6),
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Email',
                        style: TextStyle(
                          fontSize: 15,
                          color:
                              _themeProvider.primaryTextColor.withOpacity(0.87),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Expanded(child: Container()),
                      Text(
                        '${_user.email}',
                        style: TextStyle(
                          fontSize: 14,
                          color: _themeProvider.secondaryTextColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(width: 10),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: _themeProvider.secondaryTextColor,
                        size: 15,
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                // onTap: () => Navigator.push(
                //     context,
                //     CupertinoPageRoute(
                //       builder: (context) =>
                //           EditRowPage(editType: EditType.username),
                //     )),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        FontAwesomeIcons.key,
                        size: 15,
                        color: Theme.of(context).primaryColor.withOpacity(0.6),
                      ),
                      SizedBox(width: 10),
                      //hide this widget if using Google/Facebook
                      Text(
                        'Password',
                        style: TextStyle(
                          fontSize: 15,
                          color:
                              _themeProvider.primaryTextColor.withOpacity(0.87),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Expanded(child: Container()),
                      Text(
                        'Secured',
                        style: TextStyle(
                          fontSize: 14,
                          color: _themeProvider.secondaryTextColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(width: 10),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: _themeProvider.secondaryTextColor,
                        size: 15,
                      ),
                    ],
                  ),
                ),
              ),
              // SizedBox(height: 30),
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                // onTap: () => Navigator.push(
                //     context,
                //     CupertinoPageRoute(
                //       builder: (context) => EditRowPage(editType: EditType.bio),
                //     )),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        FontAwesomeIcons.lock,
                        size: 15,
                        color: Theme.of(context).primaryColor.withOpacity(0.6),
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Privacy',
                        style: TextStyle(
                          fontSize: 15,
                          color:
                              _themeProvider.primaryTextColor.withOpacity(0.87),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Expanded(child: Container()),
                      SizedBox(
                        width: 180,
                        child: Text(
                          'More',
                          textAlign: TextAlign.end,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14,
                            color: _themeProvider.secondaryTextColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: _themeProvider.secondaryTextColor,
                        size: 15,
                      ),
                    ],
                  ),
                ),
              ),
              // SizedBox(height: 30),

              SizedBox(height: 10),
              Divider(thickness: 0.5),
              SizedBox(height: 10),
              Text(
                'SUPPPORT',
                style: TextStyle(
                  fontSize: 14,
                  color: _themeProvider.secondaryTextColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 10),
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                // onTap: () => Navigator.push(
                //     context,
                //     CupertinoPageRoute(
                //       builder: (context) => EditRowPage(
                //           editType: EditType.socialLinks,
                //           socialLink: 'instagram'),
                //     )),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.border_color,
                        size: 16.5,
                        color: Theme.of(context).primaryColor.withOpacity(0.6),
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Report a problem',
                        style: TextStyle(
                          fontSize: 15,
                          color:
                              _themeProvider.primaryTextColor.withOpacity(0.87),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Expanded(child: Container()),
                    ],
                  ),
                ),
              ),
              // SizedBox(height: 30),
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                // onTap: () => Navigator.push(
                //     context,
                //     CupertinoPageRoute(
                //       builder: (context) => EditRowPage(
                //           editType: EditType.socialLinks, socialLink: 'tiktok'),
                //     )),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.help,
                        size: 16.5,
                        color: Theme.of(context).primaryColor.withOpacity(0.6),
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Help',
                        style: TextStyle(
                          fontSize: 15,
                          color:
                              _themeProvider.primaryTextColor.withOpacity(0.87),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Expanded(child: Container()),
                    ],
                  ),
                ),
              ),
              // SizedBox(height: 30),

              SizedBox(height: 10),
              Divider(thickness: 0.5),
              SizedBox(height: 10),
              Text(
                'ABOUT',
                style: TextStyle(
                  fontSize: 14,
                  color: _themeProvider.secondaryTextColor,
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
                      Icons.group,
                      size: 16.5,
                      color: Theme.of(context).primaryColor.withOpacity(0.6),
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Community Guidelines',
                      style: TextStyle(
                        fontSize: 15,
                        color:
                            _themeProvider.primaryTextColor.withOpacity(0.87),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Expanded(child: Container()),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.book,
                      size: 16.5,
                      color: Theme.of(context).primaryColor.withOpacity(0.6),
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Terms & Conditions',
                      style: TextStyle(
                        fontSize: 15,
                        color:
                            _themeProvider.primaryTextColor.withOpacity(0.87),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Expanded(child: Container()),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.privacy_tip,
                      size: 16.5,
                      color: Theme.of(context).primaryColor.withOpacity(0.6),
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Privacy Policy',
                      style: TextStyle(
                        fontSize: 15,
                        color:
                            _themeProvider.primaryTextColor.withOpacity(0.87),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Expanded(child: Container()),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Divider(thickness: 0.5),
              SizedBox(height: 10),
              Text(
                'LOGIN',
                style: TextStyle(
                  fontSize: 14,
                  color: _themeProvider.secondaryTextColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 10),
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () async {
                  await _authService.logout().then((value) async {
                    deletePrefs();
                    // Navigator.popUntil(context,
                    //     ModalRoute.withName(Navigator.defaultRouteName));
                    await DefaultCacheManager().emptyCache();
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        '/', (Route<dynamic> route) => false);
                  });
                },
                child: Padding(
                  padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.logout,
                        size: 16.5,
                        color: Theme.of(context).primaryColor.withOpacity(0.6),
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Log out',
                        style: TextStyle(
                          fontSize: 15,
                          color:
                              _themeProvider.primaryTextColor.withOpacity(0.87),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Expanded(child: Container()),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> deletePrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // prefs.remove('seenDocs');
    // prefs.remove('sortedFollowingList');
    prefs.remove('lastUpdated');
  }
}
