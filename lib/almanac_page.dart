import 'package:flutter/material.dart';

class Plant {
  final String name;
  final String description;
  final String wateringInstructions;

  Plant({
    required this.name,
    required this.description,
    required this.wateringInstructions,
  });
}

List<Plant> plants = [
  Plant(
    name: 'Tulsi',
    description:
        'Tulsi is a sacred plant in Hinduism. It is known for its medicinal properties.',
    wateringInstructions: 'Water once a day in the morning.',
  ),
  Plant(
    name: 'Neem',
    description:
        'Neem is a versatile tree known for its medicinal and aromatic properties.',
    wateringInstructions: 'Water once a week.',
  ),
  // Add more plants as needed
];

class AlmanacPage extends StatelessWidget {
  final Plant plant;

  AlmanacPage({Key? key, required this.plant}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(plant.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              plant.name,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              plant.description,
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 16),
            Text(
              'Watering Instructions:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              plant.wateringInstructions,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
