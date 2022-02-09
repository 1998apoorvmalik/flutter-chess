// Imports
import 'enums.dart';
import 'game_piece.dart';
import 'movement.dart';
import 'utility.dart';
import 'game_move.dart';

// Exports
export 'game_piece.dart';
export 'game_move.dart';
export 'utility.dart';
export 'enums.dart';

class ChessController {
  ChessController({String fen = Utility.defaultFEN})
      : _board = Utility.initBoardFromFen(fen) {
    _updateLegalMoves();
  }

  List<String> _board;
  bool _isWhiteTurn = false;
  bool _isGameEnded = false;

  final List<GameMove> _moveHistory = [];
  final List<List<GameMove>> _legalMovesHistory = [];

  // Callbacks
  void Function()? sceneRefreshCallback;

  // Getter for private properties.
  List<GamePiece> get board => _board
      .map((String fenChr) => Utility.fenCharToGamePiece(fenChr))
      .toList();
  bool get isWhiteTurn => _isWhiteTurn;
  bool get isGameEnded => _isGameEnded;
  List<GameMove> get legalMoves =>
      _legalMovesHistory.isNotEmpty ? _legalMovesHistory.last : [];
  List<GameMove> get moveHistory => _moveHistory;
  PieceColor get currentTurnColor =>
      _isWhiteTurn ? PieceColor.white : PieceColor.black;

  /// Return legal moves for selected board index.
  List<GameMove> legalMovesForSelectedIndex(int index) =>
      legalMoves.where((move) => move.startIndex == index).toList();

  /// Get piece color at a given board index.
  PieceColor? pieceColorAtBoardIndex(int index) => _board[index] != '+'
      ? Utility.fenCharToGamePiece(_board[index]).pieceColor
      : null;

  /// Get piece type at a given board index.
  PieceType? pieceTypeAtBoardIndex(int index) => _board[index] != '+'
      ? Utility.fenCharToGamePiece(_board[index]).pieceType
      : null;

  bool isWhiteAtIndex(int index) =>
      _board[index] != '+' && _board[index] == _board[index].toUpperCase();
  bool isBlackAtIndex(int index) =>
      _board[index] != '+' && _board[index] == _board[index].toLowerCase();

  /// Check if two board indices represent same color pieces.
  bool _indicesSameColorCheck(int i, int j) =>
      (isWhiteAtIndex(i) && isWhiteAtIndex(j)) ||
      (isBlackAtIndex(i) && isBlackAtIndex(j));

  /// Returns raw-pseudo (may contain illegal moves) for a piece at given board index.
  List<GameMove> _getPseudoMovesForBoardIndex(int index) {
    List<GameMove> moves = [];

    if (_board[index] == '+') {
      return moves;
    }

    Movement movement = Utility.getPieceMovement(_board[index]);
    for (int i = 0; i < movement.directionalOffsets.length; i++) {
      for (int j = 1; j <= movement.maxStep; j++) {
        int nextIndex = index + movement.directionalOffsets[i] * j;
        if (Utility.isValidMoveIndex(index, movement.directionalOffsets[i],
                multiplier: j) &&
            !_indicesSameColorCheck(index, nextIndex)) {
          moves.add(GameMove(
              startIndex: index,
              endIndex: nextIndex,
              capturedPiece: _board[nextIndex]));

          if (_board[nextIndex] != '+') {
            if (_board[index].toUpperCase() == 'P') {
              moves.removeLast();
            }

            break;
          }
        } else {
          break;
        }
      }
    }

    moves.addAll(specificMovesForBoardIndex(index));

    return moves;
  }

  void _updateLegalMoves() {
    List<GameMove> legalMoves = [];
    for (int i = 0; i < _board.length; i++) {
      if (isWhiteTurn ? isBlackAtIndex(i) : isWhiteAtIndex(i)) {
        legalMoves.addAll(_getPseudoMovesForBoardIndex(i));
      }
    }
    _legalMovesHistory.add(legalMoves);
  }

  void playMove(GameMove move) {
    if (!legalMoves.contains(move)) {
      return;
    }
    // Set capture index to empty square.
    _board[move.capturedIndex] = '+';
    // Move the piece to the final index.
    _board[move.endIndex] = _board[move.startIndex];
    // Set initial index to empty square.
    _board[move.startIndex] = '+';
    // Execute scene refresh callback.
    if (sceneRefreshCallback != null) {
      sceneRefreshCallback!();
    }
    // Update turn.
    _isWhiteTurn = !_isWhiteTurn;
    // Add the move to move history.
    _moveHistory.add(move);
    // Update legal moves.
    _updateLegalMoves();
  }

  /// Undo the last played legal move.
  void undoMove() {
    if (moveHistory.isEmpty) {
      return;
    }

    GameMove move = _moveHistory.removeLast();
    // Move the piece to the initial index.
    _board[move.startIndex] = _board[move.endIndex];
    // Set the final index to empty square.
    _board[move.endIndex] = '+';
    // Move the captured piece to its corresponding index.
    _board[move.capturedIndex] = move.capturedPiece;
    // Execute scene refresh callback.
    if (sceneRefreshCallback != null) {
      sceneRefreshCallback!();
    }
    // Execute scene refresh callback.
    if (sceneRefreshCallback != null) {
      sceneRefreshCallback!();
    }
    // Update current turn.
    _isWhiteTurn = !_isWhiteTurn;
    // Update legal moves.
    _legalMovesHistory.removeLast();
  }
}

extension on ChessController {
  List<GameMove> specificMovesForBoardIndex(int index) {
    List<GameMove> specificMoves = [];

    // Pawn specific moves.
    if (_board[index].toUpperCase() == 'P') {
      Movement movement = Utility.getPieceMovement(_board[index]);
      String location = Utility.convertBoardIndexToLocation(index);
      int offset = movement.directionalOffsets.first;

      // Pawn double move.
      if ((location[1] == '2' || location[1] == '7') &&
          _board[index + offset] == '+' &&
          _board[index + offset * 2] == '+') {
        specificMoves
            .add(GameMove(startIndex: index, endIndex: index + offset * 2));
      }

      int _multiplier = isWhiteAtIndex(index) ? -1 : 1;
      int leftDiagonalOffset = Movement.allDirectionalOffsets[3] * _multiplier;
      int rightDiagonalOffset = Movement.allDirectionalOffsets[2] * _multiplier;
      int leftOffset = Movement.allDirectionalOffsets[0] * _multiplier;
      int rightOffset = -leftOffset;

      bool canPawnAttack({bool rightDirectionTest = false}) {
        int diagonalOffset =
            rightDirectionTest ? rightDiagonalOffset : leftDiagonalOffset;
        int horizontalOffset = rightDirectionTest ? rightOffset : leftOffset;

        return (Utility.isValidMoveIndex(index, diagonalOffset) &&
            !_indicesSameColorCheck(index, index + diagonalOffset) &&
            (_board[index + diagonalOffset] != '+' ||
                ((location[1] == '4' || location[1] == '5') &&
                    !_indicesSameColorCheck(index, index + horizontalOffset) &&
                    (_board[index + horizontalOffset]).toUpperCase() == 'P')));
      }

      if (canPawnAttack(rightDirectionTest: false)) {
        int endIndex = index + leftDiagonalOffset;
        int capturedIndex =
            _board[endIndex] == '+' ? index + leftOffset : endIndex;
        specificMoves.add(GameMove(
            startIndex: index,
            endIndex: endIndex,
            capturedPiece: _board[capturedIndex],
            capturedIndex: capturedIndex));
      }

      if (canPawnAttack(rightDirectionTest: true)) {
        int endIndex = index + rightDiagonalOffset;
        int capturedIndex =
            _board[endIndex] == '+' ? index + rightOffset : endIndex;
        specificMoves.add(GameMove(
            startIndex: index,
            endIndex: endIndex,
            capturedPiece: _board[capturedIndex],
            capturedIndex: capturedIndex));
      }
    }

    return specificMoves;
  }
}
