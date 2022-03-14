import 'dart:io';

import 'enums.dart';
import 'game_piece.dart';
import 'movement.dart';

class Utility {
  static const String ranks = '12345678';
  static const String files = 'abcdefgh';
  static const defaultFEN =
      'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1';
  static const int middleIndex = 28;

  static getPieceMovement(String fenChr) {
    switch (fenChr.toUpperCase()) {
      case 'K':
        return Movement.kingMovement;
      case 'R':
        return Movement.rookMovement;
      case 'B':
        return Movement.bishopMovement;
      case 'Q':
        return Movement.queenMovement;
      case 'N':
        return Movement.knightMovement;
      default:
        return fenChr == 'P'
            ? Movement.whitePawnMovement
            : Movement.blackPawnMovement;
    }
  }

  static List<String> initBoardFromFen(String fen) {
    String configFen = fen.split(' ').first;
    List<String> board = [];
    int itr = -1;

    while (++itr < configFen.length) {
      // Next rank condition.
      if (configFen[itr] == '/') {
        continue;
      }
      // Blank space condition.
      else if (int.tryParse(configFen[itr]) != null) {
        int blankSpaces = int.parse(configFen[itr]);
        // Add specified blank spaces.
        while (blankSpaces-- > 0) {
          board.add('+');
        }
      }
      // Add piece condition.
      else {
        board.add(configFen[itr]);
      }
    }
    return board;
  }

  static void debugBoard(List<String> board) {
    for (int i = 0; i < board.length; i++) {
      stdout.write(board[i]);
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

  /// Utility function to check if the next board index after adding an offset to previous board index is valid.
  static bool isValidMoveIndex(int currentIndex, int offset,
      {int multiplier = 1}) {
    int nextIndex = currentIndex + offset * multiplier;

    return (nextIndex > -1 &&
        nextIndex < ranks.length * ranks.length &&
        getDistanceBetweenBoardIndices(currentIndex, nextIndex) ==
            getDistanceBetweenBoardIndices(middleIndex, middleIndex + offset) *
                multiplier);
  }

  /// Converts game piece to fen character.
  static String gamePieceToFenChar(GamePiece gamePiece) {
    String pieceName = gamePiece.pieceType.toString().split('.').last;
    String fenChar =
        gamePiece.pieceType == PieceType.knight ? pieceName[1] : pieceName[0];

    if (gamePiece.pieceColor == PieceColor.white) {
      fenChar = fenChar.toUpperCase();
    }

    return fenChar;
  }

  /// Converts fen character to game piece.
  static GamePiece fenCharToGamePiece(String fenChar) {
    PieceColor pieceColor =
        fenChar.toUpperCase() != fenChar ? PieceColor.black : PieceColor.white;

    PieceType pieceType = fenChar.toUpperCase() == 'N'
        ? PieceType.knight
        : PieceType.values.firstWhere((pieceType) =>
            pieceType.toString().split('.').last[0] == fenChar.toLowerCase());

    return GamePiece(pieceColor: pieceColor, pieceType: pieceType);
  }
}
