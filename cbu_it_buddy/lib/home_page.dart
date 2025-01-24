import 'package:flutter/material.dart';
import 'chat_bubbles.dart';
import 'option_card.dart';
import 'helpers/chatbot_helper.dart'; // Import ChatbotHelper for Firestore integration

class CBUITBuddyHomePage extends StatefulWidget {
  const CBUITBuddyHomePage({Key? key}) : super(key: key);

  @override
  _CBUITBuddyHomePageState createState() => _CBUITBuddyHomePageState();
}

class _CBUITBuddyHomePageState extends State<CBUITBuddyHomePage> {
  final ChatbotHelper _chatbotHelper =
      ChatbotHelper(); // Firestore helper instance
  List<Map<String, dynamic>> _chatMessages = [];
  String _chatMessage = "";
  final TextEditingController _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _hasSubmittedMessage = false;

  void _handleSubmitMessage() async {
    if (_chatMessage.isNotEmpty) {
      setState(() {
        _chatMessages.add({
          "message": _chatMessage,
          "isUserMessage": true,
        });
        _chatMessage = "";
        _textController.clear();
        _hasSubmittedMessage = true;
      });

      // Fetch the bot's response using Firestore
      String botResponse = await _chatbotHelper.getAnswer(_chatMessage);

      setState(() {
        _chatMessages.add({
          "message": botResponse,
          "isUserMessage": false,
        });
      });
    }
  }

  void _handleOptionTap(String title) {
    setState(() {
      _chatMessage = title;
      _textController.text = _chatMessage;
    });
    _focusNode.requestFocus();
    _handleSubmitMessage();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text("New Chat"),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: _chatMessages.length,
              itemBuilder: (context, index) {
                final messageData =
                    _chatMessages[_chatMessages.length - 1 - index];
                return ChatBubble(
                  message: messageData['message'],
                  isUserMessage: messageData['isUserMessage'],
                );
              },
            ),
          ),
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
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    focusNode: _focusNode,
                    controller: _textController,
                    decoration: InputDecoration(
                      hintText: "Type your message...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 16.0),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _chatMessage = value;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 10),
                IconButton(
                  icon: const Icon(Icons.send,
                      color: Color.fromARGB(255, 11, 54, 90)),
                  onPressed: _handleSubmitMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
