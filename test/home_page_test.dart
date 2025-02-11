
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:partners/pages/home_page.dart';
import 'package:partners/provider/task_provider.dart';
import 'package:partners/widgets/task_category_card.dart';
import 'package:provider/provider.dart';

main(){
  testWidgets("Home Page displays all sections", (tester) async {
    HomePage homePage = HomePage();
    await tester.pumpWidget(ChangeNotifierProvider(
      create: (context) => TaskProvider(),
      child: MaterialApp(home: Scaffold(body: homePage))
      ),
    );
    expect(find.text("TASK CATEGORIES"), findsOneWidget);
    expect(find.text("ONGOING TASKS"), findsOneWidget);
    expect(find.text("UPCOMING TASKS"), findsOneWidget);
  });

  testWidgets("Displays all categories", (tester) async {
    HomePage homePage = HomePage();
    await tester.pumpWidget(ChangeNotifierProvider(
      create: (context) => TaskProvider(),
      child: MaterialApp(home: Scaffold(body: homePage))
    ));
    TaskProvider taskProvider = Provider.of<TaskProvider>(tester.element(find.byType(HomePage)), listen:false);
    expect(find.byType(TaskCategoryCard), findsNWidgets(taskProvider.categories.length));
  });
}