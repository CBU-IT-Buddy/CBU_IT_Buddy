import 'package:flutter/material.dart';
import 'chat_bubbles.dart';
import 'package:flutter/services.dart' show rootBundle;

class ChatPage extends StatefulWidget {
  final String query;

  const ChatPage({Key? key, required this.query}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<Map<String, dynamic>> _chatMessages = [];
  String _chatMessage = "";
  final TextEditingController _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _hasSubmittedMessage = false;

  Future<String> _fetchSolution(String query) async {
    final Map<String, String> fileMap = {
      'reset password': 'password_reset.txt',
      'reset mfa': 'mfa_reset.txt',
      'wifi problems': 'wifi_problems.txt',
    };

    String? fileName;
    fileMap.forEach((keyword, fName) {
      if (query.toLowerCase().contains(keyword.toLowerCase())) {
        fileName = fName;
      }
    });

    if (fileName == null) {
      return 'Sorry, I could not find a solution for that query.';
    }

    try {
      String content = await rootBundle.loadString('lib/solution/$fileName');
      return content;
    } catch (e) {
      return 'Error loading solution file.';
    }
  }

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

      // Fetch the actual solution based on the message
      String botResponse = await _fetchSolution(widget.query);

      setState(() {
        _chatMessages.add({
          "message": botResponse,
          "isUserMessage": false,
        });
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
