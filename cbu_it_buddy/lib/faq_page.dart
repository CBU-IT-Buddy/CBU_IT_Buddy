import 'package:flutter/material.dart';


//////////////////////////////////////////////
// FAQPAGE  StatelessWidget
//////////////////////////////////////////////
class FAQPage extends StatelessWidget {
  const FAQPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Frequently Asked Q&A'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        //////////////////////////////////////////////
        // Listview to display the questions and answers
        //////////////////////////////////////////////
        child: ListView(
          children: const [
            ListTile(
              title: Text('How to reset my password?'),
              subtitle: Text('You can reset your password by...'),
            ),
            ListTile(
              title: Text('How to connect to CBU WiFi?'),
              subtitle: Text('To connect to CBU WiFi, go to settings...'),
            ),
            // Add more questions and answers
          ],
        ),
      ),
    );
  }
}
