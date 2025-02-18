import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Picture Card
            Card(
              elevation: 4,
              margin: EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                leading: CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage("assets/profile.jpg"),
                ),
                title: Text("John Doe",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text("johndoe@gmail.com"),
              ),
            ),
            // Personal Information Card
            Card(
              elevation: 4,
              margin: EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                leading: Icon(Icons.person, size: 40, color: Colors.blue),
                title: Text("Personal Information",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(
                    "Age: 25\nGender: Male\nHeight: 5'10\"\nWeight: 70 kg"),
              ),
            ),
            // Health Information Card
            Card(
              elevation: 4,
              margin: EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                leading:
                    Icon(Icons.medical_services, size: 40, color: Colors.green),
                title: Text("Health Information",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(
                    "Blood Type: O+\nAllergies: None\nMedical Conditions: None"),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Bring to edit page
        },
        tooltip: "Edit Profile",
        child: Icon(Icons.edit),
      ),
    );
  }
}
