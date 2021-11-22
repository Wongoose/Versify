import 'package:overlay_support/overlay_support.dart';
import 'package:versify/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:versify/services/firebase/dynamic_links.dart';
import 'package:versify/shared/helper/helper_classes.dart';
import 'package:versify/shared/helper/helper_methods.dart';

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
          MyUser _user = MyUser(
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

  Future<dynamic> signInWithEmailPassword(String email, password) async {
    try {
      return await _auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((result) {
        return result != null ? _userFromFB(result.user) : false;
      });
    } on FirebaseAuthException catch (e) {
      print('Sign In error! ' + e.toString());
      return false;
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

      print('ERROR _auth.createUserWithEmailAndPassword | err message: ' +
          err.message.toString() +
          '\n err code is: ' +
          err.code);

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

  Future<User> signInWithGoogle({bool newUser}) async {
    // FirebaseAuth _auth = FirebaseAuth.instance;
    User _user;
    GoogleSignIn _googleSignIn = GoogleSignIn();
    // bool _isSignIn = await _googleSignIn.isSignedIn();
    if (newUser) {
      _googleSignIn.signOut();
    }
    GoogleSignInAccount googleSignInAccount =
        await _googleSignIn.signIn().catchError((onError) {
      print('ERROR message is: $onError');
    });
    GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    UserCredential authResult =
        await _auth.signInWithCredential(credential).catchError((err) {
      switch (err.code.toString()) {
        case "":
          break;
      }
    });

    _user = authResult.user;

    assert(!_user.isAnonymous);
    assert(await _user.getIdToken() != null);

    print("GoogleSignIn | User\'s Name: ${_user.displayName}");
    print("GoogleSignin | User\'s Email ${_user.email}");

    return _user;
  }

  Future<void> resetPasswordWithEmail(String email) async {
    print('resetPasswordWithEmail | RAN: ' + email);
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
        toast(err.message);
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