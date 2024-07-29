import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:labor_managment/constants/colors.dart';

class RejectedBookings extends StatefulWidget {
  const RejectedBookings({super.key});

  @override
  _RejectedBookingsState createState() => _RejectedBookingsState();
}

class _RejectedBookingsState extends State<RejectedBookings> {
  final CollectionReference bookings =
      FirebaseFirestore.instance.collection('bookings');
  final CollectionReference users =
      FirebaseFirestore.instance.collection('users');

  User? currentUser;

  @override
  void initState() {
    super.initState();
    currentUser = FirebaseAuth.instance.currentUser;
  }

  Future<Map<String, dynamic>> _getUserDetails(String userId) async {
    try {
      DocumentSnapshot userSnapshot = await users.doc(userId).get();
      return userSnapshot.data() as Map<String, dynamic>;
    } catch (e) {
      print("Error fetching user details: $e");
      return {};
    }
  }

  String _formatDate(dynamic date) {
    if (date is Timestamp) {
      return DateFormat.yMMMd().format(date.toDate());
    } else if (date is String) {
      return date;
    } else {
      return 'Unknown date';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Rejected Bookings',
          style: TextStyle(
              color: secondaryColor, fontSize: 25, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: currentUser == null
          ? const Center(child: Text('Not Logged in'))
          : StreamBuilder(
              stream: bookings
                  .where('workerId', isEqualTo: currentUser!.uid)
                  .where('status', isEqualTo: 'Rejected')
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return const Center(child: Text('An error occurred'));
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                      child: Text('No rejected bookings available'));
                }

                final List<DocumentSnapshot> docs = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final DocumentSnapshot bookingSnap = docs[index];
                    final bookingData =
                        bookingSnap.data() as Map<String, dynamic>;

                    // Fetch user details
                    String userId = bookingData['userId'];
                    return FutureBuilder<Map<String, dynamic>>(
                      future: _getUserDetails(userId),
                      builder: (context, userSnapshot) {
                        if (userSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }

                        if (userSnapshot.hasError) {
                          return const Center(
                              child: Text('Error fetching user details'));
                        }

                        final userData = userSnapshot.data ?? {};
                        String userName = userData['userName'] ?? 'Unknown';
                        String userAddress = userData['address'] ?? 'Unknown';
                        String userPhone = userData['phoneNumber'] ?? 'Unknown';

                        // Fetch booking date
                        String bookingDate =
                            _formatDate(bookingData['bookingDate']);

                        return Card(
                          color: primaryColor,
                          margin: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 15),
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'User Name: $userName',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  'Address: $userAddress',
                                  style: TextStyle(fontSize: 16),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  'Phone: $userPhone',
                                  style: TextStyle(fontSize: 16),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  'Booking Date: $bookingDate',
                                  style: TextStyle(fontSize: 16),
                                ),
                                const SizedBox(height: 10),
                                ElevatedButton(
                                  onPressed: () {
                                    _clearBooking(bookingSnap.id);
                                  },
                                  child: Text(
                                    'Clear',
                                    style: TextStyle(
                                        color: primaryColor,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 40, vertical: 10),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
    );
  }

  void _clearBooking(String bookingId) async {
    try {
      await bookings.doc(bookingId).update({'status': 'Cleared'});
      print('Rejected booking status updated to Cleared.');
    } catch (e) {
      print('Error updating booking status: $e');
    }
  }
}
