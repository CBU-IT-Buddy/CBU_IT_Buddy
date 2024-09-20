import 'package:cbu_it_buddy/app_bar.dart'; // Custom AppBar file import
import 'package:flutter/material.dart';
import 'home_page.dart'; // HomePage file import

//////////////////////////////////////////////
// Main function to run the app
//////////////////////////////////////////////
void main() {
  runApp(CBUITBuddyApp()); // Entry point of the app
}

//////////////////////////////////////////////
// Main StatelessWidget class for the app
//////////////////////////////////////////////
class CBUITBuddyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //////////////////////////////////////////////
      // Scaffold to provide structure for the app
      //////////////////////////////////////////////
      home: Scaffold(
        //////////////////////////////////////////////
        // Custom AppBar at the top of the screen
        //////////////////////////////////////////////
        appBar: buildAppBar(),

        //////////////////////////////////////////////
        // HomePage widget as the body of the app
        //////////////////////////////////////////////
        body: CBUITBuddyHomePage(),
      ),
    );
  }
}
