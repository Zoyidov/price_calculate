import 'package:flutter/material.dart';
import 'package:price_calculate/model/model.dart';
import 'package:price_calculate/presentation/byd_calculator_screen/byd_calculator_screen.dart';
import 'package:price_calculate/presentation/model_selection/model_selection.dart';

class CarSelectionScreen extends StatelessWidget {
  final List<String> brands = ['BYD', 'Tesla', 'BMW', 'Mercedes', 'Zeekr', 'Cherry'];

  final Map<String, List<Car>> carModels = {
    'BYD': [
      Car('BYD', 'Song Plus', 71.7),
      Car('BYD', 'Han EV', 77.0),
      Car('BYD', 'Tang EV', 100.0),
      Car('BYD', 'Dolphin', 60.5),
      Car('BYD', 'Seal', 82.5),
      Car('BYD', 'E6', 70.0),
      Car('BYD', 'Qin Plus EV', 61.4),
      Car('BYD', 'Song Pro', 82.0),
      Car('BYD', 'Tang Hybrid', 15.7), // Plug-in Hybrid
      Car('BYD', 'Han Hybrid', 15.7), // Plug-in Hybrid
      Car('BYD', 'G3', 15.0), // Plug-in Hybrid
      Car('BYD', 'S2', 30.0),
      Car('BYD', 'S3', 61.4),
      Car('BYD', 'S1', 36.0),
      Car('BYD', 'F3', 16.5), // Plug-in Hybrid
      Car('BYD', 'F0', 18.5),
      Car('BYD', 'e6 Plus', 70.0),
      Car('BYD', 'Tang Diesel', 2.0), // Diesel
    ],
    'Tesla': [
      Car('Tesla', 'Model 3', 60.0),
      Car('Tesla', 'Model S', 100.0),
      Car('Tesla', 'Model X', 100.0),
      Car('Tesla', 'Model Y', 75.0),
      Car('Tesla', 'Model S Plaid', 102.0),
      Car('Tesla', 'Roadster', 200.0), // Estimated capacity for the upcoming model
    ],
    'BMW': [
      Car('BMW', 'i3', 42.2),
      Car('BMW', 'iX', 76.6),
      Car('BMW', 'i4', 83.9),
      Car('BMW', 'iX3', 74.0),
      Car('BMW', 'i7', 101.7),
    ],
    'Mercedes': [
      Car('Mercedes', 'EQC', 80.0),
      Car('Mercedes', 'EQA', 66.5),
      Car('Mercedes', 'EQB', 66.5),
      Car('Mercedes', 'EQS', 107.8),
      Car('Mercedes', 'EQT', 90.0),
    ],
    'Zeekr': [
      Car('Zeekr', '001', 86.0),
    ],
    'Cherry': [
      Car('Cherry', 'eQ1', 30.0),
      Car('Cherry', 'eQ2', 30.0),
      Car('Cherry', 'eQ3', 38.0),
    ],
    // 'Nissan': [
    //   Car('Nissan', 'Leaf', 40.0),
    //   Car('Nissan', 'Ariya', 87.0),
    // ],
    // 'Hyundai': [
    //   Car('Hyundai', 'Ioniq 5', 72.6),
    //   Car('Hyundai', 'Kona Electric', 64.0),
    // ],
  };

  final Map<String, String> brandImages = {
    'BYD': 'assets/images/byd.png',
    'Tesla': 'assets/images/tesla.png',
    'BMW': 'assets/images/bmw.png',
    'Mercedes': 'assets/images/merc.png',
    'Zeekr': 'assets/images/zeekr.png',
    'Cherry': 'assets/images/cherry.png',
  };

  CarSelectionScreen({super.key});

  final TextEditingController kWhController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    double? kWh = double.tryParse(kWhController.text);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Mashina Modelini Tanlang',
        ),
          leading:  Image.asset(
          'assets/images/logo.png',
          height: 60,
          width: 60,
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
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
                              model: "MegaWatt",
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
                const SizedBox(
                  width: 20),
                FloatingActionButton(
                  backgroundColor: const Color(0xFF06b8b3),
                  onPressed: () {
                    kWh = double.tryParse(kWhController.text);
                    if (kWh != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BydCalculatorScreen(
                            model: "MegaWatt",
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
              ],
            ),
          ),
          ListView.separated(
            shrinkWrap: true,
            separatorBuilder: (context, index) => const Divider(),
            itemCount: brands.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: brandImages[brands[index]] != null
                    ? Image.asset(
                        brandImages[brands[index]]!,
                        height: 60,
                        width: 60,
                      )
                    : null,
                title: Text(
                  brands[index],
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                onTap: () {
                  if (carModels[brands[index]]!.isNotEmpty) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ModelSelectionScreen(
                          brand: brands[index],
                          models: carModels[brands[index]]!,
                        ),
                      ),
                    );
                  }
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
