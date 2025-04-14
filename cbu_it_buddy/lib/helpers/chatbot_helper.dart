import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChatbotHelper {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 👇 New Together API Key
  static const String _apiKey = '9f6e9a6b9e6e9b557e03a24132aea6b528449152e02dd8bcc3d541157686a592';
  static const String _apiUrl = 'https://api.together.xyz/v1/chat/completions';

  // Toggle for testing
  static const bool useDummyResponse = false;

  Future<String> getAnswer(String question) async {
    try {
      print("👉 Getting answer for question: $question");

      final firestoreResponse = await _getFirestoreAnswer(question);
      if (firestoreResponse != null) {
        print("✅ Found Firestore match.");
        return firestoreResponse;
      }

      print("ℹ️ No Firestore match. Falling back to Together API...");

      if (useDummyResponse) {
        print("🧪 Using dummy response for testing.");
        return "This is a test response generated locally.";
      }

      final aiResponse = await _getTogetherResponse(question);
      print("✅ AI response received.");
      return aiResponse;
    } catch (e, stackTrace) {
      print('❌ ERROR in getAnswer(): $e');
      print('STACKTRACE: $stackTrace');
      return 'An error occurred. Please try again later.';
    }
  }

  ////////////////////////////////////////////////
  // 🔎 Get answer from Firestore
  ////////////////////////////////////////////////
  Future<String?> _getFirestoreAnswer(String question) async {
    try {
      String normalizedQuestion = question.toLowerCase();

      QuerySnapshot querySnapshot = await _firestore.collection('solutions').get();
      print("📄 Firestore documents fetched: ${querySnapshot.docs.length}");

      for (var doc in querySnapshot.docs) {
        if (!doc.data().toString().contains('title')) {
          print('⚠️ Skipping document [ID: ${doc.id}] - missing title');
          continue;
        }

        String title = doc['title']?.toString().toLowerCase() ?? '';
        if (title.isEmpty) continue;

        String pattern = _buildRegexPattern(title);
        print('🔍 Comparing question "$normalizedQuestion" with pattern "$pattern"');

        RegExp regExp = RegExp(r'\b(?:' + pattern + r')\b', caseSensitive: false);

        if (regExp.hasMatch(normalizedQuestion)) {
          String content = doc['summary'] ?? doc['content'] ?? 'No content available.';
          String link = doc['link'] ?? '';

          return _formatResponse(title, content, link);
        }
      }

      return null; // No match
    } catch (e) {
      print('❌ Firestore error: $e');
      return null;
    }
  }

  ////////////////////////////////////////////////
  // 🤖 Get response from Together API
  ////////////////////////////////////////////////
  Future<String> _getTogetherResponse(String question) async {
  try {
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $_apiKey',
    };

    QuerySnapshot querySnapshot = await _firestore.collection('solutions').get();
    String relevantContent = '';

    for (var doc in querySnapshot.docs) {
      if (!doc.data().toString().contains('title')) continue;

      String title = doc['title']?.toString().toLowerCase() ?? '';
      RegExp regExp = RegExp(r'\b(?:' + _buildRegexPattern(title) + r')\b', caseSensitive: false);

      if (regExp.hasMatch(question.toLowerCase())) {
        relevantContent = doc['summary'] ?? doc['content'] ?? '';
        break;
      }
    }

    String userPrompt;

    if (relevantContent.isNotEmpty) {
      print("✅ Firestore context found. Sending enhanced prompt.");
      userPrompt =
          "Based on the following content, please summarize and format a solution for the user:\n\n$relevantContent\n\nUser's question: $question";
    } else {
      print("⚠️ No context found. Sending raw user question to Together.");
      userPrompt = question;
    }

    final body = jsonEncode({
      "model": "meta-llama/Llama-4-Maverick-17B-128E-Instruct-FP8",
      "messages": [
        {
          "role": "system",
          "content": "You are a helpful assistant who specializes in IT support at a university."
        },
        {
          "role": "user",
          "content": userPrompt
        }
      ],
      "temperature": 0.7,
      "stream": false
    });

    final response = await http.post(Uri.parse(_apiUrl), headers: headers, body: body);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['choices'][0]['message']['content'].trim();
    } else {
      print('❌ API Error: ${response.statusCode} - ${response.body}');
      return "Sorry, I'm having trouble connecting to the assistant. Please try again later.";
    }
  } catch (e) {
    print('❌ Together API request failed: $e');
    return "Sorry, something went wrong with the assistant.";
  }
}


  ////////////////////////////////////////
  // 🧾 Format chatbot response
  ////////////////////////////////////////
  String _formatResponse(String title, String content, String link) {
    final buffer = StringBuffer();
    buffer.writeln('$title\n');
    buffer.writeln(content);

    if (link.isNotEmpty) {
      buffer.writeln('\n[View Full Solution]($link)');
    }

    return buffer.toString();
  }

  ////////////////////////////////////////
  // 🧠 Build regex pattern from title
  ////////////////////////////////////////
  String _buildRegexPattern(String title) {
    List<String> words = title
        .split(' ')
        .where((word) => word.length > 3)
        .map((word) => RegExp.escape(word))
        .toList();
    return words.join(r'\b|\b');
  }
}
