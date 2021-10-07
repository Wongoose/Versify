import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:versify/dynamic_links/dynamic_link_profile.dart';
import 'package:versify/models/user_model.dart';
import 'package:versify/providers/providers_home/dynamic_link_provider.dart';
import 'package:versify/services/firebase/auth.dart';
import 'package:versify/services/firebase/profile_database.dart';
import 'package:versify/dynamic_links/dynamic_link_post.dart';

class DynamicLinkService {
  final AuthService authService;
  final DynamicLinkProvider dynamicLinkProvider;
  DynamicLinkService({this.dynamicLinkProvider, this.authService});
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
    Uri deepLink;
    if (data?.link.toString().contains('email')) {
      print('_handleDynamicLink | data contains "email"');
      String link =
          data?.link.toString().split('link=')[1].replaceAll('%3D', '=');

      print('_handleDynamicLink | split link as string: $link');
      deepLink = Uri.parse(link);
      print(
          '_handleDynamicLink | deepLink Uri.parse(link) is: ${deepLink.toString()}');
    } else {
      deepLink = data?.link;
      print('_handleDynamicLink | does not contain "email": ' +
          deepLink.toString());
    }
    // if (deepLink.queryParameters.containsKey('link')) {
    //   deepLink = Uri.parse(deepLink.queryParameters['link']);
    //   print('deepLink containes "link" | deepLink is: $deepLink');
    // }
    //   print('before | deepLink is: $deepLink');

    if (deepLink != null) {
      print('_handleDynamicLink | deepLink is: $deepLink');

      bool isProfile = deepLink.pathSegments.contains('profile');
      bool isPost = deepLink.pathSegments.contains('post');
      bool isResetEmail = deepLink.pathSegments.contains('reset-email');
      bool isVerifyEmail = deepLink.pathSegments.contains('verify-email');
      print('isProfile | is: ${isProfile.toString()}');
      print('isPost | is: ${isPost.toString()}');
      print('isResetEmail | is: ${isResetEmail.toString()}');
      print('isVerifyEmail | is: ${isVerifyEmail.toString()}');

      if (!authService.isUserAuthenticated) {
        //not signed in
        await authService.signInAnon().then((res) async {
          if (res) {
            authService.hasFirestoreDocuments = false;

            _navigateAfterHandleLink(
              deepLink: deepLink,
              isPost: isPost,
              isProfile: isProfile,
              isResetEmail: isResetEmail,
              isVerifyEmail: isVerifyEmail,
              context: context,
              onPopExitApp: onPopExitApp,
            );
          }
        });
      } else {
        ProfileDBService()
            .whetherHasAccount(authService.getCurrentUser.uid)
            .then((newUser) async {
          if (newUser != null) {
            //hsa firestore documents (authenticated)
            authService.myUser = newUser;
            authService.hasFirestoreDocuments = true;
          } else {
            //no firestore documents (set authService.myUser before Wrapper())
            authService.hasFirestoreDocuments = false;

            MyUser _user = MyUser(
              userUID: authService.authUser.uid,
              username: authService.authUser.uid,
              description: null,
              profileImageUrl:
                  'https://firebasestorage.googleapis.com/v0/b/goconnect-745e7.appspot.com/o/images%2Ffashion.png?alt=media&token=f2e8484d-6874-420c-9401-615063e53b8d',
              phoneNumber: null,
              email: null,
              socialLinks: {
                'instagram': null,
                'tiktok': null,
                'youtube': null,
                'website': null,
              },
              totalFollowers: 0,
              totalFollowing: 0,
              isFollowing: false,
              completeLogin: false,
            );
            authService.myUser = _user;
          }
          _navigateAfterHandleLink(
            deepLink: deepLink,
            isPost: isPost,
            isProfile: isProfile,
            isResetEmail: isResetEmail,
            isVerifyEmail: isVerifyEmail,
            context: context,
            onPopExitApp: onPopExitApp,
          );
        });
      }

      return true;
    } else {
      return false;
    }
  }

  void _navigateAfterHandleLink({
    Uri deepLink,
    bool isPost,
    bool isProfile,
    bool isResetEmail,
    bool isVerifyEmail,
    BuildContext context,
    bool onPopExitApp,
  }) {
    if (isPost) {
      String postId = deepLink.queryParameters['post-id'];
      if (postId != null) {
        //Navigate to post screen EXAMPLE
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => DynamicLinkPost(
                postId: postId,
                onPopExitApp: onPopExitApp,
                userUID: authService.authUser.uid)));

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
    } else if (isResetEmail) {
      String newEmail = deepLink.queryParameters['new-email'];
      print('Dynamic Link handled newEmail: $newEmail');
      toast(
        'Email verified. Please login again with $newEmail.',
        duration: Toast.LENGTH_LONG,
      );
      //add navigate to DynamicLink Quick Sign In
      authService.logout().then((_) {
        dynamicLinkProvider.updatedEmailSignin(newEmail);
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
      });
    } else if (isVerifyEmail) {
      String email = deepLink.queryParameters['email'];
      toast('Your email $email has been verified.');
      authService.userReload();
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

  Future<String> createResetEmailDynamicLink(String newEmail) async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://versify.wongoose.com/',
      link: Uri.parse('https://versifyapp.com/reset-email?new-email=$newEmail'),
      androidParameters: AndroidParameters(packageName: 'com.wongoose.versify'),
    );

    // final ShortDynamicLink shortDynamicLink = await parameters.buildShortLink();
    final Uri deepLink = await parameters.buildUrl();

    // final Uri shortUrl = shortDynamicLink.shortUrl;

    print('createEmailDynamicLink | dynamicShortUrl: ${deepLink.toString()}');

    // return deepLink.toString();
    return deepLink.toString();
  }

  Future<String> createVerifyEmailDynamicLink(String email) async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://versify.wongoose.com/',
      link: Uri.parse('https://versifyapp.com/verify-email?email=$email'),
      androidParameters: AndroidParameters(packageName: 'com.wongoose.versify'),
    );

    // final ShortDynamicLink shortDynamicLink = await parameters.buildShortLink();
    final Uri deepLink = await parameters.buildUrl();

    // final Uri shortUrl = shortDynamicLink.shortUrl;

    print('createEmailDynamicLink | dynamicShortUrl: ${deepLink.toString()}');

    // return deepLink.toString();
    return deepLink.toString();
  }
}
