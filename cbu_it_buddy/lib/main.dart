import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'services/firebase_options.dart';
import 'services/feedback_page.dart'; // Feedback Page
import 'screens/faq_page.dart'; // Frequently Asked Q&A Page
import 'screens/departments_contact_page.dart'; // CBU Departments Contact Page
import 'screens/game_page.dart'; // IT Office Game page import
import 'screens/chat_page.dart'; // Import the new ChatPage
import 'package:flutter/services.dart'; // For orientation control

//////////////////////////////////////////////
// Main function to run the app
//////////////////////////////////////////////
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // Set default orientation to portrait
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
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
        primarySwatch:
            Colors.blue, // Default theme, can be adjusted based on assets
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

  // Helper method to update the selected page and orientation
  void _updatePage(Widget newPage) {
    setState(() {
      _selectedPage = newPage;
    });
    // Adjust orientation based on the selected page
    if (newPage is GamePage) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    } else {
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CBU IT Buddy'),
      ),
      //////////////////////////////////////////////
      // Navigation Drawer Code
      //////////////////////////////////////////////
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 16, 92, 191),
              ),
              child: Text(
                'Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.chat),
              title: const Text('New Chat'),
              onTap: () {
                _updatePage(const ChatPage(query: 'Reset Password'));
                Navigator.pop(context); // Close the drawer
              },
            ),
            ListTile(
              leading: const Icon(Icons.question_answer),
              title: const Text('Frequently Asked Q&A'),
              onTap: () {
                _updatePage(const FAQPage());
                Navigator.pop(context); // Close the drawer
              },
            ),
            ListTile(
              leading: const Icon(Icons.contacts),
              title: const Text('CBU Departments Contact'),
              onTap: () {
                _updatePage(const DepartmentsContactPage());
                Navigator.pop(context); // Close the drawer
              },
            ),
            ListTile(
              leading: const Icon(Icons.feedback),
              title: const Text('Feedback for IT-Buddy'),
              onTap: () {
                _updatePage(const FeedbackPage());
                Navigator.pop(context); // Close the drawer
              },
            ),
            ListTile(
              leading: const Icon(Icons.videogame_asset),
              title: const Text('IT Office Game'),
              onTap: () {
                _updatePage(const GamePage());
                Navigator.pop(context); // Close the drawer
              },
            ),
          ],
        ),
      ),
      //////////////////////////////////////////////
      // Set the Selected Page as the Body
      //////////////////////////////////////////////
      body: _selectedPage,
    );
  }

  // Ensure orientation is reset to portrait when the widget is disposed
  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    super.dispose();
  }
}
