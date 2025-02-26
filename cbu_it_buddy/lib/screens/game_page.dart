import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';
import 'package:flame/flame.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  GamePageState createState() => GamePageState();
}

class GamePageState extends State<GamePage> {
  late HelpDeskGame _game;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    _game = HelpDeskGame(context);
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GameWidget(game: _game),
    );
  }
}

class HelpDeskGame extends FlameGame with TapDetector {
  final Random _random = Random();
  int _ringingStation = -1;
  int _secondRingingStation = -1;
  String _question = "";
  List<String> _answers = [];
  String _correctAnswer = "";
  int _totalRings = 0;
  final int _maxRings = 20;
  int _xp = 0;
  int _lives = 3;
  int _level = 1;
  bool _isDifficultyTwo = false;
  bool _walkInTriggered = false;
  bool _walkInAnswered = false;
  final int totalStations = 12;
  final BuildContext context;

  HelpDeskGame(this.context);

  late SpriteComponent background;
  late List<Workstation> workstations;
  late HintCharacter hintCharacter;

  final List<String> dummyQuestions = [
    "What is the first step to solve IT issues?",
    // Add more as needed
  ];
  final List<List<String>> dummyAnswers = [
    ["Restart", "Call support", "Check cables"],
    // Add more as needed
  ];
  final List<String> correctAnswers = [
    "Restart",
    // Add more as needed
  ];

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    background = SpriteComponent()
      ..sprite = await loadSprite('helpdesk_office.png')
      ..size = size;
    add(background);

    workstations = [
      Workstation(1, Vector2(50, 50)),
      Workstation(2, Vector2(50, 150)),
      Workstation(3, Vector2(300, 50)),
      Workstation(4, Vector2(300, 150)),
      Workstation(5, Vector2(300, 250)),
      Workstation(6, Vector2(300, 350)),
      Workstation(7, Vector2(300, 450)),
      Workstation(8, Vector2(50, 350)),
    ];
    addAll(workstations);

    hintCharacter = HintCharacter();
    add(hintCharacter);

    scheduleNextRing();
  }

  void scheduleNextRing() {
    if (_totalRings < _maxRings && _lives > 0) {
      int delaySeconds = _random.nextInt(4) + 2;
      Future.delayed(Duration(seconds: delaySeconds), () {
        if (_lives > 0) {
          ringPhone();
          if (_isDifficultyTwo && !_walkInTriggered && !_walkInAnswered) {
            _walkInTriggered = true;
            Future.delayed(const Duration(seconds: 15), showWalkInQuestion);
          }
        }
      });
    } else if (_isDifficultyTwo) {
      endGame();
    } else {
      startDifficultyTwo();
    }
  }

  void ringPhone() {
    _ringingStation = _random.nextInt(totalStations) + 1;
    if (_isDifficultyTwo) {
      do {
        _secondRingingStation = _random.nextInt(totalStations) + 1;
      } while (_secondRingingStation == _ringingStation);
    }
    int questionIndex = _random.nextInt(dummyQuestions.length);
    _question = dummyQuestions[questionIndex];
    _answers = dummyAnswers[questionIndex];
    _correctAnswer = correctAnswers[questionIndex];
    _totalRings++;

    for (var station in workstations) {
      station.isRinging = (station.number == _ringingStation ||
          station.number == _secondRingingStation);
    }
  }

  @override
  void onTapUp(TapUpInfo info) {
    for (var station in workstations) {
      if (station.isRinging &&
          station.containsPoint(info.eventPosition.widget)) {
        onStationTap(station.number);
        break;
      }
    }
  }

  void onStationTap(int stationNumber) {
    showQuestionDialog(stationNumber);
    hintCharacter.moveToStation(stationNumber);
  }

  void showQuestionDialog(int stationNumber) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(_question),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: _answers.map((answer) {
            return ListTile(
              title: Text(answer),
              onTap: () {
                showAnswerFeedback(answer == _correctAnswer, answer);
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void showWalkInQuestion() {
    if (!_walkInAnswered) {
      ringPhone();
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(_question),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: _answers.map((answer) {
              return ListTile(
                title: Text(answer),
                onTap: () {
                  showAnswerFeedback(answer == _correctAnswer, answer,
                      isWalkIn: true);
                  _walkInAnswered = true;
                },
              );
            }).toList(),
          ),
        ),
      );
    }
  }

  void showAnswerFeedback(bool isCorrect, String selectedAnswer,
      {bool isWalkIn = false}) {
    Navigator.of(context).pop();
    if (isCorrect) {
      _xp += isWalkIn ? 50 : 10;
    } else {
      _lives--;
    }
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isCorrect ? "Correct!" : "Wrong Answer!"),
        content: Text(isCorrect ? "Good job!" : "Try again next time!"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              resetForNextRing();
              if (_xp >= 30 && !_isDifficultyTwo) {
                startDifficultyTwo();
              } else if (_xp >= 50 && _isDifficultyTwo) {
                endGame();
              } else {
                scheduleNextRing();
              }
            },
            child: const Text("Next Call"),
          ),
        ],
      ),
    );
  }

  void startDifficultyTwo() {
    _level = 2;
    _totalRings = 0;
    _xp = 0;
    _isDifficultyTwo = true;
    _walkInAnswered = false;
    _walkInTriggered = false;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Level $_level"),
        content: const Text(
            "Welcome to Level 2! Answer questions from two ringing stations and handle walk-ins!"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              scheduleNextRing();
            },
            child: const Text("Start Level 2"),
          ),
        ],
      ),
    );
  }

  void endGame() {
    String message = _lives <= 0
        ? "You are out of lives."
        : "You have completed both levels!";
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Game Over!"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              resetGame();
            },
            child: const Text("Restart Game"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: const Text("Cancel"),
          ),
        ],
      ),
    );
  }

  void resetGame() {
    _xp = 0;
    _lives = 3;
    _level = 1;
    _totalRings = 0;
    _ringingStation = -1;
    _secondRingingStation = -1;
    _isDifficultyTwo = false;
    _walkInAnswered = false;
    _walkInTriggered = false;
    for (var station in workstations) {
      station.isRinging = false;
    }
    scheduleNextRing();
  }

  void resetForNextRing() {
    _ringingStation = -1;
    _secondRingingStation = -1;
    for (var station in workstations) {
      station.isRinging = false;
    }
  }
}

class Workstation extends SpriteComponent {
  final int number;
  bool isRinging = false;
  late BlinkingLight redLight;
  bool redLightAdded = false;

  Workstation(this.number, Vector2 position) {
    this.position = position;
    size = Vector2(50, 50);
  }

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load('it_worker.png');
    redLight = BlinkingLight(
        position + Vector2(15, -10)); // Position relative to workstation
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (isRinging && !redLightAdded) {
      add(redLight);
      redLightAdded = true;
    } else if (!isRinging && redLightAdded) {
      remove(redLight);
      redLightAdded = false;
    }
  }
}

class BlinkingLight extends PositionComponent with HasGameRef {
  late AnimationController _blinkController;
  bool _isVisible = true;

  BlinkingLight(Vector2 initialPosition) {
    position = NotifyingVector2.copy(
        initialPosition); // Initialize with NotifyingVector2
    size = Vector2(20, 20);
  }

  @override // Override getter to return NotifyingVector2
  NotifyingVector2 get position => super.position as NotifyingVector2;

  @override // Override setter to accept Vector2
  set position(Vector2 value) {
    super.position =
        NotifyingVector2.copy(value); // Convert Vector2 to NotifyingVector2
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();
    print('BlinkingLight loaded at $position');
    _blinkController = AnimationController(
      vsync: this as TickerProvider,
      duration: const Duration(milliseconds: 500),
    )..repeat(reverse: true);
  }

  @override
  void update(double dt) {
    super.update(dt);
    _isVisible = _blinkController.value > 0.5;
    print('BlinkingLight updating, isVisible: $_isVisible');
  }

  @override
  void render(Canvas canvas) {
    if (_isVisible) {
      canvas.drawCircle(
        Offset(size.x / 2, size.y / 2),
        size.x / 2,
        Paint()
          ..color = Colors.red
          ..style = PaintingStyle.fill,
      );
    } else {
      print('BlinkingLight not visible');
    }
  }

  @override
  void onRemove() {
    _blinkController.dispose();
    super.onRemove();
  }
}

class HintCharacter extends SpriteAnimationComponent {
  HintCharacter() {
    size = Vector2(50, 50);
    position = Vector2(100, 600);
  }

  @override
  Future<void> onLoad() async {
    final spriteSheet = await Flame.images.load('hint_character.png');
    animation = SpriteAnimation.fromFrameData(
      spriteSheet,
      SpriteAnimationData.sequenced(
        amount: 4,
        stepTime: 0.2,
        textureSize: Vector2(50, 50),
      ),
    );
  }

  void moveToStation(int stationNumber) {
    Vector2 targetPosition;
    switch (stationNumber) {
      case 1:
        targetPosition = Vector2(50, 50);
        break;
      case 2:
        targetPosition = Vector2(50, 150);
        break;
      case 3:
        targetPosition = Vector2(300, 50);
        break;
      case 4:
        targetPosition = Vector2(300, 150);
        break;
      case 5:
        targetPosition = Vector2(300, 250);
        break;
      case 6:
        targetPosition = Vector2(300, 350);
        break;
      case 7:
        targetPosition = Vector2(300, 450);
        break;
      case 8:
        targetPosition = Vector2(50, 350);
        break;
      case 9:
        targetPosition = Vector2(50, 450);
        break;
      case 10:
        targetPosition = Vector2(50, 550);
        break;
      case 11:
        targetPosition = Vector2(150, 550);
        break;
      case 12:
        targetPosition = Vector2(250, 550);
        break;
      default:
        targetPosition = Vector2(100, 600);
    }
    position =
        targetPosition; // Simple direct movement (you can enhance with animation)
  }
}
