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
  runApp(const CBUITBuddyApp());
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
class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  // Track the currently selected page
  Widget _selectedPage = const ChatPage(query: 'Reset Password');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          // title: const Text('CBU IT Buddy'),
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
                  color: Color.fromARGB(
                255,
                16,
                92,
                191,
              )),
              child: Text(
                'Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.chat),
              title: const Text('New Chat'),
              onTap: () {
                setState(() {
                  _selectedPage = const ChatPage(query: 'Reset Password');
                });
                Navigator.pop(context); // Close the drawer
              },
            ),
            ListTile(
              leading: const Icon(Icons.question_answer),
              title: const Text('Frequently Asked Q&A'),
              onTap: () {
                setState(() {
                  _selectedPage = const FAQPage();
                });
                Navigator.pop(context); // Close the drawer
              },
            ),
            ListTile(
              leading: const Icon(Icons.contacts),
              title: const Text('CBU Departments Contact'),
              onTap: () {
                setState(() {
                  _selectedPage = const DepartmentsContactPage();
                });
                Navigator.pop(context); // Close the drawer
              },
            ),
            ListTile(
              leading: const Icon(Icons.feedback),
              title: const Text('Feedback for IT-Buddy'),
              onTap: () {
                setState(() {
                  _selectedPage = const FeedbackPage();
                });
                Navigator.pop(context); // Close the drawer
              },
            ),
            ListTile(
              leading: const Icon(Icons.videogame_asset),
              title: const Text('IT Office Game'),
              onTap: () {
                setState(() {
                  _selectedPage = const GamePage();
                });
                Navigator.pop(context); // Close the drawer
              },
            ),
          ],
        ),
      ),
      //////////////////////////////////////////////
      // Set the Selected Page as the Body !!!!!!
      //////////////////////////////////////////////
      body: _selectedPage,
    );
  }
}
