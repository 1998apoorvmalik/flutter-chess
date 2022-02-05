import 'package:flutter_chess/controller/enums.dart';
import 'package:flutter_chess/controller/game_move.dart';
import 'package:flutter_chess/controller/movement.dart';
import 'package:flutter_chess/controller/utility.dart';

class GamePiece {
  static List<GamePiece> allPieces = [
    GamePiece(pieceType: PieceType.king, pieceColor: PieceColor.white),
    GamePiece(pieceType: PieceType.king, pieceColor: PieceColor.black),
    GamePiece(pieceType: PieceType.rook, pieceColor: PieceColor.white),
    GamePiece(pieceType: PieceType.rook, pieceColor: PieceColor.black),
    GamePiece(pieceType: PieceType.bishop, pieceColor: PieceColor.white),
    GamePiece(pieceType: PieceType.bishop, pieceColor: PieceColor.black),
    GamePiece(pieceType: PieceType.queen, pieceColor: PieceColor.white),
    GamePiece(pieceType: PieceType.queen, pieceColor: PieceColor.black),
    GamePiece(pieceType: PieceType.knight, pieceColor: PieceColor.white),
    GamePiece(pieceType: PieceType.knight, pieceColor: PieceColor.black),
    GamePiece(pieceType: PieceType.pawn, pieceColor: PieceColor.white),
    GamePiece(pieceType: PieceType.pawn, pieceColor: PieceColor.black),
  ];

  /// Returns given piece type movement.
  static Movement getMovementforPieceType(
      PieceType pieceType, PieceColor pieceColor) {
    switch (pieceType) {
      case PieceType.king:
        return Movement.getKingMovement();
      case PieceType.rook:
        return Movement.getRookMovement();
      case PieceType.bishop:
        return Movement.getBishopMovement();
      case PieceType.queen:
        return Movement.getQueenMovement();
      case PieceType.knight:
        return Movement.getKnightMovement();
      case PieceType.pawn:
        return Movement.getPawnMovement(pieceColor);
    }
  }

  static List<GameMove> getSpecialMovesforGamePiece(
      GamePiece piece, List<GamePiece?> board) {
    List<GameMove> specialMoves = [];

    int boardIndex = Utility.convertLocationToBoardIndex(piece.currentLocation);
    GameMove gameMove = GameMove(
        pieceColor: piece.pieceColor,
        pieceType: piece.pieceType,
        initialLocation: piece.currentLocation,
        finalLocation: '');

    if (piece.pieceType == PieceType.pawn) {
      // Pawn two step move check.
      if (piece.currentLocation[1] == '2' || piece.currentLocation[1] == '7') {
        specialMoves.add(gameMove.copyWith(
            finalLocation: Utility.convertBoardIndexToLocation(
                boardIndex + piece._movement.directionalOffsets.first * 2)));
      }
    }

    // Pawn attack check.
    int forwardDiagonalOffset = Movement.allDirectionalOffsets[2] *
        (piece.pieceColor == PieceColor.white ? -1 : 1);
    int backwardDiagonalOffset = Movement.allDirectionalOffsets[3] *
        (piece.pieceColor == PieceColor.white ? -1 : 1);

    // Check if forward diagonal attack is possible.
    if (Utility.isValidMoveIndex(
        board: board,
        currentIndex: boardIndex,
        offset: forwardDiagonalOffset,
        isAttackCheck: true)) {
      specialMoves.add(gameMove.copyWith(
          finalLocation: Utility.convertBoardIndexToLocation(
              boardIndex + forwardDiagonalOffset)));
    }

    // Check if backward diagonal attack is possible.
    if (Utility.isValidMoveIndex(
        board: board,
        currentIndex: boardIndex,
        offset: backwardDiagonalOffset,
        isAttackCheck: true)) {
      specialMoves.add(gameMove.copyWith(
          finalLocation: Utility.convertBoardIndexToLocation(
              boardIndex + backwardDiagonalOffset)));
    }

    return specialMoves;
  }

  GamePiece({
    required PieceType pieceType,
    required PieceColor pieceColor,
    List<String>? previousLocations,
    this.currentLocation = '',
  })  : _pieceType = pieceType,
        _pieceColor = pieceColor,
        _fenChar = Utility.convertPieceToFenChar(
            pieceType: pieceType, pieceColor: pieceColor),
        _movement = GamePiece.getMovementforPieceType(pieceType, pieceColor),
        previousLocations = previousLocations ?? [];

  // Private properties.
  final PieceType _pieceType;
  final PieceColor _pieceColor;
  final Movement _movement;
  final String _fenChar;

  // Getters for private fields.
  PieceType get pieceType => _pieceType;
  PieceColor get pieceColor => _pieceColor;
  Movement get movement => _movement;
  String get fenChar => _fenChar;

  // Public properties.
  String currentLocation;
  List<String> previousLocations;

  /// Moves the piece as defined by game move.
  void movePiece(GameMove move) {
    previousLocations.add(move.initialLocation);
    currentLocation = move.finalLocation;
  }

  /// Finds all valid locations for the piece to move to.
  List<GameMove> getMovementLocations(List<GamePiece?> board) {
    if (currentLocation.isEmpty) {
      return [];
    }

    List<int> validBoardIndices = [];
    int boardIndex = Utility.convertLocationToBoardIndex(currentLocation);

    for (int i = 0; i < _movement.directionalOffsets.length; i++) {
      for (int j = 1; j <= _movement.maxStep; j++) {
        int offset = _movement.directionalOffsets[i] * j;
        int nextBoardIndex = boardIndex + offset;
        if (Utility.isValidMoveIndex(
            board: board, currentIndex: boardIndex, offset: offset)) {
          validBoardIndices.add(nextBoardIndex);

          if (board[nextBoardIndex]?.pieceType != null) {
            if (pieceType == PieceType.pawn) {
              validBoardIndices.removeLast();
            }
            break;
          }
        } else {
          break;
        }
      }
    }

    return validBoardIndices
        .map((index) => GameMove(
              pieceColor: pieceColor,
              pieceType: pieceType,
              initialLocation: currentLocation,
              finalLocation: Utility.convertBoardIndexToLocation(index),
            ))
        .toList()
      ..addAll(GamePiece.getSpecialMovesforGamePiece(this, board));
  }

  GamePiece copyWith({
    PieceType? pieceType,
    PieceColor? pieceColor,
    String? currentLocation,
    List<String>? previousLocations,
  }) =>
      GamePiece(
          pieceType: pieceType ?? this.pieceType,
          pieceColor: pieceColor ?? this.pieceColor,
          currentLocation: currentLocation ?? this.currentLocation,
          previousLocations: previousLocations ?? this.previousLocations);

  @override
  String toString() => {'fen': fenChar, 'loc': currentLocation}.toString();
}
