import 'package:flutter_chess/agents/base_agent.dart';
import 'package:flutter_chess/controller/controller.dart';

class RandomAgent extends BaseAgent {
  RandomAgent(
      {required ChessController controller,
      required PieceColor playingColor,
      this.delaySeconds = 1})
      : super(controller: controller, playingColor: playingColor);

  final int delaySeconds;

  @override
  Future<List<String>> sendMove() async {
    if ((playingColor == PieceColor.white && controller.isWhiteTurn) ||
        (playingColor == PieceColor.black && !controller.isWhiteTurn)) {
      await Future.delayed(Duration(seconds: delaySeconds));

      for (String pos in controller.allLegalPositions..shuffle()) {
        List<String> legalMoves = controller.getLegalMovesForSelectedPos(pos);

        if (legalMoves.isNotEmpty) {
          return [pos, (legalMoves..shuffle()).first];
        }
      }
    }
    return [];
  }
}
