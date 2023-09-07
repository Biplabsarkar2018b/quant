import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quant/screens/login/login_screen.dart';
import 'package:quant/screens/signup/signup_screen.dart';

final isLoginSelectedProvider =
    StateProvider<bool>((ref) => true); // Initially, Login screen is shown

class AuthenticationScreen extends ConsumerStatefulWidget {
  const AuthenticationScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AuthenticationScreenState();
}

class _AuthenticationScreenState extends ConsumerState<AuthenticationScreen> {
  // bool isLoginSelected = true; // Initially, Login screen is shown

  @override
  Widget build(BuildContext context) {
    final isLoginSelected = ref.watch(isLoginSelectedProvider);
   
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'SocialX',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: Colors.red, // Border color
                  width: 2.0, // Border width
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        ref.read(isLoginSelectedProvider.notifier).state = true;
                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: 50,
                        decoration: BoxDecoration(
                          color: isLoginSelected
                              ? Colors.red // Highlight if selected
                              : Colors.white,
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(18),
                            bottomRight: Radius.circular(20),
                          ),
                        ),
                        child: Text(
                          'Login',
                          style: TextStyle(
                            fontSize: 23,
                            color: isLoginSelected ? Colors.white : Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        ref.read(isLoginSelectedProvider.notifier).state = false;
                      },
                      child: Container(
                        height: 50,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: isLoginSelected
                              ? Colors.white
                              : Colors.red, // Highlight if selected
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(18),
                          ),
                        ),
                        child: Text(
                          'Signup',
                          style: TextStyle(
                            fontSize: 23,
                            color: isLoginSelected ? Colors.black : Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 30,
            ),
            isLoginSelected ?SingleChildScrollView(child: LoginScreen() ,) : SingleChildScrollView(child: SignUpScreen(),),
          ],
        ),
      ),
      // bottomNavigationBar: GestureDetector(
      //   onTap: () {
      //   },
      //   child: Container(
      //     height: 60,
      //     alignment: Alignment.center,
      //     width: double.infinity,
      //     decoration: BoxDecoration(
      //       color: Colors.red,
      //       borderRadius: BorderRadius.only(
      //         topLeft: Radius.circular(20),
      //         topRight: Radius.circular(20),
      //       ),
      //     ),
      //     child: Text(
      //       isLoginSelected ? 'Login' : 'Register',
      //       style: TextStyle(color: Colors.white, fontSize: 23),
      //     ),
      //   ),
      // ),
    );
  }
}
