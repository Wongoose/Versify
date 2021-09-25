import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:versify/providers/home/theme_data_provider.dart';
import 'package:versify/services/auth.dart';
import 'package:versify/services/profile_database.dart';

enum PrivacySwitches { privateAccount, disableSharing, hideInteraction }

class AccountPrivacy extends StatefulWidget {
  final AuthService authService;
  AccountPrivacy({this.authService});

  @override
  _AccountPrivacyState createState() => _AccountPrivacyState();
}

class _AccountPrivacyState extends State<AccountPrivacy> {
  ProfileDBService _profileDBService;
  bool boolPrivateAcc = false;
  bool boolDisableSharing = false;
  bool boolHideInteraction = false;

  @override
  void initState() {
    super.initState();
    boolPrivateAcc = widget.authService.myUser.isPrivateAccount ?? false;
    boolDisableSharing = widget.authService.myUser.isDisableSharing ?? false;
    boolHideInteraction =
        widget.authService.myUser.isHideContentInteraction ?? false;

    print('initPrivateAccount: ' + boolPrivateAcc.toString());
    print('initDisableSharing: ' + boolDisableSharing.toString());
    print('initHideInteraction: ' + boolHideInteraction.toString());
  }

  switchPrivacySettings(PrivacySwitches privacySwitch, bool switchBool) {
    bool hasError = false;
    switch (privacySwitch) {
      case PrivacySwitches.privateAccount:
        setState(() => boolPrivateAcc = switchBool);
        _profileDBService
            .updatePrivacySettings(
          privacySwitch: privacySwitch,
          switchBool: switchBool,
          user: widget.authService.myUser,
        )
            .then((err) {
          if (!err) {
            hasError = false;
            widget.authService.myUser.isPrivateAccount = switchBool;
          } else {
            setState(() => boolPrivateAcc = !switchBool);
            hasError = true;
          }
        });
        break;
      case PrivacySwitches.disableSharing:
        setState(() => boolDisableSharing = switchBool);
        _profileDBService
            .updatePrivacySettings(
          privacySwitch: privacySwitch,
          switchBool: switchBool,
          user: widget.authService.myUser,
        )
            .then((err) {
          if (!err) {
            widget.authService.myUser.isDisableSharing = switchBool;
          } else {
            setState(() => boolDisableSharing = !switchBool);
            hasError = true;
          }
        });
        break;
      case PrivacySwitches.hideInteraction:
        setState(() => boolHideInteraction = switchBool);
        _profileDBService
            .updatePrivacySettings(
          privacySwitch: privacySwitch,
          switchBool: switchBool,
          user: widget.authService.myUser,
        )
            .then((err) {
          if (!err) {
            widget.authService.myUser.isHideContentInteraction = switchBool;
          } else {
            setState(() => boolHideInteraction = !switchBool);
            hasError = true;
          }
        });
        // TODO: Handle this case.
        break;
    }
    if (hasError) {
      toast(
          'Failed to update privacy settings. Please check your network connection and try again.');
    } else {
      toast('Updated Privacy Settings');
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeProvider _themeProvider =
        Provider.of<ThemeProvider>(context, listen: false);
    // final AuthService _authService = Provider.of<AuthService>(context);
    _profileDBService = Provider.of<ProfileDBService>(context);

    return WillPopScope(
      onWillPop: () async {
        if (Navigator.of(context).userGestureInProgress)
          return false;
        else
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
            'Privacy',
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
                'ACCOUNT PRIVACY',
                style: TextStyle(
                  fontSize: 14,
                  color: _themeProvider.secondaryTextColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 10),
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  // return Navigator.push(
                  //   context,
                  //   CupertinoPageRoute(
                  //     builder: (context) =>
                  //         AccountEditRow(editType: AccountEditType.phone),
                  //   ));
                },
                child: Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
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
                        'Private account',
                        style: TextStyle(
                          fontSize: 15,
                          color:
                              _themeProvider.primaryTextColor.withOpacity(0.87),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Expanded(child: Container()),
                      Switch(
                        value: boolPrivateAcc,
                        onChanged: (bool value) {
                          switchPrivacySettings(
                              PrivacySwitches.privateAccount, value);
                        },
                      ),
//switch

                      // Text(
                      //   _authService.getCurrentUser.phoneNumber == null
                      //       ? 'none'
                      //       : _authService.getCurrentUser.phoneNumber,
                      //   style: TextStyle(
                      //     fontSize: 14,
                      //     color: _themeProvider.secondaryTextColor,
                      //     fontWeight: FontWeight.w500,
                      //   ),
                      // ),
                      // SizedBox(width: 10),
                      // Icon(
                      //   Icons.arrow_forward_ios_rounded,
                      //   color: _themeProvider.secondaryTextColor,
                      //   size: 15,
                      // ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                child: Text(
                  'With a private account, your profile will be hidden from everyone, only you can see it.',
                  style: TextStyle(
                    height: 1.7,
                    fontSize: 12,
                    color: _themeProvider.secondaryTextColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(height: 10),
              Divider(thickness: 0.5),
              SizedBox(height: 10),
              Text(
                'POST INTERACTION',
                style: TextStyle(
                  fontSize: 14,
                  color: _themeProvider.secondaryTextColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      FontAwesomeIcons.shareAlt,
                      size: 15,
                      color: Theme.of(context).primaryColor.withOpacity(0.6),
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Disable sharing',
                      style: TextStyle(
                        fontSize: 15,
                        color:
                            _themeProvider.primaryTextColor.withOpacity(0.87),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Expanded(child: Container()),
                    Switch(
                      value: boolDisableSharing,
                      onChanged: (bool value) {
                        switchPrivacySettings(
                            PrivacySwitches.disableSharing, value);
                      },
                    )
                  ],
                ),
              ),
              SizedBox(
                child: Text(
                  'When you disable sharing, people cannot share your post.',
                  style: TextStyle(
                    height: 1.7,
                    fontSize: 12,
                    color: _themeProvider.secondaryTextColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      FontAwesomeIcons.eyeSlash,
                      size: 15,
                      color: Theme.of(context).primaryColor.withOpacity(0.6),
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Hide views, likes...',
                      style: TextStyle(
                        fontSize: 15,
                        color:
                            _themeProvider.primaryTextColor.withOpacity(0.87),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Expanded(child: Container()),
                    Switch(
                      value: boolHideInteraction,
                      onChanged: (bool value) {
                        switchPrivacySettings(
                            PrivacySwitches.hideInteraction, value);
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(
                child: Text(
                  'When enabled, the number of views, likes, and shares in your posts will be hidden.',
                  style: TextStyle(
                    height: 1.7,
                    fontSize: 12,
                    color: _themeProvider.secondaryTextColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              // SizedBox(height: 10),
              // Divider(thickness: 0.5),
              // SizedBox(height: 10),
              // Text(
              //   'PERSONALIZATION',
              //   style: TextStyle(
              //     fontSize: 14,
              //     color: _themeProvider.secondaryTextColor,
              //     fontWeight: FontWeight.w600,
              //   ),
              // ),
              // SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
