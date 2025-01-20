import 'package:flutter/material.dart';
import 'package:partners/baby_task_page.dart';
import 'package:partners/calendar_page.dart';
import 'package:partners/create_task_page.dart';
import 'package:partners/profile_page.dart';
import 'package:partners/sign_up_page.dart';
import 'package:partners/task_categories_page.dart';
import 'package:partners/task_details_page.dart';
import 'package:partners/upcoming_task_page.dart';
import 'package:partners/welcome_page.dart';
import 'home_page.dart';
import 'login_page.dart';


void main() {
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
        '/register': (context) => SignUpPage(),
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

