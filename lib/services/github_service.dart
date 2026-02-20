import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/contribution_day.dart';

class GitHubService {
  // For Android emulator use: http://10.0.2.2:3000
  // For physical device / web: use your machine's local IP
  // For localhost testing: http://localhost:3000
  static const String _baseUrl = 'http://192.168.1.7:3000';

  /// Fetches GitHub contribution data from the backend proxy.
  static Future<GitHubProfile> fetchContributions() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/github-contributions'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return GitHubProfile.fromJson(data);
    } else {
      throw Exception(
        'Failed to fetch contributions (${response.statusCode}): ${response.body}',
      );
    }
  }
}
