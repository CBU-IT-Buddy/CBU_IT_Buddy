import 'package:flutter/material.dart';
import 'dart:math';

class HintManager {
  final int correctStation;
  final Function onHintCompleted;

  HintManager({required this.correctStation, required this.onHintCompleted});

  //////////////////////////////////////////////
  // Function to start the hint sequence
  // This closes the question popup and shows the hint dialog
  //////////////////////////////////////////////
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
      {super.key, required this.correctStation, required this.onHintCompleted});

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
    //////////////////////////////////////////////
    // Initialize the animation controller and the animation itself
    // The animation moves the character from a random position to the center
    //////////////////////////////////////////////
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    // Animate character from random position to the correct station
    _animation = Tween<Offset>(
      begin: Offset(_random.nextDouble() * 2 - 1, _random.nextDouble() * 2 - 1),
      end: const Offset(0, 0), // Move towards the center of the screen
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    // Start the animation and proceed with the game once the hint is completed
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
    //////////////////////////////////////////////
    // Dialog for displaying the character animation (hint)
    //////////////////////////////////////////////
    return Dialog(
      child: Container(
        height: 200,
        padding: const EdgeInsets.all(20),
        child: Stack(
          children: [
            const Center(child: Text("Character giving a hint...")),
            SlideTransition(
              position:
                  _animation, // Position of the character based on the animation
              child: const Icon(Icons.person, size: 50), // Character icon
            ),
          ],
        ),
      ),
    );
  }
}
