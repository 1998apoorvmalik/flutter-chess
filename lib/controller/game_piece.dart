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
    GameMove gameMove =
        GameMove.fromGamePiece(movedPiece: piece, finalLocation: '');

    if (piece.pieceType == PieceType.pawn) {
      // Pawn two step move check.
      int offset = piece._movement.directionalOffsets.first;

      if ((piece.currentLocation[1] == '2' ||
              piece.currentLocation[1] == '7') &&
          board[boardIndex + offset] == null &&
          board[boardIndex + offset * 2] == null) {
        specialMoves.add(gameMove.copyWith(
            finalLocation:
                Utility.convertBoardIndexToLocation(boardIndex + offset * 2)));
      }

      // Pawn attack check.
      int rightDiagonalOffset = Movement.allDirectionalOffsets[2] *
          (piece.pieceColor == PieceColor.white ? -1 : 1);
      int leftDiagonalOffset = Movement.allDirectionalOffsets[3] *
          (piece.pieceColor == PieceColor.white ? -1 : 1);
      int leftOffset = piece.pieceColor == PieceColor.white
          ? -Movement.allDirectionalOffsets[0]
          : Movement.allDirectionalOffsets[0];
      int rightOffset = piece.pieceColor == PieceColor.white
          ? Movement.allDirectionalOffsets[0]
          : -Movement.allDirectionalOffsets[0];

      bool pawnAttackPossible({required bool rightDirectionTest}) {
        int diagonalOffset =
            rightDirectionTest ? rightDiagonalOffset : leftDiagonalOffset;
        int horizontalOffset = rightDirectionTest ? rightOffset : leftOffset;

        return (Utility.isValidMoveIndex(boardIndex, diagonalOffset) &&
            board[boardIndex + diagonalOffset]?.pieceColor !=
                piece.pieceColor &&
            (board[boardIndex + diagonalOffset]?.pieceColor != null ||
                ((piece.currentLocation[1] == '4' ||
                        piece.currentLocation[1] == '5') &&
                    board[boardIndex + horizontalOffset]?.pieceColor !=
                        piece.pieceColor &&
                    board[boardIndex + horizontalOffset]?.pieceType ==
                        PieceType.pawn)));
      }

      // Left diagonal attack test.
      if (pawnAttackPossible(rightDirectionTest: false)) {
        int finalIndex = boardIndex + leftDiagonalOffset;
        GamePiece capturedPiece = board[finalIndex] == null
            ? board[boardIndex + leftOffset]!
            : board[finalIndex]!;

        specialMoves.add(GameMove.fromGamePiece(
            movedPiece: piece,
            finalLocation: Utility.convertBoardIndexToLocation(finalIndex),
            threatenedPiece: capturedPiece));
      }

      // Right diagonal attack test.
      if (pawnAttackPossible(rightDirectionTest: true)) {
        int finalIndex = boardIndex + rightDiagonalOffset;
        GamePiece capturedPiece = board[finalIndex] == null
            ? board[boardIndex + rightOffset]!
            : board[finalIndex]!;

        specialMoves.add(GameMove.fromGamePiece(
            movedPiece: piece,
            finalLocation: Utility.convertBoardIndexToLocation(finalIndex),
            threatenedPiece: capturedPiece));
      }
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
        int nextBoardIndex = boardIndex + _movement.directionalOffsets[i] * j;
        if (Utility.isValidMoveIndex(
                boardIndex, _movement.directionalOffsets[i],
                multiplier: j) &&
            board[nextBoardIndex]?.pieceColor != _pieceColor) {
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
    // return validBoardIndices
    //     .map((index) => GameMove(
    //           movedPieceColor: pieceColor,
    //           movedPieceType: pieceType,
    //           initialLocation: currentLocation,
    //           finalLocation: Utility.convertBoardIndexToLocation(index),
    //           threatendPieceLocation: board[index]?.currentLocation,
    //           threatenedPieceColor: board[index]?.pieceColor,
    //           threatenedPieceType: board[index]?.pieceType,
    //         ))
    //     .toList()
    //   ..addAll(GamePiece.getSpecialMovesforGamePiece(this, board));

    return validBoardIndices
        .map((index) => GameMove.fromBoard(
            board: board,
            initialLocation: currentLocation,
            finalLocation: Utility.convertBoardIndexToLocation(index)))
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
