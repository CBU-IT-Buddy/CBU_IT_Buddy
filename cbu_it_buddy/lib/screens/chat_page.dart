import 'dart:async'; // Import Timer
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/chat_bubbles.dart';
import '../helpers/chatbot_helper.dart';
import '../services/bible_service.dart';
import '../widgets/option_card.dart';
import 'package:firebase_core/firebase_core.dart'; // ✅ Ensure Firebase is imported

class ChatPage extends StatefulWidget {
  final String query;

  const ChatPage({Key? key, required this.query}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final ChatbotHelper _chatbotHelper = ChatbotHelper();
  final List<Map<String, dynamic>> _chatMessages = [];
  final TextEditingController _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _hasSubmittedMessage = false;
  bool _isFirebaseInitialized = false; // ✅ Track Firebase initialization

  @override
  void initState() {
    super.initState();
    _initializeFirebaseAndLoadData();
  }

  // ✅ Ensure Firebase is initialized before fetching Bible verse
  Future<void> _initializeFirebaseAndLoadData() async {
    try {
      await Firebase.initializeApp(); // ✅ Ensures Firebase is initialized
      print("🟢 Firebase initialized inside ChatPage");
      setState(() {
        _isFirebaseInitialized = true;
      });
      _fetchBibleVerse();
    } catch (e) {
      print("❌ ERROR: Firebase failed to initialize in ChatPage: $e");
    }
  }

  Future<void> _fetchBibleVerse() async {
    if (!_isFirebaseInitialized) return; // ✅ Ensure Firebase is ready before running
    String verse = await BibleService().fetchBibleVerse();

    // Display the first message with the Bible verse
    setState(() {
      _chatMessages
          .add({"message": "Hi Lancer!\n\n'$verse'", "isUserMessage": false});
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

      // ✅ FIX: Extract both "summary" and "content" from the response
      Map<String, String> botResponseMap = await _chatbotHelper.getAnswer(userMessage);
      String botSummary = botResponseMap["summary"] ?? "No summary available.";
      String botContent = botResponseMap["content"] ?? "No response available.";

      setState(() {
        // ✅ First, show the summary as a chatbot response
        _chatMessages.add({"message": "**Summary:** $botSummary", "isUserMessage": false});

        // ✅ Then, show the full content as another response
        _chatMessages.add({"message": botContent, "isUserMessage": false});

        _textController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("IT-Buddy"),
      ),
<<<<<<< Updated upstream
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
=======
      body: _isFirebaseInitialized
          ? Column(
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
>>>>>>> Stashed changes
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
            )
          : const Center(
              child: CircularProgressIndicator(), // ✅ Show a loading indicator until Firebase initializes
            ),
    );
  }
}
