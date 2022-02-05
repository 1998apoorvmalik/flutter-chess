import 'package:flutter/material.dart';
import 'package:flutter_chess/controller/controller.dart';
import 'package:flutter_chess/widgets/chess_board/chess_board_cell.dart';

class ChessBoard extends StatefulWidget {
  const ChessBoard(
      {Key? key,
      required this.controller,
      this.opponentColor = PieceColor.black,
      this.size = 800})
      : super(key: key);

  final ChessController controller;
  final PieceColor? opponentColor;
  final double size;

  @override
  State<ChessBoard> createState() => _ChessBoardState();
}

class _ChessBoardState extends State<ChessBoard> {
  ChessBoardCell? _selectedCell;

  late List<ChessBoardCell> cells;

  void onCellTap(ChessBoardCell cell) {
    PieceColor? cellColor = widget.controller.board[cell.index]?.pieceColor;
    // If no cell is selected, select a cell.
    if (_selectedCell != null ||
        (cellColor != null && cellColor != widget.opponentColor)) {
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
      } else if (widget.controller.legalMoves
          .where((move) =>
              move.initialLocation == _selectedCell!.cellLocation &&
              move.finalLocation == cell.cellLocation)
          .isNotEmpty) {
        _playMove(widget.controller.legalMoves.firstWhere((move) =>
            move.initialLocation == _selectedCell!.cellLocation &&
            move.finalLocation == cell.cellLocation));
      } else {
        _selectedCell = null;
        _refreshBoard();
        onCellTap(cell);
      }
    }
  }

  // This method highlights the tapped cell.
  void _highlightSelectedCell() {
    cells[_selectedCell!.index] = _selectedCell!.copyWith(
        cellMode: ChessBoardCellMode.selected,
        pieceType: _selectedCell!.pieceType,
        pieceColor: _selectedCell!.pieceColor);
  }

  // This method will highlight valid next move cells for a selected piece.
  void _highlightValidMovesForSelectedCell() {
    // Check if the selected cell is not empty.
    if (_selectedCell!.pieceType != null &&
        widget.opponentColor != widget.controller.currentTurnColor) {
      widget.controller
          .getLegalMovesForSelectedLocation(_selectedCell!.cellLocation)
          .forEach((move) {
        int index =
            cells.indexWhere((cell) => cell.cellLocation == move.finalLocation);

        cells[index] = cells[index].copyWith(
            cellMode: cells[index].pieceColor != null &&
                    cells[index].pieceColor != _selectedCell!.pieceColor
                ? ChessBoardCellMode.danger
                : ChessBoardCellMode.path,
            pieceType: cells[index].pieceType);
      });
    }
  }

  void _playMove(GameMove move) {
    if (_selectedCell != null &&
        widget.opponentColor !=
            (widget.controller.isWhiteTurn
                ? PieceColor.white
                : PieceColor.black)) {
      // Controller update.
      widget.controller.playMove(move);
      setState(() {
        // Deselect the currently selected cell.
        _selectedCell = null;
      });
    }
  }

  // Updates the scene board configuration corresponding to the latest controller board.
  void _refreshBoard() {
    setState(() {
      cells = List.generate(64, (index) {
        return ChessBoardCell(
          index: index,
          onTapCallback: onCellTap,
          cellLabelBottom:
              index > 55 ? Utility.files[index - 56].toString() : '',
          cellLabelTop:
              index % 8 == 0 ? Utility.ranks[7 - (index ~/ 8)].toString() : '',
          pieceType: widget.controller.board[index]?.pieceType,
          pieceColor: widget.controller.board[index]?.pieceColor,
        );
      });
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
    return SizedBox(
      height: widget.size,
      width: widget.size,
      child: GridView.count(
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 8,
        children: cells.toList(),
      ),
    );
  }
}
