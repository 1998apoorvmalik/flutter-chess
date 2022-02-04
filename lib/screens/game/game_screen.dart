import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_chess/agents/agents.dart';
import 'package:flutter_chess/config/custom_route.dart';
import 'package:flutter_chess/constants.dart';
import 'package:flutter_chess/controller/controller.dart';
import 'package:flutter_chess/widgets/widgets.dart';
import 'package:url_launcher/url_launcher.dart';

class GameScreen extends StatefulWidget {
  const GameScreen(
      {Key? key,
      int undoAttempts = -1,
      this.player1Name = 'Player 1',
      this.player2Name = 'Player 2',
      this.isSinglePlayer = true,
      this.moveClockEnabled = false,
      this.time = 5})
      : whiteUndoAttemptsRemaining = undoAttempts,
        blackUndoAttemptsRemaining = undoAttempts,
        super(key: key);

  static const String routeName = '/game';

  static Route route({required Map<String, dynamic> options}) {
    return CustomRoute(
      fullscreenDialog: true,
      settings: const RouteSettings(name: routeName),
      builder: (_) => GameScreen(
        player1Name: options['player1Name'],
        player2Name: options['player2Name'],
        isSinglePlayer: options['isSinglePlayer'],
        moveClockEnabled: options['moveClockEnabled'],
        undoAttempts: options['undoAttempts'],
        time: options['time'],
      ),
    );
  }

  final String player1Name;
  final String player2Name;
  final bool isSinglePlayer;
  final bool moveClockEnabled;

  final int whiteUndoAttemptsRemaining;
  final int blackUndoAttemptsRemaining;
  final int time;

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  // Chess controller.
  late final ChessController chessController;

  // Create agent if game is single player.
  late final BaseAgent? agent;

  // Player times.
  int whiteTime = 0;
  int blackTime = 0;

  void _timer() {
    Future.delayed(const Duration(seconds: 1)).then((_) {
      if (!chessController.isGameEnded) {
        setState(() {
          if (chessController.isWhiteTurn) {
            whiteTime += 1;
          } else {
            blackTime += 1;
          }
        });
        _timer();
      }
    });
  }

  @override
  void initState() {
    // Initialize Chess Controller.
    chessController = ChessController();
    // checkCallback: (PieceColor color) =>
    //     _showCheckDialog(pieceColor: color),
    // checkMateCallback: (PieceColor color) =>
    //     _showCheckDialog(pieceColor: color, checkmate: true),
    // computerColor: widget.isSinglePlayer ? PieceColor.black : null,
    // moveDoneCallback: () async {
    //   if (agent != null) {
    //     final List<String> move = await agent!.sendMove();

    //     if (move.isNotEmpty) {
    //       final String fromPos = move.first;
    //       final String toPos = move.last;

    //       // Agent makes the move.
    //       if (chessController.currentTurnColor == PieceColor.black) {
    //         chessController.makeMove(fromPos: fromPos, toPos: toPos);
    //       }
    //     }
    //   }
    // });

    // Initialize Agent.
    agent = widget.isSinglePlayer
        ? RandomAgent(
            controller: chessController, playingColor: PieceColor.black)
        : null;
    _timer();

    super.initState();
  }

  @override
  void dispose() {
    // chessController.dispose();
    super.dispose();
  }

  void _showCheckDialog(
      {required PieceColor pieceColor, bool checkmate = false}) {
    showDialog(
        context: context,
        builder: (context) {
          Future.delayed(Duration(seconds: checkmate ? 5 : 1), () {
            Navigator.of(context).pop(true);
          });
          return AlertDialog(
            backgroundColor: Colors.redAccent,
            title: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (!checkmate)
                      Image.asset(
                        "assets/images/king/king-${pieceColor == PieceColor.white ? 'white' : 'black'}.png",
                        width: 30,
                      ),
                    const SizedBox(
                      width: 8.0,
                    ),
                    Text(checkmate ? 'CHECK MATE!' : 'CHECK',
                        style: Theme.of(context).textTheme.headline5),
                  ],
                ),
                if (checkmate)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      '${pieceColor == PieceColor.white ? PieceColor.black.toString().split('.').last : PieceColor.white.toString().split('.').last} Winner'
                          .toUpperCase(),
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ),
              ],
            ),
          );
        });
  }

  void gameDrawCallback() {}
  @override
  Widget build(BuildContext context) {
    // Device screen information.
    late final double _deviceWidth = MediaQuery.of(context).size.width;
    late final double _deviceHeight = MediaQuery.of(context).size.height;
    late final double _aspectRatio = _deviceWidth / _deviceHeight;

    // Board size.
    late final double _boardSize =
        _aspectRatio < 0.64 ? _deviceWidth / 1.08 : (6 * _deviceHeight / 11);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: AdaptiveHorizontalPadding(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (_) {
                              return Dialog(
                                backgroundColor: kPrimaryColor,
                                elevation: 8.0,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <PopupMenuEntry>[
                                    const PopupMenuItem(
                                      child: Text('Export FEN'),
                                    ),
                                    PopupMenuItem(
                                      onTap: () async {
                                        // String url =
                                        //     "https://lichess.org/paste?pgn=${chessController.gamePGN.replaceAll(' ', '+')}";
                                        // if (await canLaunch(url)) {
                                        //   await launch(url);
                                        // }
                                      },
                                      child: const Text(
                                        'Export PGN',
                                      ),
                                    ),
                                    const PopupMenuItem(
                                      child: Text(
                                        'Export Move List',
                                      ),
                                    ),
                                    PopupMenuItem(
                                      onTap: () => Navigator.of(context).pop(),
                                      child: const Text('Quit Game'),
                                    ),
                                  ],
                                ),
                              );
                            });
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Text(
                          'Menu',
                          style: Theme.of(context)
                              .textTheme
                              .headline3!
                              .copyWith(color: kPrimaryColor),
                        ),
                      ),
                    ),
                    Hero(
                      tag: 'title',
                      child: Text('CHESS',
                          style: Theme.of(context).textTheme.headline1),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // chessController.undoMove();
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Text(
                          'Undo',
                          style: Theme.of(context)
                              .textTheme
                              .headline3!
                              .copyWith(color: kPrimaryColor),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // const SizedBox(
            //   height: 100,
            // ),
            Expanded(
              flex: 3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ChessBoard(
                      controller: chessController,
                      agentPlayingColor:
                          widget.isSinglePlayer ? PieceColor.black : null,
                      size: _boardSize)
                ],
              ),
            ),
            Flexible(
              flex: 1,
              child: AdaptiveHorizontalPadding(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Player 1 info.
                    Row(
                      children: [
                        Image.asset(
                          'assets/images/king/king-white.png',
                          height: 50,
                        ),
                        const SizedBox(
                          width: 8.0,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${widget.player1Name}: 0',
                              style: Theme.of(context).textTheme.headline6,
                            ),
                            Text(
                              '${whiteTime ~/ 60}:${whiteTime % 60}',
                              style: Theme.of(context).textTheme.subtitle1,
                            ),
                          ],
                        )
                      ],
                    ),

                    // Player 2 info.
                    Row(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '${widget.player2Name}: 0',
                              style: Theme.of(context).textTheme.headline6,
                            ),
                            Text(
                              '${blackTime ~/ 60}:${blackTime % 60}',
                              style: Theme.of(context).textTheme.subtitle1,
                            ),
                          ],
                        ),
                        const SizedBox(
                          width: 8.0,
                        ),
                        Image.asset(
                          'assets/images/king/king-black.png',
                          height: 50,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
