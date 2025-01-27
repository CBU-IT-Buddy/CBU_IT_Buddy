import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // ✅ Correct import

class DepartmentsContactPage extends StatelessWidget {
  const DepartmentsContactPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CBU Departments Contact'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: const [
            DepartmentTile(
              title: 'Information Technology Services',
              subtitle: 'Contact: helpdesk@calbaptist.edu',
              email: 'helpdesk@calbaptist.edu',
              icon: Icons.computer,
            ),
            DepartmentTile(
              title: 'Admissions Office',
              subtitle: 'Contact: admissions@calbaptist.edu',
              email: 'admissions@calbaptist.edu',
              icon: Icons.school,
            ),
          ],
        ),
      ),
    );
  }
}

class DepartmentTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final String email;
  final IconData icon;

  const DepartmentTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.email,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(title),
      subtitle: GestureDetector(
        onTap: () => _launchEmail(email),
        child: Text(
          subtitle,
          style: const TextStyle(color: Colors.blue),
        ),
      ),
    );
  }

  Future<void> _launchEmail(String email) async {
    final Uri emailUri = Uri(scheme: 'mailto', path: email);

    if (await canLaunch(emailUri.toString())) {
      await launch(emailUri.toString());
    } else {
      throw 'Could not launch $email';
    }
  }
}
