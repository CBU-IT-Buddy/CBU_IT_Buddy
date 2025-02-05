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
  int _secondRingingStation = -1;
  String _question = "";
  List<String> _answers = [];
  String _correctAnswer = "";
  int _totalRings = 0; // Counter for ringing times
  final int _maxRings = 20; // Limit ringing to 20 times

  int _xp = 0; // Experience points
  int _lives = 3; // Number of lives
  int _level = 1; // Level of the user is at.
  int _difficulty = 1;
  final int _ringingStationsCount = 1;
  bool _isDifficultyTwo = false;
  final bool _isDifficultyThree = false;
  final bool _isWalkInActive = false;
  bool _walkInTriggered = false;
  bool _walkInAnswered = false;
  final Map<int, DateTime> _stationTimers = {};
  final Map<int, bool> _stationAnswered = {};
  final List<int> _answeredStations = [];
  final bool _firstWalkinAnswered = false;
  final bool _secondWalkinActive= false;
  Map<int, String> difficultyNames = {
  1: "Easy",
  2: "Medium",
  3: "Hard",
};


  // Stations
  int totalStations = 8;
  final List<String> dummyQuestions = [
    "What is the first step to solve IT issues?",
    "What should you do if the computer is slow?",
    "How to connect to the Wi-Fi?",
    "What is the first step to solve password issues?",
    "What should you do if the projector in your classroom is not working?",
    "What should you do if the printer is not printing?",
  ];
  final List<List<String>> dummyAnswers = [
    ["Restart", "Call support", "Check cables"],
    ["Scan for viruses", "Buy new hardware", "Call help desk"],
    ["Restart the router", "Call IT", "Reboot computer"],
    ["Contact help desk","Restart computer","Check caps lock"],
    ["Check cables","Restart the system","Call IT"],
    ["Check ink levels","Check network","Call IT desk"]
  ];
  final List<String> correctAnswers = ["Restart", "Scan for viruses", "Restart the router","Check caps lock","Call IT","Check network"];

  late AnimationController _animationController;
  bool _walkInActive = false;
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
      int delaySeconds = _random.nextInt(4) + 2; // Between 2 and 5 seconds
      Future.delayed(Duration(seconds: delaySeconds), () {
        if (mounted) {
          _ringPhone();
          if (_isDifficultyTwo && !_walkInTriggered && !_walkInAnswered) {
            _walkInTriggered = true;
            Future.delayed(const Duration(seconds: 15), () {
              if (mounted && !_walkInAnswered) {
                _showWalkInQuestion();
              }
            });
          }
          else if(_isDifficultyThree && !_walkInTriggered && !_walkInAnswered){
            _walkInTriggered = true;
            Future.delayed(const Duration(seconds: 10), () {
              if (mounted && !_walkInAnswered) {
                _showWalkInQuestion();
              }
            });
          }
        }
      });
    }
    else if (_isDifficultyTwo) {
      _endGame();
    } else {
      _startDifficultyTwo();
    }
  }
  void _checkTimers() {
  // Check for expired timers for both stations
  DateTime now = DateTime.now();
  _stationTimers.forEach((stationNumber, expirationTime) {
    if (expirationTime.isBefore(now)) {
      if (_lives > 0) {
        setState(() {
          _lives--;
        });
      }
      // Remove the timer since it's expired
      _stationTimers.remove(stationNumber);
    }
  });
}

  // Simulate ringing at a random station
void _ringPhone() {
  setState(() {
    if (_isDifficultyTwo) {
        _ringingStation = _random.nextInt(totalStations) + 1;
        do {
          _secondRingingStation = _random.nextInt(totalStations) + 1;
        } while (_secondRingingStation == _ringingStation);
      } else {
        _ringingStation = _random.nextInt(totalStations) + 1;
      }

    // Set a new question
    _question = dummyQuestions[_random.nextInt(dummyQuestions.length)];
    _answers = dummyAnswers[dummyQuestions.indexOf(_question)];
    _correctAnswer = correctAnswers[dummyQuestions.indexOf(_question)];

    _totalRings++;
    _isRinging = true;  // Start showing questions
  });
}

  // Display the stations in a grid-like arrangement
// Display the stations in a grid-like arrangement
Widget _buildStations() {
    return GridView.builder(
      padding: const EdgeInsets.all(10),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
      ),
      itemCount: totalStations,
      itemBuilder: (context, index) {
        int stationNumber = index + 1;
        bool isRinging = stationNumber == _ringingStation || stationNumber == _secondRingingStation;

        return GestureDetector(
          onTap: isRinging ? () => _onStationTap(stationNumber) : null,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            decoration: BoxDecoration(
              color: isRinging ? Colors.yellow : Colors.grey[300],
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.black),
            ),
            child: Center(
              child: Text(
                "Station $stationNumber",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        );
      },
    );
  }

  // Walk-in station displayed separately
Widget _buildWalkInStation() {
  Color animatedColor = ColorTween(
    begin: Colors.blue,
    end: Colors.lightBlue,
  ).animate(_animationController).value ?? Colors.grey;

  return GestureDetector(
    onTap: () {

    },
    child: Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: _walkInActive ? animatedColor : Colors.grey[300],
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
  void _onStationTap(int stationNumber) {
  // Mark the station as answered
  setState(() {
    _stationAnswered[stationNumber] = true;
  });

  // Your existing logic for showing question and answers
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

  // Show a question for the walk-in station
void _showWalkInQuestion() {
  _startQuestionTimer();
  setState(() {
    _walkInActive = true;
  });

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
              _showAnswerFeedback(answer == _correctAnswer, answer, isWalkIn: true);
              setState(() {
                _walkInAnswered = true; // Mark as answered
              });
            },
          );
        }).toList(),
      ),
    ),
  ).then((_) {
    setState(() => _walkInActive = false);
    _animationController.reset();
  });
}
  void _showAnswerFeedback(bool isCorrect, String selectedAnswer, {bool isWalkIn = false}) {
    Navigator.of(context).pop();

    setState(() {
      if (isCorrect) {
        _xp += isWalkIn ? 50 : 10;
      } else {
        _lives--;
      }
    });

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isCorrect ? "Correct!" : "Wrong Answer!"),
        content: Text(isCorrect ? "Good job!" : "Try again next time!"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              if (_xp >= 30 && !_isDifficultyTwo) {
                _startDifficultyTwo();
              } else if(_xp>=50 && _isDifficultyTwo){
                _startDifficultyThree();
              }else if(_xp>=120 && _isDifficultyThree){
                _endGame();
              }else if (_isDifficultyThree && _totalRings >= _maxRings) {
                _endGame();
              } else {
                _resetForNextRing();
              }
            },
            child: const Text("Next Call"),
          ),
        ],
      ),
    );
  }
    void _startDifficultyTwo() {
    setState(() {
      _level = 2;
      _totalRings = 0;
      _xp = 0;
      _isDifficultyTwo = true;
      _walkInAnswered = false;
      _walkInTriggered = false;
    });

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Level Up!"),
        content: const Text("Welcome to Level 2! Answer questions from two ringing stations and handle walk-ins!"),
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
  void _startDifficultyThree() {
  setState(() {
    _level = 3;
    _totalRings = 0;
    _xp = 0;
    _isDifficultyTwo = false; // Exit difficulty two mode
    _difficulty = 3;
    totalStations = 12;
  });

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text("Level Up!"),
      content: const Text("Welcome to Level 3! Answer questions from 12 stations and handle walk-ins!"),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            scheduleNextRing(); // Start the ringing logic for level 3
          },
          child: const Text("Start Level 3"),
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
      message = "You have completed both levels!";
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
      _secondRingingStation = -1;
      _isDifficultyTwo = false;
      _isRinging = false;
      _walkInAnswered = false;
      _walkInTriggered = false;
      _walkInActive = false;
    });
    Navigator.of(context).pop();// close current game page that is open
    //Navigate to fresh game page instance
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const GamePage()),
    );
  }
  void _startQuestionTimer() {
    _animationController.reset();
    _animationController.forward();
  }
  void _resetForNextRing() {
    setState(() {
      _ringingStation = -1;
      _secondRingingStation = -1;
      _isRinging = false;
      _walkInTriggered = false;
    });
    scheduleNextRing();
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
                    'Difficulty: ${difficultyNames[_level] ?? 'Unknown'}',
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