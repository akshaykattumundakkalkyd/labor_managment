// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:labor_managment/constants/colors.dart';

// class WorkerProfile extends StatefulWidget {
//   const WorkerProfile({Key? key}) : super(key: key);

//   @override
//   _WorkerProfileState createState() => _WorkerProfileState();
// }

// class _WorkerProfileState extends State<WorkerProfile> {
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   late String username = '';
//   late String email = '';
//   late String jobType = '';
//   late int experience = 0;

//   Future<void> fetchWorkerDetails() async {
//     try {
//       // Get the current user from Firebase Authentication
//       User? user = FirebaseAuth.instance.currentUser;

//       if (user != null) {
//         // User is signed in, get the UID
//         String currentUserUid = user.uid;

//         // Use currentUserUid to fetch user details from Firestore
//         DocumentSnapshot workerSnapshot = await FirebaseFirestore.instance
//             .collection('workers')
//             .doc(currentUserUid)
//             .get();

//         if (workerSnapshot.exists) {
//           setState(() {
//             username = workerSnapshot['userName'] ?? '';
//             email = workerSnapshot['email'] ?? '';
//             jobType = workerSnapshot['jobType'] ?? '';
//             experience = workerSnapshot['experience'] ?? 0;
//           });
//         } else {
//           print('Worker document does not exist for UID: $currentUserUid');
//         }
//       } else {
//         // No user is signed in
//         print('No worker signed in');
//       }
//     } catch (e) {
//       print('Error fetching worker details: $e');
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     fetchWorkerDetails();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Worker Profile',
//             style:
//                 TextStyle(fontWeight: FontWeight.bold, color: secondaryColor)),
//         centerTitle: true,
//         backgroundColor: primaryColor,
//       ),
//       body: Container(
//         padding: const EdgeInsets.all(20),
//         decoration: const BoxDecoration(
//           color: primaryColor,
//         ),
//         child: ListView(
//           children: <Widget>[
//             const SizedBox(height: 20),
//             // Center(
//             //   child: Container(
//             //     width: 100,
//             //     height: 100,
//             //     decoration: BoxDecoration(
//             //       shape: BoxShape.circle,
//             //       border: Border.all(width: 2, color: black),
//             //       // image: const DecorationImage(
//             //       //   // image: AssetImage('assets/default_profile.png'),
//             //       //   fit: BoxFit.cover,
//             //       // ),
//             //     ),
//             //   ),
//             // ),
//             const SizedBox(height: 10),
//             Text(
//               username,
//               style: const TextStyle(
//                 fontWeight: FontWeight.bold,
//                 fontSize: 20,
//                 color: black,
//               ),
//             ),
//             const SizedBox(height: 10),
//             Card(
//               color: primaryColor,
//               child: Padding(
//                 padding: const EdgeInsets.all(15),
//                 child: Column(
//                   children: <Widget>[
//                     Row(
//                       children: <Widget>[
//                         const Icon(Icons.email, color: ash),
//                         const SizedBox(width: 10),
//                         Text(
//                           email,
//                           style: const TextStyle(fontSize: 17, color: black),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 10),
//                     Row(
//                       children: <Widget>[
//                         const Icon(Icons.work, color: ash),
//                         const SizedBox(width: 10),
//                         Text(
//                           jobType,
//                           style: const TextStyle(fontSize: 17, color: black),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 10),
//                     Row(
//                       children: <Widget>[
//                         const Icon(Icons.timer, color: ash),
//                         const SizedBox(width: 10),
//                         Text(
//                           '$experience years of experience',
//                           style: const TextStyle(fontSize: 17, color: black),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.pushNamed(context, '/editWorker');
//               },
//               child: const Text('Edit Profile'),
//               style: ElevatedButton.styleFrom(
//                 foregroundColor: primaryColor,
//                 backgroundColor: buttonColor,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:labor_managment/constants/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WorkerProfile extends StatefulWidget {
  const WorkerProfile({Key? key}) : super(key: key);

  @override
  _WorkerProfileState createState() => _WorkerProfileState();
}

class _WorkerProfileState extends State<WorkerProfile> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late String username = '';
  late String email = '';
  late String jobType = '';
  late int experience = 0;

  Future<void> fetchWorkerDetails() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        String currentUserUid = user.uid;
        DocumentSnapshot workerSnapshot = await FirebaseFirestore.instance
            .collection('workers')
            .doc(currentUserUid)
            .get();

        if (workerSnapshot.exists) {
          setState(() {
            username = workerSnapshot['userName'] ?? '';
            email = workerSnapshot['email'] ?? '';
            jobType = workerSnapshot['jobType'] ?? '';
            experience = workerSnapshot['experience'] ?? 0;
          });
        } else {
          print('Worker document does not exist for UID: $currentUserUid');
        }
      } else {
        print('No worker signed in');
      }
    } catch (e) {
      print('Error fetching worker details: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchWorkerDetails();
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
    await prefs.remove('isAuthWorker');
  }

  // @override
  // void initState() {
  //   super.initState();
  //   fetchUserDetails();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(
              fontWeight: FontWeight.bold, color: secondaryColor, fontSize: 25),
        ),
        actions: [
          IconButton(
              onPressed: () {
                _showLogoutDialog();
              },
              icon: Icon(
                Icons.logout_rounded,
              ))
        ],
        centerTitle: true,
        backgroundColor: primaryColor,
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
                        const Icon(Icons.work, color: ash),
                        const SizedBox(width: 10),
                        Text(
                          jobType,
                          style: const TextStyle(fontSize: 17, color: black),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: <Widget>[
                        const Icon(Icons.timer, color: ash),
                        const SizedBox(width: 10),
                        Text(
                          '$experience years of experience',
                          style: const TextStyle(fontSize: 17, color: black),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                var updatedData =
                await Navigator.pushNamed(context, '/editWorker');
                if (updatedData != null && updatedData is Map) {
                  setState(() {
                    username = updatedData['userName'] as String;
                    email = updatedData['email'] as String;
                    jobType = updatedData['jobType'] as String;
                    experience = updatedData['experience'] as int;
                  });
                }
              },
              child: const Text('Edit Profile'),
              style: ElevatedButton.styleFrom(
                foregroundColor: primaryColor,
                backgroundColor: secondaryColor,
                padding:
                const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
