import 'dart:io';

import 'package:flutter_chess/controller_2/enums.dart';
import 'package:flutter_chess/controller_2/game_piece.dart';

import 'movement.dart';

class Utility {
  static String ranks = '12345678';
  static String files = 'abcdefgh';

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
        stdout.write(board[i]);
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
}
