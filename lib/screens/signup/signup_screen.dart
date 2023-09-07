import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quant/commons/snackbar.dart';
import 'package:quant/controllers/auth_controller.dart';
import 'package:quant/screens/authentication/authentication_screen.dart';

final signUpProvider = Provider((ref) {
  return _SignUpScreenState().signUp();
});

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _phoneNum = TextEditingController();
  final TextEditingController _pass = TextEditingController();
  bool checkBox = false;
  String? nameError;
  String? emailError;
  String? phoneNumError;
  String? passwordError;
  void signUp() {
    final name = _name.text;
    final email = _email.text;
    final phoneNum = _phoneNum.text;
    final password = _pass.text;

    // Reset previous error messages
    setState(() {
      nameError = null;
      emailError = null;
      phoneNumError = null;
      passwordError = null;
    });

    // Validation
    if (name.isEmpty) {
      setState(() {
        nameError = "Name is required";
      });
      return;
    } else if (name.contains(RegExp(r'[0-9]'))) {
      setState(() {
        nameError = "Name should not contain numbers";
      });
      return;
    }

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

    if (phoneNum.isEmpty) {
      setState(() {
        phoneNumError = "Phone number is required";
      });
      return;
    } else if (phoneNum.length != 10) {
      setState(() {
        phoneNumError = "Phone number should be 10 digits";
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
    if (!checkBox) {
      return;
    }
    // showSnackbar(message: "hello", context: context);
    ref
        .read(authControllerProvider.notifier)
        .signup(
          email: email,
          pass: password,
          context: context,
        )
        .then(
          (value) => ref.read(isLoginSelectedProvider.notifier).state = true,
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
                  padding:
                      EdgeInsets.only(left: 20, bottom: 40, top: 20, right: 20),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Create An Account',
                          style: TextStyle(
                              fontSize: 30,
                              color: Colors.red,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.start,
                        ),
                      ),
                      TextFormField(
                        controller: _name,
                        decoration: InputDecoration(
                          errorText: nameError,
                          errorStyle: TextStyle(color: Colors.redAccent),
                          labelText: 'Name',
                          hintText: 'John Doe',
                          hintStyle: TextStyle(color: Colors.black),
                          suffixIcon: Icon(
                            Icons.person,
                            color: Colors.red,
                          ),
                        ),
                        maxLength: 20,
                      ),
                      TextFormField(
                        controller: _email,
                        decoration: InputDecoration(
                          errorText: emailError,
                          errorStyle: TextStyle(color: Colors.redAccent),
                          labelText: 'Email',
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
                          controller: _phoneNum,
                          decoration: InputDecoration(
                            errorText: phoneNumError,
                            errorStyle: TextStyle(color: Colors.redAccent),
                            labelText: 'Phone Number',
                            hintText: '1234567890',
                            hintStyle: TextStyle(color: Colors.black),
                            suffixIcon: Icon(
                              Icons.phone,
                              color: Colors.red,
                            ),
                            prefix: CountryCodePicker(
                              onChanged: (CountryCode countryCode) {
                                // Handle country code change here
                                print(
                                    'New Country Code: ${countryCode.dialCode}');
                              },
                              initialSelection:
                                  'US', // Set your initial country selection here
                            ),
                          )),
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
                      Wrap(
                        children: [
                          Row(
                            children: [
                              Checkbox(
                                value: checkBox,
                                onChanged: (bool? newValue) {
                                  setState(() {
                                    checkBox = newValue == true;
                                  });
                                },
                              ),
                              RichText(
                                text: TextSpan(
                                  text: 'I agree to the ',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: 'Terms and Conditions',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                      Wrap(
                        children: [
                          RichText(
                            text: TextSpan(
                              text: 'Already have an account ?',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                              children: <TextSpan>[
                                TextSpan(
                                    text: ' Sign In!',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        ref
                                            .read(isLoginSelectedProvider
                                                .notifier)
                                            .state = true;
                                      }),
                              ],
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: GestureDetector(
                    onTap: () {
                      signUp();
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
                        'Register',
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
