import 'package:flutter/material.dart';
import 'package:partners/pages/partnerships_list_page.dart';
import 'package:partners/pages/task_history_page.dart';
import 'package:partners/provider/task_provider.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    TaskProvider taskProvider = Provider.of<TaskProvider>(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.blue[100],
        elevation: 0,
        title: Text(
          'PROFILE',
          style: TextStyle(color: Colors.white),
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
                backgroundColor: Colors.white,
                child: Text(
                  taskProvider.firstName[0],
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
              _buildProfileOption(Icons.people, 'PARTNERSHIPS', 'PARTNERS & ROOMMATE', context, () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => PartnershipsListPage()));
              }),
              _buildProfileOption(Icons.notifications, 'NOTIFICATIONS', 'TASKS REMINDER', context, (){
              }),
              _buildProfileOption(Icons.history, 'HISTORY', 'TASKS HISTORY', context, (){
                Navigator.push(context, MaterialPageRoute(builder: (_)=> TaskHistoryPage()));
              }),
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

