import 'package:flutter/material.dart';
import '../provider/noti_service.dart';

class NotificationTestPage extends StatelessWidget {
  const NotificationTestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () {
        Navigator.pop(context);
        })
      ),
      body: Center(
        child: ElevatedButton(
            onPressed: () async {
              await NotiService().initNotification();
              NotiService().showNotification (
            title: "Title",
            body : "Body",
          );
        },
            child: const Text('Send Notification'),
        ),
      ),
    );
  }
}
