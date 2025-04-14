import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChatbotHelper {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // API key for DeepSeek
  static const String _apiKey = 'sk-be248f60c71b4e46b3f2ed553c315091';
  static const String _apiUrl = 'https://api.deepseek.com/v1/chat/completions';

  // Get the answer to the question
  Future<String> getAnswer(String question) async {
    try {
      // First try Firestore lookup
      final firestoreResponse = await _getFirestoreAnswer(question);
      if (firestoreResponse != null) {
        return firestoreResponse; // Firestore solution found, return it
      }

      // If no Firestore match, use DeepSeek to fetch a detailed answer based on the content
      return await _getDeepSeekResponse(question);
    } catch (e, stackTrace) {
      print('Error: $e');
      print(stackTrace);
      return 'An error occurred. Please try again later.';
    }
  }

  ////////////////////////////////////////////////
  // Get answer from Firestore
  ////////////////////////////////////////////////
  Future<String?> _getFirestoreAnswer(String question) async {
    try {
      String normalizedQuestion = question.toLowerCase();

      // Query Firestore for all solutions
      QuerySnapshot querySnapshot =
          await _firestore.collection('solutions').get();

      // Iterate through the documents to find a match
      for (var doc in querySnapshot.docs) {
        String title = doc['title']?.toString().toLowerCase() ?? '';
        print(
            'Comparing Question: "$normalizedQuestion" with Title: "$title"'); // Debug print

        // Match keywords in title using regex
        RegExp regExp = RegExp(r'\b(?:' + _buildRegexPattern(title) + r')\b',
            caseSensitive: false);

        if (regExp.hasMatch(normalizedQuestion)) {
          String content = doc['content'] ?? 'No content available.';
          String link = doc['link'] ?? '';

          // Format the response based on Firestore article
          return _formatResponse(title, content, link);
        }
      }
      return null; // No matching article found in Firestore
    } catch (e) {
      print('Firestore error: $e');
      return null;
    }
  }

  ////////////////////////////////////////////////
  // Get response from DeepSeek API with Firestore context
  ////////////////////////////////////////////////
  Future<String> _getDeepSeekResponse(String question) async {
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $_apiKey',
    };

    // Query Firestore for all solutions
    QuerySnapshot querySnapshot =
        await _firestore.collection('solutions').get();

    String relevantContent = '';

    // Search Firestore for the most relevant article to provide context for DeepSeek
    for (var doc in querySnapshot.docs) {
      String title = doc['title']?.toString().toLowerCase() ?? '';

      // Use regex to match relevant articles
      RegExp regExp = RegExp(r'\b(?:' + _buildRegexPattern(title) + r')\b',
          caseSensitive: false);
      if (regExp.hasMatch(question.toLowerCase())) {
        relevantContent = doc['content'] ?? '';
        break; // Stop after the first match
      }
    }

    // If no relevant Firestore article is found, fall back to a generic DeepSeek query
    if (relevantContent.isEmpty) {
      return "Sorry, I couldn't find a relevant solution article.";
    }

    final body = jsonEncode({
      "model": "deepseek-chat",
      "messages": [
        {
          "role": "system",
          "content":
              "You are a helpful assistant who specializes in IT solutions."
        },
        {
          "role": "user",
          "content":
              "Based on the following content, please summarize and format a solution for the user:\n\n$relevantContent\n\nUser's question: $question"
        }
      ],
      "temperature": 0.7,
      "stream": false
    });

    final response = await http.post(
      Uri.parse(_apiUrl),
      headers: headers,
      body: body,
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['choices'][0]['message']['content'].trim();
    } else {
      print('API Error: ${response.statusCode} - ${response.body}');
      return "Sorry, I'm having trouble connecting to the assistant. Please try again later.";
    }
  }

  ////////////////////////////////////////
  // Format the chatbot response
  ////////////////////////////////////////
  String _formatResponse(String title, String content, String link) {
    StringBuffer responseBuffer = StringBuffer();
    responseBuffer.writeln('$title\n');
    responseBuffer.writeln(content);

    // If link is available, add a Markdown-style hyperlink
    if (link.isNotEmpty) {
      responseBuffer.writeln('\n[View Full Solution]($link)');
    }

    return responseBuffer.toString(); // Markdown string for rendering
  }

  ////////////////////////////////////////
  // Build regex pattern from title words
  ////////////////////////////////////////
  String _buildRegexPattern(String title) {
    List<String> titleWords = title.split(' ').where((word) {
      return word.length > 3; // Filter out short words (like "the", "and")
    }).toList();

    return titleWords.join(r'\b|\b'); // Join words to form the regex pattern
  }
}
