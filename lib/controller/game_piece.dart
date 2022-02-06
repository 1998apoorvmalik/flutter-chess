import 'package:flutter_chess/controller/enums.dart';
import 'package:flutter_chess/controller/utility.dart';

class GamePiece {
  GamePiece({
    required PieceType pieceType,
    required PieceColor pieceColor,
    List<String>? locationsHistory,
  })  : _pieceType = pieceType,
        _pieceColor = pieceColor,
        _locationsHistory = locationsHistory ?? [];

  // Private properties.
  final PieceType _pieceType;
  final PieceColor _pieceColor;
  final List<String> _locationsHistory;

  // Getters for private fields.
  PieceType get pieceType => _pieceType;
  PieceColor get pieceColor => _pieceColor;
  String get fenChar =>
      Utility.gamePieceToFenChar(pieceType: pieceType, pieceColor: pieceColor);
  String get currentLocation =>
      _locationsHistory.isNotEmpty ? _locationsHistory.last : '';

  /// Moves the piece as defined by game move.
  void movePiece(String location) {
    _locationsHistory.add(location);
  }

  void removeLastLocation() => _locationsHistory.removeLast();

  // GamePiece copyWith({
  //   PieceType? pieceType,
  //   PieceColor? pieceColor,
  //   List<String>? locationsHistory,
  // }) =>
  //     GamePiece(
  //         pieceType: pieceType ?? this.pieceType,
  //         pieceColor: pieceColor ?? this.pieceColor,
  //         locationsHistory: locationsHistory ?? _locationsHistory);

  @override
  String toString() => {'fen': fenChar, 'loc': currentLocation}.toString();
}
