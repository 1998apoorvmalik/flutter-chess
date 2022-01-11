import 'package:flutter/material.dart';
import 'package:flutter_chess/constants.dart';
import 'package:flutter_chess/controller/controller.dart';
import 'package:flutter_chess/widgets/chess_board/chess_board_cell.dart';

class ChessBoard extends StatefulWidget {
  const ChessBoard(
      {Key? key,
      required this.controller,
      this.agentPlayingColor = PieceColor.black,
      this.size = 800})
      : super(key: key);

  final ChessController controller;
  final PieceColor? agentPlayingColor;
  final double size;

  @override
  State<ChessBoard> createState() => _ChessBoardState();
}

class _ChessBoardState extends State<ChessBoard> {
  ChessBoardCell? _selectedCell;

  late List<ChessBoardCell> cells;

  void onCellTap(ChessBoardCell cell) {
    // If no cell is selected, select a cell.
    if (_selectedCell == null) {
      setState(() {
        _selectedCell = cell;
        _highlightSelectedCell();
        _highlightValidMovesForSelectedCell();
      });
    } else if (_selectedCell!.index == cell.index) {
      _refreshBoard();
      setState(() {
        _selectedCell = null;
      });
    } else if (widget.controller
        .getLegalMovesForSelectedPos(_selectedCell!.cellLocation)
        .contains(cell.cellLocation)) {
      _movePiece(cell);
    } else {
      _selectedCell = null;
      _refreshBoard();
      onCellTap(cell);
    }
  }

  // This method highlights the tapped cell.
  void _highlightSelectedCell() {
    if (_selectedCell != null) {
      cells[_selectedCell!.index] = _selectedCell!.copyWith(
          cellMode: ChessBoardCellMode.selected,
          pieceType: _selectedCell!.pieceType);
    }
  }

  // This method will highlight valid next move cells for a selected piece.
  void _highlightValidMovesForSelectedCell() {
    // Check if the selected cell is not empty.
    if (_selectedCell != null &&
        _selectedCell!.pieceType != null &&
        widget.agentPlayingColor !=
            (widget.controller.isWhiteTurn
                ? PieceColor.white
                : PieceColor.black)) {
      widget.controller
          .getLegalMovesForSelectedPos(_selectedCell!.cellLocation)
          .forEach((pos) {
        int index = cells.indexWhere((cell) => cell.cellLocation == pos);

        cells[index] = cells[index].copyWith(
            cellMode: cells[index].pieceColor != null &&
                    cells[index].pieceColor != _selectedCell!.pieceColor
                ? ChessBoardCellMode.danger
                : ChessBoardCellMode.path,
            pieceType: cells[index].pieceType);
      });
    }
  }

  void _movePiece(ChessBoardCell nextCell) {
    if (_selectedCell != null &&
        widget.agentPlayingColor !=
            (widget.controller.isWhiteTurn
                ? PieceColor.white
                : PieceColor.black)) {
      // Controller update.
      widget.controller.makeMove(
        fromPos: _selectedCell!.cellLocation,
        toPos: nextCell.cellLocation,
      );
      setState(() {
        // Deselect the currently selected cell.
        _selectedCell = null;
      });
    }
  }

  // Updates the scene board configuration corresponding to the latest controller board.
  void _refreshBoard() {
    setState(() {
      cells = List.generate(
        64,
        (index) => ChessBoardCell(
          index: index,
          onTapCallback: onCellTap,
          pieceType: widget.controller.board[7 - (index / 8).floor()]
              [(index % 8)],
        ),
      );
    });
  }

  @override
  void initState() {
    _refreshBoard();
    widget.controller.sceneRefreshCallback = () {
      _refreshBoard();
    };
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double _sizeQuantizer = (widget.size / 100);

    return SizedBox(
      height: widget.size,
      width: widget.size,
      child: Column(
        children: [
          Expanded(
            flex: 8,
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: List.generate(
                      8,
                      (index) => Text(
                        (8 - index).toString(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: _sizeQuantizer * 4,
                            color: _selectedCell != null &&
                                    (_selectedCell!.index / 8).floor() == index
                                ? Colors.black.withOpacity(kBlackOpacity)
                                : kIconColor),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 16,
                  child: GridView.count(
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 8,
                    children: cells.toList(),
                  ),
                ),
                Expanded(flex: 1, child: Container()),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(
                10,
                (index) => index < 1 || index > 8
                    ? Text(
                        '1',
                        style: TextStyle(
                            color: Colors.transparent,
                            fontSize: _sizeQuantizer * 4),
                      )
                    : Text(
                        BaseChessController.files[index - 1],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: _sizeQuantizer * 4,
                            color: _selectedCell != null &&
                                    (_selectedCell!.index % 8) + 1 == index
                                ? Colors.black.withOpacity(kBlackOpacity)
                                : kIconColor),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
