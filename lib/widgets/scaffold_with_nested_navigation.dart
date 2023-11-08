import 'package:biscuitt_ai/notifiers/score_notifier.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../notifiers/transcript_notifier.dart';

class ScaffoldWithNestedNavigation extends StatelessWidget {
  const ScaffoldWithNestedNavigation({
    Key? key,
    required this.navigationShell,
  }) : super(
            key: key ?? const ValueKey<String>('ScaffoldWithNestedNavigation'));

  final StatefulNavigationShell navigationShell;

  void _goBranch(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Biscuitt'),
        shadowColor: Theme.of(context).colorScheme.shadow,
      ),
      body: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => TranscriptNotifier()),
          ChangeNotifierProvider(create: (context) => ScoreNotifier()),
        ],
        child: navigationShell,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        destinations: const [
          NavigationDestination(
              icon: Icon(Icons.create_outlined),
              selectedIcon: Icon(Icons.create),
              label: "Practice"),
          NavigationDestination(
              icon: Icon(Icons.settings),
              selectedIcon: Icon(Icons.settings_outlined),
              label: "Settings"),
        ],
        onDestinationSelected: _goBranch,
      ),
    );
  }
}
