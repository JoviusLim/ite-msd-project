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
  List<String> foodItems = [];

  @override
  void initState() {
    super.initState();
    getFoodLog(int.parse(widget.id));
  }

  Future<void> getFoodLog(int id) async {
    final results = await DatabaseHelper.instance.retrieveFoodEntry(id);
    setState(() {
      foodLog = results;
      if (results['foodItems'] == "") {
        return;
      }
      foodItems = results['foodItems'].toString().split(',');
    });
  }

  // Update food item in the list
  void updateFoodItem(int index, String newName) {
    setState(() {
      foodItems[index] = newName;

      String foodItemsString = foodItems.join(',');
      DatabaseHelper.instance
          .updateFoodItems(int.parse(widget.id), foodItemsString);
    });
  }

  // Delete food item from the list
  void deleteFoodItem(int index) {
    setState(() {
      foodItems.removeAt(index);
      if (foodItems.isEmpty) {
        DatabaseHelper.instance.updateFoodItems(int.parse(widget.id), '');
        return;
      }
      String foodItemsString = foodItems.join(',');
      DatabaseHelper.instance
          .updateFoodItems(int.parse(widget.id), foodItemsString);
    });
  }

  // Add a food item to the list
  void addFoodItem(String newItem) {
    setState(() {
      foodItems.add(newItem);
      String foodItemsString = foodItems.join(',');

      DatabaseHelper.instance
          .updateFoodItems(int.parse(widget.id), foodItemsString);
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
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Image, Time and Calories Card
            Card(
              margin: const EdgeInsets.all(16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    if (foodLog['image'] != null)
                      Column(
                        children: [
                          Image.memory(
                            foodLog['image'],
                            fit: BoxFit.cover,
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    Row(
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
                                      ? DateFormat('HH:mm\ndd/MM/yyyy').format(
                                          DateTime.parse(foodLog['time']))
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
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                TextEditingController controller =
                                    TextEditingController();
                                return AlertDialog(
                                  title: const Text("Add Food Item"),
                                  content: TextField(
                                    controller: controller,
                                    decoration: const InputDecoration(
                                      hintText: "Enter new food item",
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
                                        String newItem = controller.text;
                                        if (newItem.isNotEmpty) {
                                          addFoodItem(newItem);
                                        }
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text("Add"),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 200, // Adjust height as needed
                      child: ListView.builder(
                        itemCount: foodItems.length,
                        itemBuilder: (context, index) {
                          return _FoodItem(
                            name: foodItems[index],
                            onEdit: (oldName, newName) {
                              updateFoodItem(index, newName);
                            },
                            onDelete: () {
                              deleteFoodItem(index);
                            },
                          );
                        },
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
                      onChanged: (value) async {
                        await DatabaseHelper.instance
                            .updateNotes(int.parse(widget.id), value);
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
    );
  }
}

class _FoodItem extends StatelessWidget {
  final String name;
  final void Function(String oldName, String newName) onEdit;
  final VoidCallback onDelete;

  const _FoodItem({
    required this.name,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        name,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
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
                          String newName = controller.text;
                          if (newName.isNotEmpty) {
                            onEdit(name, newName);
                          }
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
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }
}
