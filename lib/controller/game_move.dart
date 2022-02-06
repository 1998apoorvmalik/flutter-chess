import 'package:flutter_chess/controller/enums.dart';
import 'package:flutter_chess/controller/game_piece.dart';

class GameMove {
  GameMove({
    required this.movedPieceColor,
    required this.movedPieceType,
    required this.initialLocation,
    required this.finalLocation,
    this.capturedPieceColor,
    this.capturedPieceType,
    this.capturedPieceLocation,
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
          capturedPieceColor: threatenedPiece?.pieceColor,
          capturedPieceType: threatenedPiece?.pieceType,
          capturedPieceLocation: threatenedPiece?.currentLocation);

  // factory GameMove.fromBoard(
  //     {required List<GamePiece?> board,
  //     required String initialLocation,
  //     required String finalLocation}) {
  //   GamePiece movedPiece =
  //       board[Utility.convertLocationToBoardIndex(initialLocation)]!;
  //   GamePiece? threatenedPiece =
  //       board[Utility.convertLocationToBoardIndex(finalLocation)];
  //   return GameMove(
  //       movedPieceColor: movedPiece.pieceColor,
  //       movedPieceType: movedPiece.pieceType,
  //       initialLocation: initialLocation,
  //       finalLocation: finalLocation,
  //       capturedPieceColor: threatenedPiece?.pieceColor,
  //       capturedPieceType: threatenedPiece?.pieceType,
  //       capturedPieceLocation: threatenedPiece?.currentLocation);
  // }

  // Moved piece description.
  final PieceColor movedPieceColor;
  final PieceType movedPieceType;
  final String initialLocation;
  final String finalLocation;

  // Threatened piece description.
  final PieceColor? capturedPieceColor;
  final PieceType? capturedPieceType;
  final String? capturedPieceLocation;

  GameMove copyWith({
    PieceColor? movedPieceColor,
    PieceType? movedPieceType,
    String? initialLocation,
    String? finalLocation,
    PieceColor? capturedPieceColor,
    PieceType? capturedPieceType,
    String? capturedPieceLocation,
  }) =>
      GameMove(
        movedPieceColor: movedPieceColor ?? this.movedPieceColor,
        movedPieceType: movedPieceType ?? this.movedPieceType,
        initialLocation: initialLocation ?? this.initialLocation,
        finalLocation: finalLocation ?? this.finalLocation,
        capturedPieceColor: capturedPieceColor ?? this.capturedPieceColor,
        capturedPieceType: capturedPieceType ?? this.capturedPieceType,
        capturedPieceLocation:
            capturedPieceLocation ?? this.capturedPieceLocation,
      );

  @override
  String toString() =>
      {'from': initialLocation, 'to': finalLocation}.toString();
}
