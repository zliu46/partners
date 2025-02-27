import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';


import '../provider/task_provider.dart';
import 'no_partnerships_page.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _signUp() async {
    TaskProvider taskProvider =
        Provider.of<TaskProvider>(context, listen: false);
    try {
      // if username is empty or already exists, throw an exception
      if (_usernameController.text.isEmpty ||
          await taskProvider
              .checkUsernameTaken(_usernameController.text.trim())) {
        throw Exception("please change username");
      }
      UserCredential user = await taskProvider.signUp(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );
      // tell db service to add record for new user
      taskProvider.addUser(
          _usernameController.text.trim(),
          _emailController.text.trim(),
          _firstNameController.text.trim(),
          _lastNameController.text.trim(),
          user.user!.uid);

      // Navigate to home page after signup
      await taskProvider.setUser(user);
      if (await taskProvider.hasPartnerships()){
        await taskProvider.fetchPartnerships();
        await taskProvider.setCurrentPartnership(0);
        Navigator.pushReplacementNamed(context, '/home'); // Navigate to home page

      } else {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => NoPartnershipsPage()));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Signup failed: ${e.toString()}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign Up"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: "Username",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Password",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _firstNameController,
              decoration: const InputDecoration(
                labelText: "First Name",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _lastNameController,
              decoration: const InputDecoration(
                labelText: "Last Name",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
                onPressed: _signUp,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 80,
                    vertical: 15,
                  ),
                ),
                child: const Text(
                  "Sign Up",
                  style: TextStyle(color: Colors.white),
                )),
          ],
        ),
      ),
    );
  }
}
