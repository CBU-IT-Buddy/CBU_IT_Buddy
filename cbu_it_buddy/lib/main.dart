import 'package:flutter/material.dart';
import 'app_bar.dart'; // Custom AppBar file import
import 'home_page.dart'; // HomePage file import (New Chat)
import 'feedback_page.dart'; // Feedback Page
import 'faq_page.dart'; // Frequently Asked Q&A Page
import 'departments_contact_page.dart'; // CBU Departments Contact Page
import 'game_page.dart'; // IT Office Game page import

//////////////////////////////////////////////
// Main function to run the app
//////////////////////////////////////////////
void main() {
  runApp(const CBUITBuddyApp()); // Entry point of the app
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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const CBUITBuddyHomePage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.question_answer),
              title: const Text('Frequently Asked Q&A'),
              onTap: () {
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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const FeedbackPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.videogame_asset),
              title: const Text('IT Office Game'),
              onTap: () {
                // Before the game
                _showUsernameDialog(context);
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

  void _showUsernameDialog(BuildContext context) {
    TextEditingController usernameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Enter Username'),
          content: TextField(
            controller: usernameController,
            decoration: const InputDecoration(
              hintText: 'Username',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                String username = usernameController.text;
                if (username.isNotEmpty) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GamePage(username: username),
                    ),
                  );
                }
              },
              child: const Text('Start Game'),
            ),
          ],
        );
      },
    );
  }
}
