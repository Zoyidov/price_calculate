import 'package:flutter/material.dart';
import 'package:flutter_xlider/flutter_xlider.dart';
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
  double targetCharge = 100.0;
  double electricityRate = 0.0;
  double? calculatedCost;
  final double additionalAmount = 10000.0;

  void calculateChargingCost() {
    if (electricityRate <= 0) return;

    double chargeNeeded = widget.capacity * ((targetCharge - currentCharge) / 100);
    setState(() {
      calculatedCost = chargeNeeded * electricityRate + additionalAmount;
    });
  }

  String formatCost(double? cost) {
    if (cost == null) return '0.00';
    final formatter = NumberFormat('#,##0.00');
    return formatter.format(cost);
  }

  Color getSliderColor(double value) {
    if (value <= 20) {
      return Colors.red;
    } else if (value <= 40) {
      return Colors.yellow;
    } else {
      return Colors.cyan;
    }
  }

  Color getButtonColor() {
    return currentCharge <= 20 ? Colors.red : Colors.cyan;
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
              'Mashinaning zaryad darajasi (${currentCharge.round()}% - ${targetCharge.round()}%):',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            FlutterSlider(
              values: [currentCharge, targetCharge],
              max: 100,
              min: 0,
              rangeSlider: true,
              handlerHeight: 30,
              handlerWidth: 30,
              trackBar: FlutterSliderTrackBar(
                inactiveTrackBar: BoxDecoration(color: Colors.grey[300]),
                activeTrackBar: BoxDecoration(color: getSliderColor(currentCharge)),
              ),
              handler: FlutterSliderHandler(
                decoration: const BoxDecoration(),
                child: Material(
                  type: MaterialType.circle,
                  color: getSliderColor(currentCharge),
                  elevation: 3,
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    child: const Icon(Icons.circle, size: 20, color: Colors.white),
                  ),
                ),
              ),
              rightHandler: FlutterSliderHandler(
                decoration: const BoxDecoration(),
                child: Material(
                  type: MaterialType.circle,
                  color: getSliderColor(targetCharge),
                  elevation: 3,
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    child: const Icon(Icons.circle, size: 20, color: Colors.white),
                  ),
                ),
              ),
              onDragging: (handlerIndex, lowerValue, upperValue) {
                setState(() {
                  currentCharge = lowerValue;
                  targetCharge = upperValue;
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
              onSubmitted: (value) {
                calculateChargingCost();
              },
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: getButtonColor(),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                onPressed: electricityRate > 0 ? calculateChargingCost : null,
                child: const Text(
                  'Hissoblash',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 20),
            if (calculatedCost != null)
              Center(
                child: Text(
                  'Deopozid bilan:    ${formatCost(calculatedCost)} SO\'M',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
