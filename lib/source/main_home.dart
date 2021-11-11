import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:versify/providers/providers_home/tutorial_provider.dart';
import 'package:versify/screens/app_register/onboarding.dart';
import 'package:versify/services/firebase/auth.dart';
import 'package:versify/services/firebase/dynamic_links.dart';
import 'package:versify/services/json_storage/shared_preferences.dart';
import 'package:versify/shared/helper/helper_classes.dart';
import 'package:versify/shared/helper/helper_methods.dart';
import 'package:versify/shared/widgets/widgets_all_loading.dart';
import 'package:versify/source/wrapper.dart';
import 'package:provider/provider.dart';

class VersifyHome extends StatefulWidget {
  final AuthService authService;
  final DynamicLinkService dynamicLinkService;
  final MySharedPreferences mySharedPreferences;

  const VersifyHome(
      {this.authService, this.dynamicLinkService, this.mySharedPreferences});

  @override
  _VersifyHomeState createState() => _VersifyHomeState();
}

class _VersifyHomeState extends State<VersifyHome> {
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  // providers
  TutorialProvider tutorialProvider;

  // state
  bool _completedBoarding;
  bool _completedTutorial;
  Future<void> _futureInitState;

  // functions
  // Future<void> _saveDeviceToken() async {}
  Future<void> myInitState() async {
    // initState() Check OnBoarding and Tutorial SharedPreferences
    print(purplePen("VersifyHome | myInitState RAN!"));
    _completedBoarding = widget.mySharedPreferences.isCompletedBoarding;
    _completedTutorial = widget.mySharedPreferences.isCompletedTutorial;

    if (!_completedBoarding && !widget.authService.isUserAuthenticated) {
      print(greenPen(
          "VersifyHome | initState() User is new and unauthenticated - signing in anon()!"));
      final ReturnValue result = await widget.authService.signInAnon();
      if (!result.success) {
        toast(result.value);
      }
    }

    // update tutorialProvider after get SharedPreferences
    WidgetsBinding.instance.addPostFrameCallback((_) {
      tutorialProvider.setTutorialComplete(_completedTutorial);
      // widget.authService.logout();
    });
  }

  @override
  void initState() {
    super.initState();
    print(purplePen("VersifyHome | initState() RAN!"));
    if (Platform.isAndroid) {
      firebaseMessaging.getToken().then((token) {
        print(grayPen(
            "VersifyHome | firebaseMessaging.getToken() with token: $token"));
      });
    }

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print(
          purplePen("FirebaseMessaging | listen has message: ${message.data}"));

      if (message.notification != null) {
        print(greenPen("FirebaseMessaging | Message has notification!"));
        print(grayPen("Notification Title: ${message.notification.title}"));

        final SnackBar snackBar = SnackBar(
          content: Padding(
            padding: EdgeInsets.all(8),
            child: Text(
              message.notification.title,
            ),
          ),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        print(purplePen("FirebaseMessaging | snackBar SHOWN"));
      }
    });

    // initState() Dynamic Link
    widget.dynamicLinkService.handleDynamicLink(context);
    _futureInitState = myInitState();
  }

  @override
  Widget build(BuildContext context) {
    tutorialProvider = Provider.of<TutorialProvider>(context, listen: false);

    SystemChrome.setEnabledSystemUIOverlays(
        [SystemUiOverlay.top, SystemUiOverlay.bottom]);

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Theme.of(context).splashColor,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarDividerColor:
            Theme.of(context).dialogBackgroundColor,
        systemNavigationBarColor: Theme.of(context).dialogBackgroundColor,
      ),
    );

    return FutureBuilder(
      future: _futureInitState,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (_completedBoarding) {
            return Wrapper();
          } else {
            return OnBoarding();
          }
        } else {
          return SplashLoading();
        }
      },
    );
  }
}