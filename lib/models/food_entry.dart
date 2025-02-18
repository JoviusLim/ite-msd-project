import 'dart:typed_data';

class FoodEntry {
  final int? id;
  final Uint8List image;
  final String mealType;
  final List<String> foodItems;
  final String notes;
  final int calories;
  final DateTime time;

  FoodEntry({
    this.id,
    required this.image,
    required this.mealType,
    required this.foodItems,
    required this.notes,
    required this.calories,
    required this.time,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'image': image,
      'mealType': mealType,
      'foodItems': foodItems.toString(),
      'foodDescription': notes,
      'calories': calories,
      'timestap': time.millisecondsSinceEpoch,
    };
  }
}
