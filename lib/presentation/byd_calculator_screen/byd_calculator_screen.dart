import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BydCalculatorScreen extends StatefulWidget {
  final String model;
  final double capacity;

  const BydCalculatorScreen({Key? key, required this.model, required this.capacity}) : super(key: key);

  @override
  _BydCalculatorScreenState createState() => _BydCalculatorScreenState();
}

class _BydCalculatorScreenState extends State<BydCalculatorScreen> {
  double currentCharge = 0.0;
  double electricityRate = 0.0;
  double? calculatedCost;
  final double additionalAmount = 10000.0; // Fixed additional amount

  void calculateChargingCost() {
    if (electricityRate <= 0) return;

    double remainingCapacity = widget.capacity * (1 - currentCharge / 100);
    setState(() {
      // Add the fixed amount to the calculated cost
      calculatedCost = remainingCapacity * electricityRate + additionalAmount;
    });
  }

  String formatCost(double? cost) {
    if (cost == null) return '0.00';
    final formatter = NumberFormat('#,##0.00');
    return formatter.format(cost);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${widget.model}')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Battareyaning hajmi: ${widget.capacity} kWh',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text(
              'Mashinaning qolgan zaryadi (${currentCharge.round()}%):',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Slider(
              value: currentCharge,
              min: 0,
              max: 100,
              divisions: 100,
              label: '${currentCharge.round()}%',
              onChanged: (value) {
                setState(() {
                  currentCharge = value;
                  calculatedCost = null;
                });
              },
            ),
            const SizedBox(height: 20),
            const Text(
              'kWh narxi',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            TextField(
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: 'Enter rate in Sum',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  electricityRate = double.tryParse(value) ?? 0.0;
                  calculatedCost = null;
                });
              },
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: Colors.cyan,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                onPressed: calculateChargingCost,
                child: const Text('Hissoblash',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
              ),
            ),
            const SizedBox(height: 20),
            if (calculatedCost != null)
              Text(
                'Deopozid bilan:    ${formatCost(calculatedCost!+additionalAmount)} SUM',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
          ],
        ),
      ),
    );
  }
}
