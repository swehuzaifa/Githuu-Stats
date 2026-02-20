class ContributionDay {
  final String date;
  final int count;
  final String color;

  ContributionDay({
    required this.date,
    required this.count,
    required this.color,
  });

  factory ContributionDay.fromJson(Map<String, dynamic> json) {
    return ContributionDay(
      date: json['date'] as String,
      count: json['count'] as int,
      color: json['color'] as String,
    );
  }
}

class GitHubProfile {
  final String name;
  final String avatarUrl;
  final String bio;
  final int totalContributions;
  final List<ContributionDay> days;

  GitHubProfile({
    required this.name,
    required this.avatarUrl,
    required this.bio,
    required this.totalContributions,
    required this.days,
  });

  factory GitHubProfile.fromJson(Map<String, dynamic> json) {
    final daysList = (json['days'] as List)
        .map((d) => ContributionDay.fromJson(d as Map<String, dynamic>))
        .toList();

    return GitHubProfile(
      name: json['name'] as String? ?? 'Unknown',
      avatarUrl: json['avatarUrl'] as String? ?? '',
      bio: json['bio'] as String? ?? '',
      totalContributions: json['totalContributions'] as int? ?? 0,
      days: daysList,
    );
  }
}
