import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  final String userName;
  final String userInitial; // First letter of username for avatar

  const Header({super.key, required this.userName, required this.userInitial});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // User Greeting
          Text(
            "Hi $userName",
            style: const TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),

          // Profile Button (Avatar)
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/profile');
            },
            child: CircleAvatar(
              radius: 24.0,
              backgroundColor: Colors.purple[100],
              child: Text(
                userInitial,
                style: const TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
