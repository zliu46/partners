
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
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () async {
                await NotiService().showNotification(
                  id: 0,
                  title: "Test Notification",
                  body: "This is a test notification.",
                );
              },
              child: Text("Send Notification"),
            ),

            ElevatedButton(
              onPressed: () async {
                await NotiService().scheduleTaskNotification(
                  id: 1,
                  title: "hahahahaha",
                  body: "This is a test scheduled notification.",
                  hour : 19,
                  minute: 19,
                );
              },
              child: Text("Schedule Notification"),
            ),
          ],
        )
      ),
    );
  }
}
