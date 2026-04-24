import 'package:flutter/material.dart';

/// App-wide constants (texts, colors, and sizing).
class AppConstants {
  static const int winScore = 11;

  static const String appTitle = 'TABLE TENNIS COUNTER';
  static const String backgroundImagePath = 'assets/images/table_tennis_bg.jpg';
  static const String resetLabel = 'Reset Match';
  static const String tapHint = 'Tap each scoreboard to add 1 point';
  static const String winHint = 'First to 11 points wins';
  static const String matchFinishedText = 'Match Finished';
  static const String tapToScoreText = 'Tap to score';

  static const Color playerAColor = Color(0xFF22C55E);
  static const Color playerBColor = Color(0xFF38BDF8);
}
