import 'dart:io';

import 'game_piece.dart';
import 'movement.dart';
import 'extensions.dart';

class Utility {
  static const String ranks = '12345678';
  static const String files = 'abcdefgh';
  static const String allFenPieces = 'rnbqkpRNBQKP';
  static const defaultFEN =
      'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1';
  static const int middleIndex = 28;

  static Map<BigInt, int> pow2Till64 = Map.fromEntries(
      List.generate(64, (index) => index)
          .map((i) => MapEntry(i == 0 ? BigInt.one : BigInt.two << i - 1, i)));

  static void debugBoard(List<String> fenBoard) {
    for (int i = 0; i < fenBoard.length; i++) {
      stdout.write(fenBoard[i]);
      stdout.write(' ');
      if ((i + 1) % 8 == 0) {
        stdout.write('\n');
      }
    }
  }

  /// Converts game piece to fen character.
  static String gamePieceToFenChr(GamePiece gamePiece) {
    String pieceName = gamePiece.pieceType.toString().split('.').last;
    String fenChar =
        gamePiece.pieceType == PieceType.knight ? pieceName[1] : pieceName[0];

    if (gamePiece.pieceColor == PieceColor.white) {
      fenChar = fenChar.toUpperCase();
    }

    return fenChar;
  }

  /// Converts fen character to game piece.
  static GamePiece fenCharToGamePiece(String fenChr) {
    PieceColor pieceColor =
        fenChr.toUpperCase() != fenChr ? PieceColor.black : PieceColor.white;

    PieceType pieceType = fenChr.toUpperCase() == 'N'
        ? PieceType.knight
        : PieceType.values.firstWhere((pieceType) =>
            pieceType.toString().split('.').last[0] == fenChr.toLowerCase());

    return GamePiece(pieceColor: pieceColor, pieceType: pieceType);
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

  static int getPieceIndex(GamePiece piece) {
    int index = -1;
    switch (piece.pieceType) {
      case PieceType.pawn:
        index = 0;
        break;
      case PieceType.bishop:
        index = 1;
        break;
      case PieceType.knight:
        index = 2;
        break;
      case PieceType.rook:
        index = 3;
        break;
      case PieceType.queen:
        index = 4;
        break;
      case PieceType.king:
        index = 5;
        break;
    }
    return piece.pieceColor == PieceColor.white ? index : index + 6;
  }

  static GamePiece gamePieceFromIndex(int index) {
    PieceColor pieceColor = index >= 6 ? PieceColor.white : PieceColor.black;
    index -= index >= 6 ? 6 : 0;

    switch (index) {
      case 0:
        return GamePiece(pieceType: PieceType.pawn, pieceColor: pieceColor);
      case 1:
        return GamePiece(pieceType: PieceType.bishop, pieceColor: pieceColor);
      case 2:
        return GamePiece(pieceType: PieceType.knight, pieceColor: pieceColor);
      case 3:
        return GamePiece(pieceType: PieceType.rook, pieceColor: pieceColor);
      case 4:
        return GamePiece(pieceType: PieceType.queen, pieceColor: pieceColor);
      default:
        return GamePiece(pieceType: PieceType.king, pieceColor: pieceColor);
    }
  }

  static List<BigInt> initBoardFromFen(String fen) {
    String configFen = fen.split(' ').first;
    List<BigInt> board = List.filled(12, BigInt.zero, growable: false);
    int offset = 63;

    for (String fenChr in configFen.split('')) {
      // Next rank condition.
      if (fenChr == '/') {
        continue;
      } else if (int.tryParse(fenChr) != null) {
        offset -= int.parse(fenChr);
      } else {
        board[getPieceIndex(fenCharToGamePiece(fenChr))] +=
            BigInt.one << offset--;
      }
    }
    return board;
  }

  /// Converts the list of bitboards (representing current board state) to a FEN Board.
  /// This is useful for debugging purposes.
  static List<String> bitboardsToFenBoard(List<BigInt> board) {
    List<String> convertedBoard = List.filled(64, '+');
    for (int index = 0; index < board.length; index++) {
      GamePiece piece = Utility.gamePieceFromIndex(index);
      List<int> indices = board[index].getSetBitIndices();

      for (int index in indices) {
        convertedBoard[63 - index] = piece.toString();
      }
    }

    return convertedBoard;
  }

  static BigInt getOccupiedBitBoard(List<BigInt> board) {
    BigInt occupied = BigInt.zero;
    for (BigInt bitboard in board) {
      occupied ^= bitboard;
    }
    return occupied;
  }

  static BigInt getLineAttacks(BigInt s, BigInt o, BigInt m) =>
      (((o & m) - (BigInt.two * s)) ^
          ((o & m).reverse() - (BigInt.two * s.reverse())).reverse()) &
      m;
}
