import 'package:flutter/material.dart';

class SomeData extends StatelessWidget {
  final List<Category> categories = [
    Category(
      name: 'Hodimlar',
      icon: Icons.people,
      details: [
        'Zarina: +998 90 826 35 55',
        'Yunus: +998 90 016 35 55',
        'Ibrohim: +998 90 012 65 55',
        'Aziz: +998 90 830 98 14',
        'Shaxboz: +998 90 010 86 66',
        'Javoxir: +998 90 830 98 13',
        'Andrey: +998 90 830 25 55',
      ],
    ),
    Category(
      name: 'Stansiya narxlari',
      icon: Icons.monetization_on,
      details: [
        "36 kWh -> 1.999 so'm",
        "40 kWh -> 2.222 so'm",
        "120 kWh -> 2.555 so'm",
        "160 kWh -> 2.666 so'm",
        "200 kWh - 240 kWh -> 2.777 so'm",
      ],
    ),
    Category(
      name: 'Avtomobil kWh',
      icon: Icons.electric_car,
      details: [
        "BYD Chazor: 18.3",
        "BYD E6: 60.0",
        "BYD Han EV: 77.0",
        "BYD Tang EV: 100.0",
        "BYD Qin Plus EV: 65.0",
        "BYD Song Plus EV: 82.8",
        "BYD Dolphin: 60.0",
        "BYD Han EV: 82.5",
        "BYD Yuan EV: 60.0",
        "BYD Seal: 82.5",
      ],
    ),
    Category(
      name: 'Boshqa xizmatlar',
      icon: Icons.miscellaneous_services,
      details: [
        "Servis xizmati: Doniyor +998 90 022 08 88",
        "BYD Megawatt: Muslima +998 90 010 44 04",
      ],
    ),

  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ma\'lumotlar', style: TextStyle(color: Colors.white)),
      ),
      body: Center(
        child: LayoutBuilder(
          builder: (context, constraints) {
            double width = constraints.maxWidth;

            int crossAxisCount = width < 600 ? 2 : 4;

            return GridView.builder(
              padding: const EdgeInsets.all(16.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                childAspectRatio: 1.0,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                return MouseRegion(
                  onEnter: (_) => _showInkEffect(index),
                  onExit: (_) => _hideInkEffect(index),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CategoryDetailScreen(category: categories[index]),
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(15),
                    child: Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(categories[index].icon, size: 50, color: Colors.teal),
                          const SizedBox(height: 6.0),
                          Flexible(
                              child: Text(categories[index].name,textAlign: TextAlign.center, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold))),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  void _showInkEffect(int index) {
  }

  void _hideInkEffect(int index) {
  }
}

class Category {
  final String name;
  final IconData icon;
  final List<String> details;

  Category({required this.name, required this.icon, required this.details});
}


class CategoryDetailScreen extends StatelessWidget {
  final Category category;

  const CategoryDetailScreen({required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          category.name,
          style: const TextStyle( fontSize: 24, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: category.details.length,
          itemBuilder: (context, index) {
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: InkWell(
                onTap: () {
                  // Add any tap response logic here if needed
                },
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        category.details[index],
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
