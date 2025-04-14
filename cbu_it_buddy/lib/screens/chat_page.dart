import 'dart:async'; // Import Timer
import 'package:flutter/material.dart';
import '../widgets/chat_bubbles.dart';
import '../helpers/chatbot_helper.dart';
import '../services/bible_service.dart';
import '../widgets/option_card.dart';

class ChatPage extends StatefulWidget {
  final String query;

  const ChatPage({super.key, required this.query});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final ChatbotHelper _chatbotHelper = ChatbotHelper();
  final List<Map<String, dynamic>> _chatMessages = [];
  final TextEditingController _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _hasSubmittedMessage = false;

  @override
  void initState() {
    super.initState();
    _fetchBibleVerse(); // Fetch the Bible verse when the page loads
  }

  Future<void> _fetchBibleVerse() async {
    String verse = await BibleService().fetchBibleVerse();

    // Display the first message with the Bible verse
    setState(() {
      _chatMessages.add(
          {"message": "Verse of the day:\n\n$verse", "isUserMessage": false});
    });

    // Add a 2-second delay for the follow-up message
    Timer(const Duration(seconds: 2), () {
      setState(() {
        _chatMessages.add({
          "message": "Is there anything I can help you with today?",
          "isUserMessage": false
        });
      });
    });
  }

  void _handleSubmitMessage() async {
    if (_textController.text.isNotEmpty) {
      final String userMessage = _textController.text;

      setState(() {
        _chatMessages.add({"message": userMessage, "isUserMessage": true});
        _hasSubmittedMessage = true;
      });

      String botResponse = await _chatbotHelper.getAnswer(userMessage);

      setState(() {
        _chatMessages.add({"message": botResponse, "isUserMessage": false});
        _textController.clear();
      });
    }
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
      appBar: AppBar(
        toolbarHeight: 30.0,
        centerTitle: true,
        title: const Text( "IT-Buddy",
    style: TextStyle(
      fontWeight: FontWeight.bold, // Make the font bold
    ),
  ),
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
                padding: const EdgeInsets.symmetric(vertical: 6.0),
                child: Row(
                  children: [
                    const SizedBox(width: 16.0),
                    OptionCard(
                      title: "Reset Password",
                      subtitle: "All Accounts",
                      onTap: () => _submitQuickMessage("Reset Password"),
                    ),
                    OptionCard(
                      title: "Reset MFA",
                      subtitle: "Microsoft Authenticator, phone number",
                      onTap: () => _submitQuickMessage("Reset MFA"),
                    ),
                    OptionCard(
                      title: "WiFi - Problems",
                      subtitle: "CBU-SECURE, CBU...",
                      onTap: () => _submitQuickMessage("WiFi - Problems"),
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
                      hintText: "Enter a prompt here...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 16.0),
                    ),
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

  void _submitQuickMessage(String message) {
    setState(() {
      _textController.text = message;
    });
    _handleSubmitMessage();
  }
}
