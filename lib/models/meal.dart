class Meal {
  final int? id;
  final String name;
  final String imagePath;
  final int calories;
  final DateTime dateTime;

  Meal({
    this.id,
    required this.name,
    required this.imagePath,
    required this.calories,
    required this.dateTime,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'imagePath': imagePath,
      'calories': calories,
      'dateTime': dateTime.toIso8601String(),
    };
  }

  factory Meal.fromMap(Map<String, dynamic> map) {
    return Meal(
      id: map['id'],
      name: map['name'],
      imagePath: map['imagePath'],
      calories: map['calories'],
      dateTime: DateTime.parse(map['dateTime']),
    );
  }
}
