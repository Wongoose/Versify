import 'package:versify/models/user_model.dart';
import 'package:versify/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  MyUser myUser;
  User authUser;
  String userUID;

  bool get isUserSignedIn => _auth.currentUser != null;
  bool get isUserAnonymous {
    if (authUser != null) {
      return authUser.isAnonymous;
    } else {
      return true;
    }
  }

  Future<bool> signInAnon() async {
    //method setup
    print('SignInAnon() | RAN');

    try {
      return await _auth.signInAnonymously().then((UserCredential result) {
        if (result.user.uid != null) {
          print('User signed In Anon!');
          this.authUser = result.user;
          return true;
        } else {
          print('No User ID');
          return false;
        }
      });
      // FirebaseUser user = result.user;
    } catch (e) {
      print('SignInAnon() | Error: ${e.toString()}');
      return false;
    }
  }

  Stream<MyUser> get user {
    return _auth.userChanges().map(_userFromFB);
  }

  MyUser _userFromFB(User firebaseUser) {
    if (firebaseUser != null) {
      this.authUser = firebaseUser;
      this.userUID = firebaseUser.uid;
      return MyUser(userUID: firebaseUser.uid);
    } else {
      this.userUID = null;
      return null;
    }
  }

  Future<dynamic> signInEmail(String email, password) async {
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

  Future<CreateAcc> createGoogleAccount() async {
    try {
      return signInWithGoogle(newUser: true).then((resUser) async {
        String userUID = resUser.uid;
        return DatabaseService()
            .firestoreCreateAccount(userUID: userUID, email: resUser.email)
            .then((createAcc) {
          return createAcc;
          // if (createAcc == CreateAcc.hasAccount) {
          // } else {}
          // return userUID != null ? userUID : null;
        });
      });
    } catch (e) {
      return null;
    }
  }

  Future<dynamic> createAccount(String email, password) async {
    try {
      return await createEmailPassword(email, password)
          .then((UserCredential result) async {
        String userUID = result.user.uid;
        await DatabaseService()
            .firestoreCreateAccount(userUID: userUID, email: result.user.email);
        return userUID != null ? _userFromFB(result.user) : null;
      });
    } catch (e) {
      return null;
    }
  }

  Future<UserCredential> createEmailPassword(
      String email, String password) async {
    try {
      print('try');
      return await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      print('create email with error: ' + e.toString());
      return null;
    }
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

    UserCredential authResult = await _auth.signInWithCredential(credential);

    _user = authResult.user;

    assert(!_user.isAnonymous);
    assert(await _user.getIdToken() != null);
    User currentUser = _auth.currentUser;

    assert(_user.uid == currentUser.uid);
    print("User Name: ${_user.displayName}");
    print("User Email ${_user.email}");

    return currentUser;
  }

  Future<void> logout() async {
    await _auth.signOut();
  }
}
