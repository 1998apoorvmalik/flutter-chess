import 'package:flutter/material.dart';
import 'package:flutter_chess/config/custom_route.dart';
import 'package:flutter_chess/screens/game/game_screen.dart';

class OptionScreen extends StatefulWidget {
  static const String routeName = '/option';

  static Route route({required Map<String, bool> options}) {
    return CustomRoute(
      settings: const RouteSettings(name: routeName),
      fullscreenDialog: true,
      builder: (_) =>
          OptionScreen(isSinglePlayer: options['isSinglePlayer'] ?? true),
    );
  }

  const OptionScreen({Key? key, required this.isSinglePlayer})
      : super(key: key);

  final bool isSinglePlayer;

  @override
  State<OptionScreen> createState() => _OptionScreenState();
}

class _OptionScreenState extends State<OptionScreen> {
  // Device screen information.
  late final double deviceWidth = MediaQuery.of(context).size.width;
  late final double deviceHeight = MediaQuery.of(context).size.height;
  late final double aspectRatio = deviceWidth / deviceHeight;

  // Spacing valus.
  final double labelSpacing = 100.0;

  // Text field properties.
  final maxTextFieldLines = 1;
  final maxTextFieldLength = 20;
  late final TextEditingController _player1NameTextFieldController =
      TextEditingController(text: widget.isSinglePlayer ? 'Human' : 'Player 1');
  late final TextEditingController _player2NameTextFieldController =
      TextEditingController(
          text: widget.isSinglePlayer ? 'Computer' : 'Player 2');

  // Slider widget properties.
  final double _difficultySliderMinValue = 1;
  final double _difficultySliderMaxValue = 10;
  double _difficultySliderCurrentValue = 5;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: deviceWidth < 700
                    ? 12.0
                    : deviceWidth < 1200
                        ? deviceWidth / 8
                        : deviceWidth < 1800
                            ? deviceWidth / 4
                            : deviceWidth / 3),
            child: Column(
              children: [
                Expanded(
                  child: Center(
                    child: Hero(
                      tag: 'title',
                      child: Text(
                        'CHESS',
                        style: Theme.of(context).textTheme.headline1,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          InkWell(
                            splashFactory: NoSplash.splashFactory,
                            onTap: () => Navigator.of(context).pop(),
                            child: const Icon(
                              Icons.arrow_back_ios,
                              size: 32,
                            ),
                          ),
                          Text(
                            widget.isSinglePlayer
                                ? 'SinglePlayer'
                                : 'MultiPlayer',
                            style: Theme.of(context).appBarTheme.titleTextStyle,
                          ),
                          InkWell(
                            splashFactory: NoSplash.splashFactory,
                            onTap: () => Navigator.of(context)
                                .pushNamed(GameScreen.routeName),
                            child: Transform(
                              transform: Matrix4.rotationY(22 / 7),
                              alignment: Alignment.center,
                              child: const Icon(
                                Icons.arrow_back_ios,
                                size: 32,
                              ),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 32.0,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: labelSpacing,
                            child: Text(
                              'Player 1',
                              style: Theme.of(context).textTheme.headline3,
                            ),
                          ),
                          Flexible(
                            child: TextField(
                              controller: _player1NameTextFieldController,
                              decoration: const InputDecoration(
                                hintText: "Enter first player's name.",
                                counterText: "",
                              ),
                              maxLines: 1,
                              maxLength: 24,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8.0),
                      Row(
                        children: [
                          SizedBox(
                            width: labelSpacing,
                            child: Text(
                              'Player 2',
                              style: Theme.of(context).textTheme.headline3,
                            ),
                          ),
                          Flexible(
                            child: TextField(
                              controller: _player2NameTextFieldController,
                              decoration: const InputDecoration(
                                hintText: "Enter second player's name.",
                                counterText: "",
                              ),
                              maxLines: 1,
                              maxLength: 24,
                            ),
                          ),
                        ],
                      ),
                      if (widget.isSinglePlayer)
                        Row(
                          children: [
                            SizedBox(
                              width: labelSpacing,
                              child: Text(
                                'Difficulty',
                                style: Theme.of(context).textTheme.headline3,
                              ),
                            ),
                            Flexible(
                              child: Slider(
                                min: _difficultySliderMinValue,
                                max: _difficultySliderMaxValue,
                                value: _difficultySliderCurrentValue,
                                onChanged: (double nextValue) => setState(() {
                                  _difficultySliderCurrentValue = nextValue;
                                }),
                              ),
                            ),
                          ],
                        )
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Center(
                    child: Hero(
                      tag: 'chess-pieces-image',
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxWidth: 800,
                        ),
                        child: Image.asset(
                          'assets/images/chess-pieces.png',
                          filterQuality: FilterQuality.high,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
