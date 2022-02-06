import 'dart:io';

import 'package:flutter_chess/controller/enums.dart';
import 'package:flutter_chess/controller/game_piece.dart';

class Utility {
  static const String ranks = '12345678';
  static const String files = 'abcdefgh';
  static const defaultFEN =
      'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1';
  static const int middleIndex = 28;

  /// Converts piece type to fen character.
  static String gamePieceToFenChar(
      {required PieceType pieceType, required PieceColor pieceColor}) {
    String pieceName = pieceType.toString().split('.').last;
    String fenChar =
        pieceType == PieceType.knight ? pieceName[1] : pieceName[0];

    if (pieceColor == PieceColor.white) {
      fenChar = fenChar.toUpperCase();
    }

    return fenChar;
  }

  static GamePiece fenCharToGamePiece(String fenChar) {
    PieceColor pieceColor =
        fenChar.toUpperCase() != fenChar ? PieceColor.black : PieceColor.white;

    PieceType pieceType = fenChar.toUpperCase() == 'N'
        ? PieceType.knight
        : PieceType.values.firstWhere((pieceType) =>
            pieceType.toString().split('.').last[0] == fenChar.toLowerCase());

    return GamePiece(pieceColor: pieceColor, pieceType: pieceType);
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

  /// Utility function to check if the next board index after adding an offset to previous board index is valid.
  static bool isValidMoveIndex(int currentIndex, int offset,
      {int multiplier = 1}) {
    int nextIndex = currentIndex + offset * multiplier;

    return (nextIndex > -1 &&
        nextIndex < ranks.length * ranks.length &&
        Utility.getDistanceBetweenBoardIndices(currentIndex, nextIndex) ==
            Utility.getDistanceBetweenBoardIndices(
                    Utility.middleIndex, Utility.middleIndex + offset) *
                multiplier);
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
