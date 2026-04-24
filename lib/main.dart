import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const TableTennisApp());
}

class TableTennisApp extends StatelessWidget {
  const TableTennisApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Table Tennis Counter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0D9488)),
        useMaterial3: true,
      ),
      home: const CounterPage(),
    );
  }
}

class CounterPage extends StatefulWidget {
  const CounterPage({super.key});

  @override
  State<CounterPage> createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  int _playerAScore = 0;
  int _playerBScore = 0;
  static const int _winScore = 11;
  String _winnerText = '';

  void _incrementPlayerA() {
    if (_winnerText.isNotEmpty) return;
    HapticFeedback.lightImpact();
    setState(() {
      _playerAScore++;
      _checkWinner();
    });
  }

  void _incrementPlayerB() {
    if (_winnerText.isNotEmpty) return;
    HapticFeedback.lightImpact();
    setState(() {
      _playerBScore++;
      _checkWinner();
    });
  }

  void _resetScores() {
    setState(() {
      _playerAScore = 0;
      _playerBScore = 0;
      _winnerText = '';
    });
  }

  void _checkWinner() {
    if (_playerAScore >= _winScore) {
      _winnerText = 'Player A Wins!';
    } else if (_playerBScore >= _winScore) {
      _winnerText = 'Player B Wins!';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/images/table_tennis_bg.jpg', fit: BoxFit.cover),
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xCC021014), Color(0xB3122330), Color(0xCC021014)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          // Soft sports-themed light accents to avoid a flat/plain background.
          IgnorePointer(
            child: Stack(
              children: [
                Positioned(
                  top: -110,
                  left: -70,
                  child: _GlowCircle(
                    size: 240,
                    color: const Color(0xFF22C55E).withValues(alpha: 0.16),
                  ),
                ),
                Positioned(
                  bottom: -130,
                  right: -80,
                  child: _GlowCircle(
                    size: 280,
                    color: const Color(0xFF38BDF8).withValues(alpha: 0.14),
                  ),
                ),
              ],
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const SizedBox(height: 8),
                  const Text(
                    'TABLE TENNIS COUNTER',
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
                          child: HorizontalPlayerPanel(
                            playerName: 'Player A',
                            score: _playerAScore,
                            accentColor: const Color(0xFF22C55E),
                            onIncrement: _winnerText.isNotEmpty
                                ? null
                                : _incrementPlayerA,
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
                          child: HorizontalPlayerPanel(
                            playerName: 'Player B',
                            score: _playerBScore,
                            accentColor: const Color(0xFF38BDF8),
                            onIncrement: _winnerText.isNotEmpty
                                ? null
                                : _incrementPlayerB,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    child: _winnerText.isEmpty
                        ? const SizedBox.shrink()
                        : Container(
                            key: ValueKey(_winnerText),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.95),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Text(
                              _winnerText,
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
                    onPressed: _resetScores,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Reset Match'),
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
                    'Tap each scoreboard to add 1 point',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'First to 11 points wins',
                    style: TextStyle(color: Colors.white60, fontSize: 13),
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

class HorizontalPlayerPanel extends StatelessWidget {
  const HorizontalPlayerPanel({
    super.key,
    required this.playerName,
    required this.score,
    required this.accentColor,
    required this.onIncrement,
  });

  final String playerName;
  final int score;
  final Color accentColor;
  final VoidCallback? onIncrement;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onIncrement,
        borderRadius: BorderRadius.circular(22),
        child: Ink(
          padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 14),
          decoration: BoxDecoration(
            // Dark glass card: removes plain white and blends with the theme.
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
                playerName,
                style: TextStyle(
                  color: accentColor,
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 16),
              FlipCounterDisplay(score: score, accentColor: accentColor),
              const SizedBox(height: 16),
              Text(
                onIncrement == null ? 'Match Finished' : 'Tap to score',
                style: TextStyle(
                  color: onIncrement == null
                      ? Colors.white54
                      : accentColor.withValues(alpha: 0.95),
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

class FlipCounterDisplay extends StatelessWidget {
  const FlipCounterDisplay({
    super.key,
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
          border: Border.all(color: accentColor.withValues(alpha: 0.45), width: 1.4),
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
