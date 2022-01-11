import 'package:flutter_chess/controller/controller.dart';

abstract class BaseAgent {
  BaseAgent({required this.controller, required this.playingColor});

  final PieceColor playingColor;

  final ChessController controller;

  Future<List<String>> sendMove();
}
