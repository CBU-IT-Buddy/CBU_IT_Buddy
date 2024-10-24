import 'package:flutter/material.dart';
import 'option_card.dart';

class CBUITBuddyHomePage extends StatelessWidget {
  const CBUITBuddyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //////////////////////////////////////////////
      //Brian's part
      //////////////////////////////////////////////
      appBar: AppBar(
        title: const Text("New Chat"), // Optional AppBar for the chat page
      ),
      //////////////////////////////////////////////
      // Add the main body with Material context
      //////////////////////////////////////////////
      body: Stack(
        children: [
          //////////////////////////////////////////////
          // Main Column to hold the icon and options
          //////////////////////////////////////////////
          const Column(
            children: [
              SizedBox(height: 40.0), // Added spacing at the top
              Icon(Icons.handshake, size: 80), // Placeholder for the hand icon
              Spacer(), // Pushes the options down
              //////////////////////////////////////////////
              // Horizontally scrollable row of option cards
              // Positioned just above the chat bar
              //////////////////////////////////////////////
              Padding(
                padding: EdgeInsets.only(
                    bottom: 80.0), // Space between buttons and chat box
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      SizedBox(width: 16.0),
                      OptionCard(
                          title: "Reset Password", subtitle: "All Accounts"),
                      OptionCard(
                          title: "Reset MFA",
                          subtitle: "Microsoft Authenticator, phone number"),
                      OptionCard(
                          title: "WiFi - Problems",
                          subtitle: "CBU-SECURE, CBU..."),
                      // Add more option cards if needed
                      SizedBox(width: 16.0),
                    ],
                  ),
                ),
              ),
            ],
          ),
          //////////////////////////////////////////////
          // Chat Bar positioned at the bottom of the screen
          //////////////////////////////////////////////
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  //////////////////////////////////////////////
                  // Message input field
                  //////////////////////////////////////////////
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Type your message...",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 16.0),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  //////////////////////////////////////////////
                  // Send button for sending messages
                  //////////////////////////////////////////////
                  IconButton(
                    icon: const Icon(Icons.send,
                        color: Color.fromARGB(255, 11, 54, 90)),
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
