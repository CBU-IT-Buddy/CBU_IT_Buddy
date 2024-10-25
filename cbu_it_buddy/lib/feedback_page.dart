import 'package:flutter/material.dart';

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({Key? key}) : super(key: key);

  @override
  _FeedbackPageState createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  int _rating = 0; // Store the rating value
  String _userFeedback = ""; // Store user feedback
  final _feedbackController = TextEditingController(); // Controller for feedback input

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feedback Page'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //////////////////////////////////////////////
            // Title and Instructions
            //////////////////////////////////////////////
            const Text(
              'We value your feedback!',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text('Please rate your experience (1 to 5 stars):'),

            //////////////////////////////////////////////
            // Star Rating System
            //////////////////////////////////////////////
            Row(
              children: List.generate(5, (starIndex) {
                return IconButton(
                  icon: Icon(
                    starIndex < _rating ? Icons.star : Icons.star_border, // Filled if starIndex < _rating
                    color: Colors.amber,
                  ),
                  onPressed: () {
                    setState(() {
                      _rating = starIndex + 1; // Set the rating to the clicked star index
                    });
                  },
                );
              }),
            ),
            if (_rating == 0) const Text('Please select a rating from 1 to 5 stars.', style: TextStyle(color: Colors.red)),

            const SizedBox(height: 20),

            //////////////////////////////////////////////
            // Feedback Text Input
            //////////////////////////////////////////////
            const Text('Your feedback:'),
            TextField(
              controller: _feedbackController,
              onChanged: (value) {
                setState(() {
                  _userFeedback = value; // Update the feedback on change
                });
              },
              decoration: const InputDecoration(
                hintText: 'Enter your feedback here',
                border: OutlineInputBorder(),
              ),
              maxLines: 4,
            ),
            const SizedBox(height: 20),

            //////////////////////////////////////////////
            // Submit and Reset Buttons
            //////////////////////////////////////////////
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    if (_rating > 0 && _userFeedback.isNotEmpty) {
                      submitFeedback(_rating, _userFeedback);
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('Thank you!'),
                            content: const Text('Thank you for your feedback!'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('OK'),
                              ),
                            ],
                          );
                        },
                      );
                    } else {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('Error'),
                            content: const Text('Please provide a rating and feedback.'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('OK'),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                  child: const Text('Submit'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _rating = 0;
                      _userFeedback = "";
                      _feedbackController.clear(); // Clear the feedback input
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Form has been reset.')),
                    );
                  },
                  child: const Text('Reset'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  //////////////////////////////////////////////
  // Submit Feedback Function (Needs to be implemented later)
  //////////////////////////////////////////////
  void submitFeedback(int rating, String feedback) {
    print('Feedback submitted: Rating - $rating, Comment - $feedback');
    // Add logic here to send the feedback to a server or Firebase
    // For now, it just prints the result.
  }
}
