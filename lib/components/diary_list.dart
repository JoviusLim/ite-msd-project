import 'package:flutter/material.dart';
import 'package:food_diary_app/components/food_log.dart';
import 'package:food_diary_app/components/photo_capture.dart';

class DiaryListScreen extends StatefulWidget {
  const DiaryListScreen({super.key});

  @override
  State<DiaryListScreen> createState() => _DiaryListScreenState();
}

class _DiaryListScreenState extends State<DiaryListScreen> {
  final List<Map<String, String>> foodLogs = [
    {
      'image': 'placeholder',
      'title': 'Breakfast',
      'description': 'Oatmeal with fruits',
      'time': '8:00 AM',
    },
    {
      'image': 'placeholder',
      'title': 'Lunch',
      'description': 'Grilled chicken salad',
      'time': '12:30 PM',
    },
    {
      'image': 'placeholder',
      'title': 'Snack',
      'description': 'Greek yogurt',
      'time': '3:00 PM',
    },
    {
      'image': 'placeholder',
      'title': 'Dinner',
      'description': 'Salmon with vegetables',
      'time': '7:00 PM',
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Food Diary")),
      body: ListView.builder(
        itemCount: foodLogs.length,
        itemBuilder: (context, index) {
          final log = foodLogs[index];
          return Card(
            margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            elevation: 3,
            child: ListTile(
              title: Text(log['title']!),
              subtitle: Text('${log['description']}\n${log['time']}'),
              isThreeLine: true,
              trailing: IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  // Handle editing of the food log entry.
                },
              ),
              onTap: () {
                // Optionally, navigate to a detailed view for the selected entry.
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => FoodLogScreen()));
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to a new screen to add a food log entry.
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => PhotoCaptureScreen()));
        },
        tooltip: 'Add Food Log',
        child: Icon(Icons.add),
      ),
    );
  }
}
