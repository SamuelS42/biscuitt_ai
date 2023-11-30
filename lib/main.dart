import 'package:biscuitt_ai/screens/history_screen.dart';
import 'package:biscuitt_ai/screens/settings_screen.dart';
import 'package:biscuitt_ai/screens/quiz_screen.dart';
import 'package:biscuitt_ai/screens/transcript_list_screen.dart';
import 'package:biscuitt_ai/widgets/scaffold_with_nested_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

Future main() async {
  await dotenv.load(fileName: '.env');
  MobileAds.instance.initialize();
  runApp(const BiscuittApp());
}

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorPracticeKey =
    GlobalKey<NavigatorState>(debugLabel: 'shellPractice');
final _shellNavigatorHistoryKey =
    GlobalKey<NavigatorState>(debugLabel: 'shellHistory');
final _shellNavigatorSettingsKey =
    GlobalKey<NavigatorState>(debugLabel: 'shellSettings');

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
              pageBuilder: (context, state) => const NoTransitionPage(
                child: TranscriptListScreen(),
              ),
              routes: [
                GoRoute(
                    path: 'quiz',
                    pageBuilder: (context, state) => const NoTransitionPage(
                          child: QuizScreen(),
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
        ),
        StatefulShellBranch(
          navigatorKey: _shellNavigatorSettingsKey,
          routes: [
            GoRoute(
              path: '/settings',
              pageBuilder: (context, state) =>
                  const NoTransitionPage(child: SettingsScreen()),
              routes: [],
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
