import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DepartmentsContactPage extends StatelessWidget {
  const DepartmentsContactPage({Key? key}) : super(key: key);

  //////////////////////////////////////////////
  // Widget build method for DepartmentsContactPage UI
  //////////////////////////////////////////////
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CBU Departments Contact'), // Title for AppBar
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Padding around the ListView
        //////////////////////////////////////////////
        // ListView for displaying DepartmentTile widgets
        //////////////////////////////////////////////
        child: ListView(
          children: const [
            DepartmentTile(
              title: 'Information Technology Services', // Department name
              subtitle: 'Contact: helpdesk@calbaptist.edu', // Contact info
              email: 'helpdesk@calbaptist.edu', // Email for IT services
              icon: Icons.computer, // Icon representing IT services
            ),
            DepartmentTile(
              title: 'Admissions Office', // Department name
              subtitle: 'Contact: admissions@calbaptist.edu', // Contact info
              email: 'admissions@calbaptist.edu', // Email for Admissions Office
              icon: Icons.school, // Icon representing Admissions
            ),
            // Add more departments here
          ],
        ),
      ),
    );
  }
}

//////////////////////////////////////////////
// DepartmentTile - Custom ListTile for each department
//////////////////////////////////////////////
class DepartmentTile extends StatelessWidget {
  final String title; // Department name
  final String subtitle; // Contact information text
  final String email; // Email for contact link
  final IconData icon; // Icon representing department

  const DepartmentTile({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.email,
    required this.icon,
  }) : super(key: key);

  //////////////////////////////////////////////
  // Widget build method for DepartmentTile UI
  //////////////////////////////////////////////
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue), // Icon for department
      title: Text(title), // Display department title
      subtitle: GestureDetector(
        //////////////////////////////////////////////
        // Launch email on subtitle tap
        //////////////////////////////////////////////
        onTap: () => _launchEmail(email),
        child: Text(
          subtitle, // Display contact subtitle
          style:
              const TextStyle(color: Colors.blue), // Styling for clickable text
        ),
      ),
    );
  }

  //////////////////////////////////////////////
  // Function to launch email client
  //////////////////////////////////////////////
  Future<void> _launchEmail(String email) async {
    final Uri emailUri = Uri(
      scheme: 'mailto', // Use mailto scheme for email
      path: email, // Set recipient email
    );
    //////////////////////////////////////////////
    // Attempt to launch email or throw an error
    //////////////////////////////////////////////
    if (await canLaunch(emailUri.toString())) {
      await launch(emailUri.toString()); // Launch email
    } else {
      throw 'Could not launch $email'; // Error message
    }
  }
}
