import "package:url_launcher/url_launcher.dart";
import "package:versify/providers/providers_home/theme_data_provider.dart";
import "package:versify/screens/profile/settings/account_edit_row.dart";
import "package:versify/screens/profile/settings/account_privacy.dart";
import "package:versify/screens/profile/settings/account_provider.dart";
import "package:versify/screens/profile/settings/account_report_problem.dart";
import "package:versify/screens/profile/settings/account_verify_new_email.dart";
import 'package:versify/screens/profile/settings/sub-settings/account_change_email.dart';
import 'package:versify/screens/profile/settings/sub-settings/account_change_password.dart';
import 'package:versify/screens/profile/settings/widgets/acc_widget_password.dart';
import 'package:versify/screens/profile/settings/widgets/acc_widget_signin_provider.dart';
import "package:versify/screens/profile/settings/widgets/webviewer.dart";
import "package:versify/services/firebase/auth.dart";
import "package:versify/shared/widgets/widgets_all_loading.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:flutter_cache_manager/flutter_cache_manager.dart";
import "package:font_awesome_flutter/font_awesome_flutter.dart";
import "package:provider/provider.dart";
import "package:shared_preferences/shared_preferences.dart";
import 'package:versify/screens/profile/settings/sub-settings/account_change_phone.dart';

class AccountSettings extends StatefulWidget {
  static const routeName = "/accountSettings";

  @override
  _AccountSettingsState createState() => _AccountSettingsState();
}

class _AccountSettingsState extends State<AccountSettings> {
  AccountSettingsProvider _accountSettingsProvider;
  AuthService _authService;

  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      //initialize user in accountSettingsProvider (done in wrapper)
      // _accountSettingsProvider.initSettingsUser(_authService.myUser);
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeProvider _themeProvider =
        Provider.of<ThemeProvider>(context, listen: false);
    _authService = Provider.of<AuthService>(context);
    _accountSettingsProvider =
        Provider.of<AccountSettingsProvider>(context, listen: true);

    return WillPopScope(
      onWillPop: () async {
        // popAccountSettings();
        return true;
      },
      child: _authService.getCurrentUser == null
          ? SplashLoading()
          : Scaffold(
              extendBodyBehindAppBar: false,
              backgroundColor: Theme.of(context).backgroundColor,
              appBar: AppBar(
                backgroundColor: Theme.of(context).canvasColor,
                centerTitle: true,
                elevation: 0.5,
                title: Text(
                  "Settings and privacy",
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
                      "ACCOUNT",
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
                            builder: (context) => AccountChangePhone(
                                _authService.getCurrentUser?.phoneNumber
                                            ?.isNotEmpty !=
                                        null
                                    ? _authService.getCurrentUser.phoneNumber
                                    : ""),
                          )),
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
                        child: Row(
                          children: [
                            Icon(
                              Icons.phone,
                              size: 16.5,
                              color: Theme.of(context)
                                  .primaryColor
                                  .withOpacity(0.6),
                            ),
                            SizedBox(width: 10),
                            Text(
                              "Phone number",
                              style: TextStyle(
                                fontSize: 15,
                                color: _themeProvider.primaryTextColor
                                    .withOpacity(0.87),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Expanded(child: Container()),
                            Text(
                              _authService.getCurrentUser?.phoneNumber
                                          ?.isNotEmpty !=
                                      null
                                  ? _authService.getCurrentUser.phoneNumber
                                  : "none",
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
                    AccWidgetSignInProvider(),
                    AccWidgetPassword(_authService.currentSignInProvider),
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () => Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) =>
                                AccountPrivacy(authService: _authService),
                          )),
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              FontAwesomeIcons.lock,
                              size: 15,
                              color: Theme.of(context)
                                  .primaryColor
                                  .withOpacity(0.6),
                            ),
                            SizedBox(width: 10),
                            Text(
                              "Privacy",
                              style: TextStyle(
                                fontSize: 15,
                                color: _themeProvider.primaryTextColor
                                    .withOpacity(0.87),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Expanded(child: Container()),
                            SizedBox(
                              width: 180,
                              child: Text(
                                "More",
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
                      "SUPPPORT",
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
                        Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => AccountReportProblem(),
                            ));
                      },
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.border_color,
                              size: 16.5,
                              color: Theme.of(context)
                                  .primaryColor
                                  .withOpacity(0.6),
                            ),
                            SizedBox(width: 10),
                            Text(
                              "Report a problem",
                              style: TextStyle(
                                fontSize: 15,
                                color: _themeProvider.primaryTextColor
                                    .withOpacity(0.87),
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
                      onTap: () async {
                        String _url =
                            "mailto:versifyapp@gmail.com?subject=❗HELP!%20(Versify's%20Individual%20Support%20Service)&body=How%20can%20we%20help%20you?\n\nDescription:\n\n";

                        await canLaunch(_url)
                            ? await launch(_url)
                            : throw "Could not launch $_url";
                      },
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.help,
                              size: 16.5,
                              color: Theme.of(context)
                                  .primaryColor
                                  .withOpacity(0.6),
                            ),
                            SizedBox(width: 10),
                            Text(
                              "Help",
                              style: TextStyle(
                                fontSize: 15,
                                color: _themeProvider.primaryTextColor
                                    .withOpacity(0.87),
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
                      "ABOUT",
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
                            color:
                                Theme.of(context).primaryColor.withOpacity(0.6),
                          ),
                          SizedBox(width: 10),
                          Text(
                            "Community Guidelines",
                            style: TextStyle(
                              fontSize: 15,
                              color: _themeProvider.primaryTextColor
                                  .withOpacity(0.87),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Expanded(child: Container()),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SettingsWebViewer(
                                      webViewUrl:
                                          "https://versify.flycricket.io/terms.html",
                                      webViewerType:
                                          WebViewerType.termsAndConditions,
                                    )));
                      },
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.book,
                              size: 16.5,
                              color: Theme.of(context)
                                  .primaryColor
                                  .withOpacity(0.6),
                            ),
                            SizedBox(width: 10),
                            Text(
                              "Terms & Conditions",
                              style: TextStyle(
                                fontSize: 15,
                                color: _themeProvider.primaryTextColor
                                    .withOpacity(0.87),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Expanded(child: Container()),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SettingsWebViewer(
                                      webViewUrl:
                                          "https://versify.flycricket.io/privacy.html",
                                      webViewerType:
                                          WebViewerType.privacypolicy,
                                    )));
                      },
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.privacy_tip,
                              size: 16.5,
                              color: Theme.of(context)
                                  .primaryColor
                                  .withOpacity(0.6),
                            ),
                            SizedBox(width: 10),
                            Text(
                              "Privacy Policy",
                              style: TextStyle(
                                fontSize: 15,
                                color: _themeProvider.primaryTextColor
                                    .withOpacity(0.87),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Expanded(child: Container()),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Divider(thickness: 0.5),
                    SizedBox(height: 10),
                    Text(
                      "LOGIN",
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
                        _authService.logout().then((_) async {
                          await deletePrefs();
                          // Navigator.popUntil(context,
                          //     ModalRoute.withName(Navigator.defaultRouteName));
                          await DefaultCacheManager().emptyCache();
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              "/", (Route<dynamic> route) => false);
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
                              color: Theme.of(context)
                                  .primaryColor
                                  .withOpacity(0.6),
                            ),
                            SizedBox(width: 10),
                            Text(
                              "Log out",
                              style: TextStyle(
                                fontSize: 15,
                                color: _themeProvider.primaryTextColor
                                    .withOpacity(0.87),
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
    // prefs.remove("seenDocs");
    // prefs.remove("sortedFollowingList");
    prefs.remove("lastUpdated");
  }
}
