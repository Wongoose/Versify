import "package:versify/providers/providers_home/theme_data_provider.dart";
import "package:versify/screens/profile/settings/account_provider.dart";
import 'package:versify/screens/profile/settings/widgets/acc_widget_help.dart';
import 'package:versify/screens/profile/settings/widgets/acc_widget_logout.dart';
import 'package:versify/screens/profile/settings/widgets/acc_widget_password.dart';
import 'package:versify/screens/profile/settings/widgets/acc_widget_phone.dart';
import 'package:versify/screens/profile/settings/widgets/acc_widget_privacy.dart';
import 'package:versify/screens/profile/settings/widgets/acc_widget_privacy_policy.dart';
import 'package:versify/screens/profile/settings/widgets/acc_widget_report_problem.dart';
import 'package:versify/screens/profile/settings/widgets/acc_widget_signin_provider.dart';
import 'package:versify/screens/profile/settings/widgets/acc_widget_terms.dart';
import "package:versify/services/firebase/auth.dart";
import "package:versify/shared/widgets/widgets_all_loading.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";

class AccountSettings extends StatefulWidget {
  static const routeName = "/accountSettings";

  @override
  _AccountSettingsState createState() => _AccountSettingsState();
}

class _AccountSettingsState extends State<AccountSettings> {
  AuthService _authService;

  @override
  Widget build(BuildContext context) {
    final ThemeProvider _themeProvider =
        Provider.of<ThemeProvider>(context, listen: false);
    _authService = Provider.of<AuthService>(context);

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
                    // SECTION ACCOUNT
                    Text(
                      "ACCOUNT",
                      style: TextStyle(
                        fontSize: 14,
                        color: _themeProvider.secondaryTextColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 10),
                    // ITEM 1
                    AccWidgetPhone(
                        parsedHasPhoneNumber: _authService
                                .getCurrentUser?.phoneNumber?.isNotEmpty !=
                            null),
                    // ITEM 2
                    AccWidgetSignInProvider(),
                    // ITEM 3
                    AccWidgetPassword(_authService.currentSignInProvider),
                    // ITEM 4
                    AccWidgetPrivacy(),
                    SizedBox(height: 10),
                    Divider(thickness: 0.5),
                    SizedBox(height: 10),
                    // NEW SECTION
                    Text(
                      "SUPPPORT",
                      style: TextStyle(
                        fontSize: 14,
                        color: _themeProvider.secondaryTextColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 10),
                    // ITEM 5
                    AccWidgetReportProblem(),
                    // ITEM 6
                    AccWidgetHelp(),
                    SizedBox(height: 10),
                    Divider(thickness: 0.5),
                    SizedBox(height: 10),
                    // NEW SECTION
                    Text(
                      "ABOUT",
                      style: TextStyle(
                        fontSize: 14,
                        color: _themeProvider.secondaryTextColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 10),
                    // ITEM 7
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
                      child: Row(
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
                    // ITEM 8
                    AccWidgetTerms(),
                    // ITEM 9
                    AccWidgetPrivacyPolicy(),
                    SizedBox(height: 10),
                    Divider(thickness: 0.5),
                    SizedBox(height: 10),
                    // NEW SECTION
                    Text(
                      "LOGIN",
                      style: TextStyle(
                        fontSize: 14,
                        color: _themeProvider.secondaryTextColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 10),
                    AccWidgetLogout(),
                  ],
                ),
              ),
            ),
    );
  }

//   Future<void> deletePrefs() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     // prefs.remove("seenDocs");
//     // prefs.remove("sortedFollowingList");
//     prefs.remove("lastUpdated");
//   }
}
