import 'enums.dart';
import 'movement_vector.dart';

class BaseChessController {
  static PieceType fenCharToPieceType(String fenChar) {
    if (fenChar == 'r') {
      return PieceType.blackRook;
    } else if (fenChar == 'n') {
      return PieceType.blackKnight;
    } else if (fenChar == 'b') {
      return PieceType.blackBishop;
    } else if (fenChar == 'q') {
      return PieceType.blackQueen;
    } else if (fenChar == 'k') {
      return PieceType.blackKing;
    } else if (fenChar == 'p') {
      return PieceType.blackPawn;
    } else if (fenChar == 'N') {
      return PieceType.whiteKnight;
    } else if (fenChar == 'B') {
      return PieceType.whiteBishop;
    } else if (fenChar == 'Q') {
      return PieceType.whiteQueen;
    } else if (fenChar == 'K') {
      return PieceType.whiteKing;
    } else if (fenChar == 'P') {
      return PieceType.whitePawn;
    } else {
      return PieceType.whiteRook;
    }
  }

  static String pieceTypeToFenChar(PieceType piece) {
    switch (piece) {
      case PieceType.blackPawn:
        return 'p';
      case PieceType.whitePawn:
        return 'P';

      case PieceType.blackKing:
        return 'k';

      case PieceType.whiteKing:
        return 'K';

      case PieceType.blackQueen:
        return 'q';

      case PieceType.whiteQueen:
        return 'Q';

      case PieceType.blackRook:
        return 'r';

      case PieceType.whiteRook:
        return 'R';

      case PieceType.blackKnight:
        return 'n';

      case PieceType.whiteKnight:
        return 'N';

      case PieceType.blackBishop:
        return 'b';

      case PieceType.whiteBishop:
        return 'B';
    }
  }

  static const String ranks = '12345678';
  static const String files = 'abcdefgh';

  Map<PieceType, MovementVector> pieceMovementOffset = {};

  BaseChessController() {
    // Pawn special move function.
    List<String> pawnSpecialMove(
        {required List<List<PieceType?>> board,
        required String pos,
        required PieceColor color}) {
      List<int> loc = positionToLocation(pos);
      List<String> validMovesLoc = [];

      // Two cell move.
      if (color == PieceColor.white
          ? loc[0] == 1
          : loc[0] == 6 &&
              board[loc.first + (color == PieceColor.white ? 2 : -2)]
                      [loc.last] ==
                  null) {
        validMovesLoc.add(locationToPosition(
            [loc.first + (color == PieceColor.white ? 2 : -2), loc.last]));
      }

      // Check if left-diagonal attack is possible.
      if (loc.last < 7) {
        // Left attack move.
        PieceType? leftAttackLocPieceType =
            board[loc.first + (color == PieceColor.white ? 1 : -1)]
                [loc.last + 1];
        if (leftAttackLocPieceType != null &&
            getPieceTypeColor(leftAttackLocPieceType) != color) {
          validMovesLoc.add(locationToPosition([
            loc.first + (color == PieceColor.white ? 1 : -1),
            loc.last + 1
          ]));
        }
      }

      // Check if right-diagonal attack is possible.
      if (loc.last > 1) {
        // Right attack move.
        PieceType? rightAttackLocPieceType =
            board[loc.first + (color == PieceColor.white ? 1 : -1)]
                [loc.last - 1];
        if (rightAttackLocPieceType != null &&
            getPieceTypeColor(rightAttackLocPieceType) != color) {
          validMovesLoc.add(locationToPosition([
            loc.first + (color == PieceColor.white ? 1 : -1),
            loc.last - 1
          ]));
        }
      }

      return validMovesLoc;
    }

    for (PieceType piece in PieceType.values) {
      MovementVector movementVector;

      switch (piece) {
        // Pawn
        case PieceType.blackPawn:
        case PieceType.whitePawn:
          movementVector = MovementVector(
            pieceType: piece,
            directions: [
              [(piece == PieceType.whitePawn ? 1 : -1), 0]
            ],
            maxStep: 1,
            mirrorDirection: false,
            getSpecialMoves: (
                    {required List<List<PieceType?>> board,
                    required String pos}) =>
                pawnSpecialMove(
                    board: board, pos: pos, color: getPieceTypeColor(piece)),
          );
          break;

        // King
        case PieceType.blackKing:
        case PieceType.whiteKing:
          movementVector = MovementVector(
            pieceType: piece,
            directions: [
              [0, 1],
              [-1, 0],
              [-1, 1],
              [1, 1]
            ],
            maxStep: 1,
            mirrorDirection: true,
          );
          break;

        // Queen
        case PieceType.blackQueen:
        case PieceType.whiteQueen:
          movementVector = MovementVector(
              pieceType: piece,
              directions: [
                [0, 1],
                [-1, 0],
                [-1, 1],
                [1, 1]
              ],
              maxStep: 8,
              mirrorDirection: true);
          break;

        // Rook
        case PieceType.blackRook:
        case PieceType.whiteRook:
          movementVector = MovementVector(
            pieceType: piece,
            directions: [
              [0, 1],
              [-1, 0]
            ],
            maxStep: 8,
            mirrorDirection: true,
          );
          break;

        // Knight
        case PieceType.blackKnight:
        case PieceType.whiteKnight:
          movementVector = MovementVector(
            pieceType: piece,
            directions: [
              [1, 2],
              [-1, 2],
              [1, -2],
              [-1, -2]
            ],
            maxStep: 1,
            mirrorDirection: true,
            allowJump: true,
          );
          break;

        // Bishop
        case PieceType.blackBishop:
        case PieceType.whiteBishop:
          movementVector = MovementVector(
            pieceType: piece,
            directions: [
              [-1, 1],
              [1, 1],
            ],
            maxStep: 8,
            mirrorDirection: true,
          );
          break;
      }

      pieceMovementOffset.addEntries(
          [MapEntry<PieceType, MovementVector>(piece, movementVector)]);
    }
  }

  static String convertMoveToAlgebricNotation({
    required List<List<PieceType?>> board,
    required List<int> fromLoc,
    required List<int> toLoc,
    bool castlingMove = false,
  }) {
    PieceType? fromLocPiece = board[fromLoc.first][fromLoc.last];
    PieceType? toLocPiece = board[toLoc.first][toLoc.last];

    // Invalid move provided, return an empty string.
    if (fromLocPiece == null) {
      return '';
    }

    // Check if castling move.
    if (castlingMove) {
      int moveLength = toLoc.last - fromLoc.last;
      if (moveLength > 0) {
        return '0-0-0';
      } else {
        return '0-0';
      }
    }

    // Append at start of the algebric notation.
    String prefix = (fromLocPiece != PieceType.whitePawn &&
            fromLocPiece != PieceType.blackPawn)
        ? pieceTypeToFenChar(fromLocPiece).toUpperCase()
        : '';

    // Append at end of the algebric notation.
    String suffix = locationToPosition(toLoc);

    String body = '';

    // Current turn piece captures opponent piece.
    if (toLocPiece != null) {
      body = 'x';
      if (fromLocPiece == PieceType.whitePawn ||
          fromLocPiece == PieceType.blackPawn) {
        prefix = locationToPosition(fromLoc)[0];
      }
    }
    // Current turn piece moves to an empty location on the board.
    else {}

    return prefix + body + suffix;
  }

  static List<int> positionToLocation(String loc) {
    // Make sure that the location 'loc' is in correct format.
    assert(loc.length == 2 &&
        BaseChessController.files.contains(loc[0]) &&
        BaseChessController.ranks.contains(loc[1]));

    int row = BaseChessController.ranks.indexOf(loc[1]);
    int col = BaseChessController.files.indexOf(loc[0]);

    return [row, col];
  }

  static PieceColor getPieceTypeColor(PieceType piece) {
    return piece.toString().split('.').last.substring(0, 5) == 'white'
        ? PieceColor.white
        : PieceColor.black;
  }

  static String locationToPosition(List<int> locationIndex) =>
      '${files[locationIndex.last]}${locationIndex.first + 1}';
}
