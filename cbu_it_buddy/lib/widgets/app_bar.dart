import 'package:flutter/material.dart';
import '../services/feedback_page.dart'; // Import the FeedbackPage
// Import the GameView widget

//////////////////////////////////////////////
// Function to build the AppBar for the app
//////////////////////////////////////////////
AppBar buildAppBar(BuildContext context) {
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
        // Action for menu button: You can use a Drawer or another feature
        Scaffold.of(context).openDrawer(); // Example of opening a Drawer
      },
    ),

    //////////////////////////////////////////////
    // Actions (logo image and feedback button on the right)
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
            // Logo image with an asset path
            Image.asset(
              'lib/assets/images/cbu_logo.png', // Relative path based on the project structure
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
