import 'utility.dart';

enum PieceType {
  king,
  queen,
  pawn,
  bishop,
  knight,
  rook,
}

enum PieceColor {
  white,
  black,
}

class GamePiece {
  const GamePiece({required this.pieceType, required this.pieceColor});

  factory GamePiece.fromFenChr(String fenChr) =>
      Utility.fenCharToGamePiece(fenChr);

  // Private properties.
  final PieceType pieceType;
  final PieceColor pieceColor;

  String get fenChar => Utility.gamePieceToFenChr(this);

  @override
  String toString() => fenChar;
}
