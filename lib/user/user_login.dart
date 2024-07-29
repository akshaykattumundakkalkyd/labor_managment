import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:labor_managment/constants/colors.dart';
import 'package:labor_managment/widget/button.dart';
import 'package:labor_managment/widget/textfield.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserLogin extends StatefulWidget {
  const UserLogin({super.key});

  @override
  State<UserLogin> createState() => _UserLoginState();
}

class _UserLoginState extends State<UserLogin> {
  TextEditingController passwordTextController = TextEditingController();
  TextEditingController emailTextController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth auth = FirebaseAuth.instance;

  void _saveAuthCredentialsUser(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isAuthUser', value);
  }

  Future<bool> checkUserExists(String email) async {
    try {
      CollectionReference workers =
          FirebaseFirestore.instance.collection('users');
      QuerySnapshot querySnapshot =
          await workers.where('email', isEqualTo: email).get();
      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      print('Error checking worker existence: $e');
      return false;
    }
  }

  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      return userCredential.user;
    } catch (e) {
      print('Error signing in: $e');
      return null;
    }
  }

  void signIn(String email, String password) async {
    if (_formKey.currentState?.validate() ?? false) {
      String email = emailTextController.text;
      String password = passwordTextController.text;

      bool userExists = await checkUserExists(email);

      if (userExists) {
        User? user = await signInWithEmailAndPassword(email, password);
        if (user != null) {
          print('Signed in successfully.');
          // Navigate to the worker dashboard or home screen
          Navigator.pushNamedAndRemoveUntil(
              context, '/userDashboard', (route) => false);
          _saveAuthCredentialsUser(true);
        } else {
          _showSnackbar('Login failed. Please check your credentials.');
        }
      } else {
        _showSnackbar('User does not exist.');
      }
    }
  }

  void _showSnackbar(String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 200.0),
            child: Container(
              padding: EdgeInsets.all(24),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Login ',
                          style: TextStyle(
                              color: secondaryColor,
                              fontSize: 35,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 48),
                        CustomTextField(
                          labelText: 'Enter Email',
                          prefixIcon: Icons.mail_outline,
                          controller: emailTextController,
                          obscureText: false,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        CustomTextField(
                          labelText: 'Enter Password',
                          prefixIcon: Icons.vpn_key,
                          controller: passwordTextController,
                          obscureText: true,
                        ),
                        const SizedBox(height: 34),
                        CustomElevatedButton(
                            onPressed: () {
                              signIn(emailTextController.text,
                                  passwordTextController.text);
                            },
                            buttonText: 'Login'),
                        const SizedBox(height: 24.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Dont have an accout yet ?',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(width: 6),
                            GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, '/userRegistration');
                                },
                                child: const Text(
                                  'Create',
                                  style: TextStyle(
                                      color: blue, fontWeight: FontWeight.bold),
                                ))
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
