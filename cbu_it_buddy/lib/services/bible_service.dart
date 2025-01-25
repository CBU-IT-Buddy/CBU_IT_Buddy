import 'package:cloud_firestore/cloud_firestore.dart';

class BibleService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> fetchBibleVerse() async {
    try {
      final querySnapshot = await _firestore.collection('bibleverse').get();
      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.first['verse'] ?? 'No verse available';
      } else {
        return "No Bible verses available at the moment.";
      }
    } catch (e) {
      return "Error fetching Bible verse: $e";
    }
  }
}
