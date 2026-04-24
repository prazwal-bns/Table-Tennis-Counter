import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:table_tennis_counter/models/player.dart';
import 'package:table_tennis_counter/utils/constants.dart';
import 'package:table_tennis_counter/widgets/control_buttons.dart';
import 'package:table_tennis_counter/widgets/score_card.dart';

/// Main app screen for score tracking and match controls.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

/// State and simple score logic for the home screen.
class _HomeScreenState extends State<HomeScreen> {
  final Player _playerA = Player(
    name: 'Player A',
    accentColorHex: AppConstants.playerAColor.toARGB32(),
  );
  final Player _playerB = Player(
    name: 'Player B',
    accentColorHex: AppConstants.playerBColor.toARGB32(),
  );

  String _winnerText = '';

  bool get _isMatchFinished => _winnerText.isNotEmpty;

  void _incrementPlayerScore(Player player) {
    if (_isMatchFinished) return;

    HapticFeedback.lightImpact();
    setState(() {
      player.score++;
      _checkWinner();
    });
  }

  void _checkWinner() {
    if (_playerA.score >= AppConstants.winScore) {
      _winnerText = '${_playerA.name} Wins!';
      return;
    }

    if (_playerB.score >= AppConstants.winScore) {
      _winnerText = '${_playerB.name} Wins!';
    }
  }

  void _resetScores() {
    setState(() {
      _playerA.score = 0;
      _playerB.score = 0;
      _winnerText = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(AppConstants.backgroundImagePath, fit: BoxFit.cover),
          const _GradientOverlay(),
          const _BackgroundGlowLayer(),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const SizedBox(height: 8),
                  const Text(
                    AppConstants.appTitle,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: ScoreCard(
                            player: _playerA,
                            isDisabled: _isMatchFinished,
                            onTap: _isMatchFinished
                                ? null
                                : () => _incrementPlayerScore(_playerA),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          width: 2,
                          margin: const EdgeInsets.symmetric(vertical: 28),
                          color: Colors.white24,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ScoreCard(
                            player: _playerB,
                            isDisabled: _isMatchFinished,
                            onTap: _isMatchFinished
                                ? null
                                : () => _incrementPlayerScore(_playerB),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  ControlButtons(
                    winnerText: _winnerText,
                    onReset: _resetScores,
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Dark gradient layer to improve text readability.
class _GradientOverlay extends StatelessWidget {
  const _GradientOverlay();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xCC021014), Color(0xB3122330), Color(0xCC021014)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
    );
  }
}

/// Decorative glow circles for sports-themed background depth.
class _BackgroundGlowLayer extends StatelessWidget {
  const _BackgroundGlowLayer();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Stack(
        children: [
          Positioned(
            top: -110,
            left: -70,
            child: _GlowCircle(
              size: 240,
              color: AppConstants.playerAColor.withValues(alpha: 0.16),
            ),
          ),
          Positioned(
            bottom: -130,
            right: -80,
            child: _GlowCircle(
              size: 280,
              color: AppConstants.playerBColor.withValues(alpha: 0.14),
            ),
          ),
        ],
      ),
    );
  }
}

/// Single radial glow circle.
class _GlowCircle extends StatelessWidget {
  const _GlowCircle({
    required this.size,
    required this.color,
  });

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [color, Colors.transparent],
          stops: const [0.2, 1],
        ),
      ),
    );
  }
}
