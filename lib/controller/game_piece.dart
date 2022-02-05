import 'package:flutter_chess/controller/enums.dart';
import 'package:flutter_chess/controller/game_move.dart';
import 'package:flutter_chess/controller/movement.dart';
import 'package:flutter_chess/controller/utility.dart';

class GamePiece {
  GamePiece({
    required PieceType pieceType,
    required PieceColor pieceColor,
    List<String>? previousLocations,
    this.currentLocation = '',
  })  : _pieceType = pieceType,
        _pieceColor = pieceColor,
        _fenChar = Utility.convertPieceToFenChar(
            pieceType: pieceType, pieceColor: pieceColor),
        _movement = Utility.getMovementforPieceType(pieceType),
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
        int nextBoardIndex = boardIndex + _movement.directionalOffsets[i] * j;
        if (nextBoardIndex > -1 &&
            nextBoardIndex < board.length &&
            Utility.getDistanceBetweenBoardIndices(
                    boardIndex, nextBoardIndex) ==
                Utility.getDistanceBetweenBoardIndices(
                        28, 28 + _movement.directionalOffsets[i]) *
                    j &&
            board[nextBoardIndex]?.pieceColor != _pieceColor) {
          validBoardIndices.add(nextBoardIndex);

          if (board[nextBoardIndex]?.pieceType != null) {
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
        .toList();
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