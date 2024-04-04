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
    wateringInstructions:
        'Ideal Conditions for Growing Tulsi:\n- Temperature: 20-30°C\n- Water Level: Moderate, consistently moist soil\n- Soil Type: Well-drained, fertile soil\n- **pH**: 6.0-7.5\n\nStage 1 (0-3 weeks):\n- Select a sunny location for planting tulsi seeds or seedlings.\n- Prepare the planting area by loosening the soil and removing any weeds.\n- Plant tulsi seeds or seedlings in well-drained, fertile soil.\n- Water the newly planted seeds or seedlings thoroughly and keep the soil consistently moist.\n\nStage 2 (4-6 weeks):\n- Continue regular watering, ensuring the soil remains consistently moist but not waterlogged.\n- Apply a balanced fertilizer to promote healthy root and foliage growth.\n- Mulch around the base of the plants to retain moisture and suppress weeds.\n- Monitor for pests such as aphids and caterpillars, and take appropriate action if necessary.\n\nStage 3 (7-9 weeks):\n- Gradually reduce watering frequency but maintain soil moisture to encourage deeper root growth.\n- Apply organic fertilizers such as compost or vermicompost to provide nutrients.\n- Pinch off any flower buds to encourage bushier growth and delay flowering.\n- Prune the tulsi plants to remove any dead or diseased branches and shape the plant.\n\nStage 4 (10-12 weeks):\n- Continue monitoring for pests and diseases, especially as the plants mature.\n- Harvest tulsi leaves as needed, cutting stems just above a pair of leaves.\n- Provide support to tall varieties of tulsi to prevent them from bending or breaking.\n- Avoid over-fertilizing to prevent excessive leaf growth at the expense of flavor and aroma.\n\nStage 5 (13-15 weeks):\n- Continue harvesting tulsi leaves regularly to encourage new growth.\n- Allow some flower buds to develop for seed production if desired.\n- Maintain soil moisture and fertility to support ongoing growth and productivity.\n- Prepare for overwintering if growing tulsi as a perennial in colder climates.\n\nThese guidelines should help in successfully growing tulsi while ensuring optimal conditions and care at each stage of its growth.',
  ),
  Plant(
    name: 'Neem',
    description:
        'Neem is a versatile tree known for its medicinal and aromatic properties.',
    wateringInstructions:
        'Ideal Conditions for Growing Neem:\n- Temperature: 25-35°C\n- Water Level: Moderate, well-drained soil with occasional deep watering\n- Soil Type: Sandy loam with good drainage\n- pH: 6.0-7.5\n\nStage 1 (0-3 weeks):\n- Select a sunny location with well-drained soil for planting neem seeds or seedlings.\n- Prepare the planting site by loosening the soil and incorporating organic matter.\n- Plant neem seeds or seedlings at a spacing of 6-8 meters.\n- Water the newly planted seeds or seedlings thoroughly and maintain soil moisture.\n\nStage 2 (4-6 weeks):\n- Continue regular watering, allowing the soil to dry slightly between watering.\n- Apply a balanced fertilizer with micronutrients to support root development.\n- Mulch around the base of the plants to retain moisture and suppress weeds.\n- Monitor for pests such as aphids and caterpillars, and take appropriate action if necessary.\n\nStage 3 (7-9 weeks):\n- Gradually reduce watering frequency to encourage deeper root growth.\n- Apply organic fertilizers such as compost or vermicompost to provide nutrients.\n- Prune the neem plants to remove any dead or diseased branches and shape the canopy.\n- Monitor for signs of nutrient deficiencies and adjust fertilization as needed.\n\nStage 4 (10-12 weeks):\n- Provide support to young neem trees if necessary to prevent wind damage.\n- Apply a phosphorus-rich fertilizer to promote flower and fruit development.\n- Thin out excessive fruit clusters to ensure proper fruit size and quality.\n- Continue monitoring for pests and diseases, and take preventive measures as needed.\n\nStage 5 (13-15 weeks):\n- Harvest neem seeds or fruits as they ripen, taking care to avoid damage to the tree.\n- Remove any fallen or rotting fruit from the ground to prevent disease spread.\n- Continue to water and fertilize the neem tree as needed to support ongoing growth.\n- Inspect the tree for signs of stress or damage and address any issues promptly.',
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
            Flexible(
              child: SingleChildScrollView(
                child: Text(
                  plant.wateringInstructions,
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: AlmanacPage(plant: plants[0]), // Adjust index as needed
  ));
}
