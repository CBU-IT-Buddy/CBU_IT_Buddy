import 'package:flutter/material.dart';
import 'chat_bubbles.dart';
import 'option_card.dart';

class CBUITBuddyHomePage extends StatefulWidget {
  const CBUITBuddyHomePage({Key? key}) : super(key: key);

  @override
  _CBUITBuddyHomePageState createState() => _CBUITBuddyHomePageState();
}

class _CBUITBuddyHomePageState extends State<CBUITBuddyHomePage> {
  // Holds the chat messages (user and AI)
  List<Map<String, dynamic>> _chatMessages = [];

  // Holds the current message typed by the user
  String _chatMessage = "";

  // TextEditingController for the TextField input
  final TextEditingController _textController = TextEditingController();

  // FocusNode to handle keyboard focus on the TextField
  final FocusNode _focusNode = FocusNode();

  // State variable to check if a message has been submitted
  bool _hasSubmittedMessage = false;

  // Function to handle message submission
  void _handleSubmitMessage() async {
    if (_chatMessage.isNotEmpty) {
      setState(() {
        // Add user message to the chat
        _chatMessages.add({
          "message": _chatMessage,
          "isUserMessage": true,
        });
        _chatMessage = ""; // Clear the input
        _textController.clear(); // Clear the text input field
        _hasSubmittedMessage = true; // Update state to indicate message submission
      });

      // Simulate AI response delay (e.g., 1 second)
      await Future.delayed(const Duration(seconds: 1));

      // Add a mock AI response after the delay
      setState(() {
        _chatMessages.add({
          "message": "This is a generic AI response.", // Mock AI response
          "isUserMessage": false,
        });
      });
    }
  }

  // Function to handle option card selection
  void _handleOptionTap(String title) {
    setState(() {
      _chatMessage = title; // Set the chat bar text to the option card title
      _textController.text = _chatMessage; // Update the TextField controller
    });
    _focusNode.requestFocus(); // Request focus for the TextField to show keyboard
    _handleSubmitMessage(); // Automatically submit the message
  }

  @override
  void dispose() {
    _focusNode.dispose(); // Clean up the focus node when the widget is disposed
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true, // Adjust the layout when the keyboard appears
      appBar: AppBar(
        title: const Text("New Chat"),
      ),
      body: Column(
        children: [
          // Expanded widget to display the chat bubbles
          Expanded(
            child: ListView.builder(
              reverse: true, // Newest messages at the bottom
              itemCount: _chatMessages.length,
              itemBuilder: (context, index) {
                final messageData = _chatMessages[_chatMessages.length - 1 - index];
                return ChatBubble(
                  message: messageData['message'],
                  isUserMessage: messageData['isUserMessage'],
                );
              },
            ),
          ),
          // Option cards only shown if no message has been submitted
          if (!_hasSubmittedMessage)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Row(
                  children: [
                    const SizedBox(width: 16.0),
                    OptionCard(
                      title: "Reset Password",
                      subtitle: "All Accounts",
                      onTap: _handleOptionTap,
                    ),
                    OptionCard(
                      title: "Reset MFA",
                      subtitle: "Microsoft Authenticator, phone number",
                      onTap: _handleOptionTap,
                    ),
                    OptionCard(
                      title: "WiFi - Problems",
                      subtitle: "CBU-SECURE, CBU...",
                      onTap: _handleOptionTap,
                    ),
                    const SizedBox(width: 16.0),
                  ],
                ),
              ),
            ),
          // Chat Bar at the bottom of the screen
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                // Expanded TextField for user input
                Expanded(
                  child: TextField(
                    focusNode: _focusNode, // Attach focus to the TextField
                    controller: _textController, // Handle user input
                    decoration: InputDecoration(
                      hintText: "Type your message...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _chatMessage = value; // Update chat message state
                      });
                    },
                  ),
                ),
                const SizedBox(width: 10),
                // Send button for submitting messages
                IconButton(
                  icon: const Icon(Icons.send, color: Color.fromARGB(255, 11, 54, 90)),
                  onPressed: _handleSubmitMessage, // Call the submit function on press
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
