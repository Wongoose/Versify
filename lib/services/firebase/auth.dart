import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:overlay_support/overlay_support.dart';
import 'package:versify/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:versify/services/firebase/dynamic_links.dart';
import 'package:versify/shared/helper/helper_classes.dart';
import 'package:versify/shared/helper/helper_methods.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  MyUser myUser;
  User authUser;
  String userUID;
  String currentSignInProvider;

  bool hasFirestoreDocuments;

  bool get isUserAuthenticated => authUser != null;

  bool get isUserAnonymous {
    if (authUser != null) {
      return authUser.isAnonymous;
    } else {
      return true;
    }
  }

  bool get isEmailVerified => authUser.emailVerified;

  User get getCurrentUser => _auth.currentUser;

  Future<String> getCurrentSignInProvider() async {
    final IdTokenResult idTokenResult =
        await _auth.currentUser.getIdTokenResult();

    print("currentSignInProvider | is: ${idTokenResult?.signInProvider}");
    return currentSignInProvider = idTokenResult.signInProvider;
  }

  void updateAuthMyUser(MyUser user) {
    myUser = user;
  }

  Future<ReturnValue> signInAnon() async {
    //method setup
    print('SignInAnon() | RAN');

    try {
      return await _auth.signInAnonymously().then((UserCredential result) {
        if (result.user.uid != null) {
          print('User signed In Anon!');
          this.authUser = result.user;
          final MyUser _user = MyUser(
            userUID: result.user.uid,
            username: result.user.uid,
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
          myUser = _user;
          return ReturnValue(true, "success");
        } else {
          print(redPen("signInAnon() | FAILED with error: No User ID"));
          return ReturnValue(false, "No User ID");
        }
      });
      // FirebaseUser user = result.user;
    } on FirebaseAuthException catch (err) {
      print(redPen("signInAnon() | FAILED with catch error: $err"));
      return ReturnValue(false, "Failed to sign in to app. Please try again.");
    }
  }

  Stream<MyUser> get user {
    return _auth.userChanges().map(_userFromFB);
  }

  MyUser _userFromFB(User firebaseUser) {
    print("Stream User Changes | firebaseUser exists: ${firebaseUser != null}");
    if (firebaseUser != null) {
      print('Stream User Changes | uid: ${firebaseUser.uid}');
      print(
          'Stream User Changes | phone: ${firebaseUser.phoneNumber ?? 'is null'}');
      print('Stream User Changes | email: ${firebaseUser.email ?? 'is null'}');
      authUser = firebaseUser;
      userUID = firebaseUser.uid;

      // this.myUser = MyUser(
      //   userUID: firebaseUser.uid,
      //   phoneNumber: firebaseUser.phoneNumber,
      //   email: firebaseUser.email,
      // );
      return MyUser(
        userUID: firebaseUser.uid,
        phoneNumber: firebaseUser.phoneNumber,
        email: firebaseUser.email,
        streamStatus: StreamMyUserStatus.success,
      );
    } else {
      print('Stream User Changes | NO USER');
      userUID = null;
      return MyUser(streamStatus: StreamMyUserStatus.none);
    }
  }

  Future<ReturnValue> signInWithEmailPassword(
      String email, String password) async {
    try {
      print(purplePen("signInWithEmailPassword | STARTED!"));
      final UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      print(greenPen("signInWithEmailPassword | SUCCESSFUL!"));
      return ReturnValue(true, result.user.email);
    } on FirebaseAuthException catch (err) {
      print(redPen("signInWithEmailPassword | FAILED with catch error: $err"));
      return ReturnValue(false, err.message);
    }
  }

  // Future<CreateAcc> createGoogleAccount() async {
  //   try {
  //     return signInWithGoogle(newUser: true).then((resUser) async {
  //       String userUID = resUser.uid;
  //       return DatabaseService()
  //           .firestoreCreateAccount(userUID: userUID, email: resUser.email)
  //           .then((createAcc) {
  //         return createAcc;
  //         // if (createAcc == CreateAcc.hasAccount) {
  //         // } else {}
  //         // return userUID != null ? userUID : null;
  //       });
  //     });
  //   } catch (e) {
  //     return null;
  //   }
  // }

  // Future<dynamic> createAccount(String email, password) async {
  //   try {
  //     return await createEmailPassword(email, password)
  //         .then((UserCredential result) async {
  //       String userUID = result.user.uid;
  //       await DatabaseService()
  //           .firestoreCreateAccount(userUID: userUID, email: result.user.email);
  //       return userUID != null ? _userFromFB(result.user) : null;
  //     });
  //   } catch (e) {
  //     return null;
  //   }
  // }

  // Future<UserCredential> createEmailPassword(
  //     String email, String password) async {
  //   try {
  //     print('try');
  //     return await _auth.createUserWithEmailAndPassword(
  //         email: email, password: password);
  //   } catch (err) {
  //     print('ERROR _auth.createUserWithEmailAndPassword | err message: ' +
  //         err.toString());

  //     switch (err.toString()) {
  //       case "email-already-in-use":
  //         break;
  //     }
  //     return null;
  //   }
  // }

  Future<Map<String, String>> createUserEmailPassword(
      String email, String password) async {
    Map<String, String> returnVal;

    await _auth
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((userCredential) async {
//send verification to email when sign up
      await verifyEmailAddress();
      toast('A verification email was sent to your inbox');
    }).catchError((err) {
      String errorCode = "";
      String errorMessage = '';

      print(
          "ERROR _auth.createUserWithEmailAndPassword | err message: ${err.message}\n err code is: ${err.code}");

      switch (err.code.toString()) {
        case "email-already-in-use":
          errorCode = "email-already-in-use";
          errorMessage =
              "This email has already been used, please use another email and try again.";
      }
      returnVal = {
        'errorCode': errorCode,
        'errorMessage': errorMessage,
      };
    });

    return returnVal;
  }

  Future<ReturnValue> signInWithGoogle({bool newUser}) async {
    try {
      print(purplePen("signInWithGoogle | STARTED!"));
      final GoogleSignIn _googleSignIn = GoogleSignIn();
      final bool signedIn = await _googleSignIn.isSignedIn();
      if (newUser && signedIn) {
        await _googleSignIn.signOut();
      }
      final GoogleSignInAccount googleSignInAccount =
          await _googleSignIn.signIn();

      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      // CHECK FOR EXISTING EMAIL IN FIREBASE - via Cloud Functions (If true only proceed)

      final UserCredential authResult =
          await _auth.signInWithCredential(credential);

      final User user = authResult.user;

      // FOR DEBUGGING
      assert(!user.isAnonymous);
      assert(await user.getIdToken() != null);

      print(greenPen("signInWithGoogle | SUCCESSFUL!"));
      print(grayPen("Google account display name: ${user.displayName}"));
      print(grayPen("Googl eaccount email ${user.email}"));

      return ReturnValue(true, user.email);
    } catch (err) {
      print(redPen("signInWithGoogle | FAILED with catch error: $err"));
      return ReturnValue(false,
          "Something went wrong while signing in with Google. Please try again.");
    }
  }

  Future<ReturnValue> signInWithFacebook({bool newUser}) async {
    try {
      print(purplePen("signInWithFacebook | STARTED!"));

      final FacebookLogin fbLogin = FacebookLogin();

      final bool loggedIn = await fbLogin.isLoggedIn;
      if (newUser && loggedIn) {
        await fbLogin.logOut();
      }

      final FacebookLoginResult result = await fbLogin.logIn(["email"]);

      switch (result.status) {
        case FacebookLoginStatus.loggedIn:
          final String token = result.accessToken.token;
          final response = await http.get(Uri.parse(
              "https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email&access_token=$token"));

          final profile = jsonDecode(response.body);
          final AuthCredential credential =
              FacebookAuthProvider.credential(token);
          final UserCredential authResult =
              await _auth.signInWithCredential(credential);

          final User user = authResult.user;

          // FOR DEBUGGING
          assert(!user.isAnonymous);
          assert(await user.getIdToken() != null);

          print(greenPen("signInWithFacebook | SUCCESSFUL!"));
          print(grayPen(profile.toString()));

          return ReturnValue(true,
              profile["email"]?.toString() ?? profile["name"]?.toString());
          break;
        case FacebookLoginStatus.cancelledByUser:
          print(purplePen("signInWithFacebook | CANCELLED by user!"));
          return ReturnValue(false, "");

          break;
        case FacebookLoginStatus.error:
          print(redPen(
              "signInWithFacebook | FAILED when logging in: ${result.errorMessage}"));
          return ReturnValue(false, result.errorMessage);
          break;

        default:
          print(redPen("signInWithFacebook | DEFAULTED when logging in."));
          return ReturnValue(false,
              "Something went wrong while signing in with Facebook. Please try again.");
      }
    } on FirebaseAuthException catch (err) {
      print(redPen("signInWithFacebook | FAILED with catch error: $err"));
      switch (err.code) {
        case "account-exists-with-different-credential":
          return ReturnValue(false,
              "This email address is already linked to an existing account. Try signing in using the Google or Email option");
          break;
        default:
          return ReturnValue(false,
              "Something went wrong while signing in with Facebook. Please try again.");
          break;
      }
    }
  }

  Future<void> resetPasswordWithEmail(String email) async {
    print('resetPasswordWithEmail | RAN: $email');
    _auth.sendPasswordResetEmail(email: email);
  }

  Future<bool> verifyEmailAddress() async {
    print('authService | verifyEmailAddress');

    try {
      return DynamicLinkService()
          .createVerifyEmailDynamicLink(authUser.email)
          .then((dynamicLinkUrl) {
        return _auth.currentUser
            .sendEmailVerification(ActionCodeSettings(
          url: dynamicLinkUrl,
          androidInstallApp: false,
          handleCodeInApp: false,
          androidPackageName: 'com.wongoose.versify',
          dynamicLinkDomain: 'versify.wongoose.com',
        ))
            .then((_) {
          return true;
        });
      });
    } catch (err) {
      if (err == "too-many-requests") {
        toast(err.toString());
      }
      return false;
    }
  }

  Future<void> userReload() async {
    await _auth.currentUser.reload();
  }

  Future<void> logout() async {
    await _auth.signOut();
  }
}
