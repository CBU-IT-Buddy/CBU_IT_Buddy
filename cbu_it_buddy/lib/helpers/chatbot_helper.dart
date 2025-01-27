import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/llm_service.dart'; // Brian edited code (Added LLM Service import)

class ChatbotHelper {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final LLMService _llmService = LLMService(); // Brian edited code (LLM Service instance)

  ////////////////////////////////////////////////
  // Get answer from Firestore with Summary
  ////////////////////////////////////////////////
  Future<Map<String, String>> getAnswer(String question) async {
    try {
      String normalizedQuestion = question.toLowerCase();

      // Query Firestore for all solutions
      QuerySnapshot querySnapshot =
          await _firestore.collection('solutions').get();

      // Iterate through documents to find a match
      for (var doc in querySnapshot.docs) {
        String title = doc['title']?.toString().toLowerCase() ?? '';
        print('Comparing Question: "$normalizedQuestion" with Title: "$title"');

        // Regex matching to improve query flexibility
        RegExp regExp = RegExp(r'\b(?:' + _buildRegexPattern(title) + r')\b',
            caseSensitive: false);

        if (regExp.hasMatch(normalizedQuestion)) {
          String content = doc['content'] ?? 'No content available.';
          String link = doc['link'] ?? '';

          // ✅ Brian edited code: Explicitly cast Firestore data to a Map
          Map<String, dynamic>? docData = doc.data() as Map<String, dynamic>?;

          // ✅ Brian edited code: Check if 'summary' exists before generating it
          String summary = (docData != null && docData.containsKey('summary'))
              ? docData['summary']
              : await _llmService.generateSummary(content);

          return {
            "summary": summary,
            "content": content,
            "link": link
          };
        }
      }

      return {
        "summary": "No summary available", // Brian edited code (Default summary response)
        "content": "Sorry, I don't have an answer for that question. Try rephrasing it.",
        "link": ""
      };
    } catch (e, stackTrace) {
      print('Error fetching solution: $e');
      print(stackTrace);
      return {
        "summary": "Error occurred", // Brian edited code (Handle error with summary)
        "content": "An error occurred while retrieving the solution. Please try again later.",
        "link": ""
      };
    }
  }

  ////////////////////////////////////////
  // Format chatbot response
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
      return word.length > 3; // Remove short words like "the", "and"
    }).toList();

    return titleWords.join(r'\b|\b'); // Join words to form regex pattern
  }
}
