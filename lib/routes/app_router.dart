import 'package:go_router/go_router.dart';
import '../screens/entry_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/github_dashboard.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const EntryScreen(),
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const ProfileScreen(),
    ),
    GoRoute(
      path: '/github-dashboard',
      builder: (context, state) => const GitHubDashboard(),
    ),
  ],
);
