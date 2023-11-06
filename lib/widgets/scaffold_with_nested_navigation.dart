import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
      appBar: AppBar(),
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        destinations: const [
          NavigationDestination(
              icon: Icon(Icons.create_outlined),
              selectedIcon: Icon(Icons.create),
              label: "Practice"),
          NavigationDestination(
              icon: Icon(Icons.view_list),
              selectedIcon: Icon(Icons.view_list_outlined),
              label: "History"),
        ],
        onDestinationSelected: _goBranch,
      ),
    );
  }
}
