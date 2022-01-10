import 'package:flutter/material.dart';
import 'package:flutter_chess/constants.dart';
import 'package:flutter_chess/controller/controller.dart';

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
    this.onTapCallback,
    this.cellMode = ChessBoardCellMode.normal,
  }) : super(key: key);

  final int index;
  final PieceType? pieceType;
  final void Function(ChessBoardCell cell)? onTapCallback;
  final ChessBoardCellMode cellMode;

  PieceColor? get pieceColor => pieceType != null
      ? BaseChessController.getPieceTypeColor(pieceType!)
      : null;

  String get cellLocation {
    return '${BaseChessController.files[(index % 8)]}${(8 - (index / 8).floor()).toString()}';
  }

  ChessBoardCell copyWith({
    int? index,
    PieceType? pieceType,
    void Function(ChessBoardCell cell)? onTapCallback,
    ChessBoardCellMode? cellMode,
  }) =>
      ChessBoardCell(
        index: index ?? this.index,
        pieceType: pieceType,
        onTapCallback: onTapCallback ?? this.onTapCallback,
        cellMode: cellMode ?? this.cellMode,
      );

  @override
  Widget build(BuildContext context) {
    Image? _cellImage;
    Color _cellOverlayColor;

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
      case PieceType.blackPawn:
        _cellImage = Image.asset('assets/images/pawn/pawn-black.png');
        break;
      case PieceType.whitePawn:
        _cellImage = Image.asset('assets/images/pawn/pawn-white.png');
        break;
      case PieceType.blackKing:
        _cellImage = Image.asset('assets/images/king/king-black.png');
        break;
      case PieceType.whiteKing:
        _cellImage = Image.asset('assets/images/king/king-white.png');
        break;
      case PieceType.blackQueen:
        _cellImage = Image.asset('assets/images/queen/queen-black.png');
        break;
      case PieceType.whiteQueen:
        _cellImage = Image.asset('assets/images/queen/queen-white.png');
        break;
      case PieceType.blackRook:
        _cellImage = Image.asset('assets/images/rook/rook-black.png');
        break;
      case PieceType.whiteRook:
        _cellImage = Image.asset('assets/images/rook/rook-white.png');
        break;
      case PieceType.blackKnight:
        _cellImage = Image.asset('assets/images/knight/knight-black.png');
        break;
      case PieceType.whiteKnight:
        _cellImage = Image.asset('assets/images/knight/knight-white.png');
        break;
      case PieceType.blackBishop:
        _cellImage = Image.asset('assets/images/bishop/bishop-black.png');
        break;
      case PieceType.whiteBishop:
        _cellImage = Image.asset('assets/images/bishop/bishop-white.png');
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
        color: (index / 8).floor() % 2 != 0
            ? (index % 2 == 0
                ? Colors.black.withOpacity(kBlackOpacity)
                : Colors.white.withOpacity(kBlackOpacity))
            : (index % 2 == 0
                ? Colors.white.withOpacity(kBlackOpacity)
                : Colors.black.withOpacity(kBlackOpacity)),
        child: Container(
          color: _cellOverlayColor,
          child: Hero(
            tag: index,
            child: _cellImage ?? Container(),
          ),
        ),
      ),
    );
  }
}
