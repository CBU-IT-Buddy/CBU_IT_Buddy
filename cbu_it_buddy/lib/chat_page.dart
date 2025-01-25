import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'chat_bubbles.dart';
import 'helpers/chatbot_helper.dart'; // Import the helper class

class ChatPage extends StatefulWidget {
  final String query;

  const ChatPage({Key? key, required this.query}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final ChatbotHelper _chatbotHelper = ChatbotHelper();
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance; // Firestore instance
  List<Map<String, dynamic>> _chatMessages = [];
  String _chatMessage = "";
  final TextEditingController _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _hasSubmittedMessage = false;

  @override
  void initState() {
    super.initState();
    _textController.addListener(() {
      setState(() {
        _chatMessage =
            _textController.text; // Update _chatMessage as the user types
      });
    });
    _fetchBibleVerse(); // Fetch the Bible verse when the page loads
  }

  Future<void> _fetchBibleVerse() async {
    try {
      // Fetch a random Bible verse from Firestore
      final QuerySnapshot querySnapshot =
          await _firestore.collection('bibleverse').get();
      if (querySnapshot.docs.isNotEmpty) {
        final randomVerse = querySnapshot.docs.first; // Select the first verse
        final verseText = randomVerse['verse'] ??
            'No verse available'; // Ensure there's a fallback
        setState(() {
          _chatMessages.add({
            "message": verseText,
            "isUserMessage": false,
          });
        });
      } else {
        setState(() {
          _chatMessages.add({
            "message": "No Bible verses available at the moment.",
            "isUserMessage": false,
          });
        });
      }
    } catch (e) {
      setState(() {
        _chatMessages.add({
          "message": "Error fetching Bible verse: $e",
          "isUserMessage": false,
        });
      });
    }
  }

  void _handleSubmitMessage() async {
    print("Sending Question: $_chatMessage"); // Debug print
    if (_chatMessage.isNotEmpty) {
      setState(() {
        _chatMessages.add({
          "message": _chatMessage,
          "isUserMessage": true,
        });
        _hasSubmittedMessage = true;
      });

      String botResponse = await _chatbotHelper.getAnswer(_chatMessage);

      print("Bot Response: $botResponse"); // Debug print

      setState(() {
        _chatMessages.add({
          "message": botResponse,
          "isUserMessage": false,
        });
      });

      setState(() {
        _chatMessage = "";
        _textController.clear();
      });
    }
  }

  Future<void> _getBotResponse(String question) async {
    String botResponse = await _chatbotHelper.getAnswer(question);

    setState(() {
      _chatMessages.add({
        "message": botResponse,
        "isUserMessage": false,
      });
    });
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
        title: const Text("Chat with IT Buddy"),
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
                    _optionCard("Reset Password", "All Accounts"),
                    _optionCard(
                        "Reset MFA", "Microsoft Authenticator, phone number"),
                    _optionCard("WiFi - Problems", "CBU-SECURE, CBU..."),
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

  Widget _optionCard(String title, String subtitle) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _chatMessage = title;
          _textController.text = _chatMessage;
        });
        _focusNode.requestFocus();
        _handleSubmitMessage(); // Submit the message after it's set
      },
      child: Card(
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(subtitle),
            ],
          ),
        ),
      ),
    );
  }
}
