class Movement {
  // First four offsets: horizontal, vertical, left diagonal, right diagonal.
  // Last four offsets corresponds to Knight movement direction.
  static const List<int> allDirectionalOffsets = [1, 8, 7, 9, 10, 17, 15, 6];

  static Movement kingMovement = Movement(
    directionalOffsets: allDirectionalOffsets.sublist(0, 4),
    maxStep: 1,
  );

  static Movement queenMovement = Movement(
    directionalOffsets: allDirectionalOffsets.sublist(0, 4),
    maxStep: 8,
  );

  static Movement bishopMovement = Movement(
    directionalOffsets: allDirectionalOffsets.sublist(2, 4),
    maxStep: 8,
  );

  static Movement knightMovement = Movement(
    directionalOffsets: allDirectionalOffsets.sublist(4),
    maxStep: 1,
  );

  static Movement rookMovement = Movement(
    directionalOffsets: allDirectionalOffsets.sublist(0, 2),
    maxStep: 8,
  );

  static Movement blackPawnMovement = Movement(
    directionalOffsets: allDirectionalOffsets.sublist(1, 2),
    maxStep: 1,
    mirrorDirection: false,
  );

  static Movement whitePawnMovement = Movement(
    directionalOffsets:
        allDirectionalOffsets.sublist(1, 2).map((e) => -e).toList(),
    maxStep: 1,
    mirrorDirection: false,
  );

  Movement({
    required List<int> directionalOffsets,
    required this.maxStep,
    bool mirrorDirection = true,
  }) : directionalOffsets = mirrorDirection
            ? directionalOffsets.expand((dir) => [-dir, dir]).toList()
            : directionalOffsets;

  final List<int> directionalOffsets;
  final int maxStep;
}
