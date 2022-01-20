import 'package:flutter_chess/controller/controller.dart';

class MovementVector {
  MovementVector({
    required this.pieceType,
    required this.directions,
    required this.maxStep,
    required this.mirrorDirection,
    this.getSpecialMoves,
    this.allowJump = false,
  }) : pieceColor = BaseChessController.getPieceTypeColor(pieceType);

  final PieceType pieceType;
  final PieceColor pieceColor;
  final List<List<int>> directions;
  final int maxStep;
  final bool mirrorDirection;
  final bool allowJump;
  final List<String> Function(
      {required List<List<PieceType?>> board,
      required List<String> moveList,
      required String pos})? getSpecialMoves;

  bool _isSafe(int x, int y) => x >= 0 && y >= 0 && x < 8 && y < 8;

  bool _isEmptyCell(List<List<PieceType?>> board, int x, int y) =>
      _isSafe(x, y) && board[x][y] == null;

  bool _isEnemyCell(List<List<PieceType?>> board, int x, int y) {
    return _isSafe(x, y) &&
        BaseChessController.getPieceTypeColor(board[x][y] ?? pieceType) !=
            pieceColor;
  }

  List<List<int>> get _directionVectors {
    List<List<int>> dVect = [];

    for (List<int> direction in directions) {
      int x = direction[0];
      int y = direction[1];

      dVect.add([x, y]);

      if (mirrorDirection) {
        if (x == y) {
          dVect.add([-x, -y]);
        } else {
          dVect.add([y, x]);
        }
      }
    }

    return dVect;
  }

  List<String> directionalOffsets(
      {required List<List<PieceType?>> board,
      required List<String> moveList,
      required String pos}) {
    List<int> locationIndex = BaseChessController.positionToLocation(pos);
    List<List<int>> directionVectors = _directionVectors.toList();
    List<String> validLocations = [];

    for (int i = 0; i < directionVectors.length; i++) {
      List<int> directionVector = directionVectors[i];

      for (int step = 1; step <= maxStep; step++) {
        int xPos = locationIndex[0] + (directionVector[0] * step);
        int yPos = locationIndex[1] + (directionVector[1] * step);

        if (_isEmptyCell(board, xPos, yPos)) {
          validLocations
              .add(BaseChessController.locationToPosition([xPos, yPos]));
        } else if (pieceType != PieceType.whitePawn &&
            pieceType != PieceType.blackPawn &&
            _isEnemyCell(board, xPos, yPos)) {
          validLocations
              .add(BaseChessController.locationToPosition([xPos, yPos]));
          break;
        } else {
          break;
        }
      }
    }

    // Add any special moves location to the list.
    if (getSpecialMoves != null) {
      validLocations
          .addAll(getSpecialMoves!(board: board, moveList: moveList, pos: pos));
    }

    return validLocations;
  }
}
