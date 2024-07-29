import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:labor_managment/admin/admin_dashboard.dart';
import 'package:labor_managment/admin/admin_home.dart';
import 'package:labor_managment/admin/admin_login.dart';
import 'package:labor_managment/admin/staff_management.dart';
import 'package:labor_managment/admin/user_managment.dart';
import 'package:labor_managment/constants/colors.dart';
import 'package:labor_managment/role_selection_page.dart';
import 'package:labor_managment/splash_screen.dart';
import 'package:labor_managment/user/user_dashboard_page.dart';
import 'package:labor_managment/user/user_home.dart';
import 'package:labor_managment/user/user_login.dart';
import 'package:labor_managment/user/user_registration.dart';
import 'package:labor_managment/user/workers_list_page.dart';
import 'package:labor_managment/worker/dashboard.dart';
import 'package:labor_managment/worker/edit_worker_page.dart';
import 'package:labor_managment/worker/worker_home.dart';
import 'package:labor_managment/worker/worker_login.dart';
import 'package:labor_managment/worker/worker_profile.dart';
import 'package:labor_managment/worker/worker_registration.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/roleSelection',
      routes: {
        '/': (context) => SplashScreen(),
        '/roleSelection': (context) => RoleSelectionPage(),
        //user
        '/userLogin': (context) => UserLogin(),
        '/userRegistration': (context) => UserRegistration(),
        '/userHome': (context) => UserHome(),
        '/userDashboard': (context) => UserDashboardPage(),
        //worker
        '/workerRegistration': (context) => WorkerRegistration(),
        '/workerLogin': (context) => WorkerLogin(),
        '/workerHome': (context) => WorkerHome(),
        '/workersList': (context) => Workerslistpage(),
        '/workerProfile': (context) => WorkerProfile(),
        '/workerdashboard': (context) => DashboardPage(),
        '/editWorker': (context) => EditWorkerPage(),
        //Admin
        '/adminLogin': (context) => AdminLoginPage(),
        '/adminHome': (context) => AdminHome(),
        '/adminDashboard': (context) => AdminDashboard(),
        '/userManagement': (context) => UserManagementPage(),
        '/staffManagment': (context) => StaffManagementPage(),
      },
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: ash),
          useMaterial3: true,
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: AppBarTheme(backgroundColor: Colors.white),
          primarySwatch: Colors.blue,
          brightness: Brightness.light,
          hintColor: Color(0xFF066A75)),
    );
  }
}
