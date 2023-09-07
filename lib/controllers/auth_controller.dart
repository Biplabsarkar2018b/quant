import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quant/api/auth_repo.dart';
import 'package:quant/screens/home/home_screen.dart';

final authControllerProvider =
    StateNotifierProvider<AuthController, bool>((ref) {
  return AuthController(
    authRepo: ref.watch(authRepoProvider),
  );
});

class AuthController extends StateNotifier<bool> {
  final AuthRepo _authRepo;
  AuthController({
    required AuthRepo authRepo,
  })  : _authRepo = authRepo,
        super(false);

  Future<void> login({
    required String email,
    required String pass,
    required BuildContext context,
  }) async {
    state = true;
    try {
      await _authRepo.login(
        email: email,
        password: pass,
        context: context,
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(),
        ),
      );
    } catch (e) {
      print(e);
    }
    state = false;
  }

  Future<void> signup({
    required String email,
    required String pass,
    required BuildContext context,
  }) async {
    state = true;
    try {
      await _authRepo.signup(
        email: email,
        password: pass,
        context: context,
      );
    } catch (e) {
      print(e);
    }
    state = false;
  }
}
