import 'package:flutter_chess/controller/base_chess_controller.dart';
import 'package:flutter_chess/controller/movement_vector.dart';
import 'enums.dart';

class ChessController extends BaseChessController {
  ChessController({
    String initialFenString =
        'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1',
  }) : _board = List.generate(8, (_) => List.generate(8, (_) => null)) {
    _loadGameFromFenString(initialFenString);
  }

  final List<List<PieceType?>> _board;

  // All moves during the game are stored in this list.
  final List<String> _moveList = [];

  // Some game properties to keep track of.
  bool blackKingSideCastleRestricted = false;
  bool blackQueenSideCastleRestricted = false;

  bool whiteKingSideCastleRestricted = false;
  bool whiteQueenSideCastleRestricted = false;

  bool isGameEnded = false;
  bool isWhiteTurn = true;

  List<List<PieceType?>> get board => _board;

  List<String> get moveList => _moveList;

  bool get canWhiteKingSideCastle =>
      isWhiteTurn &&
      !whiteKingSideCastleRestricted &&
      _board[0][5] == null &&
      _board[0][6] == null;

  bool get canWhiteQueenSideCastle =>
      isWhiteTurn &&
      !whiteQueenSideCastleRestricted &&
      board[0][1] == null &&
      _board[0][2] == null &&
      _board[0][3] == null;

  bool get canBlackKingSideCastle =>
      !isWhiteTurn &&
      !blackKingSideCastleRestricted &&
      _board[7][5] == null &&
      _board[7][6] == null;

  bool get canBlackQueenSideCastle =>
      !isWhiteTurn &&
      !blackQueenSideCastleRestricted &&
      board[7][1] == null &&
      _board[7][2] == null &&
      _board[7][3] == null;

  String get gamePGN {
    List<String> pgnList = [];
    int n = 0;
    for (int i = 0; i < _moveList.length; i++) {
      if (i % 2 == 0) {
        pgnList.add((++n).toString() + '.');
      }
      pgnList.add(_moveList[i]);
    }
    return pgnList.join(" ");
  }

  void _movePiece({
    required PieceType piece,
    required String loc,
  }) {
    List<int> locationIndex = BaseChessController.positionToLocation(loc);
    int row = locationIndex[0];
    int col = locationIndex[1];

    _board[row][col] = piece;
  }

  void _loadGameFromFenString(String fenString) {
    List<String> boardConfig = fenString.split(' ').first.split('/');

    for (int i = 0; i < 8; i++) {
      int offset = 0;
      for (int j = 0; j < boardConfig[i].length; j++) {
        int? nSkip = int.tryParse(boardConfig[i][j]);

        if (nSkip == null) {
          _movePiece(
              piece: BaseChessController.fenCharToPieceType(boardConfig[i][j]),
              loc: '${BaseChessController.files[j + offset]}${8 - i}');
        } else {
          offset += nSkip - 1;
        }
      }
    }
  }

  // Check if pawn can be transformed to queen.
  void _pawnTransfromConditionCheck() {
    for (int i = 0; i < 8; i++) {
      if (_board[0][i] == PieceType.blackPawn) {
        _board[0][i] = PieceType.blackQueen;
      }

      if (_board[7][i] == PieceType.whitePawn) {
        _board[7][i] = PieceType.whiteQueen;
      }
    }
  }

  // Castling allowed only if king and rook are not moved from their original positions in the game.
  void _updateCastlingStatus(String pos) {
    if (pos == 'h1' || pos == 'e1') {
      whiteKingSideCastleRestricted = true;
    }
    if (pos == 'a1' || pos == 'e1') {
      whiteQueenSideCastleRestricted = true;
    }
    if (pos == 'h8' || pos == 'e8') {
      blackKingSideCastleRestricted = true;
    }
    if (pos == 'a8' || pos == 'e8') {
      blackQueenSideCastleRestricted = true;
    }
  }

  void makeMove({
    required String fromPos,
    required String toPos,
  }) {
    List<int> fromLoc = BaseChessController.positionToLocation(fromPos);
    List<int> toLoc = BaseChessController.positionToLocation(toPos);

    PieceType? piece = _board[fromLoc.first][fromLoc.last];

    // Check if a valid piece can be moved.
    if (getLegalMovesForSelectedCell(fromPos).contains(toPos)) {
      // Castling move check.
      int moveLength = toLoc.last - fromLoc.last;
      bool castlingMove = false;
      if ((piece! == PieceType.whiteKing || piece == PieceType.blackKing) &&
          moveLength.abs() > 1) {
        castlingMove = true;

        if (moveLength < 0) {
          // Queen Side Castle.
          _board[fromLoc.first][0] = null;
          _board[fromLoc.first][3] =
              isWhiteTurn ? PieceType.whiteRook : PieceType.blackRook;
        } else {
          // King Side Castle.
          _board[fromLoc.first][7] = null;
          _board[fromLoc.first][5] =
              isWhiteTurn ? PieceType.whiteRook : PieceType.blackRook;
        }
      }

      // Add move to the move list.
      _moveList.add((BaseChessController.convertMoveToAlgebricNotation(
          board: board,
          fromLoc: fromLoc,
          toLoc: toLoc,
          castlingMove: castlingMove)));

      // Update board.
      _movePiece(piece: piece, loc: toPos);
      _board[fromLoc.first][fromLoc.last] = null;

      // Update turn.
      isWhiteTurn = !isWhiteTurn;

      // Update castling restrictions.
      _updateCastlingStatus(fromPos);

      // Check if pawn can be transformed to higher value piece.
      _pawnTransfromConditionCheck();
    }
  }

  List<String> getLegalMovesForSelectedCell(String loc) {
    List<int> locationIndex = BaseChessController.positionToLocation(loc);
    PieceType? piece = _board[locationIndex.first][locationIndex.last];

    List<String> legalMoves = [];

    if (piece != null) {
      MovementVector boardPiece = pieceMovementOffset[piece]!;

      if ((boardPiece.pieceColor == PieceColor.white && isWhiteTurn) ||
          (boardPiece.pieceColor == PieceColor.black && !isWhiteTurn)) {
        legalMoves = boardPiece.directionalOffsets(board: _board, loc: loc);
      }

      if (canWhiteKingSideCastle) {
        legalMoves.add('g1');
      }
      if (canWhiteQueenSideCastle) {
        legalMoves.add('c1');
      }
      if (canBlackKingSideCastle) {
        legalMoves.add('g8');
      }
      if (canBlackQueenSideCastle) {
        legalMoves.add('c8');
      }
    }

    return legalMoves;
  }
}
