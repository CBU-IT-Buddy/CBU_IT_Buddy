import 'package:flutter/material.dart';

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({Key? key}) : super(key: key);

  @override
  _FeedbackPageState createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  int _rating = 0; // Rating value from 1 to 5
  String _userFeedback = ""; // Stores user feedback text
  final _feedbackController =
      TextEditingController(); // Controller for TextField input

  //////////////////////////////////////////////
  // Function to submit feedback (mock implementation)
  //////////////////////////////////////////////
  void submitFeedback(int rating, String feedback) {
    print('Feedback submitted: Rating - $rating, Comment - $feedback');
    // Logic to send feedback to a server or Firebase can be implemented here.
  }

  //////////////////////////////////////////////
  // Function to reset the form (clears rating, feedback text)
  //////////////////////////////////////////////
  void _resetForm() {
    setState(() {
      _rating = 0;
      _userFeedback = "";
      _feedbackController.clear(); // Clear TextField input
    });
  }

  //////////////////////////////////////////////
  // Widget build for FeedbackPage UI
  //////////////////////////////////////////////
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feedback Page'),
        centerTitle: true, // Center-align the AppBar title
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //////////////////////////////////////////////
            // Title and instructions for feedback
            //////////////////////////////////////////////
            const Text(
              'We value your feedback!',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text('Please rate your experience (1 to 5 stars):'),

            //////////////////////////////////////////////
            // Row of star icons for rating input
            //////////////////////////////////////////////
            Row(
              children: List.generate(5, (starIndex) {
                return IconButton(
                  icon: Icon(
                    starIndex < _rating
                        ? Icons.star
                        : Icons.star_border, // Filled star if selected
                    color: Colors.amber,
                  ),
                  onPressed: () {
                    setState(() {
                      _rating =
                          starIndex + 1; // Set rating to clicked star's index
                    });
                  },
                );
              }),
            ),

            //////////////////////////////////////////////
            // Message prompting user to select a rating if rating is zero
            //////////////////////////////////////////////
            if (_rating == 0)
              const Text(
                'Please select a rating from 1 to 5 stars.',
                style: TextStyle(color: Colors.red),
              ),

            const SizedBox(height: 20),

            //////////////////////////////////////////////
            // Feedback input field
            //////////////////////////////////////////////
            const Text('Your feedback:'),
            TextField(
              controller:
                  _feedbackController, // Controller to manage TextField input
              onChanged: (value) {
                setState(() {
                  _userFeedback = value; // Update feedback as user types
                });
              },
              decoration: InputDecoration(
                hintText: 'Enter your feedback here',
                border: const OutlineInputBorder(),
                //////////////////////////////////////////////
                // Error message if feedback is empty and rating is selected
                //////////////////////////////////////////////
                errorText: _userFeedback.isEmpty && _rating > 0
                    ? 'Please enter feedback.'
                    : null,
              ),
              maxLines: 4,
            ),

            const SizedBox(height: 20),

            //////////////////////////////////////////////
            // Row with Submit and Reset buttons
            //////////////////////////////////////////////
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //////////////////////////////////////////////
                // Submit button logic
                //////////////////////////////////////////////
                ElevatedButton(
                  onPressed: () {
                    if (_rating > 0 && _userFeedback.isNotEmpty) {
                      submitFeedback(_rating, _userFeedback);
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Thank you!'),
                          content: const Text('Thank you for your feedback!'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                _resetForm(); // Reset form after successful submission
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          'Feedback submitted successfully!')),
                                );
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        ),
                      );
                    } else {
                      //////////////////////////////////////////////
                      // Error alert if rating or feedback is missing
                      //////////////////////////////////////////////
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Error'),
                          content: const Text(
                              'Please provide a rating and feedback.'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('OK'),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                  child: const Text('Submit'),
                ),

                //////////////////////////////////////////////
                // Reset button logic (resets rating and feedback input)
                //////////////////////////////////////////////
                ElevatedButton(
                  onPressed: () {
                    _resetForm(); // Clear the form fields
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
}
