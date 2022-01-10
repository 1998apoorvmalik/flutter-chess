import 'package:flutter/material.dart';

class AdaptiveHorizontalPadding extends StatelessWidget {
  const AdaptiveHorizontalPadding({Key? key, required this.child})
      : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final double _deviceWidth = MediaQuery.of(context).size.width;

    return Padding(
        padding: EdgeInsets.symmetric(
            horizontal: _deviceWidth < 700
                ? 12.0
                : _deviceWidth < 1200
                    ? _deviceWidth / 8
                    : _deviceWidth < 1800
                        ? _deviceWidth / 4
                        : _deviceWidth / 3),
        child: child);
  }
}
