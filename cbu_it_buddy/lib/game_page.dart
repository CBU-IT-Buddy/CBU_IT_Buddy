import 'package:flutter/material.dart';
import 'dart:math';

class GamePage extends StatefulWidget {
  const GamePage({super.key});
  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> with SingleTickerProviderStateMixin {
  final Random _random = Random();
  int _ringingStation = -1; // Initially, no station is ringing
  bool _isRinging = false;
  String _question = "";
  List<String> _answers = [];
  String _correctAnswer = "";
  int _totalRings = 0; // Counter for ringing times
  final int _maxRings = 5; // Limit ringing to 5 times

  int _xp = 0; // Experience points
  int _lives = 3; // Number of lives
  int _level = 1; // Level of the user is at.

  // Stations
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
  final List<String> correctAnswers = ["Restart", "Scan for viruses", "Restart the router"];

  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    // Schedule the first call after a random delay
    scheduleNextRing();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // Schedule the next phone ringing with a random delay
  void scheduleNextRing() {
    if (_totalRings < _maxRings && _lives > 0) {
      int delaySeconds = _random.nextInt(4) + 2; // Random time between 2 and 5 seconds
      Future.delayed(Duration(seconds: delaySeconds), () {
        if (mounted) {
          _ringPhone();
        }
      });
    } else {
      _endGame(); // End the game after 5 rings
    }
  }

  // Simulate ringing at a random station
  void _ringPhone() {
    setState(() {
      _ringingStation = _random.nextInt(totalStations) + 1; // Random station 1-8
      _isRinging = true;
      _question = dummyQuestions[_random.nextInt(dummyQuestions.length)];
      _answers = dummyAnswers[dummyQuestions.indexOf(_question)];
      _correctAnswer = correctAnswers[dummyQuestions.indexOf(_question)];
      _totalRings++;
    });
  }

  // Display the stations in a grid-like arrangement
  Widget _buildStations() {
    return GridView.builder(
      padding: const EdgeInsets.all(10),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4, // Four stations per row for a semi-circle effect
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 1,
      ),
      itemCount: totalStations,
      itemBuilder: (context, index) {
        int stationNumber = index + 1;
        return GestureDetector(
          onTap: _ringingStation == stationNumber ? () => _onStationTap() : null, // Allow tapping only when ringing
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

  // Walk-in station displayed separately
  Widget _buildWalkInStation() {
    return GestureDetector(
      onTap: () {
        // Walk-in feature to be implemented later
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.black),
        ),
        child: const Center(
          child: Text(
            'W (Walk-in)',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  // When the user taps the ringing station
  void _onStationTap() {
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
                _showAnswerFeedback(answer == _correctAnswer, answer);
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  // Feedback after answering the question
  void _showAnswerFeedback(bool isCorrect, String selectedAnswer) {
  Navigator.of(context).pop(); // Close the question dialog

  if (isCorrect) {
    setState(() {
      _xp += 10; // Add XP for correct answer
    });
  } else {
    setState(() {
      _lives--; // Decrement lives for incorrect answer
    });
  }

  // Show feedback dialog for correct or wrong answer
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(isCorrect ? "Correct!" : "Wrong Answer!"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: _answers.map((answer) {
          return Container(
            color: answer == selectedAnswer && !isCorrect
                ? Colors.red // Highlight wrong answer in red
                : answer == _correctAnswer
                    ? Colors.green // Highlight correct answer in green
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
            Navigator.of(context).pop(); // Close the feedback dialog

            // Check for level-up after feedback dialog is dismissed
            if (isCorrect && _xp >= 30) {
              setState(() {
                _level++; // Increase level
                _xp = 0;  // Reset XP
              });

              // Show level-up dialog
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text("Level Up!"),
                  content: Text("Congratulations! You've reached Level $_level!"),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Close the level-up dialog
                        setState(() {
                          _ringingStation = -1; // Reset the ringing station
                          _isRinging = false;    // Stop ringing
                        });
                        scheduleNextRing(); // Schedule the next call
                      },
                      child: const Text("Continue"),
                    ),
                  ],
                ),
              );
            } else {
              // If no level-up, continue game normally
              setState(() {
                _ringingStation = -1; // Reset the ringing station
                _isRinging = false;    // Stop ringing
              });
              scheduleNextRing(); // Schedule the next call
            }
          },
          child: const Text("Next Call"),
        ),
      ],
    ),
  );
}

  // End the game after 5 rings
  void _endGame() {
    String message;
    if (_lives <= 0) {
      message = "You are out of lives.";
    } else {
      message = "You have completed 5 calls.";
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Game Over!"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
              _restartGame(); // Call the restart method
            },
            child: const Text("Restart Game"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
              Navigator.of(context).pop(); // Go back to the previous screen (main page)
            },
            child: const Text("Cancel"),
          ),
        ],
      ),
    );
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
    Navigator.of(context).pop();// close current game page that is open
    //Navigate to fresh game page instance
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const GamePage()),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('IT Office Game'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _restartGame, // Restart the game
          ),
        ],),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          // Display XP, Lives, and Level
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                children: [
                  const Icon(Icons.flash_on, color: Colors.yellow), // Lightning Icon for XP
                  const SizedBox(width: 4), // Spacing
                  Text(
                    'XP: $_xp',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Row(
                children: [
                  const Icon(Icons.favorite, color: Colors.red), // Heart Icon for Lives
                  const SizedBox(width: 4), // Spacing
                  Text(
                    'Lives: $_lives',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.blue), // Star Icon for Level (you can choose another icon)
                  const SizedBox(width: 4), // Spacing
                  Text(
                    'Level: $_level',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
        ),
          const Text(
            'Click the ringing station to answer the call!',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: _buildStations(), // Display the 8 stations
          ),
          const SizedBox(height: 20),
          _buildWalkInStation(), // Display the walk-in station
        ],
      ),
    );
  }
}
