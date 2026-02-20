import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../providers/github_provider.dart';
import '../providers/theme_provider.dart';
import '../models/contribution_day.dart';
import '../utils/hex_color.dart';

class GitHubDashboard extends ConsumerWidget {
  const GitHubDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final githubData = ref.watch(githubProvider);
    final colors = Theme.of(context).extension<AppColors>()!;
    final isDark = ref.watch(themeModeProvider) == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded,
              color: colors.textSecondary, size: 20),
          onPressed: () => context.go('/profile'),
        ),
        title: Text(
          'GitHub Contributions',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: colors.textPrimary,
          ),
        ),
        centerTitle: true,
        actions: [
          // Theme toggle in app bar
          IconButton(
            onPressed: () =>
                ref.read(themeModeProvider.notifier).toggle(),
            icon: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, anim) =>
                  RotationTransition(turns: anim, child: child),
              child: Icon(
                isDark
                    ? Icons.light_mode_rounded
                    : Icons.dark_mode_rounded,
                key: ValueKey(isDark),
                size: 22,
                color: isDark
                    ? const Color(0xFFFBBF24)
                    : colors.textTertiary,
              ),
            ),
          ),
          const SizedBox(width: 4),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            height: 1,
            color: Theme.of(context).dividerColor,
          ),
        ),
      ),
      body: githubData.when(
        loading: () => _buildLoading(colors),
        error: (error, stack) => _buildError(context, ref, error, colors),
        data: (profile) => _buildDashboard(context, profile, colors, isDark),
      ),
    );
  }

  Widget _buildLoading(AppColors colors) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 44,
            height: 44,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: AlwaysStoppedAnimation<Color>(colors.accent),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Fetching your contributions...',
            style: GoogleFonts.poppins(
              fontSize: 15,
              color: colors.textMuted,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildError(
      BuildContext context, WidgetRef ref, Object error, AppColors colors) {
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
                color: colors.errorBackground,
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
                color: colors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Make sure the backend is running\nand your token is configured.',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: colors.textMuted,
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
                backgroundColor: colors.buttonPrimary,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(
                    horizontal: 28, vertical: 14),
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

  Widget _buildDashboard(BuildContext context, GitHubProfile profile,
      AppColors colors, bool isDark) {
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
                  colors.accent,
                  colors,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  'This Week',
                  _getThisWeekCount(profile.days).toString(),
                  Icons.calendar_today_rounded,
                  const Color(0xFF30A14E),
                  colors,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  'Best Day',
                  _getBestDay(profile.days).toString(),
                  Icons.emoji_events_rounded,
                  const Color(0xFFF59E0B),
                  colors,
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
              color: colors.cardBackground,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: colors.shadowColor,
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
                        color: colors.textPrimary,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${profile.totalContributions} contributions',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: colors.textMuted,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 6),

                // Day labels + heatmap grid
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
                                  color: colors.textMuted,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            for (int w = 0; w < weeks.length; w++)
                              Column(
                                children: [
                                  for (int d = 0;
                                      d < weeks[w].length;
                                      d++)
                                    Tooltip(
                                      message:
                                          '${weeks[w][d].date}: ${weeks[w][d].count} contributions',
                                      child: Container(
                                        width: 14,
                                        height: 14,
                                        margin:
                                            const EdgeInsets.all(2),
                                        decoration: BoxDecoration(
                                          color: _getCellColor(
                                              weeks[w][d].color,
                                              isDark),
                                          borderRadius:
                                              BorderRadius.circular(
                                                  3),
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
                        color: colors.textMuted,
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
                        margin:
                            const EdgeInsets.symmetric(horizontal: 2),
                        decoration: BoxDecoration(
                          color: _getCellColor(hex, isDark),
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    const SizedBox(width: 4),
                    Text(
                      'More',
                      style: GoogleFonts.poppins(
                        fontSize: 10,
                        color: colors.textMuted,
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
              color: colors.cardBackground,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: colors.shadowColor,
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
                    color: colors.textPrimary,
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
                              color: _getCellColor(day.color, isDark),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              day.date,
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                color: colors.textTertiary,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: day.count > 0
                                  ? colors.positiveBackground
                                  : colors.tagBackground,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '${day.count} contributions',
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: day.count > 0
                                    ? colors.positiveText
                                    : colors.textMuted,
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

  Widget _buildStatCard(String label, String value, IconData icon,
      Color color, AppColors colors) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 14),
      decoration: BoxDecoration(
        color: colors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: colors.shadowColor,
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
              color: colors.textPrimary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 11,
              color: colors.textMuted,
            ),
          ),
        ],
      ),
    );
  }

  /// Adjusts heatmap cell colors for dark mode
  Color _getCellColor(String hex, bool isDark) {
    if (isDark && (hex == '#ebedf0' || hex == '#EBEDF0')) {
      return const Color(0xFF2A2A2A);
    }
    return hexToColor(hex);
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

  List<ContributionDay> _getRecentDays(
      List<ContributionDay> days, int count) {
    if (days.length <= count) return days.reversed.toList();
    return days.sublist(days.length - count).reversed.toList();
  }
}
