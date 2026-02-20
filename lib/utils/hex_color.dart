import 'dart:ui';

/// Parses a hex color string (e.g., "#9be9a8") to a Flutter Color.
Color hexToColor(String hex) {
  hex = hex.replaceFirst('#', '');
  if (hex.length == 6) {
    hex = 'FF$hex'; // add full opacity
  }
  return Color(int.parse(hex, radix: 16));
}
