import 'package:flutter/material.dart';
import 'dart:math';

class GamePage extends StatefulWidget {
  final String username;

  const GamePage({super.key, required this.username});

  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> with SingleTickerProviderStateMixin {
  final Random _random = Random();
  int _ringingStation = -1;
  bool _isRinging = false;
  String _question = "";
  List<String> _answers = [];
  String _correctAnswer = "";
  int _totalRings = 0;
  final int _maxRings = 5;

  int _xp = 0;
  int _lives = 3;
  int _level = 1;
  int _hintCount = 3; // Defined hint counter

  static List<Map<String, dynamic>> leaderboard = [];

  final int totalStations = 8;
  final List<String> dummyQuestions = [
    "What is the first step to solve IT issues?",
    "What should you do if the computer is slow?",
    "How to connect to the Wi-Fi?",
  ];
  final List<List<String>> dummyAnswers = [
    ["Restart", "Call support", "Check cables"],
    ["Scan for viruses", "Buy new hardware", "Call help desk"],
    ["Restart the router", "Call IT", "Reboot computer"],
  ];
  final List<String> correctAnswers = [
    "Restart",
    "Scan for viruses",
    "Restart the router"
  ];

  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    scheduleNextRing();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void scheduleNextRing() {
    if (_totalRings < _maxRings && _lives > 0) {
      int delaySeconds = _random.nextInt(4) + 2;
      Future.delayed(Duration(seconds: delaySeconds), () {
        if (mounted) {
          _ringPhone();
        }
      });
    } else {
      _endGame();
    }
  }

  void _ringPhone() {
    setState(() {
      _ringingStation = _random.nextInt(totalStations) + 1;
      _isRinging = true;
      int questionIndex = _random.nextInt(dummyQuestions.length);
      _question = dummyQuestions[questionIndex];
      _answers = dummyAnswers[questionIndex];
      _correctAnswer = correctAnswers[questionIndex];
      _totalRings++;
    });
  }

  Widget _buildStations() {
    return GridView.builder(
      padding: const EdgeInsets.all(10),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 1,
      ),
      itemCount: totalStations,
      itemBuilder: (context, index) {
        int stationNumber = index + 1;
        return GestureDetector(
          onTap: _ringingStation == stationNumber ? () => _onStationTap() : null,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            decoration: BoxDecoration(
              color: _ringingStation == stationNumber ? Colors.yellow : Colors.grey[300],
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.black),
            ),
            child: Center(
              child: Text(
                'Station $stationNumber',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        );
      },
    );
  }

  void _onStationTap() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(_question),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ..._answers.map((answer) {
              return ListTile(
                title: Text(answer),
                onTap: () {
                  _showAnswerFeedback(answer == _correctAnswer, answer);
                },
              );
            }).toList(),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _hintCount > 0
                  ? () {
                      setState(() {
                        _hintCount--;
                      });
                      _showAnswerFeedback(true, _correctAnswer);
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: _hintCount > 0 ? Colors.blue : Colors.grey,
              ),
              child: Text('Hint ($_hintCount left)'),
            ),
          ],
        ),
      ),
    );
  }

  void _showAnswerFeedback(bool isCorrect, String selectedAnswer) {
    Navigator.of(context).pop();

    if (isCorrect) {
      setState(() {
        _xp += 10;
      });
    } else {
      setState(() {
        _lives--;
      });
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isCorrect ? "Correct!" : "Wrong Answer!"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: _answers.map((answer) {
            return Container(
              color: answer == selectedAnswer && !isCorrect
                  ? Colors.red
                  : answer == _correctAnswer
                      ? Colors.green
                      : null,
              child: ListTile(
                title: Text(answer),
              ),
            );
          }).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              if (isCorrect && _xp >= 30) {
                setState(() {
                  _level++;
                  _xp = 0;
                });
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text("Level Up!"),
                    content: Text("Congratulations! You've reached Level $_level!"),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          setState(() {
                            _ringingStation = -1;
                            _isRinging = false;
                          });
                          scheduleNextRing();
                        },
                        child: const Text("Continue"),
                      ),
                    ],
                  ),
                );
              } else {
                setState(() {
                  _ringingStation = -1;
                  _isRinging = false;
                });
                scheduleNextRing();
              }
            },
            child: const Text("Next Call"),
          ),
        ],
      ),
    );
  }

  void _endGame() {
    String message = _lives <= 0 ? "You are out of lives." : "You have completed 5 calls.";

    _updateLeaderboard();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Game Over!"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _restartGame();
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

  void _updateLeaderboard() {
    leaderboard.add({"username": widget.username, "xp": _xp});
    leaderboard.sort((a, b) => b["xp"].compareTo(a["xp"]));
    if (leaderboard.length > 3) {
      leaderboard.removeLast();
    }
  }

  void _restartGame() {
    setState(() {
      _xp = 0;
      _lives = 3;
      _level = 1;
      _totalRings = 0;
      _ringingStation = -1;
      _isRinging = false;
    });
    Navigator.of(context).pop();
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => GamePage(username: widget.username)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('IT Office Game'),
      ),
      body: _buildStations(),
    );
  }
}
