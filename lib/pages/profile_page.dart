import 'package:flutter/material.dart';
import 'package:partners/pages/partnerships_list_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.purple[100],
        elevation: 0,
        title: Text(
          'PROFILE',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            //crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 50.0,
                backgroundColor: Colors.grey[300],
                child: Text(
                  'N',
                  style: TextStyle(
                    fontSize: 40.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              SizedBox(height: 10.0),
              TextButton(
                onPressed: () {
                  // Add functionality to change picture
                },
                child: Text('CHANGE PICTURE'),
              ),
              SizedBox(height: 20.0),
              _buildProfileOption(Icons.edit, 'EDIT PROFILE', 'EDIT YOUR PROFILE', context, null),
              //Navigate to Partnership Page
              _buildProfileOption(Icons.people, 'PEOPLE', 'PARTNERS & ROOMMATE', context, () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => PartnershipsListPage()));
              }),
              _buildProfileOption(Icons.notifications, 'NOTIFICATIONS', 'TASKS REMINDER', context, null),
              _buildProfileOption(Icons.history, 'HISTORY', 'TASKS HISTORY', context, null),
              _buildProfileOption(Icons.help, 'HELP', 'HELP CENTER, CONTACT US, PRIVACY POLICY', context, null),
              _buildProfileOption(Icons.settings, 'SETTINGS', 'THEME, ROLE, TASK TYPE', context, null),
              _buildProfileOption(
                  Icons.logout,
                  'LOGOUT',
                  '',
                  context,
                      () {
                    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
                  }),
              const SizedBox(height: 20.0),
              TextButton(
                onPressed: () {
                  // Add invite functionality
                },
                child: Text('INVITE A FRIEND', style: TextStyle(color: Colors.black)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileOption(IconData icon, String title, String subtitle, BuildContext context, VoidCallback? onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.black),
      title: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: subtitle.isNotEmpty
          ? Text(
        subtitle,
        style: TextStyle(color: Colors.grey[600]),
      )
          : null,
      onTap: onTap,
    );
  }
}

