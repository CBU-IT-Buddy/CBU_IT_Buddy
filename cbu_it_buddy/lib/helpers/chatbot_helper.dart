import 'package:flutter/services.dart' show rootBundle;

////////////////////////////////////////////////////
// Helper Class for Chatbot - Manages Keyword-based
// Answer Retrieval from Text Files in `solution`
////////////////////////////////////////////////////
class ChatbotHelper {
  // Map of keywords to corresponding file paths
  final Map<String, String> keywordToFile = {
    'password reset': 'lib/solution/password_reset.txt',
    'wifi connection': 'lib/solution/wifi_connection.txt',
    // Additional mappings go here
  };

  ////////////////////////////////////////////////
  // Fetch answer based on keyword match in query
  ////////////////////////////////////////////////
  Future<String> getAnswer(String question) async {
    // Iterate through keyword-file mappings
    for (var entry in keywordToFile.entries) {
      if (question.toLowerCase().contains(entry.key.toLowerCase())) {
        // Load and return content of matched file
        return await _loadTextFile(entry.value);
      }
    }
    // Default response if no keyword is matched
    return 'Sorry, I don’t have an answer for that question.';
  }

  //////////////////////////////////////
  // Load text file from assets folder
  //////////////////////////////////////
  Future<String> _loadTextFile(String filePath) async {
    try {
      // Read the content of the file specified
      final content = await rootBundle.loadString(filePath);
      return content;
    } catch (e) {
      // Error response if file cannot be read
      return 'Sorry, I could not retrieve the answer. Please try again later.';
    }
  }
}
