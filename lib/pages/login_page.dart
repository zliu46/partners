import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:partners/pages/no_partnerships_page.dart';
import 'package:partners/provider/task_provider.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[100],
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context)
            .unfocus(), // Hide keyboard when tapping outside
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40.0),
                  const Text(
                    'LOGIN',
                    style: TextStyle(
                      fontSize: 32.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 40.0),
                  _inputField(_emailController, 'EMAIL'),
                  const SizedBox(height: 20.0),
                  _inputField(_passwordController, 'PASSWORD'),
                  const SizedBox(height: 40.0),
                  Center(
                    child: ElevatedButton(
                      onPressed: _signIn,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 80,
                          vertical: 15,
                        ),
                      ),
                      child: const Text(
                        'LOGIN',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  Center(
                    child: TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/signUp');
                      },
                      child: Text(
                        "DON'T HAVE AN ACCOUNT? SIGN UP",
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20.0), // Extra padding at the bottom
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _inputField(TextEditingController controller, String label) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
    );
  }

  Future<void> _signIn() async {
    TaskProvider taskProvider =
        Provider.of<TaskProvider>(context, listen: false);
    try {
      UserCredential user = await taskProvider.signIn(
          _emailController.text.trim(), _passwordController.text.trim());
      if (await taskProvider.hasPartnerships()) {
        await taskProvider.fetchPartnerships();
        await taskProvider.setCurrentPartnership(0);
        Navigator.pushReplacementNamed(
            context, '/home'); // Navigate to home page
      } else {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => NoPartnershipsPage()));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Login failed: ${e.toString()}")),
      );
    }
  }
}
