import 'package:flutter/material.dart';

class UpcomingTaskPage extends StatelessWidget {
  const UpcomingTaskPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'UPCOMING TASKS LIST',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ListView(
                  children: [
                    _buildTaskTile('WASH DISHES', '4:00 PM', '1H', Colors.green[100]!),
                    _buildTaskTile('BUY STEAK FROM SAFEWAY', '7:00 PM', '3H', Colors.purple[100]!),
                    _buildTaskTile('BABY BATH', '9:00 PM', '6H', Colors.blue[100]!),
                    _buildTaskTile('BUY PAPER TOWEL', '5:00 PM', '1D', Colors.orange[100]!),
                    _buildTaskTile('BABY’S APPOINTMENT', '10:30 AM', '1W', Colors.grey[300]!),
                  ],
                ),
              ),
              FloatingActionButton(
                onPressed: () {
                 Navigator.pushNamed(context, '/calendar');
                },
                backgroundColor: Colors.amber[100],
                child: Icon(Icons.calendar_today, color: Colors.black),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTaskTile(String title, String time, String duration, Color color) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.0),
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 5.0),
              Row(
                children: [
                  Icon(Icons.access_time, size: 16.0, color: Colors.red),
                  SizedBox(width: 5.0),
                  Text(
                    time,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            ],
          ),
          Text(
            duration,
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}