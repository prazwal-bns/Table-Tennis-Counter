import 'package:flutter/material.dart';
import 'package:table_tennis_counter/models/player.dart';
import 'package:table_tennis_counter/utils/constants.dart';

/// Reusable player score card.
///
/// This card is tappable and triggers score increment via [onTap].
class ScoreCard extends StatelessWidget {
  const ScoreCard({
    super.key,
    required this.player,
    required this.onTap,
    required this.isDisabled,
  });

  final Player player;
  final VoidCallback? onTap;
  final bool isDisabled;

  Color get _accentColor => Color(player.accentColorHex);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Ink(
          padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 14),
          decoration: BoxDecoration(
            color: const Color(0xFF0F172A).withValues(alpha: 0.62),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.18),
              width: 1.1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.35),
                blurRadius: 18,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                player.name,
                style: TextStyle(
                  color: _accentColor,
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 16),
              _FlipCounterDisplay(
                score: player.score,
                accentColor: _accentColor,
              ),
              const SizedBox(height: 16),
              Text(
                isDisabled
                    ? AppConstants.matchFinishedText
                    : AppConstants.tapToScoreText,
                style: TextStyle(
                  color: isDisabled
                      ? Colors.white54
                      : _accentColor.withValues(alpha: 0.95),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Internal widget for flip-style score display.
class _FlipCounterDisplay extends StatelessWidget {
  const _FlipCounterDisplay({
    required this.score,
    required this.accentColor,
  });

  final int score;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 220),
      transitionBuilder: (child, animation) {
        return ScaleTransition(scale: animation, child: child);
      },
      child: Container(
        key: ValueKey(score),
        width: 200,
        height: 230,
        decoration: BoxDecoration(
          color: const Color(0xFF111827),
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Color(0x40000000),
              blurRadius: 18,
              offset: Offset(0, 8),
            ),
          ],
          border: Border.all(
            color: accentColor.withValues(alpha: 0.45),
            width: 1.4,
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              children: [
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Color(0xFF1F2937),
                      borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Color(0xFF111827),
                      borderRadius:
                          BorderRadius.vertical(bottom: Radius.circular(14)),
                    ),
                  ),
                ),
              ],
            ),
            Container(
              height: 2,
              margin: const EdgeInsets.symmetric(horizontal: 10),
              color: Colors.white24,
            ),
            Text(
              score.toString().padLeft(2, '0'),
              style: TextStyle(
                color: Colors.white,
                fontSize: 96,
                fontWeight: FontWeight.w800,
                letterSpacing: 2,
                shadows: [
                  Shadow(
                    color: accentColor.withValues(alpha: 0.55),
                    blurRadius: 16,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
