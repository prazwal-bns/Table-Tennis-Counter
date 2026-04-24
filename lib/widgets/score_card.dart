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
    required this.onUndoTap,
    required this.isDisabled,
    required this.onNameTap,
    required this.isLastScored,
  });

  final Player player;
  final VoidCallback? onTap;
  final VoidCallback? onUndoTap;
  final bool isDisabled;
  final VoidCallback onNameTap;
  final bool isLastScored;

  Color get _accentColor => Color(player.accentColorHex);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool compact = constraints.maxHeight < 360 || constraints.maxWidth < 260;
        final double nameFont = compact ? 18 : 24;
        final double hintFont = compact ? 11 : 12;

        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(22),
            child: Ink(
              padding: EdgeInsets.symmetric(
                vertical: compact ? 12 : 22,
                horizontal: compact ? 10 : 14,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFF0F172A).withValues(alpha: 0.62),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: isLastScored
                      ? _accentColor.withValues(alpha: 0.95)
                      : Colors.white.withValues(alpha: 0.18),
                  width: isLastScored ? 2.2 : 1.1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.35),
                    blurRadius: 18,
                    offset: const Offset(0, 10),
                  ),
                  if (isLastScored)
                    BoxShadow(
                      color: _accentColor.withValues(alpha: 0.35),
                      blurRadius: 22,
                      spreadRadius: 1,
                    ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: onNameTap,
                    borderRadius: BorderRadius.circular(8),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              player.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: _accentColor,
                                fontSize: nameFont,
                                fontWeight: FontWeight.w700,
                                decoration: TextDecoration.underline,
                                decorationColor: _accentColor.withValues(alpha: 0.7),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Icon(Icons.edit, size: compact ? 14 : 18, color: _accentColor),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: compact ? 2 : 6),
                  Text(
                    AppConstants.tapNameToEditText,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.7),
                      fontSize: hintFont,
                    ),
                  ),
                  SizedBox(height: compact ? 8 : 16),
                  Expanded(
                    child: _FlipCounterDisplay(
                      score: player.score,
                      accentColor: _accentColor,
                    ),
                  ),
                  SizedBox(height: compact ? 8 : 16),
                  if (isLastScored)
                    Container(
                      margin: EdgeInsets.only(bottom: compact ? 6 : 10),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: _accentColor.withValues(alpha: 0.18),
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(
                          color: _accentColor.withValues(alpha: 0.6),
                        ),
                      ),
                      child: Text(
                        '${AppConstants.lastScoredPrefix} ${player.name}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: _accentColor,
                          fontSize: compact ? 10 : 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
              const SizedBox(height: 6),
              OutlinedButton.icon(
                onPressed: onUndoTap,
                icon: const Icon(Icons.undo, size: 18),
                label: const Text(AppConstants.undoLabel),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(160, 40),
                  side: BorderSide(
                    color: _accentColor.withValues(alpha: 0.7),
                    width: 1.1,
                  ),
                  foregroundColor: _accentColor,
                  textStyle: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                  backgroundColor: Colors.black.withValues(alpha: 0.12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 8),
                  Text(
                    isDisabled
                        ? AppConstants.matchFinishedText
                        : AppConstants.tapToScoreText,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: isDisabled
                          ? Colors.white54
                          : _accentColor.withValues(alpha: 0.95),
                      fontSize: compact ? 12 : 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
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
        width: double.infinity,
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
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
