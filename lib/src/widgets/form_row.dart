import "package:flutter/material.dart";
import "package:snacktrack/src/styles/layout.dart";

class FormRow extends StatelessWidget {
  const FormRow({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: fieldPadding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: children,
      ),
    );
  }
}
