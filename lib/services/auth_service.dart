import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final _auth = FirebaseAuth.instance;
  final _google = GoogleSignIn();

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

  Future<User?> loginGoogle() async {
    final user = await _google.signIn();
    if (user == null) return null;

    final auth = await user.authentication;

    final cred = GoogleAuthProvider.credential(
      accessToken: auth.accessToken,
      idToken: auth.idToken,
    );

    return (await _auth.signInWithCredential(cred)).user;
  }

  Future<void> logout() async {
    await _auth.signOut();
    await _google.signOut();
  }
}