import 'package:cloud_firestore/cloud_firestore.dart';

class ChatbotHelper {
  // Firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  ////////////////////////////////////////////////
  // Get answer from Firestore
  ////////////////////////////////////////////////
  Future<String> getAnswer(String question) async {
    try {
      // Normalize the question to lowercase
      String normalizedQuestion = question.toLowerCase();

      // Query the Firestore `solutions` collection
      QuerySnapshot querySnapshot =
          await _firestore.collection('solutions').get();

      // Iterate through documents to find a keyword match in titles
      for (var doc in querySnapshot.docs) {
        String title = doc['title']?.toString().toLowerCase() ?? '';
        if (normalizedQuestion.contains(title)) {
          // Found a match - prepare the response
          String content = doc['content'] ?? 'No content available.';
          String link = doc['link'] ?? '';
          return _formatResponse(title, content, link);
        }
      }

      // Default response if no match is found
      return 'Sorry, I don’t have an answer for that question.';
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
    responseBuffer.writeln('**$title**\n');
    responseBuffer.writeln(content);

    if (link.isNotEmpty) {
      responseBuffer.writeln('\n[View Full Solution]($link)');
    }

    return responseBuffer.toString();
  }
}
