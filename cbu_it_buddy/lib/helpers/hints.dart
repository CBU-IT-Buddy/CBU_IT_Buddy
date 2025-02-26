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

  const HintDialog({
    super.key,
    required this.correctStation,
    required this.onHintCompleted,
  });

  @override
  HintDialogState createState() => HintDialogState();
}

class HintDialogState extends State<HintDialog>
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

    // Animate character from random position to the center
    _animation = Tween<Offset>(
      begin: Offset(_random.nextDouble() * 2 - 1, _random.nextDouble() * 2 - 1),
      end: const Offset(0, 0), // Move towards the center of the dialog
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    // Start the animation and close the dialog before proceeding
    _controller.forward().whenComplete(() {
      Future.delayed(const Duration(seconds: 1), () {
        Navigator.of(context).pop(); // Close the hint dialog
        widget
            .onHintCompleted(); // Continue with the game (e.g., show feedback)
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
                  _animation, // Position of the character based on animation
              child: Image.asset(
                'assets/images/hint_character.png', // Shrek-like character
                width: 50,
                height: 50,
                fit: BoxFit.contain, // Ensure the image fits within bounds
              ),
            ),
          ],
        ),
      ),
    );
  }
}
