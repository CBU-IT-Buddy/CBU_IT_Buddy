import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart'; // Used for opening external links

class FAQPage extends StatelessWidget {
  const FAQPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Frequently Asked Q&A'), // Title of the FAQ page
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0), // Adds spacing around the FAQ list
        child: FAQList(), // Calls FAQList widget to display FAQs dynamically
      ),
    );
  }
}

// FAQList fetches FAQ data from Firestore and displays it in a list
class FAQList extends StatelessWidget {
  const FAQList({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('faq').snapshots(), // Listens for real-time updates from Firestore
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator()); // Shows a loading indicator while data is loading
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text("No FAQs available")); // Displays a message if there are no FAQs in Firestore
        }

        var faqItems = snapshot.data!.docs; // Extracts documents from Firestore

        return ListView.builder(
          itemCount: faqItems.length, // Number of FAQ items
          itemBuilder: (context, index) {
            var faq = faqItems[index]; // Retrieves each FAQ document
            return FAQTile(
              title: faq['title'], // Extracts the FAQ title
              content: faq['content'], // Extracts the FAQ summary content
              link: faq['link'], // Extracts the FAQ link to a detailed article
            );
          },
        );
      },
    );
  }
}

// FAQTile represents an individual FAQ item with expand/collapse functionality
class FAQTile extends StatefulWidget {
  final String title; // Title of the FAQ
  final String content; // Short summary of the FAQ solution
  final String link; // Link to a full article with more details

  const FAQTile({required this.title, required this.content, required this.link, super.key});

  @override
  _FAQTileState createState() => _FAQTileState();
}

class _FAQTileState extends State<FAQTile> {
  bool isExpanded = false; // Keeps track of whether the tile is expanded

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8), // Adds space between FAQ cards
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), // Rounds the corners of the card
      elevation: 3, // Adds shadow effect to the card
      child: ExpansionTile(
        title: Text(
          widget.title, // Displays the FAQ title
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), // Padding inside the expanded tile
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.content), // Displays the short summary content of the FAQ
                const SizedBox(height: 8), // Adds spacing between content and the "Read More" link
                GestureDetector(
                  onTap: () async {
                    Uri url = Uri.parse(widget.link); // Converts the link into a URI
                    if (await canLaunchUrl(url)) {
                      await launchUrl(url); // Opens the link in a web browser
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Could not open link")), // Shows an error message if the link fails to open
                      );
                    }
                  },
                  child: Text(
                    "Read More", // Clickable text for viewing the full FAQ article
                    style: TextStyle(
                      color: Colors.blue, // Makes the text blue to indicate a clickable link
                      decoration: TextDecoration.underline, // Underlines the text for a link effect
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
