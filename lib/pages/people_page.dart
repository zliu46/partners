import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/partnerships_service.dart';
import '../provider/task_provider.dart';

class PeoplePage extends StatefulWidget {
  @override
  _PeoplePageState createState() => _PeoplePageState();
}

class _PeoplePageState extends State<PeoplePage> {
  final TextEditingController _groupNameController = TextEditingController();
  final TextEditingController _joinGroupController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final partnershipsService = context.watch<PartnershipsService>();
    final taskProvider = context.watch<TaskProvider>();
    final userId = taskProvider.currentUserId;
    final userGroupId = taskProvider.partnershipId; // Current user's group ID

    return Scaffold(
      appBar: AppBar(title: const Text("Manage Groups")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(child: _buildUserGroup(userGroupId, partnershipsService)), // Real-time group info
            Divider(),
            _buildCreateGroupSection(userId, partnershipsService, taskProvider), // Create group
            Divider(),
            _buildJoinGroupSection(userId, partnershipsService, taskProvider), // Join group
          ],
        ),
      ),
    );
  }

  /// **1️⃣ Display User's Current Group and Members (Live Updates)**
  Widget _buildUserGroup(String? groupId, PartnershipsService partnershipsService) {
    if (groupId == null || groupId.isEmpty) {
      return Center(child: Text("You are not in a group. Create or join one below!"));
    }

    return StreamBuilder<DocumentSnapshot>(
      stream: partnershipsService.getPartnershipStream(groupId), // Live data from Firestore
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || !snapshot.data!.exists) {
          return Center(child: Text("Group not found."));
        }

        final groupData = snapshot.data!.data() as Map<String, dynamic>;
        final members = List<String>.from(groupData['members'] ?? []);

        return Column(
          children: [
            Text("Your Group: ${groupData['groupname'] ?? 'Unnamed Group'}",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: members.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(members[index]),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  /// **2️⃣ Create a New Group**
  Widget _buildCreateGroupSection(String? userId, PartnershipsService partnershipsService, TaskProvider taskProvider) {
    return Column(
      children: [
        Text("Create a Group", style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 10),
        TextField(
          controller: _groupNameController,
          decoration: InputDecoration(
            labelText: "Enter Group Name",
            border: OutlineInputBorder(),
          ),
        ),
        SizedBox(height: 10),
        _isLoading
            ? CircularProgressIndicator()
            : ElevatedButton(
          onPressed: () async {
            final partnershipName = _groupNameController.text.trim();
            if (partnershipName.isEmpty) return;

            setState(() => _isLoading = true);

            String? newPartnershipId = await partnershipsService.createPartnership(userId!, partnershipName);

            setState(() => _isLoading = false);

            if (newPartnershipId != null) {
              taskProvider.setPartnershipId(newPartnershipId);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Partnership Created!")));
            } else {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("❌ Failed to create partnership.")));
            }
          },
          child: Text("Create Partnership"),
        ),
      ],
    );
  }

  /// **3️⃣ Join an Existing Group**
  Widget _buildJoinGroupSection(String? userId, PartnershipsService partnershipsService, TaskProvider taskProvider) {
    return Column(
      children: [
        Text("Join a Group", style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 10),
        TextField(
          controller: _joinGroupController,
          decoration: InputDecoration(
            labelText: "Enter Group ID",
            border: OutlineInputBorder(),
          ),
        ),
        SizedBox(height: 10),
        _isLoading
            ? CircularProgressIndicator()
            : ElevatedButton(
          onPressed: () async {
            final groupId = _joinGroupController.text.trim();
            if (groupId.isEmpty) return;

            setState(() => _isLoading = true);

            bool success = await partnershipsService.joinPartnership(userId!, groupId);

            setState(() => _isLoading = false);

            if (success) {
              taskProvider.setPartnershipId(groupId);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Joined Group Successfully!")));
            } else {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("❌ Failed to join group!")));
            }
          },
          child: Text("Join Group"),
        ),
      ],
    );
  }
}
