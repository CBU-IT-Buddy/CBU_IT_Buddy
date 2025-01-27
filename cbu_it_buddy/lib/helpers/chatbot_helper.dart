import 'package:cloud_firestore/cloud_firestore.dart';

class ChatbotHelper {
  // Firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  ////////////////////////////////////////////////
  // Get answer from Firestore
  ////////////////////////////////////////////////
  Future<String> getAnswer(String question) async {
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
        // Allow better matching by considering individual words in the question
        RegExp regExp = RegExp(r'\b(?:' + _buildRegexPattern(title) + r')\b',
            caseSensitive: false);

        if (regExp.hasMatch(normalizedQuestion)) {
          String content = doc['content'] ?? 'No content available.';
          String link = doc['link'] ?? '';
          return _formatResponse(title, content, link);
        }
      }

      return "Sorry, I don't have an answer for that question. Please try asking in a different way.";
    } catch (e, stackTrace) {
      print('Error fetching solution: $e');
      print(stackTrace);
      return 'An error occurred while retrieving the solution. Please try again later.';
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
    // Remove common words and split by space, then join with '|'
    List<String> titleWords = title.split(' ').where((word) {
      return word.length > 3; // Filter out short words (like "the", "and")
    }).toList();

    return titleWords.join(r'\b|\b'); // Join words to form the regex pattern
  }
}
