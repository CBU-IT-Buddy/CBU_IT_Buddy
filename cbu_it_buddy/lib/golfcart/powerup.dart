import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'constants.dart';
import 'player.dart';
import 'golfcartgame.dart';
import 'package:flutter/material.dart';

class PowerUp extends RectangleComponent with CollisionCallbacks, HasGameRef<GolfCartGame> {
  // Now only one type: 'invincibility'
  PowerUp({required Vector2 position})
      : super(
          position: position,
          size: Vector2(60, 60),
          paint: Paint()..color = Colors.yellow, // Changed to yellow for invincibility
        );

  @override
  Future<void> onLoad() async {
    super.onLoad();
    add(RectangleHitbox()); // Add a rectangle hitbox for collision detection
  }

  @override
  void update(double dt) {
    super.update(dt);
    position.y += obstacleSpeed1 * dt; // Move downward (positive y direction)

    if (position.y > gameRef.size.y) {
      removeFromParent();
    }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (other is Player) {
      debugPrint('Invincibility power-up collision detected with Player.');
      
      try {
        debugPrint('Activating invincibility for Player.');
        other.startInvincibility();
        debugPrint('Invincibility successfully applied. Removing power-up.');
        removeFromParent();
      } catch (e, stackTrace) {
        debugPrint('Error during collision handling: $e');
        debugPrint('Stack trace: $stackTrace');
      }
    }
  }
}