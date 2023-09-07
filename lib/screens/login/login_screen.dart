import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quant/commons/snackbar.dart';
import 'package:quant/screens/authentication/authentication_screen.dart';
import 'package:quant/screens/home/home_screen.dart';

import '../../controllers/auth_controller.dart';

final loginProvider = Provider((ref) {
  return _LoginScreenState().login();
});

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _pass = TextEditingController();
  String? emailError;
  String? passwordError;
  @override
  void dispose() {
    super.dispose();
    _email.dispose();
    _pass.dispose();
  }

  void login() {
    final email = _email.text;
    final password = _pass.text;

    // Reset previous error messages
    setState(() {
      emailError = null;
      passwordError = null;
    });

    if (email.isEmpty) {
      setState(() {
        emailError = "Email is required";
      });
      return;
    } else if (!RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$')
        .hasMatch(email)) {
      setState(() {
        emailError = "Invalid email format";
      });
      return;
    }

    if (password.isEmpty) {
      setState(() {
        passwordError = "Password is required";
      });
      return;
    } else if (password.length < 6 || password.length > 12) {
      setState(() {
        passwordError = "Password should be between 6 and 12 characters";
      });
      return;
    }

    // showSnackbar(message: "hello", context: context);
    ref.read(authControllerProvider.notifier).login(
          email: email,
          pass: password,
          context: context,
        );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authControllerProvider);
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(
              color: Colors.red,
            ),
          )
        : Container(
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey,
                          spreadRadius: 10,
                          blurRadius: 20)
                    ],
                    borderRadius: BorderRadius.all(Radius.circular(40)),
                    color: Colors.white),
                padding: EdgeInsets.only(
                    left: 20, bottom: 40, top: 20, right: 20),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Sign in to your Account',
                        style: TextStyle(
                            fontSize: 30,
                            color: Colors.red,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.start,
                      ),
                    ),
                    TextFormField(
                      controller: _email,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        errorText: emailError,
                        errorStyle: TextStyle(color: Colors.redAccent),
                        hintText: 'JohnDoe@gmail.com',
                        hintStyle: TextStyle(color: Colors.black),
                        suffixIcon: Icon(
                          Icons.email,
                          color: Colors.red,
                        ),
                      ),
                      maxLength: 20,
                    ),
                    TextFormField(
                      controller: _pass,
                      obscureText: true,
                      obscuringCharacter: '#',
                      decoration: InputDecoration(
                        errorText: passwordError,
                        errorStyle: TextStyle(color: Colors.redAccent),
                        labelText: 'Password',
                        hintText: '123@abc',
                        hintStyle: TextStyle(color: Colors.black),
                        suffixIcon: Icon(
                          Icons.lock_outline,
                          color: Colors.red,
                        ),
                      ),
                      maxLength: 20,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'Forgot Password?',
                        style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                        textAlign: TextAlign.end,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text('Login with'),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                            onPressed: () {},
                            icon: Image.asset(
                              'assets/g_icon.png',
                              width: 25,
                            )),
                        IconButton(
                            onPressed: () {},
                            icon: Image.asset(
                              'assets/facebook.png',
                              width: 25,
                            ))
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Wrap(
                      children: [
                        RichText(
                          text: TextSpan(
                            text: "Don't have an account ?",
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                  text: ' Register Now!',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      ref
                                          .read(isLoginSelectedProvider
                                              .notifier)
                                          .state = false;
                                    }),
                            ],
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 150,
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: GestureDetector(
                  onTap: () {
                    login();
                  },
                  child: Container(
                    height: 60,
                    alignment: Alignment.center,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: Text(
                      'Login',
                      style: TextStyle(color: Colors.white, fontSize: 23),
                    ),
                  ),
                ),
              )
            ],
          ),
        );
  }
}
