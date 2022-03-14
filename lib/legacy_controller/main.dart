import 'package:flutter_chess/legacy_controller/controller.dart';

void main() {
  ChessController controller = ChessController();
  Utility.debugBoard(controller.board
      .map((gamePiece) => Utility.gamePieceToFenChar(gamePiece))
      .toList());

  print(controller.legalMoves);
}
