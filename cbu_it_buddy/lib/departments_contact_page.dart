import 'package:flutter/material.dart';

//////////////////////////////////////////////
// dcp  StatelessWidget
//////////////////////////////////////////////
class DepartmentsContactPage extends StatelessWidget {
  const DepartmentsContactPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CBU Departments Contact'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        //////////////////////////////////////////////
        /// ListView to display the departments
        //////////////////////////////////////////////
        child: ListView(
          children: const [
            ListTile(
              title: Text('IT Department'),
              subtitle: Text('Contact: it-department@cbu.edu'),
            ),
            ListTile(
              title: Text('Admissions Office'),
              subtitle: Text('Contact: admissions@cbu.edu'),
            ),
            // Add more departments
          ],
        ),
      ),
    );
  }
}
