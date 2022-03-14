import 'game_move.dart';
import 'game_piece.dart';
import 'movement.dart';
import 'utility.dart';
import 'extensions.dart';

export 'utility.dart';
export 'game_piece.dart';
export 'game_move.dart';

class ChessController {
  ChessController({String fen = Utility.defaultFEN})
      : _board = Utility.initBoardFromFen(fen) {
    _updateLegalMoves();
  }

  final List<BigInt> _board;
  bool _isWhiteTurn = false;
  bool _isGameEnded = false;

  final List<GameMove> _moveHistory = [];
  final List<List<GameMove>> _legalMovesHistory = [];

  // Callbacks
  void Function()? sceneRefreshCallback;

  // Getter for private properties.
  List<BigInt> get bitBoard => _board;
  List<String> get fenBoard => Utility.bitboardsToFenBoard(_board);
  List<GamePiece> get board => fenBoard
      .map((String fenChr) => Utility.fenCharToGamePiece(fenChr))
      .toList();

  bool get isWhiteTurn => _isWhiteTurn;
  bool get isGameEnded => _isGameEnded;
  PieceColor get currentTurnColor =>
      _isWhiteTurn ? PieceColor.white : PieceColor.black;

  List<GameMove> get moveHistory => _moveHistory;
  List<GameMove> get legalMoves =>
      _legalMovesHistory.isNotEmpty ? _legalMovesHistory.last : [];

  /// Return legal moves for selected board index.
  List<GameMove> legalMovesForIndex(int index) =>
      legalMoves.where((move) => move.startIndex == index).toList();

  /// Get piece color at a given board index.
  PieceColor? pieceColorAtBoardIndex(int index) => fenBoard[index] != '+'
      ? Utility.fenCharToGamePiece(fenBoard[index]).pieceColor
      : null;

  /// Get piece type at a given board index.
  PieceType? pieceTypeAtBoardIndex(int index) => fenBoard[index] != '+'
      ? Utility.fenCharToGamePiece(fenBoard[index]).pieceType
      : null;

  /// Returns raw-pseudo (may contain illegal moves) for a piece at given board index.
  List<GameMove> _pseudoLegalMovesForPiece(
      {required String fenChr,
      required BigInt bitboard,
      required BigInt occupied}) {
    List<GameMove> moves = [];

    for (int index in bitboard.getSetBitIndices()) {
      print(index);
      BigInt slider = bitboard & -bitboard;
      print(slider.toBin());
      BigInt horizontalAttacks = Utility.getLineAttacks(
          slider, occupied, Movement.onlyRank1 << (index ~/ 8));
      BigInt verticalAttacks = Utility.getLineAttacks(
          slider, occupied, Movement.onlyFileA >> 7 - (index % 8));

      for (int endIndex
          in (horizontalAttacks | verticalAttacks).getSetBitIndices()) {
        moves.add(GameMove(startIndex: index, endIndex: endIndex));
      }

      bitboard &= bitboard - BigInt.one;
    }
    return moves;

    // for (int i = 0; i < movement.directionalOffsets.length; i++) {
    //   BigInt movesBitboard = movement.directionalOffsets[i] > 0
    //       ? (bitboard << movement.directionalOffsets[i].abs() & ~occupied)
    //       : (bitboard >> movement.directionalOffsets[i].abs() & ~occupied);

    //   if (movesBitboard < BigInt.zero) {
    //     break;
    //   }
    //   List<int> endIndices = Utility.bitboardToIndices(movesBitboard);

    //   Utility.bitboardToIndices(bitboard).forEach((startIndex) {
    //     endIndices.forEach((endIndex) {
    //       moves.add(GameMove(startIndex: startIndex, endIndex: endIndex));
    //     });
    //   });
    // }
  }

  void _updateLegalMoves() {
    List<GameMove> legalMoves = [];
    BigInt occupied = Utility.getOccupiedBitBoard(_board);
    for (int i = 0; i < _board.length; i++) {
      legalMoves.addAll(_pseudoLegalMovesForPiece(
          fenChr: Utility.gamePieceFromIndex(i).fenChar,
          bitboard: _board[i],
          occupied: occupied));
    }
    _legalMovesHistory.add(legalMoves);
  }

  void playMove(GameMove move) {
    if (!legalMoves.contains(move)) {
      return;
    }
    // TODO: Update Board!

    // Execute scene refresh callback.
    if (sceneRefreshCallback != null) {
      sceneRefreshCallback!();
    }
    // Update turn.
    _isWhiteTurn = !_isWhiteTurn;
    // Add the move to move history.
    _moveHistory.add(move);
    // Update legal moves.
    _updateLegalMoves();
  }

  void undoMove() {
    if (moveHistory.isEmpty) {
      return;
    }
    // Get the last played move.
    GameMove move = _moveHistory.removeLast();

    // TODO: Update Board!

    // Execute scene refresh callback.
    if (sceneRefreshCallback != null) {
      sceneRefreshCallback!();
    }
    // Update current turn.
    _isWhiteTurn = !_isWhiteTurn;
    // Update legal moves.
    _legalMovesHistory.removeLast();
  }
}
