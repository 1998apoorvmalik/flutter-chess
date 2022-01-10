import 'package:flutter/material.dart';
import 'package:flutter_chess/config/custom_route.dart';
import 'package:flutter_chess/constants.dart';
import 'package:flutter_chess/controller/controller.dart';
import 'package:flutter_chess/widgets/widgets.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({Key? key}) : super(key: key);

  static const String routeName = '/game';

  static Route route() {
    return CustomRoute(
      fullscreenDialog: true,
      settings: const RouteSettings(name: routeName),
      builder: (_) => const GameScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Chess Controller.
    final ChessController chessController = ChessController();

    // Device screen information.
    final double _deviceWidth = MediaQuery.of(context).size.width;
    final double _deviceHeight = MediaQuery.of(context).size.height;
    final double _aspectRatio = _deviceWidth / _deviceHeight;

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
                      onPressed: () => Navigator.of(context).pop(),
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
                        print(chessController.gamePGN);
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
                      size: _aspectRatio < 0.64
                          ? _deviceWidth / 1.08
                          : (6 * _deviceHeight / 11)),
                ],
              ),
            ),
            Flexible(
              flex: 1,
              child: Container(),
            )
          ],
        ),
      ),
    );
  }
}
