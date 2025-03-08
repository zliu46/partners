import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/partnership.dart';
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
            _buildCreatePartnershipSection(username, taskProvider),
            Divider(),
            Expanded(child: _PartnershipSelector()),
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

}


class _PartnershipSelector extends StatefulWidget {

  _PartnershipSelector({
    Key? key,

  }) : super(key: key);

  @override
  State<_PartnershipSelector> createState() => _PartnershipSelectorState();
}

class _PartnershipSelectorState extends State<_PartnershipSelector> {
  late int? _activePartnershipIndex;
  late List<Partnership> partnerships;
  late TaskProvider taskProvider;
  @override
  void initState() {
    super.initState();
  }

  void _handlePartnershipSelection(int index) {
    setState(() {
      _activePartnershipIndex = index;
    });
    taskProvider.setCurrentPartnership(index);
  }

  @override
  Widget build(BuildContext context) {
    taskProvider = Provider.of<TaskProvider>(context);
    _activePartnershipIndex = taskProvider.currentPartnershipIndex;
    partnerships = taskProvider.partnerships;
    return ListView.builder(
      itemCount: partnerships.length,
      itemBuilder: (context, index) {
        final isSelected = index == _activePartnershipIndex;
        Partnership partnership = partnerships[index];
        return StreamBuilder<Map<String, dynamic>> (
          stream: taskProvider.fetchPartnershipStream(partnership.id),
            builder: (context, snapshot)
        {
          var partnership = snapshot.data!;
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            child: ListTile(
              leading: Checkbox(
                value: isSelected,
                onChanged: (_) => _handlePartnershipSelection(index),
                shape: const CircleBorder(),
              ),
              title: Text(
                partnership['name'],
                style: TextStyle(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              subtitle: Text('Code: ${partnership['secret_code']}'),
              onTap: () => _handlePartnershipSelection(index),
            ),
          );
        }
        );
      },
    );
  }
}



