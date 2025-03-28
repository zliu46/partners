import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:partners/pages/login_page.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset(
                'lib/assets/welcome.json',
                width: 250,
                height: 250,
                fit: BoxFit.contain,
              ),
              Text(
                'WELCOME TO PARTNERS',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20.0),
              Text(
                'PLEASE LOGIN TO YOUR ACCOUNT\nOR CREATE NEW ACCOUNT TO CONTINUE',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.grey[700],
                ),
              ),
              SizedBox(height: 40.0),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context, MaterialPageRoute (
                    builder: (BuildContext context) => LoginPage(),
                  ),);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                ),
                child: Text(
                  'LOGIN',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(height: 20.0),
              OutlinedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/signUp');
                },
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                ),
                child: Text(
                  'CREATE ACCOUNT',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}