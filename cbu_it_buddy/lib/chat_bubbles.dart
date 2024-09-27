import 'package:flutter/material.dart';

//////////////////////////////////////////////
// StatelessWidget for displaying chat bubbles
//////////////////////////////////////////////
class ChatBubble extends StatelessWidget {
  final String message; // Message text
  final bool isUserMessage; // Check if it's a user or AI message

  ChatBubble({required this.message, required this.isUserMessage});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isUserMessage ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
        padding: EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: isUserMessage
              ? const Color(0xFF4BAEFF)
              : const Color.fromARGB(179, 255, 191, 0),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12.0),
            topRight: Radius.circular(12.0),
            bottomLeft: isUserMessage ? Radius.circular(12.0) : Radius.zero,
            bottomRight: isUserMessage ? Radius.zero : Radius.circular(12.0),
          ),
        ),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width *
              0.7, // Make the bubble responsive
        ),
        child: Text(
          message,
          style: TextStyle(
            color: Colors.black,
            fontSize: 14.0,
          ),
        ),
      ),
    );
  }
}
