import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'constants.dart';
import 'golfcartgame.dart';
import 'gametimer.dart';
import 'lifecount.dart';
import 'player.dart';

// End game screen widget
class GameEndScreen extends StatelessWidget {
  final VoidCallback onExit;

  const GameEndScreen({
    Key? key, 
    required this.onExit
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.8),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Game Over',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: onExit,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
              ),
              child: const Text(
                'Exit',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Make GameView a separate widget that can be embedded anywhere
class GameView extends StatefulWidget {
  GameView({Key? key}) : super(key: key);

  @override
  State<GameView> createState() => _GameViewState();
}

class _GameViewState extends State<GameView> {
  late final GolfCartGame game;
  bool showEndScreen = false;

  @override
  void initState() {
    super.initState();
    game = GolfCartGame()
      ..onGameStateChanged = (GameState state) {
        if (state == GameState.END && mounted) {
          setState(() {
            showEndScreen = true;
          });
        }
      };
  }

  void exitGame() {
    Navigator.of(context).pop(); // Return to the previous screen
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            const Positioned(
              top: 20,
              left: 0,
              right: 0,
              child: Center(child: GameTimer()),
            ),
            // Positioned(
            //     bottom: 40,
            //     left: 0,
            //     right: 0,
            //     child: Center(
            //       child: SizedBox(
            //         width: 80,
            //         height: 80,
            //         child: FloatingActionButton(
            //           backgroundColor: Colors.blue.withOpacity(0.7),
            //           elevation: 8,
            //           onPressed: () => game.player.onBrake(),
            //           child: const Icon(
            //             Icons.arrow_downward,
            //             size: 36,
            //             color: Colors.white,
            //           ),
            //         ),
            //       ),
            //     ),
            //   ),
            // Show end game screen when game is over
            if (showEndScreen)
              Container(
                width: double.infinity,
                height: double.infinity,
                color: Colors.black.withOpacity(0.5),
                child: GameEndScreen(onExit: exitGame),
              ),
          ],
        ),
      ),
    );
  }
}

// Keep your original GameApp for standalone use
class GameApp extends StatelessWidget {
  GameApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.grey,
      ),
      home: GameView(),
    );
  }
}

// Original main function
void main() {
  runApp(GameApp());
}