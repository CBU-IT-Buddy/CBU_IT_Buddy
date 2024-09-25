import 'package:flutter/material.dart';

//////////////////////////////////////////////
// OptionCard widget with title and subtitle
// Now includes onTap function for interactivity
//////////////////////////////////////////////
class OptionCard extends StatelessWidget {
  final String title; // Title for the option card
  final String subtitle; // Subtitle for the option card
  final Function(String) onTap; // Function to handle the tap event

  OptionCard(
      {required this.title, required this.subtitle, required this.onTap});

  @override
  Widget build(BuildContext context) {
    //////////////////////////////////////////////
    // GestureDetector to make the card clickable
    //////////////////////////////////////////////
    return GestureDetector(
      onTap: () =>
          onTap(title), // When tapped, pass the title to the onTap function
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        child: Card(
          elevation: 3,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //////////////////////////////////////////////
                // Title text for the card
                //////////////////////////////////////////////
                Text(
                  title,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  overflow: TextOverflow.visible, // Prevent text wrapping
                ),
                SizedBox(height: 5),
                //////////////////////////////////////////////
                // Subtitle text for the card
                //////////////////////////////////////////////
                Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                  overflow: TextOverflow.visible, // Prevent text wrapping
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
