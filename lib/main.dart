import 'package:biscuitt_ai/screens/history_screen.dart';
import 'package:biscuitt_ai/screens/quiz_screen.dart';
import 'package:biscuitt_ai/screens/transcript_list_screen.dart';
import 'package:biscuitt_ai/widgets/scaffold_with_nested_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'models/file_model.dart';

Future main() async {
  await dotenv.load(fileName: '.env');
  runApp(const BiscuittApp());
}

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorPracticeKey =
    GlobalKey<NavigatorState>(debugLabel: 'shellPractice');
final _shellNavigatorHistoryKey =
    GlobalKey<NavigatorState>(debugLabel: 'shellHistory');

final _router =
    GoRouter(initialLocation: '/', navigatorKey: _rootNavigatorKey, routes: [
  StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return ScaffoldWithNestedNavigation(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          navigatorKey: _shellNavigatorPracticeKey,
          routes: [
            GoRoute(
              path: '/',
              pageBuilder: (context, state) => NoTransitionPage(
                  child: ChangeNotifierProvider(
                create: (context) => FileModel(),
                child: const TranscriptListScreen(),
              )),
              routes: [
                GoRoute(
                    path: 'quiz',
                    builder: (context, state) => ChangeNotifierProvider(
                          create: (context) => FileModel(),
                          child: const QuizScreen(),
                        )),
              ],
            )
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _shellNavigatorHistoryKey,
          routes: [
            GoRoute(
              path: '/history',
              pageBuilder: (context, state) =>
                  const NoTransitionPage(child: HistoryScreen()),
              routes: const [],
            )
          ],
        )
      ])
]);

class BiscuittApp extends StatelessWidget {
  const BiscuittApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Biscuitt',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      routerConfig: _router,
    );
  }
}
