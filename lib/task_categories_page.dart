import 'package:flutter/material.dart';
// Task Categories Page
class TaskCategoriesPage extends StatelessWidget {
  const TaskCategoriesPage({super.key});

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
          'Task Categories',
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
                'TASK CATEGORIES',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20.0),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                  children: [
                    _buildCategoryCard('BABY', Colors.amber[200]!),
                    _buildCategoryCard('ROOM', Colors.green[200]!),
                    _buildCategoryCard('GROCERIES', Colors.purple[200]!),
                    _buildCategoryCard('APPOINTMENT', Colors.grey[300]!),
                  ],
                ),
              ),
              FloatingActionButton(
                onPressed: () {
                  // Add new task category functionality
                },
                backgroundColor: Colors.purple[100],
                child: Icon(Icons.add, color: Colors.black),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryCard(String title, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Center(
        child: Text(
          title,
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}