import 'package:flutter/material.dart';
import 'package:flutter_chess/screens/screens.dart';
import 'package:flutter_chess/theme.dart';

import 'config/custom_router.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ChessApp());
}

class ChessApp extends StatelessWidget {
  const ChessApp({Key? key}) : super(key: key);

  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'Chess',
      debugShowCheckedModeBanner: false,
      onGenerateRoute: CustomRouter.onGenerateRoute,
      initialRoute: MainMenuScreen.routeName,
      theme: themeData,
    );
  }
}
