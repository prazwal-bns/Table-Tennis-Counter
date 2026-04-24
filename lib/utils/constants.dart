import 'package:flutter/material.dart';

/// App-wide constants (texts, colors, and sizing).
class AppConstants {
  static const int winScore = 11;

  static const String appTitle = 'TABLE TENNIS COUNTER';
  static const String backgroundImagePath = 'assets/images/table_tennis_bg.jpg';
  static const String resetLabel = 'Reset Match';
  static const String undoLabel = 'Undo Last Point';
  static const String tapHint = 'Tap each scoreboard to add 1 point';
  static const String winHint = 'First to 11 points wins';
  static const String matchFinishedText = 'Match Finished';
  static const String tapToScoreText = 'Tap to score';
  static const String tapNameToEditText = 'Tap name to edit';
  static const String editNameTitle = 'Edit Player Name';
  static const String playerNameLabel = 'Player name';
  static const String cancelLabel = 'Cancel';
  static const String saveLabel = 'Save';
  static const String resetConfirmTitle = 'Reset match?';
  static const String resetConfirmMessage =
      'This will reset both scores and clear winner.';
  static const String resetConfirmAction = 'Reset';
  static const String nameRequiredMessage = 'Name cannot be empty';
  static const String lastScoredPrefix = 'Last scored:';

  static const Color playerAColor = Color(0xFF22C55E);
  static const Color playerBColor = Color(0xFF38BDF8);
}
