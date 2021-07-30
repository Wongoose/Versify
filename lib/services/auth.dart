import 'package:flutter/services.dart';
import 'package:versify/models/user_model.dart';
import 'package:versify/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

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

  User get getCurrentUser => _auth.currentUser;

  Future<String> getCurrentSignInProvider() async {
    return _auth.currentUser
        .getIdTokenResult()
        .then((IdTokenResult tokenResult) {
      print('currentSignInProvider | is: ' + tokenResult?.signInProvider);
      currentSignInProvider = tokenResult.signInProvider;
      return tokenResult.signInProvider;
    });
  }

  Future<bool> signInAnon() async {
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
          return true;
        } else {
          print('No User ID');
          return false;
        }
      });
      // FirebaseUser user = result.user;
    } on FirebaseAuthException catch (e) {
      print('SignInAnon() | Error: ${e.toString()}');
      return false;
    }
  }

  Stream<MyUser> get user {
    return _auth.userChanges().map(_userFromFB);
  }

  MyUser _userFromFB(User firebaseUser) {
    print(
        'Stream User Changes | hashCode: ' + firebaseUser.hashCode.toString());
    if (firebaseUser != null) {
      this.authUser = firebaseUser;
      this.userUID = firebaseUser.uid;
      this.myUser = MyUser(
        userUID: firebaseUser.uid,
        phoneNumber: firebaseUser.phoneNumber,
        email: firebaseUser.email,
      );
      return this.myUser;
    } else {
      this.userUID = null;
      return null;
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
        .catchError((err) {
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
        'errorMessage': err.message,
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

  Future<void> logout() async {
    await _auth.signOut();
  }
}
