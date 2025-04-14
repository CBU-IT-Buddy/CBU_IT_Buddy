import 'package:cbu_it_buddy/main.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart'; // Used for opening links

class FAQPage extends StatelessWidget {
  const FAQPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Frequently Asked Questions',
          style:
              TextStyle(fontWeight: FontWeight.bold), // Stylish app bar title
        ),
        centerTitle: true,
        backgroundColor: cbuNavyBlue, // Sets a nice blue accent color
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0), // Padding around the FAQList
        child: FAQList(), // Display FAQList widget
      ),
    );
  }
}

class FAQList extends StatelessWidget {
  const FAQList({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('faq').snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
              child: CircularProgressIndicator()); // Shows loading animation
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
              child: Text("No FAQs available",
                  style: TextStyle(fontSize: 18, color: cbuNavyBlue)));
        }

        var faqItems = snapshot.data!.docs;

        return ListView.builder(
          itemCount: faqItems.length,
          itemBuilder: (context, index) {
            var faq = faqItems[index];
            return FAQTile(
              title: faq['title'] ?? "No Title",
              content: faq['content'] ?? "No Content Available",
              link: faq['link'] ?? "",
            );
          },
        );
      },
    );
  }
}

class FAQTile extends StatefulWidget {
  final String title;
  final String content;
  final String link;

  const FAQTile(
      {required this.title,
      required this.content,
      required this.link,
      super.key});

  @override
  _FAQTileState createState() => _FAQTileState();
}

class _FAQTileState extends State<FAQTile> {
  bool isExpanded = false; // Tracks expansion state

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration:
          const Duration(milliseconds: 300), // Smooth animation when expanding
      curve: Curves.easeInOut,
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12), // Rounded corners
        boxShadow: [
          BoxShadow(
            color: cbuNavyBlue.withOpacity(0.1), // Subtle shadow effect
            blurRadius: 6,
            spreadRadius: 2,
          ),
        ],
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(12)), // Matches container radius
        title: Text(
          widget.title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: cbuNavyBlue, // FAQ title style
          ),
        ),
        iconColor: cbuNavyBlue, // Sets the expand/collapse arrow color
        collapsedIconColor: cbuNavyBlue, // Grey icon when collapsed
        onExpansionChanged: (expanded) {
          setState(() {
            isExpanded = expanded; // Toggle expanded state
          });
        },
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.content,
                  style: const TextStyle(
                      fontSize: 16, color: cbuNavyBlue), // FAQ content style
                ),
                const SizedBox(height: 12),
                Center(
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      Uri url = Uri.parse(widget.link);
                      if (await canLaunchUrl(url)) {
                        await launchUrl(url);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text("Could not open link",
                                  style: TextStyle(color: Colors.white))),
                        );
                      }
                    },
                    icon: const Icon(Icons.open_in_new,
                        size: 18), // Open link icon
                    label: const Text("Read More"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: cbuNavyBlue, // Blue button
                      foregroundColor: Colors.white, // White text
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(8), // Rounded button corners
                      ),
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
