import 'package:versify/services/firebase/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class TestGoogle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
              onTap: () {
                signInWithGoogle();
              },
              child: Container(
                height: 100,
                width: 200,
                color: Colors.pink,
                child: Text('Log In'),
              )),
        ],
      ),
    );
  }

  Future<void> signIn() async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    User _user;

    // _auth.signInWithCredential(credential);
  }

  Future<User> signInWithGoogle() async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    User _user;
    GoogleSignIn _googleSignIn = GoogleSignIn();
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
}
