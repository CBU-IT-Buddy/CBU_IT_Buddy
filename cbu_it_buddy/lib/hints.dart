import 'package:flutter/material.dart';
import 'dart:math';

class HintManager {
  final int correctStation;
  final Function onHintCompleted;

  HintManager({required this.correctStation, required this.onHintCompleted});

  // Function to start the hint sequence
  void showHint(BuildContext context) {
    Navigator.of(context).pop(); // Close the question popup

    // Display the character giving a hint
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissing while hint is showing
      builder: (context) => HintDialog(
        correctStation: correctStation,
        onHintCompleted: onHintCompleted,
      ),
    );
  }
}

class HintDialog extends StatefulWidget {
  final int correctStation;
  final Function onHintCompleted;

  const HintDialog(
      {Key? key, required this.correctStation, required this.onHintCompleted})
      : super(key: key);

  @override
  _HintDialogState createState() => _HintDialogState();
}

class _HintDialogState extends State<HintDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    // Animate character from random position to the correct station
    _animation = Tween<Offset>(
      begin: Offset(_random.nextDouble() * 2 - 1, _random.nextDouble() * 2 - 1),
      end: Offset(0, 0),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _controller.forward().whenComplete(() {
      // Hint is done, callback to resume game
      Future.delayed(const Duration(seconds: 1), () {
        widget.onHintCompleted(); // Continue after hint
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        height: 200,
        padding: const EdgeInsets.all(20),
        child: Stack(
          children: [
            Center(child: Text("Character giving a hint...")),
            SlideTransition(
              position: _animation,
              child: Icon(Icons.person, size: 50), // Character icon
            ),
          ],
        ),
      ),
    );
  }
}
