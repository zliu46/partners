import 'package:flutter/material.dart';

import 'model/task_category.dart';
import 'model/task_details.dart';

// Home Page
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              _Header(),
              SizedBox(height: 20.0),
              // Task Categories Section
              _TaskCategoriesHeader(),
              SizedBox(height: 10.0),
              Column(
                children: [
                  Row(
                    children: [
                      _TaskCategory(TaskCategory("Baby", Colors.amber[200]!), 5),
                      SizedBox(width: 10.0),
                      _TaskCategory(TaskCategory("Room", Colors.green[200]!), 2),
                    ],
                  ),
                  SizedBox(height: 10.0),
                  Row(
                    children: [
                      _TaskCategory(TaskCategory('GROCERIES', Colors.purple[200]!), 2),
                      SizedBox(width: 10.0),
                      _TaskCategory(TaskCategory('APPOINTMENT', Colors.grey[300]!), 2),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20.0),

              // Ongoing Tasks Section
              Text(
                'ONGOING TASKS',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10.0),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/taskDetail',
                    arguments: TaskDetails(
                      title: 'Feed the baby',
                      category: 'Baby care',
                      description: 'Heat up the milk in a bottle then feed the baby. Remember to burp the baby after.',
                      createdBy: 'Samantha',
                    ),
                  );
                },
                child: Container(
                  padding: EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.amber[100],
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'FEED THE BABY',
                        style: TextStyle(fontSize: 16.0),
                      ),
                      Row(
                        children: [
                          Icon(Icons.access_time, size: 16.0, color: Colors.red),
                          SizedBox(width: 5.0),
                          Text(
                            '2:45 PM - 3:00 PM',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 20.0),

              // Upcoming Tasks Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'UPCOMING TASKS',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context,'/upcomingTask');
                    },
                    child: Text('SEE ALL'),
                  ),
                ],
              ),
              SizedBox(height: 10.0),
              Expanded(
                child: ListView(
                  children: [
                    Container(
                      padding: EdgeInsets.all(16.0),
                      margin: EdgeInsets.only(bottom: 10.0),
                      decoration: BoxDecoration(
                        color: Colors.green[100],
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'WASH DISHES',
                            style: TextStyle(fontSize: 16.0),
                          ),
                          Row(
                            children: [
                              Text(
                                '1H',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 5.0),
                              Icon(Icons.access_time, size: 16.0, color: Colors.red),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(16.0),
                      margin: EdgeInsets.only(bottom: 10.0),
                      decoration: BoxDecoration(
                        color: Colors.purple[100],
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'BUY STEAK FROM SAFEWAY',
                            style: TextStyle(fontSize: 16.0),
                          ),
                          Row(
                            children: [
                              Text(
                                '3H',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 5.0),
                              Icon(Icons.access_time, size: 16.0, color: Colors.red),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(16.0),
                      margin: EdgeInsets.only(bottom: 10.0),
                      decoration: BoxDecoration(
                        color: Colors.amber[100],
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'BATH BABY',
                            style: TextStyle(fontSize: 16.0),
                          ),
                          Row(
                            children: [
                              Text(
                                '6H',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 5.0),
                              Icon(Icons.access_time, size: 16.0, color: Colors.red),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TaskCategory extends StatelessWidget {
  final TaskCategory taskCategory;
  final int numTasks;
  const _TaskCategory(this.taskCategory, this.numTasks, {super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, '/babyTask');
        },
        child: Container(
          height: 120.0,
          decoration: BoxDecoration(
            color: taskCategory.color,
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Center(
            child: Text(
              '$taskCategory\n$numTasks TASKS',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16.0),
            ),
          ),
        ),
      ),
    );
  }
}

class _TaskCategoriesHeader extends StatelessWidget{

  const _TaskCategoriesHeader({super.key});
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'TASK CATEGORIES',
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.pushNamed(context, '/taskCategories');
          },
          child: Text('SEE ALL'),
        ),
      ],
    );
  }
}

// maybe this should be a stateful widget since it has to know user
// replace hard coded values with user passed from widget construction
class _Header extends StatelessWidget {
  const _Header({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'HI NOAH',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        GestureDetector(
          onTap: () {
            Navigator.pushNamed(context,'/profile');
          },
          child: CircleAvatar(
            radius: 24.0,
            child: Text(
              'N',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
