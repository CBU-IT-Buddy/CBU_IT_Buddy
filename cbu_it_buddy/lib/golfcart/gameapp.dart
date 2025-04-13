import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'constants.dart';
import 'golfcartgame.dart';
import 'gametimer.dart';
import 'lifecount.dart'; // Import the LifeCounter widget
import 'player.dart';

void main() {
  runApp(GameApp());
}

// GameApp container
class GameApp extends StatelessWidget {
  final game = GolfCartGame();

  GameApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.grey,
      ),
      home: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              GestureDetector(
                onHorizontalDragEnd: (details) {
                  if (details.primaryVelocity! > 0) {
                    game.player.onSwipeRight();
                  } else if (details.primaryVelocity! < 0) {
                    game.player.onSwipeLeft();
                  }
                },
                child: Center(
                  child: FittedBox(
                    child: SizedBox(
                      width: gameWidth,
                      height: gameHeight,
                      child: GameWidget(game: game),
                    ),
                  ),
                ),
              ),
              Positioned( // Display Timer
                top: 20,
                left: 0,
                right: 0,
                child: Center(
                  child: GameTimer(), 
                ),
              ),
              Positioned( // Display Life Counter
                top: 20,
                left: 20,
                child: Builder(
                  builder: (context) {
                    // Ensure the game is loaded before accessing player
                    try {
                      return LifeCounter(lives: game.player.lives);
                    } catch (e) {
                      return const SizedBox.shrink(); // Return empty widget if player not initialized
                    }
                  },
                ),
              ),
              // Bottom Centered Boost Button
              Positioned(
                bottom: 40,
                left: 0,
                right: 0,
                child: Center(
                  child: SizedBox(
                    width: 80,
                    height: 80,
                    child: FloatingActionButton(
                      backgroundColor: Colors.blue.withOpacity(0.7),
                      elevation: 8,
                      onPressed: () => game.player.onBrake(),
                      child: const Icon(
                        Icons.arrow_downward,
                        size: 36,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}