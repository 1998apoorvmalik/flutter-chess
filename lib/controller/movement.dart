// First four offsets: horizontal, vertical, left diagonal, right diagonal.
// Last four offsets corresponds to Knight movement direction.

import 'package:flutter_chess/controller/enums.dart';

class Movement {
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

  /// Returns given piece type movement.
  static Movement getMovementforPieceType(
      PieceType pieceType, PieceColor pieceColor) {
    switch (pieceType) {
      case PieceType.king:
        return Movement.kingMovement;
      case PieceType.rook:
        return Movement.rookMovement;
      case PieceType.bishop:
        return Movement.bishopMovement;
      case PieceType.queen:
        return Movement.queenMovement;
      case PieceType.knight:
        return Movement.knightMovement;
      case PieceType.pawn:
        return pieceColor == PieceColor.black
            ? Movement.blackPawnMovement
            : Movement.whitePawnMovement;
    }
  }

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
