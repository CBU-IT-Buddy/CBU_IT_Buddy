import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flutter/material.dart';
import 'golfcartgame.dart';
import 'constants.dart';
import 'obstacle.dart';
import 'movingobstacle.dart';

// PlayerDirection enum for future animations
enum PlayerDirection { left, right, none }

enum PlayerState { idle, moving }

class Player extends SpriteComponent with HasGameRef<GolfCartGame>, CollisionCallbacks {
  // Variable declaration
  PlayerDirection playerDirection;
  double moveSpeed;
  Vector2 velocity = Vector2.zero();
  ValueNotifier<int> lives; // Use ValueNotifier for lives
  ValueNotifier<int> score = ValueNotifier<int>(0); // Add score
  int currentLaneIndex;
  double targetX;
  final String spritePath;
  bool isFlashing = false; // Flag to indicate if the player is flashing
  bool isInvincible = false; // Flag to indicate if the player is invincible
  double flashTimer = 0.0; // Timer for flashing effect
  int flashCount = 0; // Counter for flashing effect
  Sprite? originalSprite; // Store original sprite for flashing effect
  int lastDebugPrintTime = -1; // Track the last time debug print was made
  
  // Variables for swipe down functionality
  bool isSwipingDown = false;
  double originalY = 0.0;
  double swipeDownDistance = 150.0; // Distance to move down when swiping down
  double swipeDownTimer = 0.0; // Timer for swipe down duration
  final double swipeDownDuration = 1.0; // Duration in seconds

  // Constructor
  Player({
    required Vector2 position,
    required double width,
    required double height,
    required this.spritePath,
    int initialLives = 3, // Initialize lives with a default value
    Color color = Colors.deepPurple,
  })  : lives = ValueNotifier<int>(initialLives), // Initialize ValueNotifier
        playerDirection = PlayerDirection.none, // Initialize playerDirection here
        moveSpeed = playerDelta, // Initialize moveSpeed
        currentLaneIndex = 1, 
        targetX = lanes[1], 
        super(
          position: position,
          anchor: Anchor.center,
          size: Vector2(width, height),
        );

  @override
  Future<void> onLoad() async {
    super.onLoad();
    sprite = await gameRef.loadSprite(spritePath);
    originalSprite = sprite; // Store original sprite for flashing effect
    originalY = position.y; // Store the original y position

    // Custom hitbox to occupy only the top 25% of the golf cart image
    final hitbox = RectangleHitbox.relative(
      Vector2(0.75, 0.15), // 75% width and 25% height of the sprite
      position: Vector2(width / 8, 40), 
      parentSize: size,
    );
    add(hitbox);
  }

  @override
  void update(double dt) {
    super.update(dt);
    _updatePlayerPosition(dt);
    _updateFlashing(dt);
    _updateSwipeDown(dt);
    
    // Debug print for player move speed (only print occasionally to avoid console spam)
    if (gameRef.gameTime.toInt() % 5 == 0 && gameRef.gameTime.floor() != lastDebugPrintTime) {
      debugPrint('Player moveSpeed: $moveSpeed');
      lastDebugPrintTime = gameRef.gameTime.floor();
    }
  }

  void _updatePlayerPosition(double dt) {
    if ((position.x - targetX).abs() > 1.0) {
      double direction = (targetX - position.x).sign;
      position.x += direction * moveSpeed * dt;
      if ((position.x - targetX).abs() < moveSpeed * dt) {
        position.x = targetX;
      }
    }
  }

  void _updateFlashing(double dt) {
    if (isFlashing) {
      flashTimer += dt;
      if (flashTimer >= 0.1) {
        flashTimer = 0.0;
        flashCount++;
        sprite = (flashCount % 2 == 1) ? null : originalSprite;
        if (flashCount >= 10) {
          isFlashing = false;
          sprite = originalSprite; // Ensure sprite is reset to original
        }
      }
    }
  }
  
  void _updateSwipeDown(double dt) {
    if (isSwipingDown) {
      swipeDownTimer += dt;
      if (swipeDownTimer >= swipeDownDuration) {
        // Return to original position
        isSwipingDown = false;
        position.y = originalY;
        debugPrint('Swipe down effect ended');
      }
    }
  }

  void onSwipeLeft() {
    print('Swipe Left');
    if (currentLaneIndex > 0) {
      currentLaneIndex--;
      targetX = lanes[currentLaneIndex];
    }
  }

  void onSwipeRight() {
    print('Swipe Right');
    if (currentLaneIndex < lanes.length - 1) {
      currentLaneIndex++;
      targetX = lanes[currentLaneIndex];
    }
  }
  
  void onBrake() {
    if (!isSwipingDown) {
      debugPrint('Swipe Down');
      isSwipingDown = true;
      swipeDownTimer = 0.0;
      position.y = originalY + swipeDownDistance; // Move player down
    }
  }

  void startFlashing() {
    if (isFlashing) return; // Prevent multiple flashing effects
    isFlashing = true;
    flashTimer = 0.0;
    flashCount = 0;
  }

  void startInvincibility() {
    isInvincible = true;
    Future.delayed(Duration(seconds: 3), () {
      isInvincible = false;
    });
  }

  void handleCollision() {
    if (isInvincible) {
      return; // If player is invincible, ignore the collision
    }
    
    startFlashing();

    if (!isFlashing) {
      lives.value--; // Decrement lives
    }

    if (lives.value <= 0) {
      // Handle game over logic here
    }
  }

  void difficultySpeedBoost() {
    moveSpeed *= 1.2;
    // Cap the moveSpeed at maxPlayerMoveSpeed
    if (moveSpeed > maxPlayerMoveSpeed) {
      moveSpeed = maxPlayerMoveSpeed;
    }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    
    if (other is Obstacle || other is MovingObstacle) {
      // Only process collisions that happen near the front of the player
      bool isFrontCollision = false;
      for (final point in intersectionPoints) {
        if (point.y <= position.y - size.y * 0.3) { // If point is in front third of player
          isFrontCollision = true;
          break;
        }
      }
      
      if (isFrontCollision) {
        // If the player is invincible, don't handle the collision
        if (!isInvincible) {
          handleCollision();
        }
      }
    }
  }
}