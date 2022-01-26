import 'package:flutter_chess/controller_2/movement.dart';
import 'package:flutter_chess/controller_2/utility.dart';
import 'package:flutter_chess/controller_2/enums.dart';

class GamePiece {
  GamePiece(
      {required PieceType pieceType,
      required PieceColor pieceColor,
      this.currentLocation = '',
      this.previousLocations = const []})
      : _pieceType = pieceType,
        _pieceColor = pieceColor,
        fenChar = Utility.convertPieceToFenChar(
            pieceType: pieceType, pieceColor: pieceColor),
        _movement = Utility.getMovementforPieceType(pieceType);

  final PieceType _pieceType;
  final PieceColor _pieceColor;
  final Movement _movement;

  String currentLocation;
  final List<String> previousLocations;

  final String fenChar;

  // Getters for private fields.
  PieceType get pieceType => _pieceType;
  PieceColor get pieceColor => _pieceColor;
  Movement get movement => _movement;

  @override
  String toString() => fenChar;
}
