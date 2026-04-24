import 'package:flutter/material.dart';
import 'package:table_tennis_counter/utils/constants.dart';

/// Reusable bottom controls section.
///
/// Contains winner message, reset button, and helper texts.
class ControlButtons extends StatelessWidget {
  const ControlButtons({
    super.key,
    required this.winnerText,
    required this.onReset,
  });

  final String winnerText;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          child: winnerText.isEmpty
              ? const SizedBox.shrink()
              : Container(
                  key: ValueKey(winnerText),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.95),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Text(
                    winnerText,
                    style: const TextStyle(
                      color: Color(0xFF0F766E),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
        ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: onReset,
          icon: const Icon(Icons.refresh),
          label: const Text(AppConstants.resetLabel),
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(220, 56),
            side: const BorderSide(color: Colors.white70, width: 1.4),
            foregroundColor: Colors.white,
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
            backgroundColor: const Color(0x1AFFFFFF),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          AppConstants.tapHint,
          style: TextStyle(color: Colors.white70, fontSize: 14),
        ),
        const SizedBox(height: 4),
        const Text(
          AppConstants.winHint,
          style: TextStyle(color: Colors.white60, fontSize: 13),
        ),
      ],
    );
  }
}
