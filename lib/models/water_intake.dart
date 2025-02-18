class WaterIntake {
  final int? id;
  final DateTime date;
  final int intake;

  WaterIntake({
    this.id,
    required this.date,
    required this.intake,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date.millisecondsSinceEpoch,
      'intake': intake,
    };
  }

  factory WaterIntake.fromMap(Map<String, dynamic> map) {
    return WaterIntake(
      id: map['id'],
      date: DateTime.fromMillisecondsSinceEpoch(map['date']),
      intake: map['intake'],
    );
  }
}
