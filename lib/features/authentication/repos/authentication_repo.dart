import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthenticationRepository {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  User? get _user => _firebaseAuth.currentUser;
  bool get isLoggedIn => _user != null;
}

final authRepo = Provider((ref) => AuthenticationRepository());
