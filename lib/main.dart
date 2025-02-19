import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:partners/provider/auth_service.dart';
import 'package:partners/provider/task_provider.dart';
import 'package:partners/pages/calendar_page.dart';
import 'package:partners/pages/create_task_page.dart';
import 'package:partners/firebase_options.dart';
import 'package:partners/pages/profile_page.dart';
import 'package:partners/pages/sign_up_page.dart';
import 'package:partners/pages/task_categories_page.dart';
import 'package:partners/pages/upcoming_task_page.dart';
import 'package:partners/pages/welcome_page.dart';
import 'package:provider/provider.dart';
import 'package:partners/pages//home_page.dart';
import 'package:partners/pages//login_page.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
      MultiProvider(
        providers: [
          Provider<AuthService>(create: (_) => AuthService()),
          Provider<TaskProvider>(create: (_) => TaskProvider()),
        ],
        child: const MyApp()
      ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Navigation',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // Define routes
      initialRoute: '/',
      routes: {
        '/': (context) => WelcomePage(),
        '/login': (context) => LoginPage(),
        '/signUp': (context) => SignUpPage(),
        '/home': (context) => HomePage(),// Add other pages here
        '/taskCategories' : (context) => TaskCategoriesPage(),
        '/profile' : (context) => ProfilePage(),
        '/upcomingTask' : (context) => UpcomingTaskPage(),
        '/calendar' : (context) => CalendarPage(),
        '/createTask' : (context) => CreateTaskPage(),
      },
    );
  }
}

