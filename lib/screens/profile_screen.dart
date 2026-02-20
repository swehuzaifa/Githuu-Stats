import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isLoading = false;

  void _navigateToDashboard() {
    setState(() => _isLoading = true);

    // Brief delay to show loading state before navigating
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        setState(() => _isLoading = false);
        context.go('/github-dashboard');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Profile avatar
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF2D9CDB).withValues(alpha: 0.15),
                        blurRadius: 30,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    radius: 70,
                    backgroundColor: Colors.white,
                    child: CircleAvatar(
                      radius: 66,
                      backgroundImage:
                          const AssetImage('assets/profile.jpg'),
                    ),
                  ),
                )
                    .animate()
                    .fadeIn(duration: 600.ms)
                    .scale(
                        begin: const Offset(0.85, 0.85), duration: 600.ms),

                const SizedBox(height: 28),

                // Name
                Text(
                  'Huzaifa Shahab',
                  style: GoogleFonts.poppins(
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1A1A2E),
                    letterSpacing: -0.3,
                  ),
                ).animate().fadeIn(delay: 200.ms, duration: 500.ms),

                const SizedBox(height: 8),

                // Bio
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F4F6),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'CS Student  ·  AI Enthusiast',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF6B7280),
                    ),
                  ),
                ).animate().fadeIn(delay: 350.ms, duration: 500.ms),

                const SizedBox(height: 48),

                // Stats card preview
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
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
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.grid_view_rounded,
                            size: 20,
                            color: const Color(0xFF2D9CDB),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Contribution Heatmap',
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF374151),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      // Mini preview of heatmap colors
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          for (final color in [
                            const Color(0xFFEBEDF0),
                            const Color(0xFF9BE9A8),
                            const Color(0xFF40C463),
                            const Color(0xFF30A14E),
                            const Color(0xFF216E39),
                          ])
                            Container(
                              width: 24,
                              height: 24,
                              margin: const EdgeInsets.symmetric(horizontal: 3),
                              decoration: BoxDecoration(
                                color: color,
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'See your full year of activity',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: const Color(0xFF9CA3AF),
                        ),
                      ),
                    ],
                  ),
                )
                    .animate()
                    .fadeIn(delay: 500.ms, duration: 600.ms)
                    .slideY(begin: 0.08, duration: 600.ms),

                const SizedBox(height: 32),

                // View GitHub Activity button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _navigateToDashboard,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2D9CDB),
                      foregroundColor: Colors.white,
                      disabledBackgroundColor:
                          const Color(0xFF2D9CDB).withValues(alpha: 0.7),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.rocket_launch_rounded, size: 20),
                              const SizedBox(width: 10),
                              Text(
                                'View My GitHub Activity',
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                  ),
                )
                    .animate()
                    .fadeIn(delay: 700.ms, duration: 500.ms)
                    .slideY(begin: 0.12, duration: 500.ms),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
