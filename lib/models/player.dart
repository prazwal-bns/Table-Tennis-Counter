/// Simple player model used by the score board.
class Player {
  Player({
    required this.name,
    required this.accentColorHex,
    this.score = 0,
  });

  final String name;
  final int accentColorHex;
  int score;
}
