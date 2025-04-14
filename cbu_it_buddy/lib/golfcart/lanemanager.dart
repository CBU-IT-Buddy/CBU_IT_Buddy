import 'dart:math';
import 'package:flame/components.dart';
import 'constants.dart';

class LaneManager {
  final List<double> lanes = [lane1, lane2, lane3]; // Add lanes property
  final Map<double, List<PositionComponent>> laneObjects = {
    lane1: [],
    lane2: [],
    lane3: [],
  };
  final Map<double, double> lastSpawnTime = {
    lane1: 0.0,
    lane2: 0.0,
    lane3: 0.0,
  };

  List<double>? getTwoRandomLanes(double currentTime) {
    final random = Random();
    final availableLanes = lanes.where((lane) {
      final timeSinceLastSpawn = currentTime - lastSpawnTime[lane]!;
      return timeSinceLastSpawn >= 3.0;
    }).toList();
    if (availableLanes.length < 2) {
      return null;
    }
    availableLanes.shuffle(random);
    return availableLanes.take(2).toList();
  }

  void addObjectToLane(double lane, PositionComponent object, double currentTime) {
    laneObjects[lane]!.add(object);
    lastSpawnTime[lane] = currentTime;
  }

  void removeObjectFromLane(PositionComponent object) {
    double? lane = getLaneForPosition(object.position.x);
    if (lane != null) {
      laneObjects[lane]!.remove(object);
    }
  }

  double? getLaneForPosition(double x) {
    for (double lane in lanes) {
      if ((x - lane).abs() < 1.0) {
        return lane;
      }
    }
    return null;
  }

  int getObjectsInLane(double lane) {
    return laneObjects[lane]!.length;
  }

  int getTotalObjects() {
    return laneObjects.values.fold(0, (sum, object) => sum + object.length);
  }
}