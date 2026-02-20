import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:github_stats/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScopeWrapper());
    expect(find.text('GitHub Stats'), findsOneWidget);
  });
}

// Wrap with ProviderScope for testing
class ProviderScopeWrapper extends StatelessWidget {
  const ProviderScopeWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return const GitHubStatsApp();
  }
}
