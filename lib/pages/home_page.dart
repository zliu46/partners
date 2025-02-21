import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:partners/pages/calendar_page.dart';
import 'package:partners/pages/profile_page.dart';
import 'package:partners/widgets/expandable_fab.dart';
import 'package:partners/widgets/header.dart';
import 'package:partners/widgets/ongoing_task_section.dart';
import 'package:partners/widgets/upcoming_task_section.dart';
import 'package:provider/provider.dart';
import 'package:partners/provider/task_provider.dart';
import 'package:partners/widgets/task_categories_section.dart';
import 'package:partners/widgets/task_list_section.dart';

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
    final taskProvider = Provider.of<TaskProvider>(context);
    taskProvider.fetchTasks();
    taskProvider.fetchCategories();
    final categories = taskProvider.categories;
    final ongoingTasks = taskProvider.ongoingTasks;
    final upcomingTasks = taskProvider.upcomingTasks;

    return Scaffold(
      bottomNavigationBar: NavigationBar(
          onDestinationSelected: (int index) {
            setState(() {
              currentPageIndex = index;
            });
          },
          selectedIndex: currentPageIndex,
          destinations: <Widget>[
            NavigationDestination(
                selectedIcon: Icon(Icons.home),
                icon: Icon(Icons.home_outlined),
                label: 'Home'),
            NavigationDestination(
              selectedIcon: Icon(Icons.calendar_today),
              icon: Icon(Icons.calendar_today_outlined),
              label: 'Calendar',
            ),
            NavigationDestination(
                icon: CircleAvatar(
                  radius: 20.0,
                  backgroundColor: Colors.purple[100],
                  child: Text(
                    'N',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
                label: 'Profile')
          ]),
      body: <Widget>[
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Header(
                  userName: 'Noah',
                ),
                // Task Categories Section
                TaskCategoriesSection(categories: categories),
                const SizedBox(height: 20.0),

                // Ongoing Tasks Section
                OngoingTaskSection(),
                const SizedBox(height: 20.0),

                UpcomingTaskSection(),
              ],
            ),
          ),
        ),
        CalendarPage(),
        ProfilePage(),
      ][currentPageIndex],
      floatingActionButton: currentPageIndex == 0
          ? ExpandableFab(
              distance: 112,
              children: _expandableFabChildren(context),
            )
          : null,
    );
  }
}

List<Widget> _expandableFabChildren(BuildContext context) {
  return [
    Row(children: [
      Text("Add task"),
      ActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => CreateTaskPage()));
        }, //add task
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
      color: theme.colorScheme.secondary,
      elevation: 4,
      child: IconButton(
        onPressed: onPressed,
        icon: icon,
        color: theme.colorScheme.onSecondary,
      ),
    );
  }
}
