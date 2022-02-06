import 'package:flutter_chess/controller/controller.dart';
import 'package:flutter_test/flutter_test.dart';

int getMovesPermutationAtDepth(
    {required ChessController chessController, required int depth}) {
  int nMoves = 0;

  if (depth > 0) {
    for (GameMove move in chessController.legalMoves) {
      chessController.playMove(move);

      int newMoves = getMovesPermutationAtDepth(
          chessController: chessController, depth: depth - 1);
      nMoves += newMoves;

      chessController.undoMove();

      // if (depth == 3) {
      //   print("${move.initialLocation}${move.finalLocation}: $newMoves");
      // }
    }
  } else {
    nMoves = 1;
  }

  return nMoves;
}

void main() {
  group('Chess Controller', () {
    final ChessController chessController = ChessController();
    int nMoves;

    test('Controller Test at Depth 1', () {
      nMoves = getMovesPermutationAtDepth(
          chessController: chessController, depth: 1);
      expect(nMoves, 20);
    });

    test('Controller Test at Depth 2', () {
      nMoves = getMovesPermutationAtDepth(
          chessController: chessController, depth: 2);

      expect(nMoves, 400);
    });

    test('Controller Test at Depth 3', () {
      nMoves = getMovesPermutationAtDepth(
          chessController: chessController, depth: 3);

      expect(nMoves, 8902);
    });

    test('Controller Test at Depth 4', () {
      nMoves = getMovesPermutationAtDepth(
          chessController: chessController, depth: 4);

      expect(nMoves, 197756);
    });

    // test('Controller Test at Depth 5', () {
    //   nMoves = getMovesPermutationAtDepth(
    //       chessController: chessController, depth: 5);

    //   expect(nMoves, 4865609);
    // });
  });
}
