import 'utility.dart';

class GameMove {
  const GameMove(
      {required this.startIndex,
      required this.endIndex,
      this.capturedPiece = '+',
      int? capturedIndex})
      : capturedIndex = capturedIndex ?? endIndex;

  final int startIndex;
  final int endIndex;

  final String capturedPiece;
  final int capturedIndex;

  // Getters
  // String get initialLocation => Utility.convertBoardIndexToLocation(startIndex);
  // String get finalLocation => Utility.convertBoardIndexToLocation(endIndex);

  @override
  String toString() {
    return '${Utility.convertBoardIndexToLocation(startIndex)}${Utility.convertBoardIndexToLocation(endIndex)}';
  }
}
