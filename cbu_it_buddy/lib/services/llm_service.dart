import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class LLMService {
  final String apiKey = dotenv.env['OPENAI_API_KEY'] ?? ''; // ✅ Load API Key from .env

  Future<String> generateSummary(String content) async {
    const String apiUrl = "https://api.openai.com/v1/chat/completions";

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $apiKey",
      },
      body: jsonEncode({
        "model": "gpt-3.5-turbo",
        "messages": [
          {"role": "system", "content": "Summarize the following IT help content in one sentence."},
          {"role": "user", "content": content}
        ]
      }),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      return responseData["choices"][0]["message"]["content"].trim();
    } else {
      throw Exception("Failed to generate summary");
    }
  }
}
