import 'package:flutter/material.dart';

class BigHeading extends StatelessWidget {
  const BigHeading({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    // If an appBar is in use then extra top padding will push the component too far down
    final paddingTop = Scaffold.of(context).hasAppBar &&
            Scaffold.of(context).appBarMaxHeight != null &&
            Scaffold.of(context).appBarMaxHeight! > 0
        ? 0.0
        : MediaQuery.paddingOf(context).top + kToolbarHeight;

    return Padding(
      padding: EdgeInsets.only(bottom: 12, top: paddingTop),
      child: Text(title, style: Theme.of(context).textTheme.headlineMedium),
    );
  }
}
