import 'package:flutter/material.dart';

/// OptionCard widget with a title, subtitle, and an `onTap` function for interactivity.
class OptionCard extends StatelessWidget {
  final String title; // Title displayed on the card
  final String subtitle; // Subtitle displayed on the card
  final VoidCallback onTap; // Function to handle the tap event (no parameters)

  const OptionCard({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // Use the onTap function directly
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Card(
          elevation: 5, // Slight elevation for better visibility
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10), // Rounded corners
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 15.0,
              horizontal: 20.0,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment:
                  CrossAxisAlignment.start, // Align text to the start
              children: [
                // Title Text
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  overflow: TextOverflow.visible, // Prevents text wrapping
                ),
                const SizedBox(height: 5),
                // Subtitle Text
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.visible, // Prevents text wrapping
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
