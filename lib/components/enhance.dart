import 'package:flutter/material.dart';
import 'package:food_diary_app/components/water_log.dart';
import 'package:food_diary_app/models/profile_model.dart';
import 'package:food_diary_app/utils/database_helper.dart';

class EnhanceScreen extends StatefulWidget {
  const EnhanceScreen({super.key});

  @override
  State<EnhanceScreen> createState() => _EnhanceScreenState();
}

class _EnhanceScreenState extends State<EnhanceScreen> {
  int totalCalories = 0;
  int totalEntries = 0;
  int bmi = 0;
  int waterIntake = 0;
  int caloriesOfTheDay = 0;

  Future<void> getData() async {
    // Fetch total calories from the database
    Map<dynamic, dynamic> data =
        await DatabaseHelper.instance.retrieveTotalCaloriesAndEntries();
    ProfileModel profile = await DatabaseHelper.instance.getProfileData();
    int water = await DatabaseHelper.instance
        .getTotalWaterIntakeForDate(DateTime.now());
    int calories =
        await DatabaseHelper.instance.getTotalCaloriesForDate(DateTime.now());
    setState(() {
      totalCalories = data['totalCalories'];
      totalEntries = data['totalEntries'];
      caloriesOfTheDay = calories;
      bmi = profile.weight ~/ ((profile.height / 100) * (profile.height / 100));
      waterIntake = water;
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
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
              elevation: 2,
              margin: EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Icon(Icons.insert_chart, size: 40, color: Colors.green),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Diary Summary",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16)),
                          SizedBox(height: 4),
                          Text("Total Entries: $totalEntries"),
                          Text(
                              "Average Calories: ${totalEntries > 0 ? totalCalories ~/ totalEntries : 0} kcal"),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Calories Intake Card
            Card(
              elevation: 2,
              margin: EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Icon(Icons.local_fire_department,
                        size: 40, color: Colors.redAccent),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Calories Intake of The Day",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16)),
                          SizedBox(height: 4),
                          Text("Calories: $caloriesOfTheDay kcal"),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // BMI Calculator Card
            Card(
              elevation: 2,
              margin: EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Icon(Icons.fitness_center, size: 40, color: Colors.blue),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("BMI Calculator",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16)),
                          SizedBox(height: 4),
                          Text("Your BMI: $bmi"),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Water Intake Log Card
            Card(
              elevation: 4,
              margin: EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => WaterLogPage()),
                  ).then((_) => getData());
                },
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Icon(Icons.local_drink,
                          size: 40, color: Colors.lightBlue),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Water Intake Log",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16)),
                            SizedBox(height: 4),
                            Text(
                                "Today's Water Intake: ${(waterIntake / 1000).toStringAsFixed(1)} L"),
                          ],
                        ),
                      ),
                      Icon(Icons.arrow_forward_ios, color: Colors.grey),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
