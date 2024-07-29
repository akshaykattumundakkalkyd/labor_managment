import 'package:flutter/material.dart';
import 'package:labor_managment/constants/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
    _checkAuthStatus();
  }

  _navigateToHome() async {
    // Delay for 2 seconds
    await Future.delayed(Duration(seconds: 6));

    // Navigate to role selection page
    Navigator.pushReplacementNamed(context, '/roleSelection');
  }


  Future<void> _checkAuthStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final isAuthUser = prefs.getBool('isAuthUser') ?? false;
    final isAuthWorker = prefs.getBool('isAuthWorker') ?? false;
    final isAuthAdmin = prefs.getBool('isAuthAdmin') ?? false;

    if (isAuthUser) {
      Navigator.pushNamedAndRemoveUntil(context, '/userDashboard', (route)=> false);
    }else if(isAuthWorker){
      Navigator.pushNamedAndRemoveUntil(context, '/workerdashboard', (route)=> false);
    } else if (isAuthAdmin){
      Navigator.pushNamedAndRemoveUntil(context, '/adminDashboard', (route)=> false);
    } else {
      Navigator.pushNamedAndRemoveUntil(context, '/roleSelection', (route)=> false);
    }
  }
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: primaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Job Junction',
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: secondaryColor,
              ),
            ),
            SizedBox(height: 32),
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(ash),
            ),
          ],
        ),
      ),
    );
  }
}