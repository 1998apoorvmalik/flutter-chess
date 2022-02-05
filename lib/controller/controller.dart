// Imports
import 'package:flutter/scheduler.dart';
import 'package:flutter_chess/controller/enums.dart';
import 'package:flutter_chess/controller/game_move.dart';
import 'package:flutter_chess/controller/utility.dart';
import 'package:flutter_chess/controller/game_piece.dart';

// Exports
export 'package:flutter_chess/controller/enums.dart';
export 'package:flutter_chess/controller/game_move.dart';
export 'package:flutter_chess/controller/utility.dart';
export 'package:flutter_chess/controller/game_piece.dart';

class ChessController {
  ChessController({String fen = Utility.defaultFEN}) {
    _initializeFromFen(fen);
    reset();
  }

  final List<GamePiece?> _board = [];

  late PieceColor _currentTurnColor;
  late bool _isGameEnded;
  final List<GameMove> _legalMoves = [];
  final List<GameMove> _moveHistory = [];

  VoidCallback? sceneRefreshCallback;

  // Getter for private properties.
  List<GamePiece?> get board => _board;
  bool get isWhiteTurn => _currentTurnColor == PieceColor.white ? true : false;
  bool get isBlackTurn => _currentTurnColor == PieceColor.black ? true : false;
  bool get isGameEnded => _isGameEnded;
  PieceColor get currentTurnColor => _currentTurnColor;
  List<GameMove> get legalMoves => _legalMoves;
  List<GameMove> get moveHistory => _moveHistory;

  /// Returns legal moves for a given board location.
  List<GameMove> getLegalMovesForSelectedLocation(String loc) {
    return _legalMoves.where((move) => move.initialLocation == loc).toList();
  }

  /// Used to reset the current game session.
  void reset() {
    _isGameEnded = false;
    _currentTurnColor = PieceColor.white;
    _updateLegalMoves();
    _moveHistory.clear();
  }

  /// Debug method to print the current state of the board
  void printBoard() {
    Utility.debugBoard(_board);
  }

  /// Updates legal moves for the current player.
  void _updateLegalMoves() {
    List<GameMove> legalMoves = [];
    for (GamePiece? piece in _board) {
      if (piece != null && piece.pieceColor == _currentTurnColor) {
        legalMoves.addAll(piece.getMovementLocations(_board));
      }
    }

    _legalMoves.clear();
    _legalMoves.addAll(legalMoves);
  }

  /// Plays the legal game move.
  void playMove(GameMove move) {
    if (_legalMoves.contains(move)) {
      // Get the board's initial and final indices from the given move.
      int initialIndex =
          Utility.convertLocationToBoardIndex(move.initialLocation);
      int finalIndex = Utility.convertLocationToBoardIndex(move.finalLocation);

      // Moves the piece to final location.
      _board[finalIndex] = _board[initialIndex]!..movePiece(move);

      // Set game piece at initial location to null.
      _board[Utility.convertLocationToBoardIndex(move.initialLocation)] = null;

      // Execute scene refresh callback.
      if (sceneRefreshCallback != null) {
        sceneRefreshCallback!();
      }

      // Update current turn.
      _currentTurnColor = _currentTurnColor == PieceColor.white
          ? PieceColor.black
          : PieceColor.white;

      // Add the move to move history.
      _moveHistory.add(move);

      // Update legal moves.
      _updateLegalMoves();
    }
  }

  /// Undo the last played legal move.
  void undoMove() {
    if (moveHistory.isEmpty) {
      return;
    }

    GameMove move = _moveHistory.removeLast();

    board[Utility.convertLocationToBoardIndex(move.initialLocation)] = GamePiece
        .allPieces
        .firstWhere((piece) =>
            piece.pieceColor == move.movedPieceColor &&
            piece.pieceType == move.movedPieceType)
        .copyWith(currentLocation: move.initialLocation);
    board[Utility.convertLocationToBoardIndex(move.finalLocation)] = null;

    if (move.threatenedPieceColor != null) {
      int threatenedPieceIndex =
          Utility.convertLocationToBoardIndex(move.threatendPieceLocation!);

      board[threatenedPieceIndex] = GamePiece.allPieces
          .firstWhere((piece) =>
              piece.pieceColor == move.threatenedPieceColor &&
              piece.pieceType == move.threatenedPieceType)
          .copyWith(currentLocation: move.threatendPieceLocation);
    }

    // Execute scene refresh callback.
    if (sceneRefreshCallback != null) {
      sceneRefreshCallback!();
    }

    // Update current turn.
    _currentTurnColor = _currentTurnColor == PieceColor.white
        ? PieceColor.black
        : PieceColor.white;

    // Update legal moves.
    _updateLegalMoves();
  }

  void _initializeFromFen(String fen) {
    String configFen = fen.split(' ').first;

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
          _board.add(null);
        }
      }
      // Add piece condition.
      else {
        int index = _board.length;
        _board.add(GamePiece.allPieces
            .firstWhere((piece) => piece.fenChar == configFen[itr])
            .copyWith(
                currentLocation: Utility.convertBoardIndexToLocation(index)));
      }
    }
  }
}
