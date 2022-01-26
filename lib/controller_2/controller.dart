import 'package:flutter_chess/controller_2/utility.dart';
import 'package:flutter_chess/controller_2/game_piece.dart';

class ChessController {
  ChessController(
      {String fen =
          'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1'}) {
    _initializeFromFen(fen);
  }

  final List<GamePiece?> _board = [];

  // Getter for private properties.
  List<GamePiece?> get board => _board;

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
