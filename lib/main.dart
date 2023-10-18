import 'package:biscuitt_ai/screens/history_screen.dart';
import 'package:biscuitt_ai/screens/quiz_screen.dart';
import 'package:biscuitt_ai/screens/ranking_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/score_model.dart';

void main() {
  runApp(const BiscuittApp());
}

class BiscuittApp extends StatelessWidget {
  const BiscuittApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Biscuitt',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightGreen),
        useMaterial3: true,
      ),
      home: const MainAppContainer(title: 'Biscuitt: (TODO make good tagline)'),
    );
  }
}

class MainAppContainer extends StatefulWidget {
  const MainAppContainer({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MainAppContainer> createState() => _MainAppContainerState();
}

class _MainAppContainerState extends State<MainAppContainer> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    NavigationBar navBar = NavigationBar(
      destinations: const <Widget>[
        NavigationDestination(
            icon: Icon(Icons.create_outlined),
            selectedIcon: Icon(Icons.create),
            label: "Quiz"),
        NavigationDestination(icon: Icon(Icons.stars), label: "Ranking"),
        NavigationDestination(
            icon: Icon(Icons.view_list),
            selectedIcon: Icon(Icons.view_list_outlined),
            label: "History"),
      ],
      onDestinationSelected: (int index) {
        setState(() {
          currentPageIndex = index;
        });
      },
      selectedIndex: currentPageIndex,
    );

    return Scaffold(
      bottomNavigationBar: navBar,
      body: <Widget>[
        QuizScreen(),
        RankingScreen(),
        HistoryScreen(),
      ][currentPageIndex],
    );
  }
}
