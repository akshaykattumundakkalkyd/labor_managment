import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/colors.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  late String username = '';
  late String email = '';
  late String number = '';
  late String address = '';

  Future<void> fetchUserDetails() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        String currentUserUid = user.uid;
        DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUserUid)
            .get();

        if (userSnapshot.exists) {
          setState(() {
            username = userSnapshot['userName'] ?? '';
            email = userSnapshot['email'] ?? '';
            number = userSnapshot['phoneNumber'] ?? '';
            address = userSnapshot['address'] ?? 0;
          });
        } else {
          print('user document does not exist for UID: $currentUserUid');
        }
      } else {
        print('No user signed in');
      }
    } catch (e) {
      print('Error fetching user details: $e');
    }
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'Cancel',
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Logout'),
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                    context, '/roleSelection', (route) => false);
                logout();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> logout() async {
    _auth.signOut();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('isAuthUser');
  }

  @override
  void initState() {
    super.initState();
    fetchUserDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(
              fontWeight: FontWeight.bold, color: secondaryColor, fontSize: 25),
        ),
        centerTitle: true,
        backgroundColor: primaryColor,
        actions: [
          IconButton(
              onPressed: () {
                _showLogoutDialog();
              },
              icon: Icon(
                Icons.logout_rounded,
              ))
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: primaryColor,
        ),
        child: ListView(
          children: <Widget>[
            const SizedBox(height: 20),
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundColor: ash,
                child: Text(
                  username.isNotEmpty ? username[0].toUpperCase() : '?',
                  style: const TextStyle(fontSize: 40, color: primaryColor),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              username,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: black,
              ),
            ),
            const SizedBox(height: 10),
            Card(
              color: primaryColor,
              margin: const EdgeInsets.symmetric(vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        const Icon(Icons.email, color: ash),
                        const SizedBox(width: 10),
                        Text(
                          email,
                          style: const TextStyle(fontSize: 17, color: black),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: <Widget>[
                        const Icon(Icons.phone, color: ash),
                        const SizedBox(width: 10),
                        Text(
                          number,
                          style: const TextStyle(fontSize: 17, color: black),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: <Widget>[
                        const Icon(Icons.location_city, color: ash),
                        const SizedBox(width: 10),
                        Text(
                          address,
                          style: const TextStyle(fontSize: 17, color: black),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            // ElevatedButton(
            //   onPressed: () async {
            //     var updatedData =
            //         await Navigator.pushNamed(context, '/editWorker');
            //     if (updatedData != null && updatedData is Map) {
            //       setState(() {
            //         username = updatedData['userName'] as String;
            //         email = updatedData['email'] as String;
            //         number = updatedData['number'] as String;
            //         address = updatedData['address'] as String;
            //       });
            //     }
            //   },
            //   child: const Text('Edit Profile'),
            //   style: ElevatedButton.styleFrom(
            //     foregroundColor: primaryColor,
            //     backgroundColor: secondaryColor,
            //     padding:
            //         const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            //     shape: RoundedRectangleBorder(
            //       borderRadius: BorderRadius.circular(10),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
