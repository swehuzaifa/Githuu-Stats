import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../providers/github_provider.dart';
import '../models/contribution_day.dart';
import '../utils/hex_color.dart';

class GitHubDashboard extends ConsumerWidget {
  const GitHubDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final githubData = ref.watch(githubProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded,
              color: Color(0xFF374151), size: 20),
          onPressed: () => context.go('/profile'),
        ),
        title: Text(
          'GitHub Contributions',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF1A1A2E),
          ),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            height: 1,
            color: const Color(0xFFF3F4F6),
          ),
        ),
      ),
      body: githubData.when(
        loading: () => _buildLoading(),
        error: (error, stack) => _buildError(context, ref, error),
        data: (profile) => _buildDashboard(context, profile),
      ),
    );
  }

  Widget _buildLoading() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            width: 44,
            height: 44,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2D9CDB)),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Fetching your contributions...',
            style: GoogleFonts.poppins(
              fontSize: 15,
              color: const Color(0xFF9CA3AF),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildError(BuildContext context, WidgetRef ref, Object error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: const Color(0xFFFEE2E2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.cloud_off_rounded,
                size: 36,
                color: Color(0xFFEF4444),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Couldn\'t load data',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF374151),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Make sure the backend is running\nand your token is configured.',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: const Color(0xFF9CA3AF),
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => ref.invalidate(githubProvider),
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: Text(
                'Retry',
                style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1A1A2E),
                foregroundColor: Colors.white,
                elevation: 0,
                padding:
                    const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboard(BuildContext context, GitHubProfile profile) {
    // Organize days into weeks (columns) with 7 days each
    final List<List<ContributionDay>> weeks = [];
    for (int i = 0; i < profile.days.length; i += 7) {
      final end =
          (i + 7 > profile.days.length) ? profile.days.length : i + 7;
      weeks.add(profile.days.sublist(i, end));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Stats cards row
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Total',
                  profile.totalContributions.toString(),
                  Icons.grid_view_rounded,
                  const Color(0xFF2D9CDB),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  'This Week',
                  _getThisWeekCount(profile.days).toString(),
                  Icons.calendar_today_rounded,
                  const Color(0xFF30A14E),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  'Best Day',
                  _getBestDay(profile.days).toString(),
                  Icons.emoji_events_rounded,
                  const Color(0xFFF59E0B),
                ),
              ),
            ],
          )
              .animate()
              .fadeIn(duration: 500.ms)
              .slideY(begin: 0.05, duration: 500.ms),

          const SizedBox(height: 24),

          // Heatmap card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Contribution Graph',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF1A1A2E),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${profile.totalContributions} contributions',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: const Color(0xFF9CA3AF),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 6),

                // Day labels
                Row(
                  children: [
                    SizedBox(
                      width: 28,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          for (final label in [
                            '', 'Mon', '', 'Wed', '', 'Fri', ''
                          ])
                            SizedBox(
                              height: 18,
                              child: Text(
                                label,
                                style: GoogleFonts.poppins(
                                  fontSize: 10,
                                  color: const Color(0xFF9CA3AF),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 4),
                    // Heatmap grid
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            for (int w = 0; w < weeks.length; w++)
                              Column(
                                children: [
                                  for (int d = 0; d < weeks[w].length; d++)
                                    Tooltip(
                                      message:
                                          '${weeks[w][d].date}: ${weeks[w][d].count} contributions',
                                      child: Container(
                                        width: 14,
                                        height: 14,
                                        margin: const EdgeInsets.all(2),
                                        decoration: BoxDecoration(
                                          color: hexToColor(weeks[w][d].color),
                                          borderRadius:
                                              BorderRadius.circular(3),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Legend
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Less',
                      style: GoogleFonts.poppins(
                        fontSize: 10,
                        color: const Color(0xFF9CA3AF),
                      ),
                    ),
                    const SizedBox(width: 4),
                    for (final hex in [
                      '#ebedf0',
                      '#9be9a8',
                      '#40c463',
                      '#30a14e',
                      '#216e39'
                    ])
                      Container(
                        width: 14,
                        height: 14,
                        margin: const EdgeInsets.symmetric(horizontal: 2),
                        decoration: BoxDecoration(
                          color: hexToColor(hex),
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    const SizedBox(width: 4),
                    Text(
                      'More',
                      style: GoogleFonts.poppins(
                        fontSize: 10,
                        color: const Color(0xFF9CA3AF),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
              .animate()
              .fadeIn(delay: 200.ms, duration: 600.ms)
              .slideY(begin: 0.05, duration: 600.ms),

          const SizedBox(height: 24),

          // Recent activity card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Recent Activity',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1A1A2E),
                  ),
                ),
                const SizedBox(height: 16),
                ..._getRecentDays(profile.days, 7).map((day) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        children: [
                          Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              color: hexToColor(day.color),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              day.date,
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                color: const Color(0xFF6B7280),
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: day.count > 0
                                  ? const Color(0xFFECFDF5)
                                  : const Color(0xFFF3F4F6),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '${day.count} contributions',
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: day.count > 0
                                    ? const Color(0xFF059669)
                                    : const Color(0xFF9CA3AF),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )),
              ],
            ),
          )
              .animate()
              .fadeIn(delay: 400.ms, duration: 600.ms)
              .slideY(begin: 0.05, duration: 600.ms),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildStatCard(
      String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, size: 22, color: color),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1A1A2E),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 11,
              color: const Color(0xFF9CA3AF),
            ),
          ),
        ],
      ),
    );
  }

  int _getThisWeekCount(List<ContributionDay> days) {
    if (days.length < 7) return 0;
    return days
        .sublist(days.length - 7)
        .fold(0, (sum, day) => sum + day.count);
  }

  int _getBestDay(List<ContributionDay> days) {
    if (days.isEmpty) return 0;
    return days.map((d) => d.count).reduce((a, b) => a > b ? a : b);
  }

  List<ContributionDay> _getRecentDays(List<ContributionDay> days, int count) {
    if (days.length <= count) return days.reversed.toList();
    return days.sublist(days.length - count).reversed.toList();
  }
}
