import 'package:flutter_chess/controller_2/controller.dart';
import 'package:flutter_chess/controller_2/utility.dart';

import 'enums.dart';

void main() {
  ChessController chessController = ChessController();

  Utility.debugBoard(chessController.board);

  chessController.board
      .where((piece) => piece?.pieceType == PieceType.knight)
      .forEach((element) {
    print(element?.getMovementLocations(chessController.board));
  });
}
