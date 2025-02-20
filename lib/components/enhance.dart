import 'package:flutter/material.dart';
import 'package:food_diary_app/utils/database_helper.dart';

class EnhanceScreen extends StatefulWidget {
  const EnhanceScreen({super.key});

  @override
  State<EnhanceScreen> createState() => _EnhanceScreenState();
}

class _EnhanceScreenState extends State<EnhanceScreen> {
  int totalCalories = 0;
  int totalEntries = 0;

  Future<void> getTotalCalories() async {
    // Fetch total calories from the database
    Map<dynamic, dynamic> data =
        await DatabaseHelper.instance.retrieveTotalCaloriesAndEntries();
    setState(() {
      totalCalories = data['totalCalories'];
      totalEntries = data['totalEntries'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Stats")),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Diary Summary Card
            Card(
              elevation: 4,
              margin: EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                leading:
                    Icon(Icons.insert_chart, size: 40, color: Colors.green),
                title: Text("Diary Summary",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(
                    "Total Entries: $totalEntries\nAverage Calories: ${totalEntries > 0 ? totalCalories ~/ totalEntries : 0}"),
                onTap: () {
                  // Navigate to Diary Summary Page
                  /* Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DiarySummaryPage()),
          ); */
                },
              ),
            ),
            // Calories Intake Card
            Card(
              elevation: 4,
              margin: EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                leading: Icon(Icons.local_fire_department,
                    size: 40, color: Colors.redAccent),
                title: Text("Calories Intake of the day",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text("Total Calories: $totalCalories"),
                onTap: () {
                  // Navigate to Calories Intake Page
                  /*   Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CaloriesIntakePage()),
          ); */
                },
              ),
            ),
            // BMI Calculator Card
            Card(
              elevation: 4,
              margin: EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                leading:
                    Icon(Icons.fitness_center, size: 40, color: Colors.blue),
                title: Text("BMI Calculator",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text("Calculate your BMI"),
                onTap: () {
                  // Navigate to BMI Calculator Page
                  /*  Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => BMICalculatorPage()),
          ); */
                },
              ),
            ),
            // Water Intake Log Card
            Card(
              elevation: 4,
              margin: EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                leading:
                    Icon(Icons.local_drink, size: 40, color: Colors.lightBlue),
                title: Text("Water Intake Log",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text("Today's Water Intake: 1.5L"),
                onTap: () {
                  // Navigate to Water Intake Log Page
                  /*  Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => WaterIntakeLogPage()),
          ); */
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
