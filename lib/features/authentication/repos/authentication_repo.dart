import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthenticationRepository {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  User? get _user => _firebaseAuth.currentUser;
  bool get isLoggedIn => _user != null;

  Future<void> signUp({required String email, required String password}) async {
    await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
  }
}

final authRepo = Provider((ref) => AuthenticationRepository());
