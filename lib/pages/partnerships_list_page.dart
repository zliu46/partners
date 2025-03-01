import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/task_provider.dart';

class PartnershipsListPage extends StatefulWidget {
  const PartnershipsListPage({super.key});

  @override
  _PartnershipsListPageState createState() => _PartnershipsListPageState();
}

class _PartnershipsListPageState extends State<PartnershipsListPage> {
  final TextEditingController _partnershipNameController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final taskProvider = context.watch<TaskProvider>();
    final username = taskProvider.username; // Get user ID
    final partnershipId = taskProvider.currentPartnership.id;

    return Scaffold(
      appBar: AppBar(title: Text("Partnerships")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            //_buildCreatePartnershipSection(username, taskProvider),
            //Divider(),
            Expanded(child: _buildPartnershipList(taskProvider, username, partnershipId)),
          ],
        ),
      ),
    );
  }

  /// Create Partnership UI**
  Widget _buildCreatePartnershipSection(String? username, TaskProvider taskProvider) {
    return Column(
      children: [
        Text("Create a Partnership", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        SizedBox(height: 10),
        TextField(
          controller: _partnershipNameController,
          decoration: InputDecoration(
            labelText: "Enter Partnership Name",
            border: OutlineInputBorder(),
          ),
        ),
        SizedBox(height: 10),
        _isLoading
            ? CircularProgressIndicator()
            : ElevatedButton(
          onPressed: () async {
            final partnershipName = _partnershipNameController.text.trim();
            if (partnershipName.isEmpty || username == null) return;

            setState(() => _isLoading = true);

            String newPartnershipId = await taskProvider.createPartnership(partnershipName);

            setState(() => _isLoading = false);

            if (newPartnershipId.isNotEmpty) {
              taskProvider.setPartnershipId(newPartnershipId);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Partnership Created!")));
            } else {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Failed to create partnership.")));
            }
          },
          child: Text("Create Partnership"),
        ),
      ],
    );
  }

  /// Display Partnerships with Join Option**
  Widget _buildPartnershipList(TaskProvider taskProvider, String? username, String partnershipId) {
    return StreamBuilder<Map<String, dynamic>>(
      stream: taskProvider.fetchPartnershipStream(partnershipId),
      builder: (context, snapshot) {

        if (!snapshot.hasData || snapshot.data == null) {
          return Center(child: Text("Partnership not found."));
        }

        var partnership = snapshot.data!;
        String partnershipName = partnership['name'];
        List<String> members = partnership['users'];
        return Column(
          children: [
            Text("Group Name: $partnershipName"),
            SizedBox(height: 10),
            Text("Members: ${members.join(', ')}"),
            Text("Partnership code: ${partnership['secret_code']}")
          ],
        );
      },
    );
  }
}




