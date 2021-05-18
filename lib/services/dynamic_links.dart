import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:versify/services/auth.dart';
import 'package:versify/z-wrappers/post_dynamic_link.dart';
import 'package:versify/z-wrappers/profile_dynamic_link.dart';
import 'package:versify/z-wrappers/wrapper_dynamic_links.dart';

class DynamicLinkService {
  final BuildContext context2;

  DynamicLinkService(this.context2);

  // void addContext(BuildContext context) {
  //   context = context;
  // }

  Future<bool> handleDynamicLink() async {
//Get initial dynamic link if app started with link
    bool _hasDynamicLink;
    final PendingDynamicLinkData data =
        await FirebaseDynamicLinks.instance.getInitialLink();

    _hasDynamicLink = await _handleDynamicLink(data);

    // Open link when app is already in the background
    FirebaseDynamicLinks.instance.onLink(onSuccess: (dynamicLinkData) async {
      _hasDynamicLink = await _handleDynamicLink(dynamicLinkData);
    }, onError: (err) async {
      print('handleDynamicLink onError | ERROR: $err');
      _hasDynamicLink = false;
    });
    return _hasDynamicLink;
  }

  Future<bool> _handleDynamicLink(PendingDynamicLinkData data) async {
    final Uri deepLink = data?.link;

    if (deepLink != null) {
      print('_handleDynamicLink | deepLink is: $deepLink');

      bool isProfile = deepLink.pathSegments.contains('profile');
      bool isPost = deepLink.pathSegments.contains('post');
      print('isProfile | is: ${isProfile.toString()}');
      print('isPost | is: ${isPost.toString()}');

      // AuthService().signInAnon();

      if (isPost) {
        String postId = deepLink.queryParameters['post-id'];
        if (postId != null) {
          //Navigate to post screen EXAMPLE
          Navigator.of(context2).push(MaterialPageRoute(
              builder: (context) => DynamicLinkPost(postId: postId)));

          print('isPost | Post ID is: $postId');
        }
      } else if (isProfile) {
        String userId = deepLink.queryParameters['user-id'];
        if (userId != null) {
          //Navigate to user screen EXAMPLE
          Navigator.of(context2).push(MaterialPageRoute(
              builder: (context) => DynamicLinkProfile(userId: userId)));

          print('isProfile | Profile ID is: $userId');
        }
      }
      return true;
    } else {
      return false;
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