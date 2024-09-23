import 'package:flutter/material.dart';

class OptionCard extends StatelessWidget {
  final String title;
  final String subtitle;

  const OptionCard({super.key, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    //////////////////////////////////////////////
    // Container for each option card
    //////////////////////////////////////////////
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //////////////////////////////////////////////
              // Title text for the card
              //////////////////////////////////////////////
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                overflow: TextOverflow.visible, // Prevent text wrapping
              ),
              const SizedBox(height: 5),
              //////////////////////////////////////////////
              // Subtitle text for the card
              //////////////////////////////////////////////
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey, fontSize: 12),
                overflow: TextOverflow.visible, // Prevent text wrapping
              ),
            ],
          ),
        ),
      ),
    );
  }
}
