import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:food_diary_app/components/food_log.dart';
import 'package:food_diary_app/components/add_food.dart';
import 'package:food_diary_app/utils/database_helper.dart';
import 'package:intl/intl.dart';

class DiaryListScreen extends StatefulWidget {
  final CameraDescription camera;

  const DiaryListScreen({super.key, required this.camera});

  @override
  State<DiaryListScreen> createState() => _DiaryListScreenState();
}

class _DiaryListScreenState extends State<DiaryListScreen> {
  List<Map<String, dynamic>> foodLogs = [];

  @override
  void initState() {
    super.initState();
    getFoodEntries();
  }

  Future<void> getFoodEntries() async {
    final entries =
        await DatabaseHelper.instance.retrieveFoodEntriesSortedByLatest();
    setState(() {
      foodLogs = entries;
    });
  }

  Future<void> removeFoodEntry(int id) async {
    await DatabaseHelper.instance.deleteFoodEntry(id);
    getFoodEntries();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Food Diary")),
      body: RefreshIndicator(
        onRefresh: getFoodEntries,
        child: foodLogs.isEmpty
            ? ListView(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.8,
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.restaurant_menu,
                              size: 64, color: Colors.grey[300]),
                          SizedBox(height: 16),
                          Text(
                            'No food logs available. Add some entries!',
                            style: TextStyle(fontSize: 18, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              )
            : ListView.builder(
                itemCount: foodLogs.length,
                itemBuilder: (context, index) {
                  final log = foodLogs[index];
                  return Card(
                    margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      title: Text(
                        '${log['mealType']![0].toUpperCase()}${log['mealType']!.substring(1)}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Padding(
                        padding: EdgeInsets.only(top: 4),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              log['notes'] ?? '',
                              style: TextStyle(color: Colors.grey[700]),
                            ),
                            Text(
                              DateFormat('dd/MM/yyyy @ HH:mm')
                                  .format(DateTime.parse(log['time'])),
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Calories: ${log['calories']}',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete,
                            color: Theme.of(context).primaryColor),
                        onPressed: () {
                          removeFoodEntry(log['id']);
                        },
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                FoodLogScreen(id: log['id'].toString()),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          bool result = await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      AddFoodLogScreen(camera: widget.camera)));

          if (result == true) {
            getFoodEntries();
          }
        },
        tooltip: 'Add Food Log',
        child: Icon(Icons.add),
      ),
    );
  }
}
