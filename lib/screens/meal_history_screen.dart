import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../data/database_helper.dart';
import '../models/meal.dart';

class MealHistoryScreen extends StatefulWidget {
  const MealHistoryScreen({super.key});

  @override
  MealHistoryScreenState createState() => MealHistoryScreenState();
}

class MealHistoryScreenState extends State<MealHistoryScreen> {
  List<Meal> _meals = [];

  @override
  void initState() {
    super.initState();
    _loadMeals();
  }

  Future<void> _loadMeals() async {
    final dbHelper = DatabaseHelper();
    final meals = await dbHelper.getMeals();
    setState(() {
      _meals = meals;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meal History'),
      ),
      body: _meals.isEmpty
          ? const Center(child: Text("No meals logged yet."))
          : ListView.builder(
              itemCount: _meals.length,
              itemBuilder: (context, index) {
                final meal = _meals[index];
                return Card(
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    leading: meal.imagePath.isNotEmpty
                        ? Image.file(
                            File(meal.imagePath),
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          )
                        : const Icon(Icons.image_not_supported),
                    title: Text(meal.name),
                    subtitle: Text(
                      '${meal.calories} kcal • ${DateFormat('yyyy-MM-dd – kk:mm').format(meal.dateTime)}',
                    ),
                  ),
                );
              },
            ),
    );
  }
}
