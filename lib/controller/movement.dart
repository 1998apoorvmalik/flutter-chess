// First four offsets: horizontal, vertical, left diagonal, right diagonal.
// Last four offsets corresponds to Knight movement direction.

class Movement {
  static const List<int> allDirectionalOffsets = [1, 8, 7, 9, 10, 17, 15, 6];

  static Movement getKingMovement() => Movement(
        directionalOffsets: allDirectionalOffsets.sublist(0, 4),
        maxStep: 1,
      );

  static Movement getQueenMovement() => Movement(
        directionalOffsets: allDirectionalOffsets.sublist(0, 4),
        maxStep: 8,
      );

  static Movement getBishopMovement() => Movement(
        directionalOffsets: allDirectionalOffsets.sublist(2, 4),
        maxStep: 8,
      );

  static Movement getKnightMovement() => Movement(
        directionalOffsets: allDirectionalOffsets.sublist(4),
        maxStep: 1,
      );

  static Movement getRookMovement() => Movement(
        directionalOffsets: allDirectionalOffsets.sublist(0, 2),
        maxStep: 8,
      );

  static Movement getPawnMovement() => Movement(
        directionalOffsets: allDirectionalOffsets.sublist(1, 2),
        maxStep: 1,
        mirrorDirection: true,
      );

  Movement({
    required List<int> directionalOffsets,
    required int maxStep,
    bool mirrorDirection = true,
  })  : _directionalOffsets = mirrorDirection
            ? directionalOffsets.expand((dir) => [-dir, dir]).toList()
            : directionalOffsets,
        _maxStep = maxStep;

  final List<int> _directionalOffsets;
  final int _maxStep;

  // Getter for private properties.
  List<int> get directionalOffsets => _directionalOffsets;
  int get maxStep => _maxStep;
}
