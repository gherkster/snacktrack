import 'package:flutter/material.dart';

class BigHeading extends StatelessWidget {
  const BigHeading({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 40, 0, 12),
      child: Text(title, style: Theme.of(context).textTheme.headlineMedium),
    );
  }
}
