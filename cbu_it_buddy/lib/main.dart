import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'services/firebase_options.dart';
import 'widgets/app_bar.dart'; // Custom AppBar file import
import 'services/feedback_page.dart'; // Feedback Page
import 'screens/faq_page.dart'; // Frequently Asked Q&A Page
import 'screens/departments_contact_page.dart'; // CBU Departments Contact Page
import 'screens/game_page.dart'; // IT Office Game page import
import 'screens/chat_page.dart'; // Import the new ChatPage
import 'package:flutter_dotenv/flutter_dotenv.dart'; // env for API key

//////////////////////////////////////////////
// Main function to run the app
//////////////////////////////////////////////
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ Load environment variables
  try {
    await dotenv.load();
    print("🟢 .env file loaded successfully!");
  } catch (e) {
    print("❌ ERROR: .env file not found! $e");
  }

  runApp(const CBUITBuddyApp());
}

//////////////////////////////////////////////
// Main StatelessWidget class for the app
//////////////////////////////////////////////
class CBUITBuddyApp extends StatelessWidget {
  const CBUITBuddyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          print("🟢 Firebase initialized successfully!");
          return MaterialApp(
            title: 'CBU IT Buddy',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            debugShowCheckedModeBanner: false,
            home: const MainPage(),
          );
        } else if (snapshot.hasError) {
          print("❌ Firebase initialization error: ${snapshot.error}");
          return MaterialApp(
            home: Scaffold(
              body: Center(
                child: Text("❌ Firebase failed to initialize: ${snapshot.error}"),
              ),
            ),
          );
        }
        return const MaterialApp(
          home: Scaffold(
            body: Center(
              child: CircularProgressIndicator(), // ✅ Show loading until Firebase is ready
            ),
          ),
        );
      },
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
  // ✅ Initialize selected page
  Widget _selectedPage = const ChatPage(query: 'Reset Password');

  @override
  Widget build(BuildContext context) {
    print("🟢 MainPage Widget is Building..."); // ✅ Debugging print

    return Scaffold(
      appBar: AppBar(
        title: const Text('CBU IT Buddy'),
      ),
      //////////////////////////////////////////////
      // ✅ Brian edited code: Added SafeArea to prevent UI issues
      //////////////////////////////////////////////
      drawer: SafeArea(
        child: Drawer(
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
                  setState(() {
                    _selectedPage = const ChatPage(query: 'Reset Password');
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.question_answer),
                title: const Text('Frequently Asked Q&A'),
                onTap: () {
                  setState(() {
                    _selectedPage = const FAQPage();
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.contacts),
                title: const Text('CBU Departments Contact'),
                onTap: () {
                  setState(() {
                    _selectedPage = const DepartmentsContactPage();
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.feedback),
                title: const Text('Feedback for IT-Buddy'),
                onTap: () {
                  setState(() {
                    _selectedPage = const FeedbackPage();
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.videogame_asset),
                title: const Text('IT Office Game'),
                onTap: () {
                  setState(() {
                    _selectedPage = const GamePage();
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
      //////////////////////////////////////////////
      // ✅ Set the Selected Page as the Body
      //////////////////////////////////////////////
      body: _selectedPage,
    );
  }
}
