import 'package:flutter/material.dart';

class RoleSelectionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onDoubleTap: () {
                Navigator.pushNamed(context, '/adminLogin');
              },
              child: Text(
                'Job Junction',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).hintColor,
                ),
              ),
            ),
            SizedBox(height: 54),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RoleSelectionCard(
                  role: 'User',
                  description: 'For individuals looking for services',
                  icon: Icons.person,
                  onPressed: () {
                    Navigator.pushNamed(context, '/userLogin');
                  },
                ),
                SizedBox(width: 20),
                RoleSelectionCard(
                  role: 'Staff',
                  description: 'For staffs available for services',
                  icon: Icons.work,
                  onPressed: () {
                    Navigator.pushNamed(context, '/workerLogin');
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class RoleSelectionCard extends StatelessWidget {
  final String role;
  final String description;
  final IconData icon;
  final VoidCallback onPressed;

  const RoleSelectionCard({
    required this.role,
    required this.description,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 160,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 48,
              color: Theme.of(context).hintColor,
            ),
            const SizedBox(height: 10),
            Text(
              role,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).hintColor,
              ),
            ),
            SizedBox(height: 8),
            Text(
              description,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
