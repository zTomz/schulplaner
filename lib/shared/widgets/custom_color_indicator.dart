import 'package:flutter/material.dart';

class CustomColorIndicator extends StatelessWidget {
  final Color color;

  const CustomColorIndicator({
    super.key,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 4,
      height: 20,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(360),
      ),
    );
  }
}
