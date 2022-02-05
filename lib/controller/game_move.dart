import 'package:flutter_chess/controller/enums.dart';
import 'package:flutter_chess/controller/game_piece.dart';
import 'package:flutter_chess/controller/utility.dart';

class GameMove {
  GameMove({
    required this.movedPieceColor,
    required this.movedPieceType,
    required this.initialLocation,
    required this.finalLocation,
    this.threatenedPieceColor,
    this.threatenedPieceType,
    this.threatendPieceLocation,
  });

  factory GameMove.fromGamePiece(
          {required GamePiece movedPiece,
          required String finalLocation,
          GamePiece? threatenedPiece}) =>
      GameMove(
          movedPieceColor: movedPiece.pieceColor,
          movedPieceType: movedPiece.pieceType,
          initialLocation: movedPiece.currentLocation,
          finalLocation: finalLocation,
          threatenedPieceColor: threatenedPiece?.pieceColor,
          threatenedPieceType: threatenedPiece?.pieceType,
          threatendPieceLocation: threatenedPiece?.currentLocation);

  factory GameMove.fromBoard(
      {required List<GamePiece?> board,
      required String initialLocation,
      required String finalLocation}) {
    GamePiece movedPiece =
        board[Utility.convertLocationToBoardIndex(initialLocation)]!;
    GamePiece? threatenedPiece =
        board[Utility.convertLocationToBoardIndex(finalLocation)];
    return GameMove(
        movedPieceColor: movedPiece.pieceColor,
        movedPieceType: movedPiece.pieceType,
        initialLocation: initialLocation,
        finalLocation: finalLocation,
        threatenedPieceColor: threatenedPiece?.pieceColor,
        threatenedPieceType: threatenedPiece?.pieceType,
        threatendPieceLocation: threatenedPiece?.currentLocation);
  }

  // Moved piece description.
  final PieceColor movedPieceColor;
  final PieceType movedPieceType;
  final String initialLocation;
  final String finalLocation;

  // Threatened piece description.
  final PieceColor? threatenedPieceColor;
  final PieceType? threatenedPieceType;
  final String? threatendPieceLocation;

  GameMove copyWith({
    PieceColor? movedPieceColor,
    PieceType? movedPieceType,
    String? initialLocation,
    String? finalLocation,
    PieceColor? threatenedPieceColor,
    PieceType? threatenedPieceType,
    String? threatendPieceLocation,
  }) =>
      GameMove(
        movedPieceColor: movedPieceColor ?? this.movedPieceColor,
        movedPieceType: movedPieceType ?? this.movedPieceType,
        initialLocation: initialLocation ?? this.initialLocation,
        finalLocation: finalLocation ?? this.finalLocation,
        threatenedPieceColor: threatenedPieceColor ?? this.threatenedPieceColor,
        threatenedPieceType: threatenedPieceType ?? this.threatenedPieceType,
        threatendPieceLocation:
            threatendPieceLocation ?? this.threatendPieceLocation,
      );

  @override
  String toString() =>
      {'from': initialLocation, 'to': finalLocation}.toString();
}
