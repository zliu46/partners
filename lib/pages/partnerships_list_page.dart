import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/database_service.dart';
import '../provider/task_provider.dart';

class PartnershipsListPage extends StatefulWidget {
  @override
  _PartnershipsListPageState createState() => _PartnershipsListPageState();
}

class _PartnershipsListPageState extends State<PartnershipsListPage> {
  final TextEditingController _partnershipNameController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final partnershipsService = context.watch<DatabaseService>();
    final taskProvider = context.watch<TaskProvider>();
    final userName = taskProvider.userName; // Get user ID
    final partnershipId = taskProvider.currentPartnership;

    return Scaffold(
      appBar: AppBar(title: Text("Partnerships")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildCreatePartnershipSection(userName, partnershipsService, taskProvider),
            Divider(),
            Expanded(child: _buildPartnershipList(partnershipsService, taskProvider, userName, partnershipId)),
          ],
        ),
      ),
    );
  }

  /// Create Partnership UI**
  Widget _buildCreatePartnershipSection(String? userName, DatabaseService partnershipsService, TaskProvider taskProvider) {
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
            if (partnershipName.isEmpty || userName == null) return;

            setState(() => _isLoading = true);

            String newPartnershipId = await partnershipsService.createPartnership(userName, partnershipName);

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
  Widget _buildPartnershipList(DatabaseService partnershipsService, TaskProvider taskProvider, String? userName, String partnershipId) {
    return StreamBuilder<Map<String, dynamic>>(
      stream: partnershipsService.fetchPartnershipStream(partnershipId),
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
          ],
        );
      },
    );
  }
}




