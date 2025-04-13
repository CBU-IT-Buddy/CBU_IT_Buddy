import 'package:flutter/material.dart';

class LifeCounter extends StatelessWidget {
  final ValueNotifier<int> lives;

  LifeCounter({required this.lives});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: lives,
      builder: (context, value, child) {
        return Text(
          'Lives: $value',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
          ),
        );
      },
    );
  }
}