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
    if (playingColor == controller.currentTurnColor) {
      await Future.delayed(Duration(seconds: delaySeconds));
      return (controller.getAllPseudoLegalMovesforCurrentPlayer..shuffle())
          .first;
    }
    return [];
  }
}
