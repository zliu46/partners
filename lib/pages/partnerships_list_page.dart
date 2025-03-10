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
  final TextEditingController _partnershipNameController =
      TextEditingController();
  final TextEditingController _partnershipCodeController =
  TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final taskProvider = context.watch<TaskProvider>();
    final username = taskProvider.username; // Get user ID

    return Scaffold(
      appBar: AppBar(title: Text("Partnerships")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildCreatePartnershipSection(username),
            Divider(),
            _buildJoinPartnershipSection(username),
            Divider(),
            Expanded(child: _PartnershipSelector()),
          ],
        ),
      ),
    );
  }

  /// Create Partnership UI**
  Widget _buildCreatePartnershipSection(String? username) {
    TaskProvider taskProvider = Provider.of<TaskProvider>(context);
    return Column(
      children: [
        Text("Create a Partnership",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
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
                  final partnershipName =
                      _partnershipNameController.text.trim();
                  if (partnershipName.isEmpty || username == null) return;

                  setState(() => _isLoading = true);

                  String newPartnershipId =
                      await taskProvider.createPartnership(partnershipName);

                  setState(() => _isLoading = false);

                  if (newPartnershipId.isNotEmpty) {
                    taskProvider.setPartnershipId(newPartnershipId);
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Partnership Created!")));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("Failed to create partnership.")));
                  }
                },
                child: Text("Create Partnership"),
              ),
      ],
    );
  }

  /// Join Partnership UI**
  Widget _buildJoinPartnershipSection(String? username) {
    TaskProvider taskProvider = Provider.of<TaskProvider>(context);
    return Column(
      children: [
        Text("Join a Partnership",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        SizedBox(height: 10),
        TextField(
          controller: _partnershipCodeController,
          decoration: InputDecoration(
            labelText: "Enter Partnership Code",
            border: OutlineInputBorder(),
          ),
        ),
        SizedBox(height: 10),
        _isLoading
            ? CircularProgressIndicator()
            : ElevatedButton(
          onPressed: () async {
            final partnershipCode =
            _partnershipCodeController.text.trim();
            if (partnershipCode.isEmpty || username == null) return;

            setState(() => _isLoading = true);

            await taskProvider.joinPartnership(partnershipCode);

            setState(() => _isLoading = false);
          },
          child: Text("Join Partnership"),
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
        return StreamBuilder<Map<String, dynamic>>(
            stream: taskProvider.fetchPartnershipStream(partnership.id),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting &&
                  !snapshot.hasData) {
                return const Card(
                  margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  child: ListTile(
                    title: Text('Loading...'),
                    leading: SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                );
              }

              if (snapshot.hasError) {
                return Card(
                  margin:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  child: ListTile(
                    title: const Text('Error loading partnership'),
                    subtitle: Text('${snapshot.error}'),
                    leading: const Icon(Icons.error, color: Colors.red),
                  ),
                );
              }

              if (!snapshot.hasData || snapshot.data == null) {
                return const Card(
                  margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  child: ListTile(
                    title: Text('No data available'),
                    leading: Icon(Icons.info_outline),
                  ),
                );
              }
              var partnershipData = snapshot.data!;

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                child: ListTile(
                  leading: Checkbox(
                    value: isSelected,
                    onChanged: (_) => _handlePartnershipSelection(index),
                    shape: const CircleBorder(),
                  ),
                  title: Text(
                    partnershipData['name'] ?? 'Unnamed Partnership',
                    style: TextStyle(
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  subtitle: Text(
                    'Code: ${partnershipData['secret_code'] ?? 'N/A'}\n'
                    'Partners: ${partnershipData['users'].isNotEmpty ? partnershipData['users'].join(', ') : 'No users'}',
                  ),
                  onTap: () => _handlePartnershipSelection(index),
                ),
              );
            });
      },
    );
  }
}
