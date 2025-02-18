import 'package:flutter/material.dart';
import 'package:food_diary_app/utils/database_helper.dart';
import 'package:intl/intl.dart';

class FoodLogScreen extends StatefulWidget {
  final String id;

  const FoodLogScreen({super.key, required this.id});

  @override
  State<FoodLogScreen> createState() => _FoodLogScreenState();
}

class _FoodLogScreenState extends State<FoodLogScreen> {
  Map<String, dynamic> foodLog = {};

  @override
  void initState() {
    super.initState();
    getFoodLog(int.parse(widget.id));
  }

  Future<void> getFoodLog(int id) async {
    final results = await DatabaseHelper.instance.retrieveFoodEntry(id);
    setState(() {
      foodLog = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          foodLog["mealType"] != null &&
                  foodLog["mealType"].toString().isNotEmpty
              ? foodLog["mealType"].toString()[0].toUpperCase() +
                  foodLog["mealType"].toString().substring(1)
              : "Food Log",
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: (String value) {
              if (value == 'edit') {
                // Edit action
              } else if (value == 'delete') {
                // Delete action
              }
            },
            itemBuilder: (BuildContext context) {
              return {'Edit', 'Delete'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice.toLowerCase(),
                  child: Text(choice),
                );
              }).toList();
            },
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Time and Calories Card
            Card(
              margin: const EdgeInsets.all(16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.access_time, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              foodLog['time'] != null
                                  ? DateFormat('HH:mm\ndd/MM/yyyy')
                                      .format(DateTime.parse(foodLog['time']))
                                  : 'No time available',
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.green.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          Text(
                            foodLog['calories'].toString(),
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                          const Text(
                            "calories",
                            style: TextStyle(
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Food Items Section
            Card(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Food Items",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextButton.icon(
                          icon: const Icon(Icons.add),
                          label: const Text("Add Item"),
                          onPressed: () {
                            // Add new food item
                          },
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 200, // Adjust height as needed
                      child: ListView(
                        children: [_FoodItem(name: foodLog['foodItem']?.toString() ?? 'No food item')],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Notes Section
            Card(
              margin: const EdgeInsets.all(16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Notes",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: TextEditingController(text: foodLog['notes']),
                      onEditingComplete: () {
                        // Update notes
                      },
                      decoration: InputDecoration(
                        hintText: "Add notes about your meal...",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      maxLines: 3,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add_photo_alternate),
        label: const Text("Add Photo"),
        onPressed: () {
          // Add meal photo
        },
      ),
    );
  }
}

class _FoodItem extends StatelessWidget {
  final String name;

  const _FoodItem({
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.restaurant,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  TextEditingController controller =
                      TextEditingController(text: name);
                  return AlertDialog(
                    title: const Text("Edit Food Item"),
                    content: TextField(
                      controller: controller,
                      decoration: const InputDecoration(
                        hintText: "Enter new name",
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text("Cancel"),
                      ),
                      TextButton(
                        onPressed: () {
                          // Update the food item name
                          Navigator.of(context).pop();
                        },
                        child: const Text("Save"),
                      ),
                    ],
                  );
                },
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              // Delete food item
            },
          ),
        ],
      ),
    );
  }
}
