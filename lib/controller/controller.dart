// Imports
import 'package:flutter/material.dart';
import 'package:flutter_chess/controller/enums.dart';
import 'package:flutter_chess/controller/move.dart';
import 'package:flutter_chess/controller/utility.dart';
import 'package:flutter_chess/controller/game_piece.dart';

// Exports
export 'package:flutter_chess/controller/enums.dart';
export 'package:flutter_chess/controller/move.dart';
export 'package:flutter_chess/controller/utility.dart';
export 'package:flutter_chess/controller/game_piece.dart';

class ChessController {
  ChessController(
      {String fen =
          'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1'}) {
    _initializeFromFen(fen);
    reset();
  }

  final List<GamePiece?> _board = [];

  late PieceColor _currentTurnColor;
  late bool _isGameEnded;
  final List<GameMove> _legalMoves = [];

  late final VoidCallback? sceneRefreshCallback;

  // Getter for private properties.
  List<GamePiece?> get board => _board;
  bool get isWhiteTurn => _currentTurnColor == PieceColor.white ? true : false;
  bool get isBlackTurn => _currentTurnColor == PieceColor.black ? true : false;
  bool get isGameEnded => _isGameEnded;
  PieceColor get currentTurnColor => _currentTurnColor;
  List<GameMove> get legalMoves => _legalMoves;

  /// Returns legal moves for a given board location.
  List<GameMove> getLegalMovesForSelectedLocation(String loc) {
    return _legalMoves.where((move) => move.initialLocation == loc).toList();
  }

  /// Used to reset the current game session.
  void reset() {
    _isGameEnded = false;
    _currentTurnColor = PieceColor.white;
    _updateLegalMoves();
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
      // Moves the piece to final location.
      _board[Utility.convertLocationToBoardIndex(move.finalLocation)] =
          _board[Utility.convertLocationToBoardIndex(move.initialLocation)];

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

      // Update legal moves.
      _updateLegalMoves();
    }
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
        _board.add(Utility.allPieces
            .firstWhere((piece) => piece.fenChar == configFen[itr])
            .copyWith(
                currentLocation: Utility.convertBoardIndexToLocation(index)));
      }
    }
  }
}
