import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

/// Manages theme mode state (light/dark toggle)
final themeModeProvider = NotifierProvider<ThemeModeNotifier, ThemeMode>(
  ThemeModeNotifier.new,
);

class ThemeModeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() => ThemeMode.light;

  void toggle() {
    state = state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
  }

  bool get isDark => state == ThemeMode.dark;
}

/// Light theme — Pinterest-inspired clean white
final ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  scaffoldBackgroundColor: const Color(0xFFF9FAFB),
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xFF2D9CDB),
    brightness: Brightness.light,
    surface: const Color(0xFFF9FAFB),
  ),
  textTheme: GoogleFonts.poppinsTextTheme(ThemeData.light().textTheme),
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.white,
    elevation: 0,
    surfaceTintColor: Colors.white,
    iconTheme: IconThemeData(color: Color(0xFF374151)),
    titleTextStyle: TextStyle(
      color: Color(0xFF1A1A2E),
      fontSize: 18,
      fontWeight: FontWeight.w600,
    ),
  ),
  cardColor: Colors.white,
  dividerColor: const Color(0xFFF3F4F6),
  extensions: const [
    AppColors(
      cardBackground: Colors.white,
      textPrimary: Color(0xFF1A1A2E),
      textSecondary: Color(0xFF374151),
      textTertiary: Color(0xFF6B7280),
      textMuted: Color(0xFF9CA3AF),
      tagBackground: Color(0xFFF3F4F6),
      accent: Color(0xFF2D9CDB),
      buttonPrimary: Color(0xFF1A1A2E),
      shadowColor: Color(0x0A000000),
      positiveBackground: Color(0xFFECFDF5),
      positiveText: Color(0xFF059669),
      errorBackground: Color(0xFFFEE2E2),
    ),
  ],
);

/// Dark theme — Pinterest dark mode style
final ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  scaffoldBackgroundColor: const Color(0xFF111111),
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xFF2D9CDB),
    brightness: Brightness.dark,
    surface: const Color(0xFF111111),
  ),
  textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF1A1A1A),
    elevation: 0,
    surfaceTintColor: Color(0xFF1A1A1A),
    iconTheme: IconThemeData(color: Color(0xFFE5E7EB)),
    titleTextStyle: TextStyle(
      color: Color(0xFFF9FAFB),
      fontSize: 18,
      fontWeight: FontWeight.w600,
    ),
  ),
  cardColor: const Color(0xFF1A1A1A),
  dividerColor: const Color(0xFF2A2A2A),
  extensions: const [
    AppColors(
      cardBackground: Color(0xFF1A1A1A),
      textPrimary: Color(0xFFF9FAFB),
      textSecondary: Color(0xFFE5E7EB),
      textTertiary: Color(0xFFD1D5DB),
      textMuted: Color(0xFF9CA3AF),
      tagBackground: Color(0xFF2A2A2A),
      accent: Color(0xFF4DB8FF),
      buttonPrimary: Color(0xFF2D9CDB),
      shadowColor: Color(0x33000000),
      positiveBackground: Color(0xFF052E16),
      positiveText: Color(0xFF34D399),
      errorBackground: Color(0xFF450A0A),
    ),
  ],
);

/// Custom theme extension for app-specific colors
@immutable
class AppColors extends ThemeExtension<AppColors> {
  final Color cardBackground;
  final Color textPrimary;
  final Color textSecondary;
  final Color textTertiary;
  final Color textMuted;
  final Color tagBackground;
  final Color accent;
  final Color buttonPrimary;
  final Color shadowColor;
  final Color positiveBackground;
  final Color positiveText;
  final Color errorBackground;

  const AppColors({
    required this.cardBackground,
    required this.textPrimary,
    required this.textSecondary,
    required this.textTertiary,
    required this.textMuted,
    required this.tagBackground,
    required this.accent,
    required this.buttonPrimary,
    required this.shadowColor,
    required this.positiveBackground,
    required this.positiveText,
    required this.errorBackground,
  });

  @override
  AppColors copyWith({
    Color? cardBackground,
    Color? textPrimary,
    Color? textSecondary,
    Color? textTertiary,
    Color? textMuted,
    Color? tagBackground,
    Color? accent,
    Color? buttonPrimary,
    Color? shadowColor,
    Color? positiveBackground,
    Color? positiveText,
    Color? errorBackground,
  }) {
    return AppColors(
      cardBackground: cardBackground ?? this.cardBackground,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textTertiary: textTertiary ?? this.textTertiary,
      textMuted: textMuted ?? this.textMuted,
      tagBackground: tagBackground ?? this.tagBackground,
      accent: accent ?? this.accent,
      buttonPrimary: buttonPrimary ?? this.buttonPrimary,
      shadowColor: shadowColor ?? this.shadowColor,
      positiveBackground: positiveBackground ?? this.positiveBackground,
      positiveText: positiveText ?? this.positiveText,
      errorBackground: errorBackground ?? this.errorBackground,
    );
  }

  @override
  AppColors lerp(AppColors? other, double t) {
    if (other == null) return this;
    return AppColors(
      cardBackground: Color.lerp(cardBackground, other.cardBackground, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textTertiary: Color.lerp(textTertiary, other.textTertiary, t)!,
      textMuted: Color.lerp(textMuted, other.textMuted, t)!,
      tagBackground: Color.lerp(tagBackground, other.tagBackground, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      buttonPrimary: Color.lerp(buttonPrimary, other.buttonPrimary, t)!,
      shadowColor: Color.lerp(shadowColor, other.shadowColor, t)!,
      positiveBackground: Color.lerp(positiveBackground, other.positiveBackground, t)!,
      positiveText: Color.lerp(positiveText, other.positiveText, t)!,
      errorBackground: Color.lerp(errorBackground, other.errorBackground, t)!,
    );
  }
}
