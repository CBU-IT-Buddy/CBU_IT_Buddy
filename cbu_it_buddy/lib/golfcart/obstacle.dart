import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flutter/material.dart';
import 'player.dart';
import 'golfcartgame.dart';
import 'constants.dart';

class Obstacle extends SpriteComponent with CollisionCallbacks, HasGameRef<GolfCartGame> {
  double speed = obstacleSpeed1;
  final String spritePath;

  Obstacle({
    required Vector2 position,
    required Vector2 size,
    required this.spritePath,
  }) : super(
          position: position,
          size: size,
          anchor: Anchor.center,
        );

  @override
  Future<void> onLoad() async {
    super.onLoad();
    sprite = await gameRef.loadSprite(spritePath);
    add(RectangleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);
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
