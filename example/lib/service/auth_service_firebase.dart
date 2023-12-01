import 'package:example/model/user.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

class FirebaseAuthService {
  final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;

  User? _currentUser;

  User? get currentUser => _currentUser;

  Future<String?> getCurrentUserId() async {
    if (currentUser != null) {
      return currentUser?.userId;
    }
    auth.User? firebaseUser = _auth.currentUser;
    if (firebaseUser != null) {
      return firebaseUser.uid;
    }
    return null;
  }

  Future<User?> signInAnonymously() async {
    auth.UserCredential credential = await _auth.signInAnonymously();
    auth.User? firebaseUser = credential.user;
    User? user = _userFromFirebaseUser(firebaseUser);
    return user;
  }

  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    auth.UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    auth.User? firebaseUser = credential.user;
    User? user = _userFromFirebaseUser(firebaseUser);
    return user;
  }

  Future<bool> signOut() async {
    await _auth.signOut();
    return true;
  }

  Future<User?> signUpWithEmailAndPassword(
    String email,
    String password,
    String username,
  ) async {
    auth.UserCredential credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    auth.User? firebaseUser = credential.user;
    User? user = _userFromFirebaseUser(firebaseUser);
    user?.username = username;
    return user;
  }

  User? _userFromFirebaseUser(auth.User? firebaseUser) {
    if (firebaseUser != null) {
      String? email = firebaseUser.email;
      if (email != null) {
        User user = User(firebaseUser.uid, email);
        String? displayName = firebaseUser.displayName;
        String? photoURL = firebaseUser.photoURL;
        if (displayName != null) {
          user.username = displayName;
        }
        if (photoURL != null) {
          user.profilePhotoUrl = photoURL;
        }
        return user;
      }
    }
    return null;
  }

  Future<bool> sendPasswordResetEmail(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
    return true;
  }

  Future<bool> sendEmailVerification() async {
    auth.User? firebaseUser = _auth.currentUser;
    if (firebaseUser != null) {
      await firebaseUser.sendEmailVerification();
      return true;
    }
    return false;
  }

  Future<bool> checkIfEmailVerified() async {
    auth.User? firebaseUser = _auth.currentUser;
    if (firebaseUser != null) {
      return firebaseUser.emailVerified;
    }
    return false;
  }
}
