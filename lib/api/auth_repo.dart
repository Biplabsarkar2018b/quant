import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quant/commons/snackbar.dart';

final authRepoProvider = Provider((ref) {
  return AuthRepo(auth: FirebaseAuth.instance);
});

class AuthRepo {
  final FirebaseAuth _auth;
  AuthRepo({required FirebaseAuth auth}) : _auth = auth;

  Future<void> login({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      showSnackbar(message: "Logged In", context: context);
    } catch (e) {
      showSnackbar(message: "Something went wrong", context: context);
    }
  }

  Future<void> signup({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      showSnackbar(message: "User Created", context: context);
    } catch (e) {
      showSnackbar(message: "Something went wrong", context: context);
    }
  }
}
