import 'package:example/model/user.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthService {
  final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;

  User _currentUser;

  User get currentUser => _currentUser;

  Future<String> getCurrentUserId() async {
    if (currentUser != null) {
      return currentUser.userId;
    }
    auth.User firebaseUser = _auth.currentUser;
    if (firebaseUser != null) {
      return firebaseUser.uid;
    } else {
      return null;
    }
  }

  Future<User> signInAnonymously() async {
    auth.UserCredential credential = await _auth.signInAnonymously();
    auth.User firebaseUser = credential.user;
    User user = _userFromFirebaseUser(firebaseUser);
    return user;
  }

  Future<User> signInWithEmailAndPassword(String email, String password) async {
    auth.UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    auth.User firebaseUser = credential.user;
    User user = _userFromFirebaseUser(firebaseUser);
    return user;
  }

  Future<User> signInWithGoogle() async {
    GoogleSignIn googleSignIn = GoogleSignIn(
      scopes: [
        'email',
        //'https://www.googleapis.com/auth/contacts.readonly',
      ],
    );

    if (await googleSignIn.isSignedIn()) {
      await googleSignIn.signOut();
    }
    GoogleSignInAccount googleUser = await googleSignIn.signIn();
    GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    auth.AuthCredential authCredential = auth.GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final auth.UserCredential userCredential =
        await _auth.signInWithCredential(authCredential);
    auth.User firebaseUser = userCredential.user;
    User user = _userFromFirebaseUser(firebaseUser);
    return user;
  }

  Future<bool> signOut() async {
    await _auth.signOut();
    return true;
  }

  Future<User> signUpWithEmailAndPassword(
      String email, String password, String username) async {
    auth.UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    auth.User firebaseUser = credential.user;
    if (firebaseUser != null && firebaseUser.email != null) {
      User user =
          User(firebaseUser.uid, firebaseUser.email, username: username);
      return user;
    } else {
      return null;
    }
  }

  User _userFromFirebaseUser(auth.User firebaseUser) {
    if (firebaseUser != null && firebaseUser.email != null) {
      User user = User(firebaseUser.uid, firebaseUser.email);
      if (firebaseUser.displayName != null) {
        user.username = firebaseUser.displayName;
      }
      if (firebaseUser.photoURL != null) {
        user.profilePhotoUrl = firebaseUser.photoURL;
      }
      return user;
    }
    return null;
  }

  Future<bool> sendPasswordResetEmail(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
    return true;
  }

  Future<bool> sendEmailVerification() async {
    auth.User firebaseUser = _auth.currentUser;
    await firebaseUser.sendEmailVerification();
    return true;
  }

  Future<bool> checkIfEmailVerified() async {
    auth.User firebaseUser = _auth.currentUser;
    return firebaseUser.emailVerified;
  }
}
