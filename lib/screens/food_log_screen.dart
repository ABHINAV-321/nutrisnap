import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class FoodLogScreen extends StatefulWidget {
  const FoodLogScreen({super.key});

  @override
  State<FoodLogScreen> createState() => _FoodLogScreenState();
}

class _FoodLogScreenState extends State<FoodLogScreen> {
  final TextEditingController _mealNameController = TextEditingController();
  final TextEditingController _calorieController = TextEditingController();
  File? _pickedImage;

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile == null) return;

    setState(() {
      _pickedImage = File(pickedFile.path);
    });

    // 🔗 AI backend call to analyze the image
    final request = http.MultipartRequest(
      'POST',
      Uri.parse(
          'https://ac66-2403-a080-833-31e7-8d62-c93a-766e-dd66.ngrok-free.app/analyze'),
    );
    request.files
        .add(await http.MultipartFile.fromPath('image', pickedFile.path));

    final response = await request.send();
    final responseBody = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      final data = json.decode(responseBody);
      setState(() {
        _mealNameController.text = data['meal_name'];
        _calorieController.text = data['calories'].toString();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('AI analysis failed')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Log a Meal'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _pickedImage != null
                ? Image.file(_pickedImage!, height: 200)
                : Image.asset('assets/images/sample_meal.jpg', height: 200),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _pickImage,
              icon: const Icon(Icons.photo),
              label: const Text('Pick Meal Image'),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _mealNameController,
              decoration: const InputDecoration(labelText: 'Meal Name'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _calorieController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Calories'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // You can save the meal data to SQLite or memory here
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Meal logged successfully!')),
                );
              },
              child: const Text('Save Meal'),
            ),
          ],
        ),
      ),
    );
  }
}
