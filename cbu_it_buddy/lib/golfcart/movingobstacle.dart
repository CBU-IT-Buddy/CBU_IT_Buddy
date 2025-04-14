import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'constants.dart';
import 'player.dart';
import 'golfcartgame.dart';

class MovingObstacle extends SpriteComponent with CollisionCallbacks, HasGameRef<GolfCartGame> {
  final List<String> spritePaths;
  late double movementSpeed;
  bool movingRight;
  double speed = obstacleSpeed1;

  MovingObstacle({
    required Vector2 position,
    required Vector2 size,
    required this.spritePaths,
    required this.movingRight,
  }) : super(position: position, size: size, anchor: Anchor.center) {
    final random = Random();
    movementSpeed = random.nextDouble() * 50 + 150; // Random speed between 150 and 200
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    final random = Random();
    final selectedSpritePath = spritePaths[random.nextInt(spritePaths.length)];
    sprite = await gameRef.loadSprite(selectedSpritePath);
    
    // Flip the sprite horizontally if moving left
    if (!movingRight) {
      flipHorizontally();
    }
    
    add(RectangleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Move the obstacle from left to right and back
    if (movingRight) {
      position.x += movementSpeed * dt;
      if (position.x >= lane3) {
        movingRight = false;
        flipHorizontally(); // Flip sprite when direction changes to left
      }
    } else {
      position.x -= movementSpeed * dt;
      if (position.x <= lane1) {
        movingRight = true;
        flipHorizontally(); // Flip sprite when direction changes to right
      }
    }

    // Move the obstacle downward
    position.y += speed * dt;
    _checkBounds();
  }

  void _checkBounds() {
    if (position.y > bottomBound) {
      gameRef.laneManager.removeObjectFromLane(this);
      removeFromParent();
    }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (other is Player) {
      print('Collision with player!');
      other.handleCollision();
      gameRef.laneManager.removeObjectFromLane(this);
      removeFromParent();
    }
  }
}