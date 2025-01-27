import 'package:flutter/material.dart';

//////////////////////////////////////////////
// StatelessWidget for displaying chat bubbles
//////////////////////////////////////////////
class ChatBubble extends StatelessWidget {
  final String message; // Message text
  final bool isUserMessage; // Check if it's a user or AI message
  final TextStyle? userMessageStyle; // Custom style for user message
  final TextStyle? aiMessageStyle; // Custom style for AI message
  final EdgeInsetsGeometry? padding; // Custom padding for bubble
  final EdgeInsetsGeometry? margin; // Custom margin for bubble

  const ChatBubble({
    Key? key,
    required this.message,
    required this.isUserMessage,
    this.userMessageStyle,
    this.aiMessageStyle,
    this.padding,
    this.margin,
  }) : super(key: key);

  //////////////////////////////////////////////
  // Build method for the ChatBubble UI
  //////////////////////////////////////////////
  @override
  Widget build(BuildContext context) {
    return Align(
      //////////////////////////////////////////////
      // Alignment based on message type (user or AI)
      //////////////////////////////////////////////
      alignment: isUserMessage ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        //////////////////////////////////////////////
        // Set margin and padding with default values if not provided
        //////////////////////////////////////////////
        margin: margin ??
            const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
        padding: padding ?? const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: isUserMessage
              ? const Color.fromARGB(255, 16, 92, 191) // User message color
              : const Color.fromARGB(255, 226, 172, 36), // AI message color
          //////////////////////////////////////////////
          // Set border radius based on message type
          //////////////////////////////////////////////
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
            bottomLeft: isUserMessage ? Radius.circular(20.0) : Radius.zero,
            bottomRight: isUserMessage ? Radius.zero : Radius.circular(20.0),
          ),
          //////////////////////////////////////////////
          // Apply shadow for subtle elevation
          //////////////////////////////////////////////
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1), // Shadow color
              blurRadius: 4.0, // Shadow blur effect
              spreadRadius: 2.0, // Shadow spread effect
            ),
          ],
        ),
        //////////////////////////////////////////////
        // Constraints to make the bubble responsive
        //////////////////////////////////////////////
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7, // Max bubble width
        ),
        //////////////////////////////////////////////
        // Text widget to display message content with style based on message type
        //////////////////////////////////////////////
        child: Text(
          message,
          style: isUserMessage
              ? userMessageStyle ??
                  const TextStyle(
                    color: Colors.white, // Default color for user message
                    fontSize: 14.0,
                  )
              : aiMessageStyle ??
                  const TextStyle(
                    color: Colors.black, // Default color for AI message
                    fontSize: 14.0,
                  ),
        ),
      ),
    );
  }
}
