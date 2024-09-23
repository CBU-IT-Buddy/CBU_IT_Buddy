import 'package:flutter/material.dart';
import 'app_bar.dart'; // Custom AppBar file import
import 'home_page.dart'; // HomePage file import
import 'feedback_page.dart'; // Import FeedbackPage

//////////////////////////////////////////////
// Main function to run the app
//////////////////////////////////////////////
void main() {
  runApp(const CBUITBuddyApp()); // Entry point of the app
}

//////////////////////////////////////////////
// Main StatelessWidget class for the app
//////////////////////////////////////////////
class CBUITBuddyApp extends StatelessWidget {
  const CBUITBuddyApp({super.key});

  // Variable to control which page is shown first
  static const bool showFeedbackPageFirst = true; // Set to false to show HomePage first

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //////////////////////////////////////////////
      // Dynamically set which page to show first
      //////////////////////////////////////////////
      home: showFeedbackPageFirst 
          ? const FeedbackPage()  // Show FeedbackPage if true
          : Scaffold(
              appBar: buildAppBar(context), // Custom AppBar
              body: const CBUITBuddyHomePage(), // HomePage
            ),
    );
  }
}
