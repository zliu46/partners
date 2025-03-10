import 'package:flutter/material.dart';
import 'package:partners/pages/ai_chat_page.dart';
import 'package:partners/pages/calendar_page.dart';
import 'package:partners/pages/profile_page.dart';
import 'package:partners/widgets/expandable_fab.dart';
import 'package:partners/widgets/ongoing_task_section.dart';
import 'package:partners/widgets/upcoming_task_section.dart';
import 'package:provider/provider.dart';
import 'package:partners/provider/task_provider.dart';
import 'package:partners/widgets/task_categories_section.dart';
import 'package:partners/widgets/add_category_dialog.dart';

import 'create_task_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    var taskProvider = Provider.of<TaskProvider>(context);
    taskProvider.fetchTasks();
    taskProvider.fetchCategories();

    final List<Widget> pages = [
      SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TaskCategoriesSection(categories: taskProvider.categories),
                const SizedBox(height: 20.0),
                OngoingTaskSection(),
                const SizedBox(height: 20.0),
                UpcomingTaskSection(),
              ],
            ),
          ),
        ),
      ),
      CalendarPage(),
      ProfilePage(),
      AIChatPage(),
    ];
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 50,
       backgroundColor: Colors.blue[100],
       // Customize AppBar color
      ),
      drawer: Drawer(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 80, bottom: 5),
              color: Colors.blue[100], // Background color
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Profile Image
                  CircleAvatar(
                    radius: 40, // Bigger size
                    backgroundColor: Colors.white,
                    child: Text(
                      taskProvider.firstName[0].toUpperCase(), // Capitalize initial
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10), // Space below avatar
                  // Name
                  Text(
                    taskProvider.firstName,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Username or email
                  Text(
                    "test_user", // Replace with taskProvider.username
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),

            // Navigation List Items
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              selected: currentPageIndex == 0,
              onTap: () {
                setState(() => currentPageIndex = 0);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: const Text('Calendar'),
              selected: currentPageIndex == 1,
              onTap: () {
                setState(() => currentPageIndex = 1);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profile'),
              selected: currentPageIndex == 2,
              onTap: () {
                setState(() => currentPageIndex = 2);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.chat),
              title: const Text('AI Chat'),
              selected: currentPageIndex == 3,
              onTap: () {
                setState(() => currentPageIndex = 3);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: pages[currentPageIndex], // Load selected page dynamically

      // Floating Action Button (Only for HomePage)
      floatingActionButton: currentPageIndex == 0
          ? ExpandableFab(
        distance: 100,
        children: _expandableFabChildren(context),
      )
          : null,
    );
  }
}

// Floating Action Buttons for HomePage
List<Widget> _expandableFabChildren(BuildContext context) {
  return [
    Row(children: [
      Text("Add task"),
      ActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => CreateTaskPage()));
        }, // Add task
        icon: const Icon(Icons.add),
      )
    ]),
    Row(children: [
      Text("Add category"),
      ActionButton(
        onPressed: (() {
          showAddCategoryDialog(context);
        }),
        icon: const Icon(Icons.add),
      )
    ])
  ];
}

// Floating Action Button UI
@immutable
class ActionButton extends StatelessWidget {
  const ActionButton({
    super.key,
    this.onPressed,
    required this.icon,
  });
  final VoidCallback? onPressed;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      color: Colors.blue[100],
      elevation: 4,
      child: IconButton(
        onPressed: onPressed,
        icon: icon,
        color: theme.colorScheme.onSecondary,
      ),
    );
  }
}

