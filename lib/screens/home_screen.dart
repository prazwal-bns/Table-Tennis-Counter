import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
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
  Player? _lastScoredPlayer;
  final FlutterTts _flutterTts = FlutterTts();

  bool get _isMatchFinished => _winnerText.isNotEmpty;

  @override
  void initState() {
    super.initState();
    _initTts();
  }

  Future<void> _initTts() async {
    // Queue mode prevents speech overlap while tapping quickly.
    await _flutterTts.setQueueMode(1);
    await _flutterTts.setSpeechRate(0.45);
    await _flutterTts.setVolume(1.0);
    await _flutterTts.setPitch(1.0);
  }

  String _buildScoreAnnouncement() {
    if (_playerA.score == _playerB.score) {
      return '${_playerA.score} all';
    }
    return '${_playerA.name} ${_playerA.score}, ${_playerB.name} ${_playerB.score}';
  }

  Future<void> _speakScoreUpdate() async {
    await _flutterTts.stop();
    await _flutterTts.speak(_buildScoreAnnouncement());
  }

  void _incrementPlayerScore(Player player) {
    if (_isMatchFinished) return;

    HapticFeedback.lightImpact();
    setState(() {
      player.score++;
      _lastScoredPlayer = player;
      _checkWinner();
    });
    _speakScoreUpdate();
  }

  void _checkWinner() {
    _winnerText = '';

    if (_playerA.score >= AppConstants.winScore) {
      _winnerText = '${_playerA.name} Wins!';
      return;
    }

    if (_playerB.score >= AppConstants.winScore) {
      _winnerText = '${_playerB.name} Wins!';
    }
  }

  void _undoLastPoint() {
    if (_lastScoredPlayer == null || _lastScoredPlayer!.score <= 0) return;

    HapticFeedback.selectionClick();
    setState(() {
      _lastScoredPlayer!.score--;
      _lastScoredPlayer = null;
      _checkWinner();
    });
  }

  void _resetScores() {
    setState(() {
      _playerA.score = 0;
      _playerB.score = 0;
      _winnerText = '';
      _lastScoredPlayer = null;
    });
    _flutterTts.stop();
  }

  @override
  void dispose() {
    _flutterTts.stop();
    super.dispose();
  }

  /// Opens name edit dialog with current name pre-filled.
  Future<void> _showEditNameDialog(Player player) async {
    final TextEditingController controller =
        TextEditingController(text: player.name);
    String? errorText;

    // StatefulBuilder lets us validate input inside dialog without
    // affecting whole screen rebuild.
    await showDialog<void>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text(AppConstants.editNameTitle),
              content: TextField(
                controller: controller,
                autofocus: true,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  labelText: AppConstants.playerNameLabel,
                  errorText: errorText,
                ),
                onSubmitted: (_) {
                  final String trimmedName = controller.text.trim();
                  if (trimmedName.isEmpty) {
                    setDialogState(() {
                      errorText = AppConstants.nameRequiredMessage;
                    });
                    return;
                  }
                  setState(() {
                    player.name = trimmedName;
                    _checkWinner();
                  });
                  Navigator.of(context).pop();
                },
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text(AppConstants.cancelLabel),
                ),
                FilledButton(
                  onPressed: () {
                    final String trimmedName = controller.text.trim();
                    if (trimmedName.isEmpty) {
                      setDialogState(() {
                        errorText = AppConstants.nameRequiredMessage;
                      });
                      return;
                    }

                    // Update name instantly in UI.
                    setState(() {
                      player.name = trimmedName;
                      _checkWinner();
                    });
                    Navigator.of(context).pop();
                  },
                  child: const Text(AppConstants.saveLabel),
                ),
              ],
            );
          },
        );
      },
    );
  }

  /// Confirms reset action to prevent accidental score loss.
  Future<void> _confirmResetDialog() async {
    final bool? shouldReset = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(AppConstants.resetConfirmTitle),
          content: const Text(AppConstants.resetConfirmMessage),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text(AppConstants.cancelLabel),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text(AppConstants.resetConfirmAction),
            ),
          ],
        );
      },
    );

    if (shouldReset == true) {
      HapticFeedback.selectionClick();
      _resetScores();
    }
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
            child: LayoutBuilder(
              builder: (context, constraints) {
                final double titleSize = constraints.maxWidth < 420 ? 20 : 24;

                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      const SizedBox(height: 8),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          AppConstants.appTitle,
                          maxLines: 1,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: titleSize,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      Expanded(
                        child: Row(
                          children: [
                            Expanded(child: _buildScoreCardA()),
                            const SizedBox(width: 10),
                            Container(
                              width: 2,
                              margin: const EdgeInsets.symmetric(vertical: 20),
                              color: Colors.white24,
                            ),
                            const SizedBox(width: 10),
                            Expanded(child: _buildScoreCardB()),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      ControlButtons(
                        winnerText: _winnerText,
                        onReset: _confirmResetDialog,
                        onUndo: _undoLastPoint,
                        canUndo: _lastScoredPlayer != null,
                      ),
                      const SizedBox(height: 6),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScoreCardA() {
    return ScoreCard(
      player: _playerA,
      isDisabled: _isMatchFinished,
      isLastScored: identical(_lastScoredPlayer, _playerA),
      onTap: _isMatchFinished ? null : () => _incrementPlayerScore(_playerA),
      onNameTap: () => _showEditNameDialog(_playerA),
    );
  }

  Widget _buildScoreCardB() {
    return ScoreCard(
      player: _playerB,
      isDisabled: _isMatchFinished,
      isLastScored: identical(_lastScoredPlayer, _playerB),
      onTap: _isMatchFinished ? null : () => _incrementPlayerScore(_playerB),
      onNameTap: () => _showEditNameDialog(_playerB),
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
