import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:partners/screens/baby_task_page.dart';
import 'package:partners/screens/calendar_page.dart';
import 'package:partners/screens/create_task_page.dart';
import 'package:partners/firebase_options.dart';
import 'package:partners/screens/profile_page.dart';
import 'package:partners/screens/sign_up_page.dart';
import 'package:partners/screens/task_categories_page.dart';
import 'package:partners/screens/task_details_page.dart';
import 'package:partners/screens/upcoming_task_page.dart';
import 'package:partners/screens/welcome_page.dart';
import 'screens/home_page.dart';
import 'screens/login_page.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Navigation Demo',
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
        '/babyTask' : (context) => BabyTaskPage(),
        '/taskDetail': (context) => TaskDetailsPage(),
      },
    );
  }
}

