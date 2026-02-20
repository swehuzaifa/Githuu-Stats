import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/contribution_day.dart';
import '../services/github_service.dart';

/// Provider that fetches GitHub contributions.
/// Returns a [GitHubProfile] with all contribution data.
final githubProvider = FutureProvider<GitHubProfile>((ref) async {
  return GitHubService.fetchContributions();
});
