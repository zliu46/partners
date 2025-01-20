import 'package:flutter/material.dart';

class CalendarPage extends StatelessWidget {
  const CalendarPage({super.key});

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
          'CALENDAR',
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
              Text(
                'JANUARY 08',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 5.0),
              Text(
                '4 task today',
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 20.0),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(7, (index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Column(
                        children: [
                          Text(
                            ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'][index],
                            style: TextStyle(
                              fontSize: 14.0,
                              color: index == 3 ? Colors.black : Colors.grey,
                            ),
                          ),
                          SizedBox(height: 5.0),
                          Container(
                            decoration: BoxDecoration(
                              color: index == 3 ? Colors.black : Colors.grey[300],
                              shape: BoxShape.circle,
                            ),
                            padding: EdgeInsets.all(10.0),
                            child: Text(
                              (index + 5).toString(),
                              style: TextStyle(
                                color: index == 3 ? Colors.white : Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              ),
              SizedBox(height: 20.0),
              Expanded(
                child: ListView(
                  children: [
                    _buildTaskTile('CLEAN THE KITCHEN', '09:30 AM', Colors.grey[200]!),
                    _buildTaskTile('FEED THE BABY', '10:00 AM', Colors.green[100]!),
                    _buildTaskTile('DOCTOR’S APPOINTMENT', '12:00 PM', Colors.purple[100]!),
                    _buildTaskTile('FEED THE BABY', '01:30 PM', Colors.green[100]!),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTaskTile(String title, String time, Color color) {
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
        ],
      ),
    );
  }
}
