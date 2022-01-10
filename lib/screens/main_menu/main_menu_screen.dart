import 'package:flutter/material.dart';
import 'package:flutter_chess/config/custom_route.dart';
import 'package:flutter_chess/screens/option/option_screen.dart';
import 'package:flutter_chess/widgets/adaptive_horizontal_padding.dart';

class MainMenuScreen extends StatelessWidget {
  static const String routeName = '/main-menu';

  static Route route() {
    return CustomRoute(
      fullscreenDialog: true,
      settings: const RouteSettings(name: routeName),
      builder: (_) => const MainMenuScreen(),
    );
  }

  const MainMenuScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double deviceHeight = MediaQuery.of(context).size.height;
    final double aspectRatio = deviceWidth / deviceHeight;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
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
              Expanded(
                flex: 2,
                child: AdaptiveHorizontalPadding(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ElevatedButton(
                        onPressed: () => Navigator.of(context).pushNamed(
                          OptionScreen.routeName,
                          arguments: <String, bool>{'isSinglePlayer': true},
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Text(
                            'SinglePlayer',
                            style: Theme.of(context).textTheme.headline2,
                          ),
                        ),
                      ),
                      SizedBox(height: aspectRatio < 1 ? 8 : 12),
                      ElevatedButton(
                        onPressed: () => Navigator.of(context).pushNamed(
                          OptionScreen.routeName,
                          arguments: <String, bool>{'isSinglePlayer': false},
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Text(
                            'MultiPlayer',
                            style: Theme.of(context).textTheme.headline2,
                          ),
                        ),
                      ),
                      SizedBox(height: aspectRatio < 1 ? 8 : 12),
                      ElevatedButton(
                        onPressed: () => {},
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Text(
                            'Settings',
                            style: Theme.of(context).textTheme.headline2,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
