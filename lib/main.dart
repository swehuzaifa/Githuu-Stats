import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'routes/app_router.dart';

void main() {
  runApp(const ProviderScope(child: GitHubStatsApp()));
}

class GitHubStatsApp extends StatelessWidget {
  const GitHubStatsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'GitHub Stats',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF9FAFB),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2D9CDB),
          brightness: Brightness.light,
          surface: const Color(0xFFF9FAFB),
        ),
        textTheme: GoogleFonts.poppinsTextTheme(),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
        ),
      ),
      routerConfig: appRouter,
    );
  }
}
