import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final _auth = FirebaseAuth.instance;
  final _google = GoogleSignIn();
  User? get currentUser => _auth.currentUser;

  Stream<User?> get authState => _auth.authStateChanges();

  Future<User?> login(String email, String senha) async {
    final cred = await _auth.signInWithEmailAndPassword(
      email: email,
      password: senha,
    );
    return cred.user;
  }

  Future<User?> register(String email, String senha) async {
    final cred = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: senha,
    );
    return cred.user;
  }

  Future<void> sendPasswordResetEmail(String email) async {
    await _auth.setLanguageCode('pt-BR');
    final settings = ActionCodeSettings(
      url: 'https://zetesis-firebase.firebaseapp.com/',
      handleCodeInApp: false,
    );
    await _auth.sendPasswordResetEmail(
      email: email,
      actionCodeSettings: settings,
    );
  }

  Future<User?> loginGoogle() async {
    if (kIsWeb) {
      final provider = GoogleAuthProvider();
      final cred = await _auth.signInWithPopup(provider);
      return cred.user;
    }

    final user = await _google.signIn();
    if (user == null) return null;
    final auth = await user.authentication;
    final googleCred = GoogleAuthProvider.credential(
      accessToken: auth.accessToken,
      idToken: auth.idToken,
    );
    return (await _auth.signInWithCredential(googleCred)).user;
  }

  Future<void> logout() async {
    await _auth.signOut();
    await _google.signOut();
  }

  Future<void> deleteAccount() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;
    await _auth.currentUser!.delete();
  }
}
