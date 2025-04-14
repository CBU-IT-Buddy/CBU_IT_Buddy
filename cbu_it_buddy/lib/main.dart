import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
//import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'services/firebase_options.dart';
// Custom AppBar file import
//import 'home_page.dart'; // HomePage file import (New Chat)
import 'services/feedback_page.dart'; // Feedback Page
import 'screens/faq_page.dart'; // Frequently Asked Q&A Page
import 'screens/departments_contact_page.dart'; // CBU Departments Contact Page
import 'screens/game_page.dart'; // IT Office Game page import
import 'screens/chat_page.dart'; // Import the new ChatPage
import 'golfcart/gameapp.dart'; // Import the GameView widget

//////////////////////////////////////////////
// Define CBU's Navy Blue as a constant
//////////////////////////////////////////////
const Color cbuNavyBlue = Color(0xFF002554); // Hex: #002554

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
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: createMaterialColor(cbuNavyBlue),
        appBarTheme: const AppBarTheme(
          backgroundColor: cbuNavyBlue,
          foregroundColor: Colors.white,
        ),
        colorScheme: ColorScheme.fromSeed(
          seedColor: cbuNavyBlue,
          primary: cbuNavyBlue,
        ),
      ),
      home: const MainPage(), // Set the main page with navigation drawer
    );
  }

  MaterialColor createMaterialColor(Color color) {
    List<double> strengths = <double>[.05, .1, .2, .3, .4, .5, .6, .7, .8, .9];
    Map<int, Color> swatch = <int, Color>{};
    final int r = color.red, g = color.green, b = color.blue;

    for (var strength in strengths) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    }
    return MaterialColor(color.value, swatch);
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
                color: cbuNavyBlue,
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
            ListTile(
              leading: const Icon(Icons.videogame_asset),
              title: const Text('Golfcart Game'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => GameView()),
                );
                // No need to set _selectedPage since we're navigating to a new route
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
