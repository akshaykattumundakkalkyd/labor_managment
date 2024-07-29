import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../constants/colors.dart';

class BookingHistoryPage extends StatefulWidget {
  const BookingHistoryPage({super.key});

  @override
  State<BookingHistoryPage> createState() => _BookingHistoryPageState();
}

class _BookingHistoryPageState extends State<BookingHistoryPage> {
  User? currentUser;

  @override
  void initState() {
    super.initState();
    currentUser = FirebaseAuth.instance.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Booking History',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
      ),
      body: currentUser == null
          ? Center(child: Text('User not logged in'))
          : StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('bookings')
                  .where('userId', isEqualTo: currentUser?.uid)
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
                      child: Text('No booking history available'));
                }

                return ListView.builder(
                  itemCount: snapshot.data?.docs.length,
                  itemBuilder: (context, index) {
                    var bookingSnap = snapshot.data?.docs[index];
                    String workerName = bookingSnap?['workerName'] ?? 'N/A';
                    String workerCategory =
                        bookingSnap?['jobCategory'] ?? 'N/A';
                    var bookingDate = bookingSnap?['bookingDate'];

                    // Convert Firestore Timestamp to DateTime
                    DateTime bookingDateTime;
                    if (bookingDate is Timestamp) {
                      bookingDateTime = bookingDate.toDate();
                    } else if (bookingDate is String) {
                      bookingDateTime =
                          DateFormat('yyyy-MM-dd').parse(bookingDate);
                    } else {
                      bookingDateTime = DateTime.now(); // Fallback
                    }

                    return Card(
                      color: secondaryColor,
                      margin: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 15),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Worker: $workerName',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: primaryColor,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              'Job Category: $workerCategory',
                              style: TextStyle(
                                fontSize: 16,
                                color: primaryColor,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              'Booking Date: ${DateFormat('yyyy-MM-dd').format(bookingDateTime)}',
                              style: TextStyle(
                                fontSize: 16,
                                color: primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
