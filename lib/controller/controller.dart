// Imports
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

  late bool _isWhiteTurn;
  late PieceColor _currentTurnColor;
  late bool _isGameEnded;
  late final List<GameMove> _legalMoves;

  // Getter for private properties.
  List<GamePiece?> get board => _board;
  bool get isWhiteTurn => _isWhiteTurn;
  bool get isGameEnded => _isGameEnded;
  PieceColor get currentTurnColor => _currentTurnColor;
  List<GameMove> get legalMoves => _legalMoves;

  /// Returns legal moves for a given board location.
  List<GameMove> getLegalMovesForSelectedLocation(String loc) {
    return _legalMoves.where((move) => move.initialLocation == loc).toList();
  }

  /// Used to reset the current game session.
  void reset() {
    _isWhiteTurn = true;
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
    _legalMoves = legalMoves;
  }

  void playMove(GameMove move) {
    print('played');
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
