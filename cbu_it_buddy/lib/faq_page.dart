import 'package:flutter/material.dart';

class FAQPage extends StatelessWidget {
  const FAQPage({super.key});

  //////////////////////////////////////////////
  // Widget build method for FAQPage UI
  //////////////////////////////////////////////
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Frequently Asked Q&A'), // Title for the AppBar
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Padding around the FAQList
        child: FAQList(), // Display FAQList widget
      ),
    );
  }
}

//////////////////////////////////////////////
// FAQ List with Expand/Collapse Functionality
//////////////////////////////////////////////
class FAQList extends StatefulWidget {
  const FAQList({Key? key}) : super(key: key);

  @override
  _FAQListState createState() => _FAQListState();
}

class _FAQListState extends State<FAQList> {
  //////////////////////////////////////////////
  // List of FAQ items (questions and answers)
  //////////////////////////////////////////////
  final List<Map<String, String>> _faqItems = [
    {
      'question': 'How to reset my password?',
      'answer':
          'You can reset your password by visiting the Inside CBU Portal and when attempting to log in you can select the option for forgot password.',
    },
    {
      'question': 'How to connect to CBU WiFi?',
      'answer':
          'To connect to CBU WiFi, go to your WiFi settings and select the CBU WiFi network. Enter your CBU email and password to connect.',
    },
    // Add more questions and answers here
  ];

  //////////////////////////////////////////////
  // List to track expanded state for each item
  //////////////////////////////////////////////
  final List<bool> _isExpanded = [];

  //////////////////////////////////////////////
  // Initialize expanded state list to false
  //////////////////////////////////////////////
  @override
  void initState() {
    super.initState();
    _isExpanded.addAll(List.generate(_faqItems.length, (index) => false));
  }

  //////////////////////////////////////////////
  // Widget build for displaying FAQ items as ListView
  //////////////////////////////////////////////
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _faqItems.length, // Number of FAQ items to display
      itemBuilder: (context, index) {
        //////////////////////////////////////////////
        // Each FAQ item card with question and answer
        //////////////////////////////////////////////
        return Card(
          child: ListTile(
            title: Text(_faqItems[index]['question']!), // Display question text
            trailing: Icon(
              _isExpanded[index]
                  ? Icons.expand_less
                  : Icons.expand_more, // Expand/collapse icon
            ),
            //////////////////////////////////////////////
            // Toggle expanded state on tap
            //////////////////////////////////////////////
            onTap: () {
              setState(() {
                _isExpanded[index] = !_isExpanded[index];
              });
            },
            //////////////////////////////////////////////
            // Display answer if expanded, null otherwise
            //////////////////////////////////////////////
            subtitle:
                _isExpanded[index] ? Text(_faqItems[index]['answer']!) : null,
          ),
        );
      },
    );
  }
}
