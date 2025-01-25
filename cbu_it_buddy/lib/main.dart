import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'services/firebase_options.dart';
import 'widgets/app_bar.dart'; // Custom AppBar file import
//import 'home_page.dart'; // HomePage file import (New Chat)
import 'services/feedback_page.dart'; // Feedback Page
import 'screens/faq_page.dart'; // Frequently Asked Q&A Page
import 'screens/departments_contact_page.dart'; // CBU Departments Contact Page
import 'screens/game_page.dart'; // IT Office Game page import
import 'screens/chat_page.dart'; // Import the new ChatPage

//////////////////////////////////////////////
// Main function to run the app
//////////////////////////////////////////////
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(CBUITBuddyApp());
}

//////////////////////////////////////////////
// Main StatelessWidget class for the app
//////////////////////////////////////////////
class CBUITBuddyApp extends StatelessWidget {
  const CBUITBuddyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CBU IT Buddy',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MainPage(), // Set the main page with navigation drawer
    );
  }
}

//////////////////////////////////////////////
// Main Page with Navigation Drawer
//////////////////////////////////////////////
class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CBU IT Buddy'),
      ),
      //////////////////////////////////////////////
      // Navigation Drawer Code !!!!!!
      //////////////////////////////////////////////
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'User Selection',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.chat),
              title: const Text('New Chat'),
              onTap: () {
                // Navigate to New Chat (ChatPage) instead of the old HomePage
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ChatPage(
                        query: 'Reset Password'), // Example query
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.question_answer),
              title: const Text('Frequently Asked Q&A'),
              onTap: () {
                // Navigate to FAQ Page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const FAQPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.contacts),
              title: const Text('CBU Departments Contact'),
              onTap: () {
                // Navigate to Departments Contact Page
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const DepartmentsContactPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.feedback),
              title: const Text('Feedback for IT-Buddy'),
              onTap: () {
                // Navigate to Feedback Page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const FeedbackPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.videogame_asset),
              title: const Text('IT Office Game'),
              onTap: () {
                // Navigate to the IT Office Game page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const GamePage()),
                );
              },
            ),
          ],
        ),
      ),
      body: const Center(
        child: Text('Select an option from the Navigation Drawer.'),
      ),
    );
  }
}
