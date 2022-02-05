import 'package:flutter_chess/controller/enums.dart';

class GameMove {
  GameMove(
      {required this.pieceColor,
      required this.pieceType,
      required this.initialLocation,
      required this.finalLocation,
      this.capturedPiece});
  final String initialLocation;
  final String finalLocation;
  final PieceColor pieceColor;
  final PieceType pieceType;
  final PieceType? capturedPiece;

  GameMove copyWith({
    PieceColor? pieceColor,
    PieceType? pieceType,
    String? initialLocation,
    String? finalLocation,
    PieceType? capturedPiece,
  }) =>
      GameMove(
          pieceColor: pieceColor ?? this.pieceColor,
          pieceType: pieceType ?? this.pieceType,
          initialLocation: initialLocation ?? this.initialLocation,
          finalLocation: finalLocation ?? this.finalLocation,
          capturedPiece: capturedPiece ?? this.capturedPiece);

  @override
  String toString() =>
      {'from': initialLocation, 'to': finalLocation}.toString();
}
