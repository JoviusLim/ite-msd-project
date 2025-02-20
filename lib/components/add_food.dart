import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:food_diary_app/components/camera_screen.dart';
import 'package:food_diary_app/utils/database_helper.dart';

class AddFoodLogScreen extends StatefulWidget {
  final CameraDescription camera;
  const AddFoodLogScreen({super.key, required this.camera});

  @override
  State<AddFoodLogScreen> createState() => _AddFoodLogScreenState();
}

class _AddFoodLogScreenState extends State<AddFoodLogScreen> {
  final _formKey = GlobalKey<FormState>();
  DateTime _selectedDateTime = DateTime.now();
  String _selectedMealType = "breakfast";
  final List<FoodItem> _foodItems = [];
  final _noteController = TextEditingController();
  final _caloriesController = TextEditingController();
  Uint8List? _capturedImage;

  Future<void> _selectDateTime(BuildContext context) async {
    final DateTime? datePicked = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (datePicked != null) {
      final TimeOfDay? timePicked = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_selectedDateTime),
      );
      if (timePicked != null) {
        setState(() {
          _selectedDateTime = DateTime(
            datePicked.year,
            datePicked.month,
            datePicked.day,
            timePicked.hour,
            timePicked.minute,
          );
        });
      }
    }
  }

  void _addFoodItem() {
    setState(() {
      _foodItems.add(FoodItem());
    });
  }

  void _removeFoodItem(int index) {
    setState(() {
      _foodItems.removeAt(index);
    });
  }

  Future<void> _saveFoodLog() async {
    final db = await DatabaseHelper.instance.database;
    final String mealType = _selectedMealType;
    final entry = {
      'mealType': mealType,
      'foodItems': _foodItems.map((item) => item.name).join(','),
      'notes': _noteController.text,
      'calories': _caloriesController.text,
      'time': _selectedDateTime.toIso8601String(),
      'image': _capturedImage, // Save image blob if available.
    };

    await db.insert('food_entry', entry);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Food Log"),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _saveFoodLog();
                Navigator.pop(context, true);
              }
            },
            child: const Text(
              "Save",
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            physics: const AlwaysScrollableScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height -
                    kToolbarHeight -
                    MediaQuery.of(context).padding.top,
              ),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Display captured image if available.
                    if (_capturedImage != null)
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Image.memory(_capturedImage!),
                        ),
                      ),
                    // Meal Type Selection
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Meal Type",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            DropdownButtonFormField<String>(
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 16),
                              ),
                              value: _selectedMealType,
                              items: [
                                "breakfast",
                                "lunch",
                                "dinner",
                                "snack",
                              ].map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value[0].toUpperCase() + value.substring(1),
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                );
                              }).toList(),
                              onChanged: (String? value) {
                                setState(() {
                                  _selectedMealType = value ?? "breakfast";
                                });
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please select a meal type';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Date & Time Selection
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Date & Time",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            InkWell(
                              onTap: () => _selectDateTime(context),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "${_selectedDateTime.month}/${_selectedDateTime.day}/${_selectedDateTime.year} ${_selectedDateTime.hour.toString().padLeft(2, '0')}:${_selectedDateTime.minute.toString().padLeft(2, '0')}",
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                    const Icon(Icons.calendar_today),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Food Items
                    Card(
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
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextButton.icon(
                                  icon: const Icon(Icons.add),
                                  label: const Text("Add Item"),
                                  onPressed: _addFoodItem,
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            ..._foodItems.asMap().entries.map((entry) {
                              final index = entry.key;
                              return Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: TextFormField(
                                          decoration: const InputDecoration(
                                            labelText: "Food Item",
                                            border: OutlineInputBorder(),
                                          ),
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Please enter a food item';
                                            }
                                            return null;
                                          },
                                          onChanged: (value) {
                                            setState(() {
                                              _foodItems[index].name = value;
                                            });
                                          },
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      IconButton(
                                        icon: const Icon(Icons.delete_outline),
                                        onPressed: () => _removeFoodItem(index),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                ],
                              );
                            }),
                            if (_foodItems.isEmpty)
                              const Center(
                                child: Text(
                                  "Add food items to your log",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Calories Field
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Calories",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _caloriesController,
                              decoration: const InputDecoration(
                                hintText: "Enter calories",
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter calories';
                                }
                                if (int.tryParse(value) == null) {
                                  return 'Please enter a valid number';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Notes
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Notes",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _noteController,
                              decoration: const InputDecoration(
                                hintText: "Add notes about your meal...",
                                border: OutlineInputBorder(),
                              ),
                              maxLines: 3,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CameraScreen(camera: widget.camera),
            ),
          );
          // Assuming CameraScreen returns a Uint8List blob.
          if (result != null) {
            setState(() {
              _capturedImage = result;
            });
          }
        },
        tooltip: "Add Picture",
        child: const Icon(Icons.camera_alt),
      ),
    );
  }

  @override
  void dispose() {
    _noteController.dispose();
    _caloriesController.dispose();
    super.dispose();
  }
}

class FoodItem {
  String name = '';
}
