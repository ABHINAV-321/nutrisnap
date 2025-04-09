// class Meal {
  final int? id;
  final String? name;
  final String? imagePath;
  final double? calories;
  final String dateTime;

  Meal({
    this.id,
    this.name,
    this.imagePath,
    this.calories,
    required this.dateTime,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'imagePath': imagePath,
      'calories': calories,
      'dateTime': dateTime,
    };
  }

  factory Meal.fromMap(Map<String, dynamic> map) {
    return Meal(
      id: map['id'],
      name: map['name'],
      imagePath: map['imagePath'],
      calories: map['calories'],
      dateTime: map['dateTime'],
    );
  }
}
TODO Implement this library.
