import 'package:flutter/material.dart';
import 'option_card.dart';

//////////////////////////////////////////////
// StatefulWidget to manage the chat bar state
//////////////////////////////////////////////
class CBUITBuddyHomePage extends StatefulWidget {
  @override
  _CBUITBuddyHomePageState createState() => _CBUITBuddyHomePageState();
}

class _CBUITBuddyHomePageState extends State<CBUITBuddyHomePage> {
  //////////////////////////////////////////////
  // Holds the text for the chat bar
  //////////////////////////////////////////////
  String _chatMessage = "";

  //////////////////////////////////////////////
  // FocusNode to manage focus for the TextField
  //////////////////////////////////////////////
  final FocusNode _focusNode = FocusNode();

  //////////////////////////////////////////////
  // Function to handle option card selection
  // Updates the chat bar with the title of the tapped option
  //////////////////////////////////////////////
  void _handleOptionTap(String title) {
    setState(() {
      _chatMessage = title; // Set the chat bar text to the option card title
    });
    _focusNode
        .requestFocus(); // Request focus for the TextField to show keyboard
  }

  @override
  void dispose() {
    _focusNode.dispose(); // Clean up the focus node when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Setting resizeToAvoidBottomInset to true to move widgets above the keyboard
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          // Main Column to hold the icon and options
          Column(
            children: [
              SizedBox(height: 40.0), // Added spacing at the top
              Icon(Icons.handshake, size: 80), // Placeholder for the hand icon
              Spacer(), // Pushes the options down
              // Horizontally scrollable row of option cards
              Padding(
                padding: const EdgeInsets.only(
                    bottom: 80.0), // Space between buttons and chat box
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      SizedBox(width: 16.0),
                      OptionCard(
                        title: "Reset Password",
                        subtitle: "All Accounts",
                        onTap:
                            _handleOptionTap, // Pass the handler to the OptionCard
                      ),
                      OptionCard(
                        title: "Reset MFA",
                        subtitle: "Microsoft Authenticator, phone number",
                        onTap:
                            _handleOptionTap, // Pass the handler to the OptionCard
                      ),
                      OptionCard(
                        title: "WiFi - Problems",
                        subtitle: "CBU-SECURE, CBU...",
                        onTap:
                            _handleOptionTap, // Pass the handler to the OptionCard
                      ),
                      // Add more option cards if needed
                      SizedBox(width: 16.0),
                    ],
                  ),
                ),
              ),
            ],
          ),
          // Chat Bar positioned at the bottom of the screen
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  // Message input field
                  Expanded(
                    child: TextField(
                      focusNode:
                          _focusNode, // Attach the FocusNode to the TextField
                      decoration: InputDecoration(
                        hintText: "Type your message...",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                      ),
                      controller: TextEditingController(
                          text: _chatMessage), // Autofill chat bar
                    ),
                  ),
                  SizedBox(width: 10),
                  // Send button for sending messages
                  IconButton(
                    icon: Icon(Icons.send,
                        color: const Color.fromARGB(255, 11, 54, 90)),
                    onPressed: () {
                      // Send message action
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
