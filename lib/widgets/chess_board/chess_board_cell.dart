import 'package:flutter/material.dart';
import 'package:flutter_chess/constants.dart';
import 'package:flutter_chess/controller/enums.dart';
import 'package:flutter_chess/controller/utility.dart';

enum ChessBoardCellMode {
  normal,
  selected,
  danger,
  path,
}

class ChessBoardCell extends StatelessWidget {
  const ChessBoardCell({
    Key? key,
    required this.index,
    this.pieceType,
    this.pieceColor,
    this.onTapCallback,
    this.cellMode = ChessBoardCellMode.normal,
    this.cellLabelTop = '',
    this.cellLabelBottom = '',
  }) : super(key: key);

  final int index;
  final PieceType? pieceType;
  final PieceColor? pieceColor;
  final void Function(ChessBoardCell cell)? onTapCallback;
  final ChessBoardCellMode cellMode;

  final String cellLabelTop;
  final String cellLabelBottom;

  String get cellLocation {
    return Utility.convertBoardIndexToLocation(index);
  }

  ChessBoardCell copyWith({
    int? index,
    PieceType? pieceType,
    PieceColor? pieceColor,
    void Function(ChessBoardCell cell)? onTapCallback,
    ChessBoardCellMode? cellMode,
    String? cellLabelTop,
    String? cellLabelBottom,
  }) =>
      ChessBoardCell(
        index: index ?? this.index,
        pieceType: pieceType,
        pieceColor: pieceColor,
        onTapCallback: onTapCallback ?? this.onTapCallback,
        cellMode: cellMode ?? this.cellMode,
        cellLabelTop: cellLabelTop ?? this.cellLabelTop,
        cellLabelBottom: cellLabelBottom ?? this.cellLabelBottom,
      );

  @override
  Widget build(BuildContext context) {
    Image? _cellImage;
    Color _cellOverlayColor;

    Color _cellColor = (index / 8).floor() % 2 != 0
        ? (index % 2 == 0
            ? Colors.black.withOpacity(kBlackOpacity)
            : Colors.white.withOpacity(kBlackOpacity))
        : (index % 2 == 0
            ? Colors.white.withOpacity(kBlackOpacity)
            : Colors.black.withOpacity(kBlackOpacity));

    Color _textColor = (index / 8).floor() % 2 != 0
        ? (index % 2 == 0
            ? Colors.white.withOpacity(kBlackOpacity)
            : Colors.black.withOpacity(kBlackOpacity))
        : (index % 2 == 0
            ? Colors.black.withOpacity(kBlackOpacity)
            : Colors.white.withOpacity(kBlackOpacity));

    switch (cellMode) {
      case ChessBoardCellMode.normal:
        _cellOverlayColor = Colors.transparent;
        break;
      case ChessBoardCellMode.path:
        _cellOverlayColor = Colors.orange.withOpacity(0.4);
        break;
      case ChessBoardCellMode.selected:
        _cellOverlayColor = Colors.green.withOpacity(0.6);
        break;
      case ChessBoardCellMode.danger:
        _cellOverlayColor = Colors.red.withOpacity(0.6);
        break;
    }
    switch (pieceType) {
      case PieceType.pawn:
        _cellImage = Image.asset(
            "assets/images/pawn/pawn-${pieceColor == PieceColor.white ? 'white' : 'black'}.png");
        break;
      case PieceType.king:
        _cellImage = Image.asset(
            "assets/images/king/king-${pieceColor == PieceColor.white ? 'white' : 'black'}.png");
        break;
      case PieceType.queen:
        _cellImage = Image.asset(
            "assets/images/queen/queen-${pieceColor == PieceColor.white ? 'white' : 'black'}.png");
        break;
      case PieceType.rook:
        _cellImage = Image.asset(
            "assets/images/rook/rook-${pieceColor == PieceColor.white ? 'white' : 'black'}.png");
        break;
      case PieceType.knight:
        _cellImage = Image.asset(
            "assets/images/knight/knight-${pieceColor == PieceColor.white ? 'white' : 'black'}.png");
        break;
      case PieceType.bishop:
        _cellImage = Image.asset(
            "assets/images/bishop/bishop-${pieceColor == PieceColor.white ? 'white' : 'black'}.png");
        break;
      default:
        break;
    }

    return GestureDetector(
      onTap: () {
        if (onTapCallback != null) {
          onTapCallback!(this);
        }
      },
      child: Container(
        color: _cellColor,
        child: Container(
          color: _cellOverlayColor,
          child: Stack(
            children: [
              Align(
                child: Padding(
                  padding: const EdgeInsets.only(left: 2.0),
                  child: Text(
                    cellLabelTop,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: _textColor),
                  ),
                ),
                alignment: Alignment.topLeft,
              ),
              Padding(
                child: _cellImage ?? Container(),
                padding: const EdgeInsets.all(4.0),
              ),
              Align(
                child: Padding(
                  padding: const EdgeInsets.only(right: 2.0),
                  child: Text(
                    cellLabelBottom,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: _textColor),
                  ),
                ),
                alignment: Alignment.bottomRight,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
