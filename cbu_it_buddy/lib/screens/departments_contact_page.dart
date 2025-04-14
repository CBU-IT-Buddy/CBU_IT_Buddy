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
              title: 'IT Help Desk',
              hours: 'Monday-Friday: 8am - 5pm',
              location: 'James Building, Room 160',
              email: 'helpdesk@calbaptist.edu',
              phone: '(951) 343-4444',
              icon: Icons.computer,
            ),
            DepartmentTile(
              title: 'Academic Advising',
              hours: 'Monday-Friday: 9am - 5pm',
              location: 'Yeager B146',
              email: 'advising@calbaptist.edu',
              phone: '(951) 343-4567',
              icon: Icons.book,
            ),
            DepartmentTile(
              title: 'Admissions Office',
              hours: 'Monday-Friday: 8am - 5pm',
              location: 'Yeager Center, Admissions',
              email: 'admissions@calbaptist.edu',
              phone: '(951) 343-4212',
              icon: Icons.school,
            ),
            DepartmentTile(
              title: 'Campus Recreation',
              hours: 'Monday-Friday: 6am - 10pm',
              location: 'Recreation Center',
              email: 'reccenter@calbaptist.edu',
              phone: '(951) 552-8580',
              icon: Icons.sports_gymnastics,
            ),
            DepartmentTile(
              title: 'Counseling Center',
              hours: 'Monday-Friday: 9am - 5pm',
              location: 'Business Building Breezeway, Room 120 ',
              email: 'ccrecept@calbaptist.edu',
              phone: '(951) 343-5031',
              icon: Icons.healing,
            ),
            DepartmentTile(
              title: 'Community Life',
              hours: 'Mon-Thurs: 8 a.m. to 8 p.m., Friday: 8 a.m. to 6 p.m., Weekends closed',
              location: 'Lancer Plaza',
              email: 'communitylife@calbaptist.edu',
              phone: '(951) 343-4425',
              icon: Icons.family_restroom,
            ),
            DepartmentTile(
              title: 'Financial Aid',
              hours: 'Monday-Friday: 8am - 5pm',
              location: 'Yeager Center, Room D118',
              email: 'finaid@calbaptist.edu',
              phone: '(951) 343-4236',
              icon: Icons.account_balance,
            ),
            DepartmentTile(
              title: 'International Center',
              hours: 'Monday-Friday: 8am - 5pm',
              location: 'Lancer Arms, 56A',
              email: 'international@calbaptist.edu',
              phone: '(951) 343-4690',
              icon: Icons.flag,
            ),
            DepartmentTile(
              title: 'Residence Life',
              hours: 'Monday-Friday: 8am - 5pm',
              location: 'Village, 215',
              email: 'residencelife@calbaptist.edu',
              phone: '(951) 552-8000',
              icon: Icons.house,
            ),
            DepartmentTile(
              title: 'Safety Services',
              hours: '24Hours',
              location: 'Lancer Arms, 43',
              email: 'publicsafety@calbaptist.edu',
              phone: '(951) 343-4311',
              icon: Icons.health_and_safety,
            ),
            DepartmentTile(
              title: 'Student Accounts',
              hours: 'Monday-Friday: 8am - 5pm',
              location: 'Lancer Arms, 42',
              email: 'studentaccounts@calbaptist.edu',
              phone: '(951) 343-4371',
              icon: Icons.account_box,
            ),
            DepartmentTile(
              title: 'Spiritual Life',
              hours: 'Monday-Friday: 8am - 5pm',
              location: 'Lancer Plaza',
              email: 'spirituallife@calbaptist.edu',
              phone: '(951) 323-5015',
              icon: Icons.church,
            ),
            DepartmentTile(
              title: 'University Card Services',
              hours: 'Monday-Friday: 8am - 5pm',
              location: 'Lancer Plaza, 140',
              email: 'cardservices@calbaptist.edu',
              phone: '(951) 552-8552',
              icon: Icons.card_membership,
            ),
          ],
        ),
      ),
    );
  }
}

class DepartmentTile extends StatelessWidget {
  final String title;
  final String hours;
  final String location;
  final String email;
  final String phone;
  final IconData icon;

  const DepartmentTile({
    super.key,
    required this.title,
    required this.hours,
    required this.location,
    required this.email,
    required this.phone,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.blue),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Text('Hours: $hours'),
            Text('Location: $location'),
            GestureDetector(
              onTap: () => _launchEmail(email),
              child: Text(
                'Email: $email',
                style: const TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
              ),
            ),
            GestureDetector(
              onTap: () => _launchPhone(phone),
              child: Text(
                'Phone: $phone',
                style: const TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _launchEmail(String email) async {
    final Uri emailUri = Uri(scheme: 'mailto', path: email);
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      throw 'Could not launch email: $email';
    }
  }

  Future<void> _launchPhone(String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber.replaceAll(RegExp(r'\D'), ''));
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      throw 'Could not launch phone number: $phoneNumber';
    }
  }
}
