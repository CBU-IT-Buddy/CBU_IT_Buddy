import 'dart:async';
import 'dart:math';
import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flame/parallax.dart';
import 'package:flutter/material.dart';
import 'constants.dart';
import 'gameapp.dart';
import 'obstacle.dart';
import 'player.dart';
import 'lanemanager.dart';
import 'movingobstacle.dart';
import 'gametimer.dart' as gameTimer;
import 'powerup.dart';

enum DifficultyLevel { EASY, MEDIUM, HARD }

// Define patterns for more deliberate obstacle placement
class ObstaclePattern {
  final List<List<int>> laneConfigurations;
  final double difficultyRating; // 0.0 to 1.0 where 1.0 is hardest
  final String name;

  const ObstaclePattern(
      {required this.laneConfigurations,
      required this.difficultyRating,
      required this.name});
}

enum GameState { GAME, END }

void main() {
  runApp(GameApp());
}

class GolfCartGame extends FlameGame with HasCollisionDetection {
  // Variable Declaration
  late Player player;
  late ParallaxComponent streetBG;
  double speed = speed1;
  final LaneManager laneManager = LaneManager();
  double timeSinceLastSpawn = 0.0;
  final double spawnInterval =
      0.5; // seconds, adjusted for more frequent spawning
  double gameTime = 0.0;
  int obstaclesToSpawn = 2;
  double timeSinceLastIncrease = 0.0;
  final double increaseInterval = 10.0; // seconds
  final int maxObstacles = 6;
  final int minObstacles = 2; // Minimum number of obstacles to maintain
  final String obstacleSprite = 'obstacle.png'; // Updated path
  final List<String> movingObstacleSprites = [
    'male_scooterR.png',
    'female_scooterR.png'
  ]; // Updated paths
  final String playerSprite = 'golfcart.png'; // Updated path
  final double playerWidth = 200;
  final double playerHeight = 260;
  final int difficultySpeedIncrease = 20;
  GameState gameState = GameState.GAME;
  bool timerEnd = false;

  // Callback for notifying UI of game state changes
  void Function(GameState)? onGameStateChanged;

  GolfCartGame()
      : super(
          camera: CameraComponent.withFixedResolution(
              width: gameWidth, height: gameHeight),
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    debugMode = true; // set false to remove hitboxes

    // Background
    streetBG = await loadParallaxComponent(
      [ParallaxImageData('streetbg.jpg')], // Updated path
      repeat: ImageRepeat.repeatY,
      baseVelocity: Vector2(0, -30),
      velocityMultiplierDelta: Vector2(0, speed),
      size: Vector2(gameWidth, gameHeight),
      position: Vector2(0, 0),
    );
    add(streetBG);

    // Player
    player = Player(
      position: Vector2(0.0, 500.0), // starting position at center
      width: playerWidth,
      height: playerHeight,
      spritePath: playerSprite,
    );
    world.add(player);

    // Ensure player is initialized before adding timers
    await Future.delayed(Duration.zero);

    // Add a timer to spawn power-ups
    TimerComponent powerUpTimer = TimerComponent(
      period: 5, // Spawn every 15 seconds
      repeat: true,
      onTick: spawnPowerUp,
    );
    add(powerUpTimer);
  }

  @override
  void update(double dt) {
    super.update(dt);
    gameTime += dt;
    timeSinceLastSpawn += dt;
    timeSinceLastIncrease += dt;
    timerEnd = gameTimer.timerEnd;

    // Check if game should end
    if (timerEnd && gameState != GameState.END) {
      gameState = GameState.END;
      showEndGameScreen();
    }

    if (gameState == GameState.GAME) {
      if (timeSinceLastIncrease >= increaseInterval) {
        obstaclesToSpawn = min(obstaclesToSpawn + 2, maxObstacles);
        // Obstacle.speed += difficultySpeedIncrease; // Increase obstacle speed
        player.difficultySpeedBoost(); // Increase player speed
        // speed += difficultySpeedIncrease; // background speed
        timeSinceLastIncrease = 0.0;
      }

      if (timeSinceLastSpawn >= spawnInterval) {
        spawnObstacles();
        spawnMovingObstacle();
        timeSinceLastSpawn = 0.0;
      }
    }

    // Ensure there are at least minObstacles on the screen
    if (laneManager.getTotalObjects() < minObstacles) {
      for (int i = laneManager.getTotalObjects(); i < minObstacles; i++) {
        spawnObstacles();
      }
    }
  }

  // Randomly spawn obstacles at the top of the screen
  void spawnObstacles() {
    // Maximum number of obstacles reached, do not spawn more
    if (laneManager.getTotalObjects() >= maxObstacles) {
      return;
    }

    final currentTime = gameTime;
    final lanes = laneManager.getTwoRandomLanes(currentTime);

    // Not enough available lanes, do not spawn obstacles
    if (lanes == null || lanes.length < 2) {
      return;
    }

    for (final lane in lanes) {
      final position = Vector2(lane, topBound);
      final obstacle = Obstacle(
        position: position,
        size: Vector2(300, 100),
        spritePath: obstacleSprite,
      );
      laneManager.addObjectToLane(lane, obstacle, currentTime);
      world.add(obstacle);
    }
  }

  // Randomly spawn moving obstacles at the top of the screen
  void spawnMovingObstacle() {
    final random = Random();

    // Count the current number of MovingObstacle instances
    final currentMovingObstacles =
        world.children.whereType<MovingObstacle>().length;

    if (currentMovingObstacles < 1) {
      final bool spawnFromLeft = random.nextBool();
      final position =
          spawnFromLeft ? Vector2(lane1, topBound) : Vector2(lane3, topBound);
      final movingObstacle = MovingObstacle(
        position: position,
        size: Vector2(210, 210),
        spritePaths: movingObstacleSprites,
        movingRight: spawnFromLeft,
      );
      world.add(movingObstacle);
    }
  }

  void spawnPowerUp() {
    // Don't spawn power-ups if the player isn't initialized yet
    // or if the game is not in the right state
    if (gameState != GameState.GAME) {
      debugPrint(
          'Power-up spawn skipped: game state is not GAME or player not initialized');
      return;
    }

    try {
      // Find lanes without obstacles
      List<int> availableLaneIndices = [];

      // Check each lane to see if it has any obstacles
      for (int i = 0; i < lanes.length; i++) {
        double lanePosition = lanes[i];
        if (laneManager.getObjectsInLane(lanePosition) == 0) {
          availableLaneIndices.add(i);
        }
      }

      // If all lanes have obstacles, don't spawn a power-up
      if (availableLaneIndices.isEmpty) {
        debugPrint('Power-up spawn skipped: all lanes have obstacles');
        return;
      }

      // Pick a random lane from the available lanes
      final random = Random();
      final laneIndex =
          availableLaneIndices[random.nextInt(availableLaneIndices.length)];
      final lanePosition = lanes[laneIndex];

      // Power-up size is defined as 60x60 in PowerUp class
      const powerUpWidth = 60.0;

      // Center the power-up in the lane by offsetting it by half its width
      final centeredXPosition = lanePosition - (powerUpWidth / 2);

      debugPrint('Spawning invincibility power-up in lane ${laneIndex + 1}');
      final position = Vector2(centeredXPosition, topBound);
      final powerUp = PowerUp(position: position);
      world.add(powerUp);
    } catch (e, stackTrace) {
      debugPrint('Error spawning power-up: $e');
      debugPrint('Stack trace: $stackTrace');
    }
  }

  void showEndGameScreen() {
    // Notify UI that game has ended
    if (onGameStateChanged != null) {
      onGameStateChanged!(GameState.END);
    }

    // Optional: pause the game
    pauseEngine();
  }
}
