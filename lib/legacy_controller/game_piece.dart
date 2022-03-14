import 'package:flutter_chess/legacy_controller/enums.dart';

import 'utility.dart';

class GamePiece {
  const GamePiece({required this.pieceType, required this.pieceColor});

  // Private properties.
  final PieceType pieceType;
  final PieceColor pieceColor;

  String get fenChar => Utility.gamePieceToFenChar(this);
}
