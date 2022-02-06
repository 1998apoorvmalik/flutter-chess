// Imports
import 'package:flutter/scheduler.dart';
import 'package:flutter_chess/controller/enums.dart';
import 'package:flutter_chess/controller/game_move.dart';
import 'package:flutter_chess/controller/utility.dart';
import 'package:flutter_chess/controller/game_piece.dart';

import 'movement.dart';

// Exports
export 'package:flutter_chess/controller/enums.dart';
export 'package:flutter_chess/controller/game_move.dart';
export 'package:flutter_chess/controller/utility.dart';
export 'package:flutter_chess/controller/game_piece.dart';

class ChessController {
  ChessController({String fen = Utility.defaultFEN}) {
    _initializeFromFen(fen);
    reset();
  }

  final List<GamePiece?> _board = [];

  late PieceColor _currentTurnColor;
  late bool _isGameEnded;
  final List<GamePiece> _capturedPieces = [];
  final List<List<GameMove>> _legalMovesHistory = [];
  final List<GameMove> _moveHistory = [];

  VoidCallback? sceneRefreshCallback;

  // Getter for private properties.
  List<GamePiece?> get board => _board;
  bool get isWhiteTurn => _currentTurnColor == PieceColor.white ? true : false;
  bool get isBlackTurn => _currentTurnColor == PieceColor.black ? true : false;
  bool get isGameEnded => _isGameEnded;
  PieceColor get currentTurnColor => _currentTurnColor;
  List<GamePiece> get capturedPieces => _capturedPieces;
  List<GameMove> get legalMoves => _legalMovesHistory.last;
  List<GameMove> get moveHistory => _moveHistory;

  /// Returns legal moves for a given board location.
  List<GameMove> getLegalMovesForSelectedLocation(String loc) {
    return legalMoves.where((move) => move.initialLocation == loc).toList();
  }

  /// Used to reset the current game session.
  void reset() {
    _isGameEnded = false;
    _currentTurnColor = PieceColor.white;
    _capturedPieces.clear();
    _legalMovesHistory.clear();
    _moveHistory.clear();
    _updateLegalMoves();
  }

  /// Debug method to print the current state of the board
  void printBoard() {
    Utility.debugBoard(_board);
  }

  /// Returns raw moves for a given game piece.
  List<GameMove> _getRawMovesForGamePiece(GamePiece piece) {
    List<int> validBoardIndices = [];
    int boardIndex = Utility.convertLocationToBoardIndex(piece.currentLocation);

    Movement movement =
        Movement.getMovementforPieceType(piece.pieceType, piece.pieceColor);

    for (int i = 0; i < movement.directionalOffsets.length; i++) {
      for (int j = 1; j <= movement.maxStep; j++) {
        int nextBoardIndex = boardIndex + movement.directionalOffsets[i] * j;
        if (Utility.isValidMoveIndex(boardIndex, movement.directionalOffsets[i],
                multiplier: j) &&
            _board[nextBoardIndex]?.pieceColor != piece.pieceColor) {
          validBoardIndices.add(nextBoardIndex);

          if (_board[nextBoardIndex]?.pieceType != null) {
            if (piece.pieceType == PieceType.pawn) {
              validBoardIndices.removeLast();
            }
            break;
          }
        } else {
          break;
        }
      }
    }

    return validBoardIndices
        .map((index) => GameMove(
              movedPieceColor: piece.pieceColor,
              movedPieceType: piece.pieceType,
              initialLocation: piece.currentLocation,
              finalLocation: Utility.convertBoardIndexToLocation(index),
              capturedPieceLocation: _board[index]?.currentLocation,
              capturedPieceColor: _board[index]?.pieceColor,
              capturedPieceType: _board[index]?.pieceType,
            ))
        .toList()
      ..addAll(getSpecificMovesforGamePiece(piece));
  }

  /// Updates legal moves for the current player.
  void _updateLegalMoves() {
    List<GameMove> legalMoves = [];
    for (GamePiece? piece in _board) {
      if (piece != null && piece.pieceColor == _currentTurnColor) {
        legalMoves.addAll(_getRawMovesForGamePiece(piece));
      }
    }

    _legalMovesHistory.add(legalMoves);
  }

  /// Plays the legal game move.
  void playMove(GameMove move) {
    if (legalMoves.contains(move)) {
      // Get the board's initial and final indices from the given move.
      int initialIndex =
          Utility.convertLocationToBoardIndex(move.initialLocation);
      int finalIndex = Utility.convertLocationToBoardIndex(move.finalLocation);

      // Add opponent piece to captured pieces list if it is there.
      if (move.capturedPieceColor != null) {
        _capturedPieces.add(_board[
            Utility.convertLocationToBoardIndex(move.capturedPieceLocation!)]!);
      }

      // Move the current piece to the final location.
      _board[finalIndex] = _board[initialIndex]!..movePiece(move.finalLocation);

      // Set the game piece at initial location to null.
      _board[Utility.convertLocationToBoardIndex(move.initialLocation)] = null;

      // Execute scene refresh callback.
      if (sceneRefreshCallback != null) {
        sceneRefreshCallback!();
      }

      // Update current turn.
      _currentTurnColor = _currentTurnColor == PieceColor.white
          ? PieceColor.black
          : PieceColor.white;

      // Add the move to move history.
      _moveHistory.add(move);

      // Update legal moves.
      _updateLegalMoves();
    }
  }

  /// Undo the last played legal move.
  void undoMove() {
    if (moveHistory.isEmpty) {
      return;
    }

    GameMove move = _moveHistory.removeLast();
    int initialIndex =
        Utility.convertLocationToBoardIndex(move.initialLocation);
    int finalIndex = Utility.convertLocationToBoardIndex(move.finalLocation);

    _board[initialIndex] = _board[finalIndex]
      ?..removeLastLocation()
      ..movePiece(move.initialLocation);

    _board[finalIndex] = null;

    if (move.capturedPieceColor != null) {
      int threatenedPieceIndex =
          Utility.convertLocationToBoardIndex(move.capturedPieceLocation!);

      _board[threatenedPieceIndex] = _capturedPieces.removeLast();
    }

    // Execute scene refresh callback.
    if (sceneRefreshCallback != null) {
      sceneRefreshCallback!();
    }

    // Update current turn.
    _currentTurnColor = _currentTurnColor == PieceColor.white
        ? PieceColor.black
        : PieceColor.white;

    // Update legal moves.
    _legalMovesHistory.removeLast();
  }

  void _initializeFromFen(String fen) {
    String configFen = fen.split(' ').first;

    int itr = -1;

    while (++itr < configFen.length) {
      // Next rank condition.
      if (configFen[itr] == '/') {
        continue;
      }

      // Blank space condition.
      else if (int.tryParse(configFen[itr]) != null) {
        int blankSpaces = int.parse(configFen[itr]);

        // Add specified blank spaces.
        while (blankSpaces-- > 0) {
          _board.add(null);
        }
      }
      // Add piece condition.
      else {
        _board.add(Utility.fenCharToGamePiece(configFen[itr])
          ..movePiece(Utility.convertBoardIndexToLocation(_board.length)));
      }
    }
  }
}

extension GamePieceSpecificMoves on ChessController {
  List<GameMove> getSpecificMovesforGamePiece(GamePiece piece) {
    List<GameMove> specialMoves = [];

    int boardIndex = Utility.convertLocationToBoardIndex(piece.currentLocation);
    GameMove gameMove =
        GameMove.fromGamePiece(movedPiece: piece, finalLocation: '');

    if (piece.pieceType == PieceType.pawn) {
      // Pawn two step move check.
      int offset =
          Movement.getMovementforPieceType(piece.pieceType, piece.pieceColor)
              .directionalOffsets
              .first;

      if ((piece.currentLocation[1] == '2' ||
              piece.currentLocation[1] == '7') &&
          _board[boardIndex + offset] == null &&
          _board[boardIndex + offset * 2] == null) {
        specialMoves.add(gameMove.copyWith(
            finalLocation:
                Utility.convertBoardIndexToLocation(boardIndex + offset * 2)));
      }

      // Pawn attack check.
      int rightDiagonalOffset = Movement.allDirectionalOffsets[2] *
          (piece.pieceColor == PieceColor.white ? -1 : 1);
      int leftDiagonalOffset = Movement.allDirectionalOffsets[3] *
          (piece.pieceColor == PieceColor.white ? -1 : 1);
      int leftOffset = piece.pieceColor == PieceColor.white
          ? -Movement.allDirectionalOffsets[0]
          : Movement.allDirectionalOffsets[0];
      int rightOffset = piece.pieceColor == PieceColor.white
          ? Movement.allDirectionalOffsets[0]
          : -Movement.allDirectionalOffsets[0];

      bool pawnAttackPossible({required bool rightDirectionTest}) {
        int diagonalOffset =
            rightDirectionTest ? rightDiagonalOffset : leftDiagonalOffset;
        int horizontalOffset = rightDirectionTest ? rightOffset : leftOffset;

        return (Utility.isValidMoveIndex(boardIndex, diagonalOffset) &&
            _board[boardIndex + diagonalOffset]?.pieceColor !=
                piece.pieceColor &&
            (_board[boardIndex + diagonalOffset]?.pieceColor != null ||
                ((piece.currentLocation[1] == '4' ||
                        piece.currentLocation[1] == '5') &&
                    _board[boardIndex + horizontalOffset]?.pieceColor !=
                        piece.pieceColor &&
                    _board[boardIndex + horizontalOffset]?.pieceType ==
                        PieceType.pawn)));
      }

      // Left diagonal attack test.
      if (pawnAttackPossible(rightDirectionTest: false)) {
        int finalIndex = boardIndex + leftDiagonalOffset;
        GamePiece capturedPiece = _board[finalIndex] == null
            ? _board[boardIndex + leftOffset]!
            : _board[finalIndex]!;

        specialMoves.add(GameMove.fromGamePiece(
            movedPiece: piece,
            finalLocation: Utility.convertBoardIndexToLocation(finalIndex),
            threatenedPiece: capturedPiece));
      }

      // Right diagonal attack test.
      if (pawnAttackPossible(rightDirectionTest: true)) {
        int finalIndex = boardIndex + rightDiagonalOffset;
        GamePiece capturedPiece = _board[finalIndex] == null
            ? _board[boardIndex + rightOffset]!
            : _board[finalIndex]!;

        specialMoves.add(GameMove.fromGamePiece(
            movedPiece: piece,
            finalLocation: Utility.convertBoardIndexToLocation(finalIndex),
            threatenedPiece: capturedPiece));
      }
    }
    return specialMoves;
  }
}
