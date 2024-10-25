import 'package:flutter/material.dart';
import 'feedback_page.dart'; // Import the FeedbackPage

//////////////////////////////////////////////
// Function to build the AppBar for the app
//////////////////////////////////////////////
AppBar buildAppBar(BuildContext context) {  // Pass BuildContext as a parameter
  return AppBar(
    //////////////////////////////////////////////
    // Title for the AppBar (centered)
    //////////////////////////////////////////////
    title: const Text("CBU-IT-Buddy"),
    centerTitle: true,

    //////////////////////////////////////////////
    // Leading icon (menu button on the left)
    //////////////////////////////////////////////
    leading: IconButton(
      icon: const Icon(Icons.menu),
      onPressed: () {
        // Action for menu button
      },
    ),

    //////////////////////////////////////////////
    // Actions (logo image on the right)
    //////////////////////////////////////////////
    actions: [
      Padding(
        padding: const EdgeInsets.only(right: 10.0),
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.feedback),
              onPressed: () {
                // Navigate to Feedback page
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FeedbackPage(),
                  ),
                );
              },
            ),
            Image.asset(
              '/Users/dartagnancalitz/CBU_IT_Buddy/cbu_it_buddy/lib/assets/images/cbu_logo.png', // Make sure the path matches your folder structure
              width: 50,
              height: 50,
              fit: BoxFit.contain,
            ),
          ],
        ),
      ),
    ],
  );
}
