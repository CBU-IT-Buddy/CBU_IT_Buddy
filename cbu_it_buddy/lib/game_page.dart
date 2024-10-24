import 'package:cbu_it_buddy/hints.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class GamePage extends StatefulWidget {
  const GamePage({Key? key}) : super(key: key);
  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage>
    with SingleTickerProviderStateMixin {
  final Random _random = Random();
  int _ringingStation = -1; // Initially, no station is ringing
  bool _isRinging = false;
  String _question = "";
  List<String> _answers = [];
  String _correctAnswer = "";
  int _totalRings = 0; // Counter for ringing times
  final int _maxRings = 5; // Limit ringing to 5 times

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
    if (_totalRings < _maxRings) {
      int delaySeconds =
          _random.nextInt(4) + 2; // Random time between 2 and 5 seconds
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
      _ringingStation =
          _random.nextInt(totalStations) + 1; // Random station 1-8
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
          onTap: _ringingStation == stationNumber
              ? () => _onStationTap()
              : null, // Allow tapping only when ringing
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            decoration: BoxDecoration(
              color: _ringingStation == stationNumber
                  ? Colors.yellow
                  : Colors.grey[300],
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.black),
            ),
            child: Center(
              child: Text(
                'Station $stationNumber',
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
            // Add the Hints button below the answer buttons
            ElevatedButton(
              onPressed: () {
                // Trigger the hint sequence
                HintManager(
                  correctStation: _ringingStation,
                  onHintCompleted: () {
                    // After the hint, show the question popup again and highlight correct answer
                    _showAnswerFeedback(true, _correctAnswer);
                  },
                ).showHint(context);
              },
              child: const Text('Hint'),
            ),
          ],
        ),
      ),
    );
  }

  // Feedback after answering the question
  void _showAnswerFeedback(bool isCorrect, String selectedAnswer) {
    Navigator.of(context).pop(); // Close the question dialog
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
              Navigator.of(context).pop();
              setState(() {
                _ringingStation = -1; // Reset the ringing station
                _isRinging = false; // Stop ringing
              });
              // Schedule the next call after clicking "Next Call"
              scheduleNextRing();
            },
            child: const Text("Next Call"),
          ),
        ],
      ),
    );
  }

  // End the game after 5 rings
  void _endGame() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Game Over!"),
        content: const Text("You have completed 5 calls."),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop(); // Go back to the previous screen
            },
            child: const Text("Finish"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('IT Office Game')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
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
