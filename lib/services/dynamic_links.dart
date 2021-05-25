import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:versify/services/auth.dart';
import 'package:versify/z-dynamic_link/post_dynamic_link.dart';
import 'package:versify/z-dynamic_link/profile_dynamic_link.dart';
import 'package:versify/z-dynamic_link/wrapper_dynamic_links.dart';

class DynamicLinkService {
  final AuthService authService;
  DynamicLinkService({this.authService});
  // void addContext(BuildContext context) {
  //   context = context;
  // }

  Future<bool> handleDynamicLink(BuildContext context) async {
//Get initial dynamic link if app started with link
//BACK button is pop app
    bool _hasDynamicLink;
    final PendingDynamicLinkData data =
        await FirebaseDynamicLinks.instance.getInitialLink();

    _hasDynamicLink =
        await _handleDynamicLink(data, context, onPopExitApp: true);

    // Open link when app is already in the background
    //BACK button is pop context to homewrapper
    FirebaseDynamicLinks.instance.onLink(
      onSuccess: (dynamicLinkData) async {
        _hasDynamicLink = await _handleDynamicLink(dynamicLinkData, context,
            onPopExitApp: false);
      },
      onError: (err) async {
        print('handleDynamicLink onError | ERROR: $err');
        _hasDynamicLink = false;
      },
    );
    return _hasDynamicLink;
  }

  Future<bool> _handleDynamicLink(
      PendingDynamicLinkData data, BuildContext context,
      {bool onPopExitApp}) async {
    final Uri deepLink = data?.link;

    if (deepLink != null) {
      print('_handleDynamicLink | deepLink is: $deepLink');

      bool isProfile = deepLink.pathSegments.contains('profile');
      bool isPost = deepLink.pathSegments.contains('post');
      print('isProfile | is: ${isProfile.toString()}');
      print('isPost | is: ${isPost.toString()}');

      if (!authService.isUserSignedIn) {
        //not signed in
        await AuthService().signInAnon().then((res) async {
          if (res) {
            _navigateAfterHandleLink(
              deepLink: deepLink,
              isPost: isPost,
              isProfile: isProfile,
              context: context,
              onPopExitApp: onPopExitApp,
            );
          }
        });
      } else {
        _navigateAfterHandleLink(
          deepLink: deepLink,
          isPost: isPost,
          isProfile: isProfile,
          context: context,
          onPopExitApp: onPopExitApp,
        );
      }

      return true;
    } else {
      return false;
    }
  }

  void _navigateAfterHandleLink(
      {Uri deepLink,
      bool isPost,
      bool isProfile,
      BuildContext context,
      bool onPopExitApp}) {
    if (isPost) {
      String postId = deepLink.queryParameters['post-id'];
      if (postId != null) {
        //Navigate to post screen EXAMPLE
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => DynamicLinkPost(postId: postId, onPopExitApp: onPopExitApp)));

        print('isPost | Post ID is: $postId');
      }
    } else if (isProfile) {
      String userId = deepLink.queryParameters['user-id'];
      if (userId != null) {
        //Navigate to user screen EXAMPLE
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => DynamicLinkProfile(userId: userId)));

        print('isProfile | Profile ID is: $userId');
      }
    }
  }

  Future<String> createPostDynamicLink(String postId) async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://versify.wongoose.com',
      link: Uri.parse('https://versifyapp.com/post?post-id=$postId'),
      androidParameters: AndroidParameters(packageName: 'com.wongoose.versify'),
    );
    // final Uri dynamicUrl = await parameters.buildShortLink();

    final ShortDynamicLink shortDynamicLink = await parameters.buildShortLink();
    final Uri shortUrl = shortDynamicLink.shortUrl;

    print('createPostDynamicLink | dynamicShortUrl: ${shortUrl.toString()}');

    return shortUrl.toString();
  }

  Future<String> createProfileDynamicLink(String userId) async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://versify.wongoose.com',
      link: Uri.parse('https://versifyapp.com/profile?user-id=$userId'),
      androidParameters: AndroidParameters(packageName: 'com.wongoose.versify'),
    );

    final ShortDynamicLink shortDynamicLink = await parameters.buildShortLink();
    final Uri shortUrl = shortDynamicLink.shortUrl;

    print('createProfileDynamicLink | dynamicShortUrl: ${shortUrl.toString()}');

    return shortUrl.toString();
  }
}
