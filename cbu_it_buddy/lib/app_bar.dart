import 'package:flutter/material.dart';

//////////////////////////////////////////////
// Function to build the AppBar for the app
//////////////////////////////////////////////
AppBar buildAppBar() {
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
        child: Image.asset(
          '/Users/dartagnancalitz/CBU_IT_Buddy/cbu_it_buddy/lib/assets/images/cbu_logo.png', // Make sure the path matches your folder structure
          width: 50, // Set a fixed width to prevent overflow
          height: 50, // Set a fixed height to prevent overflow
          fit: BoxFit
              .contain, // Ensure the image fits within the given dimensions
        ),
      ),
    ],
  );
}
