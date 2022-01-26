import 'package:flutter_chess/controller_2/controller.dart';
import 'package:flutter_chess/controller_2/utility.dart';

void main() {
  ChessController chessController = ChessController();

  Utility.debugBoard(chessController.board);
}
