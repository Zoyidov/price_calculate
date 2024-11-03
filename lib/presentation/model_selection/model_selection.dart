import 'package:flutter/material.dart';
import 'package:price_calculate/model/model.dart';
import 'package:price_calculate/presentation/byd_calculator_screen/byd_calculator_screen.dart';

class ModelSelectionScreen extends StatelessWidget {
  final String brand;
  final List<Car> models;

  ModelSelectionScreen({Key? key, required this.brand, required this.models}) : super(key: key);

  final TextEditingController kWhController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double? kWh = double.tryParse(kWhController.text);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF06b8b3),
        onPressed: () {
          kWh = double.tryParse(kWhController.text);
          if (kWh != null) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BydCalculatorScreen(
                  model: brand,
                  capacity: kWh!,
                ),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text(
                    'kWh hajmini kiriting',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  backgroundColor: Colors.red),
            );
          }
        },
        child: const Icon(Icons.calculate_outlined),
      ),
      appBar: AppBar(title: Text('$brand - Markasini Tanlang')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: kWhController,
                decoration: const InputDecoration(
                  labelText: 'Enter kWh',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                onSubmitted: (value) {
                  kWh = double.tryParse(value);
                  if (kWh != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BydCalculatorScreen(
                          model: brand,
                          capacity: kWh!,
                        ),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text(
                            'kWh hajmini kiriting',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          backgroundColor: Colors.red),
                    );
                  }
                },
              ),
            ),
            // List of car models
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: models.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('${models[index].model} (${models[index].capacity} kWh)'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BydCalculatorScreen(
                          model: models[index].model,
                          capacity: models[index].capacity,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
