import 'dart:io';

import 'package:flutter_chess/controller/enums.dart';
import 'package:flutter_chess/controller/game_piece.dart';

import 'movement.dart';

class Utility {
  static const String ranks = '12345678';
  static const String files = 'abcdefgh';
  static const defaultFEN =
      'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1';

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
  static Movement getMovementforPieceType(PieceType pieceType) {
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
        return Movement.getPawnMovement();
    }
  }

  /// Converts piece type to fen character.
  static String convertPieceToFenChar(
      {required PieceType pieceType, required PieceColor pieceColor}) {
    String pieceName = pieceType.toString().split('.').last;
    String fenChar =
        pieceType == PieceType.knight ? pieceName[1] : pieceName[0];

    if (pieceColor == PieceColor.white) {
      fenChar = fenChar.toUpperCase();
    }

    return fenChar;
  }

  /// Utility function to print current state of the board.
  static void debugBoard(List<GamePiece?> board) {
    for (int i = 0; i < board.length; i++) {
      if (board[i] != null) {
        stdout.write(board[i]!.fenChar);
      } else {
        stdout.write('+');
      }
      stdout.write(' ');

      if ((i + 1) % 8 == 0) {
        stdout.write('\n');
      }
    }
  }

  /// Convert board index to location.
  static String convertBoardIndexToLocation(int boardIndex) =>
      '${files[boardIndex % 8]}${ranks[ranks.length - (boardIndex / 8).floor() - 1]}';

  /// Convert location to board index.
  static int convertLocationToBoardIndex(String loc) =>
      ((ranks.length - ranks.indexOf(loc[1]) - 1) * ranks.length) +
      files.indexOf(loc[0]);

  /// Get manhattan distance between two board indices.
  static int getDistanceBetweenBoardIndices(int firstIndex, int secondIndex) {
    int x1 = firstIndex % files.length;
    int y1 = (firstIndex / files.length).floor();

    int x2 = secondIndex % ranks.length;
    int y2 = (secondIndex / ranks.length).floor();

    return (y2 - y1).abs() + (x2 - x1).abs();
  }
}
