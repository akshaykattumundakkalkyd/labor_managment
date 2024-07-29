import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:labor_managment/constants/colors.dart';

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

  Future<void> _logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacementNamed(context, '/roleSelection');
    } catch (e) {
      print('Error during sign-out: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchWorkerDetails();
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
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _logout,
              child: const Text('Logout'),
              style: ElevatedButton.styleFrom(
                foregroundColor: primaryColor,
                backgroundColor: Colors.red,
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
