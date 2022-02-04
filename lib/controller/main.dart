import 'package:flutter_chess/controller/controller.dart';

void main() {
  ChessController chessController = ChessController();

  Utility.debugBoard(chessController.board);

  print(chessController.legalMoves);
}
